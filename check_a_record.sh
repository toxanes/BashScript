#!/bin/bash
#Standard Nagios plugin return codes
STATUS_OK=0
#STATUS_WARNING=1 - not used in this script
STATUS_CRITICAL=2
STATUS_UNKNOWN=3

export TERM=xterm-256color

#Text selection
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`


# Main check function
function CHECK_A_RECORD {
    DOMAIN_IP=`dig +short $DOMAIN`

    #Check output dig +short
    if [[ -z $DOMAIN_IP ]]; then
        echo "The script did ${BOLD}not recognize${NORM} DNS. Bash command:'dig +short ${BOLD}$DOMAIN${NORM}' output:'${BOLD}$DOMAIN_IP${NORM}'."
        exit $STATUS_UNKNOWN
    fi

    if [[ $DOMAIN_IP == $IP ]]; then
        echo "OK - for domain $DOMAIN address is $IP"
        exit $STATUS_OK
    else
        echo "CRITICAL - $DOMAIN ip[$DOMAIN_IP] and storage ip[$IP] not match"
        exit $STATUS_CRITICAL
    fi
}


#HELP function
function HELP {
    echo -e "Help documentation for ${BOLD}$0${NORM}"\\n
    echo -e "${REV}-d${NORM}  --Sets the ${BOLD}DNS${NORM}."
    echo -e "${REV}-a${NORM}  --Sets the ${BOLD}estimated ip address${NORM}."
    echo -e "${REV}-h${NORM}  --Displays this ${BOLD}help${NORM} message."\\n
    echo -e "Example: ${BOLD}$0 -d 'google.com' -a '8.8.8.8'${NORM}"
    exit $STATUS_UNKNOWN
}


#opt for script
while getopts :hd:a: option
    do
        case "${option}"
        in
                d) DOMAIN=${OPTARG};;
                a) IP=${OPTARG};;
                h | *) HELP
                exit;;
        esac
    done


#check arguments
if [[ -z $DOMAIN ]]; then
	echo "The script did ${BOLD}not accept${NORM} DNS. DNS:${BOLD}$DOMAIN${NORM}. IP:${BOLD}$IP${NORM}."
	exit $STATUS_UNKNOWN
fi

if [[ -z $IP ]];then
	echo "The script did ${BOLD}not accept${NORM} estimated ip address. DNS:${BOLD}$DOMAIN${NORM}. IP:${BOLD}$IP${NORM}."
	exit $STATUS_UNKNOWN
fi

#Call main check function
CHECK_A_RECORD
