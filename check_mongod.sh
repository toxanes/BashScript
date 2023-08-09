# Standard ICINGA2/Nagios plugin return codes

STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_UNKNOWN=3

# Function to display help
function HELP {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h     This script check status service mongod"
    exit $STATUS_UNKNOWN
}

# Function to check if MongoDB process is running or not running. Use pgrep
function check_mongodb {
    pgrep -x "mongod" > /dev/null

    # Check status
    if [ $? -eq 0 ]; then
        # MongoDB is running
        echo "MongoDB process is running."
        exit $STATUS_OK
    else
        # MongoDB is not running
        echo "MongoDB process is not running."
        exit $STATUS_CRITICAL
    fi
}

# line options
while getopts "h" opt; do
    case $opt in
      h)
        HELP
        ;;
    esac
done

# Call the function
check_mongodb