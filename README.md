# el_cazador
Subdomain Enumeration Automate, URLs, Parameter URLs, Open Redirect, Subdomain Takeover check,Directory Brute force, Sensitive Data Checks on URLs, HTTP Smuggling, LFI & SQLi.


This tool is to automate your Recon process.

# Installation:

Believing this is being ran on root user.

git clone https://github.com/nihaltikka/el_cazador.git

chmod +x Pre_Hunt_installations.sh recon.sh

sed -i -e 's/\r$//' Pre_Hunt_installations.sh

mv ~/el_cazador/Pre_Hunt_installations.sh ~

mv ~/el_cazador/recon.sh ~

     $./Pre_Hunt_installations.sh

     $./recon.sh target.com


# Config Updation

1) Update the GitHub token into your recon.sh
2) Update blind xss domain to find XSS 



# Extra issue solvers.

1 -- export GOROOT=/usr/local/go
     export GOPATH=$HOME/go
     export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH
     
     Run above 3 lines if go tools are not working directly on terminal from anywhere
   
2 -- To update Nuclei 

      $nuclie -update  (For Nuclie Update)
      $nuclie -ut      (For Template update)



# Note 

Still working to add more tools and recon process into this bash tool.
