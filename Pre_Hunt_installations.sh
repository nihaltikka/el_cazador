#!/bin/bash
sudo apt update
sudo apt upgrade
sudo apt install git
sudo apt install golang
sudo apt install sysvbanner
sudo apt-get install sqlmap
mkdir Projects
mkdir Tools
git clone https://github.com/YashGoti/crtsh.git
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
go get -u github.com/tomnomnom/assetfinder
go install github.com/tomnomnom/httprobe@latest
git clone https://github.com/aboul3la/Sublist3r.git
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
git clone https://github.com/devanshbatham/ParamSpider
pip3 install -r /root/ParamSpider/requirements.txt 
mv /root/ParamSpider /root/Tools/
git clone https://github.com/defparam/smuggler.git
mv  /root/smuggler /root/Tools
go get -u github.com/vsec7/xkeys
go get -u -v github.com/lukasikic/subzy
