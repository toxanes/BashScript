#!/bin/bash
version="1.0"

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
    echo "  -n     Specify the name of the service to check."
    echo "  -v     Show version script"
    exit $STATUS_UNKNOWN
}

# Function to display version
function show_version {
    echo "Version: $version"
    exit $STATUS_OK
}

# Function to check if a service is running. Use systemctl
function check_service {
    systemctl is-active --quiet "$service_name"
    
    # Check status
    if [ $? -eq 0 ]; then
        # Service is running
        echo "$service_name service is running."
        exit $STATUS_OK
    else
        # Service is not running
        echo "$service_name service is not running."
        exit $STATUS_CRITICAL
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
