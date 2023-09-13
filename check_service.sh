#!/bin/bash
version="1.1"

# Standard ICINGA2/Nagios plugin return codes
STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_UNKNOWN=3

# Default values
service_name=""

# Function to display help
function HELP {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h     Show this help message."
    echo "  -v     Show version script"
    echo "  -n     Specify the name of the service to check. For example: $0 -n ntp"
    echo "         Possible answers:"
    echo "         - Service is running."
    echo "         - Service is not running."
    exit $STATUS_UNKNOWN
}

# Function to display version
function show_version {
    echo "Version: $version"
    exit $STATUS_OK
}

# Function to check if a service is running. Use systemctl
function check_service {
    systemctl is-active "$service_name"

    if [ $? -eq 0 ]; then
        exit $STATUS_OK
    fi
}

# Command line options
while getopts "hn:v" opt; do
    case $opt in
        n)
            service_name="$OPTARG"
            ;;
        v)
            show_version
            ;;
        h)
            HELP
            ;;
        *)
            HELP
            ;;
    esac
done

# Check if service name is provided
if [ -z "$service_name" ]; then
    echo "Service name not provided."
    HELP
fi

# Call the function
check_service

# If check_service function doesn't exit
exit $STATUS_CRITICAL
