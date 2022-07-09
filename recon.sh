#!/bin/bash

###################################################################
#Script Name	: Recon with El_Cazad0r                                                                                                                                                                                 
#Author       	: El_Cazad0r                                               
#Email         	: el_cazad0r@outlook.com                                           
###################################################################


########################################
# Happy Hunting
########################################

banner el cazador

domain=$1

mkdir -p /root/Projects/$domain/


echo "Getting domains from crtsh"

python3 /root/crtsh/crtsh.py -d $1 | anew /root/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from subfinder"

subfinder -d $1 -recursive | anew /root/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from assetfinder"

assetfinder -subs-only $1 |grep -v "*." | anew /root/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from findomain"

./findomain-linux -t $1  -u  /root/Projects/$domain/findomain_subdomains.txt

echo -e "\n Getting domains from Sublist3r"

python3 /root/Sublist3r/sublist3r.py -d $1 -o /root/Projects/$domain/sublister_subdomains.txt

echo -e "\n Getting domains from Amass"

amass enum -passive -d $1 -o /root/Projects/$domain/amass_subdomains.txt

echo -e "\n Getting domains Sorted into sorted_subdomain.txt"

cat /root/Projects/$domain/subdomains.txt /root/Projects/$domain/sublister_subdomains.txt  /root/Projects/$domain/amass_subdomains.txt /root/Projects/$domain/findomain_subdomains.txt| httprobe | sort -u > /root/Projects/$domain/sorted_subdomain.txt

echo -e "\n Getting all live domains into live_domains.txt"

cat /root/Projects/$domain/sorted_subdomain.txt | httpx | anew /root/Projects/$domain/live_domains.txt

echo -e "\n Getting all URLS using waybackurls"

cat /root/Projects/$domain/sorted_subdomain.txt | waybackurls | sort -u > /root/Projects/$domain/All_Urls.txt

echo -e "\n Getting all live URLS"

cat /root/Projects/$domain/All_Urls.txt | httpx | tee -a /root/Projects/$domain/live_urls.txt


echo -e "\n Getting parameter_urls"

cat /root/Projects/$domain/sorted_subdomain.txt | xargs -I % python3 /root/Tools/ParamSpider/paramspider.py -l high --exclude php,svg,jpg,png,jpeg,css,woff,woff2,tif,tiff,gif,ico,pdf,txt,js -o /root/Projects/$domain/Parameters/% -d%;


echo -e "\n Place All Parameter URLS into parameter_urls.txt"

cat /root/Projects/$domain/Parameters/* | tee  /root/Projects/$domain/parameter_urls.txt

cat /root/Projects/$domain/param_urls.txt | sort -u > /root/Projects/$domain/parameter_urls.txt | rm -rf /root/Projects/$domain/Parameters | rm -rf /root/Projects/$domain/param_urls.txt


echo "Getting openredir_urls"

cat /root/Projects/$domain/All_Urls.txt | grep -f ~/el_cazador/open_redirect_template.txt | anew /root/Projects/$domain/openredir_urls.txt


echo -e "\n Checking for Subdomain Takeover"

subzy --targets /root/Projects/$domain/sorted_subdomain.txt -concurrency 20 --hide_fails | anew /root/Projects/$domain/subdomain_takeover.txt


echo -e "\n Checking for any sensitive keys/information using XKeys"

cat /root/Projects/$domain/All_Urls.txt | xkeys -o /root/Projects/$domain/ | grep -v "Nothing!" | anew /root/Projects/$domain/Xkeys_output.txt


echo -e "\n Checking for HTTP Smuggling"

cat /root/Projects/$domain/sorted_subdomain.txt | httpx | python3  /root/Tools/smuggler/smuggler.py | anew /root/Projects/$domain/HTTP_smuggling.txt


echo -e "\n Checking for LFI"

cat /root/Projects/$domain/All_Urls.txt |gf lfi | qsreplace FUZZ | while read url ; do ffuf -u $url -mr “root:x” -w /root/el_cazador/LFI.txt ; done


echo -e "\n Checking for SQLI"

gf sqli /root/Projects/$domain/All_Urls.txt >> sqli.txt ; sqlmap -m sqli.txt --dbs --banner --batch --risk 3 --level 3

echo -e "\n Checking Nuclei Results"

nuclei -l /root/Projects/$domain/sorted_subdomain.txt -ut -v -o /root/Projects/$domain/nuclei_result.txt
