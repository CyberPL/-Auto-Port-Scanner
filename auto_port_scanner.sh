#!/bin/bash

TARGETS_FILE="targets.txt"
MASSCAN_OUTPUT="MASSCAN_OUTPUT.txt"
NMAP_OUTPUT="NMAP_OUTPUT.txt"
MERGED_OUTPUT="MERGED_OUTPUT.txt"
OPEN_PORTS="OPEN_PORTS.txt"
RED='\e[31m'           #RED
GREEN='\e[32m'         #GREEN
BLUE='\e[34m'          #BLUE
BOLD_YELLOW='\e[33;1m' #BOLD_YELLOW
BOLD_RED='\e[31;1m'    #BOLD_RED
END='\e[0m'

ascii_art='''
    _  _   _ _____ ___          ___  ___  ___ _____         ___  ___   _   _  _ _  _ ___ ___ 
   /_\| | | |_   _/ _ \   ___  | _ \/ _ \| _ \_   _|  ___  / __|/ __| /_\ | \| | \| | __| _ \
  / _ \ |_| | | || (_) | |___| |  _/ (_) |   / | |   |___| \__ \ (__ / _ \| .` | .` | _||   /
 /_/ \_\___/  |_| \___/        |_|  \___/|_|_\ |_|         |___/\___/_/ \_\_|\_|_|\_|___|_|_\
                                              
'''
echo -e "${RED}$ascii_art${END}"
echo -e "${BOLD_YELLOW}                                                                                  By: CyberPL ${END}"

# Perform masscan port scan
echo -e "${BOLD_YELLOW}---------------------------[ MASSCAN ]---------------------------${END}"
echo -e "${GREEN} masscan -iL "${TARGETS_FILE}" -p- -oL "${MASSCAN_OUTPUT}" ${END}"
masscan -iL "${TARGETS_FILE}" -p- -oL "${MASSCAN_OUTPUT}"

# Extracting Open ports find via masscan
cat "${MASSCAN_OUTPUT}" | grep "open" | awk '{print $3}' > "masscan_port.txt"


# If you to set a range use '-r' like '-r 1 - 500'
# Perform rustscan port scan 
echo -e "${BOLD_YELLOW}--------------------------[ RUSTSCAN ]---------------------------${END}"
echo -e "${GREEN} rustscan -a "${TARGETS_FILE}" -g -r 1-65535 | awk '{print $3}' | tr -d []  > "rustscan_port.txt" ${END}" 
rustscan -a "${TARGETS_FILE}" -g -r 1-65535 | awk '{print $3}' | tr -d []  > "rustscan_port.txt"



# Perform nmap port scan
echo -e "${BOLD_YELLOW}----------------------------[ NMAP ]-----------------------------${END}"
echo -e "${GREEN} nmap -iL "${TARGETS_FILE}" -p1-65535 > "${NMAP_OUTPUT}" ${END}" 
nmap -iL "${TARGETS_FILE}" -p1-65535 > "${NMAP_OUTPUT}"

# Extracting Open ports find via nmap
cat "${NMAP_OUTPUT}" | grep "open" | awk '{print $1}' | sed 's/\/[tu][cd]p//' > "nmap_port.txt"



# Merging all open ports data file 
cat masscan_port.txt nmap_port.txt rustscan_port.txt | sort -u | tr '\n' ',' | sed 's/,$//' > "${OPEN_PORTS}"

# Removing extra data file  (Prompt)
echo -e "${BLUE} --> Do you want to remove extra files?(y/n) ${END}"
read choice 
if [ "${choice}" == "y" ]; then

    rm  ${MASSCAN_OUTPUT} masscan_port.txt ${NMAP_OUTPUT} nmap_port.txt rustscan_port.txt ;
else
    echo -e "${BOLD_RED} Files were not deleted ${END}"
fi

# Prompt
echo -e "${BLUE} --> Do you want to perform an nmap script scan?(y/n) ${END}"
read choice

# Check the user's choice
if [ "${choice}" == "y" ]; then
echo -e "${BLUE} --> Set timing T<0-5> ${END}"
read a 
ports=`echo $(cat OPEN_PORTS.txt)`

    # Run the nmap script scan
    echo -e "${GREEN} nmap -v -T${a} -p${ports} --script vuln -iL ${TARGETS_FILE} ${END}"
    nmap -v -T${a} -p${ports} --script vuln -iL ${TARGETS_FILE}
else
    echo "Nmap Script Scan cancelled."
fi

echo -e "${BOLD_RED} Scan completed and results saved. ${END}"

