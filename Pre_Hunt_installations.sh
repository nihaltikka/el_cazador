sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt install git -y
sudo apt install golang -y

git clone https://github.com/YashGoti/crtsh.git


wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
./findomain-linux

go get -u github.com/tomnomnom/assetfinder

go install github.com/tomnomnom/httprobe@latest

git clone https://github.com/aboul3la/Sublist3r.git

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest


git clone https://github.com/six2dez/reconftw
cd reconftw/
chmod +x install.sh
./install.sh


git clone https://github.com/nahamsec/bbht.git
cd bbht
chmod +x install.sh
./install.sh

git clone https://github.com/devanshbatham/ParamSpider
cd ParamSpider
pip3 install -r requirements.txt

mv ParamSpider /root/Tools/

git clone https://github.com/defparam/smuggler.git

go get -u github.com/vsec7/xkeys

apt-get install sqlmap

go get -u -v github.com/lukasikic/subzy

mkdir Projects
