# Download full HOCOMOCO database
mkdir -p ../data/motifs/autosome/
wget https://hocomoco11.autosome.ru/final_bundle/hocomoco11/full/HUMAN/mono/HOCOMOCOv11_full_pwm_HUMAN_mono.tar.gz  -O ../data/motifs/autosome/HOCOMOCOv11_full_pwm_HUMAN_mono.tar.gz
cd ../data/motifs/autosome/
tar -xzf HOCOMOCOv11_full_pwm_HUMAN_mono.tar.gz 
cd -
rm ../data/motifs/autosome/HOCOMOCOv11_full_pwm_HUMAN_mono.tar.gz
