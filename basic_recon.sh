#!/bin/bash

###################################################################
#Script Name	: Recon with El_Cazad0r                                                                                                                                                                                 
#Author       	: El_Cazad0r                                               
#Email         	: el_cazad0r@outlook.com                                           
###################################################################


########################################
# Happy Hunting
########################################

banner ReCon

domain=$1

mkdir -p ~/Projects/$domain/

echo "Getting domains from crtsh"

python3 ~/crtsh/crtsh.py -d $1 | anew ~/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from subfinder"

subfinder -d $1 -recursive | anew ~/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from assetfinder"

assetfinder -subs-only $1 |grep -v "*." | anew ~/Projects/$domain/subdomains.txt

echo -e "\n Getting domains from findomain"

findomain -t $1  -u  ~/Projects/$domain/findomain_subdomains.txt

echo -e "\n Getting domains from Sublist3r"

python3 ~/Sublist3r/sublist3r.py -d $1 -o ~/Projects/$domain/sublister_subdomains.txt

echo -e "\n Getting domains from Amass"

amass enum -passive -d $1 -o ~/Projects/$domain/amass_subdomains.txt


echo -e "\n Getting domains Sorted into sorted_subdomain.txt"

cat ~/Projects/$domain/subdomains.txt ~/Projects/$domain/sublister_subdomains.txt  ~/Projects/$domain/amass_subdomains.txt ~/Projects/$domain/findomain_subdomains.txt| httprobe | sort -u > ~/Projects/$domain/sorted_subdomain.txt

echo -e "\n Getting all live domains into live_domains.txt"

cat ~/Projects/$domain/sorted_subdomain.txt | httpx | anew ~/Projects/$domain/live_domains.txt

echo -e "\n Getting all URLS using waybackurls"

cat ~/Projects/$domain/sorted_subdomain.txt | waybackurls | sort -u > ~/Projects/$domain/All_Urls.txt

echo -e "\n Getting all live URLS"

cat ~/Projects/$domain/All_Urls.txt | httpx | tee -a ~/Projects/$domain/live_urls.txt

echo -e "\n Getting parameter_urls"

paramspider -l  ~/Projects/$domain/sorted_subdomain.txt 

cat  ~/Projects/$domain/results/* | anew  ~/Projects/$domain/paramurls.txt

cat ~/Projects/$domain/paramurls.txt | sort -u | tee ~/Projects/$domain/unique_param_urls.txt

cat  ~/Projects/$domain/paramurls.txt | httpx | anew ~/Projects/$domain/live_param_urls.txt 

echo "Getting openredir_urls"

cat ~/Projects/$domain/All_Urls.txt  ~/Projects/$domain/param_urls.txt|egrep -e ?url= -e ?rurl -e ?next -e ?link -e ?lnk -e ?target= -e ?dest= -e ?destination= -e ?redir -e ?redirect_uri -e ?redirect_url -e /redirect/ -e ?view= -e ?login -e ?to= -e ?image_url= -e ?return= -e ?returnTo= -e ?return_to= -e ?continue= -e ?return_path= -e path= -e location= -e /out/ -e /out? -e ?go= -e ?return= -e /cgi-bin/redirect.cgi?| anew ~/Projects/$domain/openredir_urls.txt

echo -e "\n Checking for Subdomain Takeover"

subzy r --targets ~/Projects/$domain/sorted_subdomain.txt --concurrency 20 --hide_fails | anew ~/Projects/$domain/subdomain_takeover.txt


echo -e "\n Checking for any sensitive keys/information using XKeys"

cat ~/Projects/$domain/All_Urls.txt | xkeys -o ~/Projects/$domain/ | grep -v "Nothing!" | anew ~/Projects/$domain/Xkeys_output.txt

echo -e "\n Checking Nuclei Results"

nuclei -l ~/Projects/$domain/sorted_subdomain.txt -o ~/Projects/$domain/nuclei_result.txt

echo -e "\n Checking for open ports"

cat ~/Projects/$domain/sorted_subdomain.txt | dnsx | anew ~/Projects/$domain/naabu_host.txt

naabu -list ~/Projects/$domain/naabu_host.txt -top-ports 10000 -exclude-ports 80,443 -o ~/Projects/$domain/open_ports.txt

echo "Recon Completed" $domain | notify
