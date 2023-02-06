#!/bin/bash
echo -e "\n Looking for System Update"
sudo apt -y update
echo -e "\n Looking for System Upgrade"
sudo apt -y upgrade
echo -e "\n Installing/Upgrading Git"
sudo apt install  git
echo -e "\n Installing/Upgrading Python"
sudo apt-get install  python3
echo -e "\n Installing/Upgrading golang"
sudo apt install  golang
echo -e "\n Installing/Upgrading banner"
sudo apt install  sysvbanner
echo -e "\n Installing/Upgrading wget"
sudo apt-get install wget
sudo apt install wget
echo -e "\n Installing/Upgrading sqlmap"
apt-get install sqlmap
mkdir Projects
mkdir Tools
echo -e "\n Installing/Upgrading crtsh"
git clone https://github.com/YashGoti/crtsh.git
echo -e "\n Installing/Upgrading findomain"
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
echo -e "\n Installing/Upgrading anew"
go install -v github.com/tomnomnom/anew@latest
echo -e "\n Installing/Upgrading httprobe"
go install github.com/tomnomnom/httprobe@latest
echo -e "\n Installing/Upgrading assetfinder"
go install github.com/tomnomnom/assetfinder@latest
echo -e "\n Installing/Upgrading waybackurls"
go install github.com/tomnomnom/waybackurls@latest
echo -e "\n Installing/Upgrading qsreplace"
go install github.com/tomnomnom/qsreplace@latest
echo -e "\n Installing/Upgrading subfinder"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
echo -e "\n Installing/Upgrading httpx"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
echo -e "\n Installing/Upgrading Nuclei"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo -e "\n Installing/Upgrading nuclei-templates"
git clone https://github.com/projectdiscovery/nuclei-templates.git
nuclei update-templates
echo -e "\n Installing/Upgrading naabu"
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
echo -e "\n Installing/Upgrading Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git
echo -e "\n Installing/Upgrading ParamSpider"
git clone https://github.com/devanshbatham/ParamSpider
pip3 install -r /root/ParamSpider/requirements.txt 
mv /root/ParamSpider /root/Tools/
echo -e "\n Installing/Upgrading smuggler"
git clone https://github.com/defparam/smuggler.git
mv /root/smuggler /root/Tools
echo -e "\n Installing/Upgrading XKeys"
go install -v  github.com/vsec7/xkeys@latest
echo -e "\n Installing/Upgrading subzy"
go install -v github.com/lukasikic/subzy@latest
go install github.com/hahwul/dalfox/v2@latest
go get github.com/Emoe/kxss
go install -v github.com/tomnomnom/gf@latest
git clone https://github.com/maurosoria/dirsearch.git --depth 1
