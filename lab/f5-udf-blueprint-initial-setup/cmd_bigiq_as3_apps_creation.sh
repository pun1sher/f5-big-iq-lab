#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

# Default value set to UDF
env="udf"

############################################################################################
# CONFIGURATION
ip_cm1="$(cat hosts | grep cm-1 | awk '{print $2}' | sed 's/ansible_host=//g')"

############################################################################################

function pause(){
   read -p "$*"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# SECONDS used for total execution time (see end of the script)
SECONDS=0

echo -e "\nEnvironement:${RED} $env ${NC}\n"

echo -e "\n${GREEN}Create AS3 Applications${NC}"
sudo docker build -t f5-big-iq-onboarding .
sudo docker run -t f5-big-iq-onboarding ansible-playbook --version
echo -e "\n${RED}Make sure paula and paul users are correctly created on the BIG-IQ.${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

./ansible_helper ansible-playbook /ansible/bigiq_deploy_default_as3_app_svc_udf.yml -i /ansible/hosts $DEBUG_arg

# Move Security Apps + DNS into Airport Security GLobal App
./ansible_helper ansible-playbook -i notahost, /ansible/create_default_global_app_site16_site18_dns_bigiq.yml $DEBUG_arg

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

# total script execution time
echo -e "$(date +'%Y-%d-%m %H:%M'): elapsed time:${RED} $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec${NC}"