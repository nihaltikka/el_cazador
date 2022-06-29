#!/bin/bash

###################################################################
#Script Name	: Recon with El_Cazad0r                                                                                                                                                                                 
#Author       	: El_Cazad0r                                               
#Email         	: el_cazad0r@outlook.com                                           
###################################################################


########################################
# Happy Hunting
########################################


domain=$1

mkdir -p /root/Projects/$domain/


echo "Getting domains from crtsh"

python3 /root/crtsh.py/crtsh -d $1 | anew /root/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from subfinder"

subfinder -d $1 -recursive | anew /root/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from assetfinder"

assetfinder -subs-only $1 |grep -v "*." | anew /root/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from findomain"

findomain -t $1  -u  /root/Projects/$domain/findomain_subdomains.txt

echo -e "\n Getting domains from Sublist3r"

python3 /root/Sublist3r/sublist3r.py -d $1 -o /root/Projects/$domain/sublister_subdomains.txt

echo -e "\n Getting domains from Amass"

amass enum -passive -d $1 -o /root/Projects/$domain/amass_subdomains.txt

echo -e "\n Getting domains Sorted into sorted_subdomain.txt"

cat /root/Projects/$domain/subdomains.txt /root/Projects/$domain/sublister_subdomains.txt  /root/Projects/$domain/amass_subdomains.txt /root/Projects/$domain/findomain_subdomains.txt | sort -u > /root/Projects/$domain/sorted_subdomain.txt

echo -e "\n Getting all live domains into live_domains.txt"

cat /root/Projects/$domain/sorted_subdomain.txt | httprobe | anew /root/Projects/$domain/live_domains.txt

echo -e "\n Getting all URLS using waybackurls"

cat /root/Projects/$domain/sorted_subdomain.txt | waybackurls | sort -u > /root/Projects/$domain/All_Urls.txt

echo -e "\n Getting parameter_urls"

cat /root/Projects/$domain/All_Urls.txt | grep "=" | anew /root/Projects/$domain/parameter_urls.txt

echo "Getting openredir_urls"

cat /root/Projects/$domain/All_Urls.txt | grep "=http" | anew /root/Projects/$domain/openredir_urls.txt

echo -e "\n Getting all live URLS"

cat /root/Projects/$domain/All_Urls.txt | httprobe | tee -a /root/Projects/$domain/live_urls.txt

echo -e "\n Checking for Subdomain Takeover"

subzy --targets /root/Projects/$domain/sorted_subdomain.txt -concurrency 20 --hide_fails | anew /root/Projects/$domain/subdomain_takeover.txt

echo -e "\n Checking for any senstive keys/infromation using XKeys"

cat /root/Projects/$domain/All_Urls.txt | xkeys -o /root/Projects/$domain/ | grep -v "Nothing!" | anew /root/Projects/$domain/Xkeys_output.txt








