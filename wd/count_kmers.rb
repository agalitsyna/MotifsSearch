# The code kindly proveded by Ilya Vorontsov for calculation of nucleotide/dinucleotide content of the genome 
# Example usage: 
# >>> ruby count_kmers.rb hg19.fa 2

LETTERS = ['a','c','g','t','n']
LETTER_INDEX = LETTERS.each_with_index.to_h
HASH_MULTIPLIER = 8 #LETTERS.size

def decode_hash(code, kmer_len)
  result = []
  kmer_len.times{
    result.unshift(LETTERS[ code % HASH_MULTIPLIER ])
    code = code / HASH_MULTIPLIER
  }
  result.join
end

def revcomp(seq)
  seq.reverse.tr('acgtn', 'tgcan')
end

def symmetrize(counts)
  result = Hash.new(0)
  counts.each{|kmer, cnt|
    result[kmer] += cnt
    result[revcomp(kmer)] += cnt
  }
  result
end

def normalize(counts)
  sum = counts.values.inject(0.0, &:+)
  counts.map{|kmer, cnt| [kmer, cnt/sum]  }.to_h
end

def output_as_background(freqs, kmer_len)
  nucs = ['a','c','g','t']
  kmers = nucs.repeated_permutation(kmer_len).map(&:join)
  kmers.map{|kmer| freqs.fetch(kmer, 0) }.join(',')
end

def print_hsh(hsh)
  hsh.sort.each{|k, v|
    puts [k, v].join("\t")
  }
end

def filter_unknown(counts)
  counts.reject{|kmer, cnt| kmer.match(/[^acgtACGT]/) }
end

fasta_fn = ARGV[0]
kmer_len = Integer(ARGV[1])

hash_mod = HASH_MULTIPLIER ** kmer_len

kmer_counts = Hash.new(0)
File.open(fasta_fn, encoding: 'ASCII'){|f|
  f.each_line.lazy.slice_before{|l|
    l.start_with?('>')
  }.map{|chunk|
    name = chunk.shift[1..-1].strip
    [name, chunk]
  }.select{|name, chunk|
    name.match(/^chr(\d+|[XY])$/)
  }.map{|name, chunk|
    chunk.map!{|l|
      l.strip.downcase
    }
    [name, chunk.join]
  }.each{|name, seq|
    $stderr.puts(name, seq.size)
    kmer_hash = 0
    kmer_len.times{|idx|
      kmer_hash = (kmer_hash * HASH_MULTIPLIER + LETTER_INDEX[seq[idx]]) % hash_mod
    }
    kmer_counts[kmer_hash] += 1

    (kmer_len ... seq.length).each{|idx|
      kmer_hash = (kmer_hash * HASH_MULTIPLIER + LETTER_INDEX[seq[idx]]) % hash_mod
      kmer_counts[kmer_hash] += 1
    }
  }
}

kmer_counts_decoded = kmer_counts.map{|kmer_idx, cnt|
  [decode_hash(kmer_idx, kmer_len), cnt]
}.to_h

puts("--------------------\nCounts:")
print_hsh(kmer_counts_decoded)

puts("--------------------\nSymmetrized counts:")
symmetrized_counts = symmetrize(kmer_counts_decoded)
print_hsh(symmetrized_counts)

puts("--------------------\nFrequencies:")
freqs = normalize(filter_unknown(symmetrized_counts))
print_hsh(freqs)

puts("--------------------\nBackground string:")
puts(output_as_background(freqs, kmer_len))
