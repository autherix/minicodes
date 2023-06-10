#!/usr/bin/env bash

# Get the python3 executable path
python3=$(which python3)

# If the python3 executable path is empty or is equal to "/usr/bin/python3", then exit with error
if [[ -z "$python3" || "$python3" == "/usr/bin/python3" ]]; then
    echo "Python3 executable not found, or you're using the system's main python3 executable"
    exit 1
fi

# List all packages names 
python3 -m pip list --format=columns | awk '{print $1}' | tail -n +3 | while read -r line; do
    # Upgrade each package 
    printf "Upgrading %s\n" "$line"
    python3 -m pip install --upgrade "$line" --no-cache-dir
done