#!/bin/bash

# Standard Nagios plugin return codes.
STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_UNKNOWN=3

#HELP function
function HELP {
   NORM=`tput sgr0`
   BOLD=`tput bold`
   REV=`tput smso`
   echo -e "Help documentation for ${BOLD}$0${NORM}"\\n
   echo "${REV}-P${NORM}  --Sets the ${BOLD}port."
   echo "${REV}-H${NORM}  --Sets the ${BOLD}host."
   echo -e "${REV}-h${NORM}  --Displays this ${BOLD}h${NORM}elp message."\\n
   echo -e "Example: ${BOLD}$0 -H 127.0.0.1 -P 80 ${NORM}"
   exit $STATUS_UNKNOWN
}

while getopts ":P:H:h" opt; do
    case $opt in
      H)
        HOST=$OPTARG
        ;;
      P)
        PORT=$OPTARG
        ;;
      h)
         HELP
         ;;
     *)
         HELP
         ;;
        esac
    if [ -z $OPTARG ]; then
      HELP
        exit 1
    fi
done

if [[ -z ${HOST} || -z ${PORT}  ]]; then
        HELP
else
    RESULT=$(exec 3> /dev/tcp/${HOST}/${PORT})
    if [ $? -ne 0 ]; then
        echo ${RESULT}
        exit $STATUS_CRITICAL
    else
        echo "OK: Port ${PORT} on host ${HOST} is open"
        exit $STATUS_OK
    fi
fi
