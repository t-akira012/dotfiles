mkdir cica-tmp
cd cica-tmp
wget https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip \
    && unzip Cica_v5.0.3.zip

sudo mkdir /usr/share/fonts/truetype/cica
sudo cp *.ttf /usr/share/fonts/truetype/cica/
sudo fc-cache -vf
cd ..
rm -rf cica-tmp
