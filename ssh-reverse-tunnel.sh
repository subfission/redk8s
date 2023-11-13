#!/bin/bash

# Function to display usage message
function display_usage {
    echo "This script will help you create a reverse SSH tunnel for a"
    echo "secure connection from a target host."
    echo
    echo "Usage: $0 -s <source> -d <destination> -l <local_port> -r <remote_port>"
    echo "Options:"
    echo "  -s    Source (local) address or hostname"
    echo "  -d    Destination (remote) address or hostname"
    echo "  -l    Local port to bind"
    echo "  -r    Remote port on the destination server"
    echo "  -h    Display this usage message"
    exit 1
}

# Parse command line options
while getopts ":s:d:l:r:h" opt; do
  case $opt in
    s)
      source_host="$OPTARG"
      ;;
    d)
      dest_host="$OPTARG"
      ;;
    l)
      local_port="$OPTARG"
      ;;
    r)
      remote_port="$OPTARG"
      ;;
    h)
      display_usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      display_usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      display_usage
      ;;
  esac
done

# Check if all required arguments are provided
if [[ -z $source_host || -z $dest_host || -z $local_port || -z $remote_port ]]; then
    echo "All arguments are required."
    display_usage
fi

# Establish SSH reverse tunnel
echo "Setting up SSH reverse tunnel..."
echo "Running: ssh -nNT -R $remote_port:localhost:$local_port $dest_host -l $USER"
ssh -nNT -R $remote_port:localhost:$local_port $dest_host -l $USER
echo "SSH reverse tunnel established from $source_host:$local_port to $dest_host:$remote_port"
