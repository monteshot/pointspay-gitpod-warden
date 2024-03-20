#!/bin/bash

read -t 30 -p "Do you want to deploy the database? (Y(default)/n): " answer
# Set default answer to "y" if no input is provided within 30 seconds
answer="${answer:-y}"

if [[ $answer == "y" || $answer == "Y" ]]; then
    echo "Retrieving the list of DB dump files..."
    STORAGEBOX_DESTINATION_PATH="/home/gitpod/dumps"

    # Function to download a dump and check if it's empty
    download_and_check() {
        sshpass -p "$STORAGEBOX_PASS" scp -P 23 "$STORAGEBOX_USER@$STORAGEBOX_HOST:$STORAGEBOX_SOURCE_PATH/$1" "$STORAGEBOX_DESTINATION_PATH/$1"
        if [[ ! -e "$STORAGEBOX_DESTINATION_PATH/$1" || ! -s "$STORAGEBOX_DESTINATION_PATH/$1" ]]; then
            return 1
        else
            return 0
        fi
    }

    # Get the list of dump files in reverse chronological order
    dump_files=($(sshpass -p "$STORAGEBOX_PASS" ssh -p 23 "$STORAGEBOX_USER@$STORAGEBOX_HOST" "ls -1t $STORAGEBOX_SOURCE_PATH"))

    # Try importing each dump file in the list
    for dump_file in "${dump_files[@]}"; do
        echo "Downloading $dump_file..."
        if download_and_check "$dump_file"; then
            echo "Starting the DB import for $dump_file..."
            cd "$GITPOD_REPO_ROOTS"
            pv "$STORAGEBOX_DESTINATION_PATH/$dump_file" | gunzip -c | warden db import
            echo "Import has been completed successfully."
            break
        else
            echo "Error: Downloading $dump_file failed or file is empty. Trying the previous one..."
        fi
    done

    # Check if no valid dump was found
    if [[ ! -e "$STORAGEBOX_DESTINATION_PATH/$dump_file" ]]; then
        echo "Error: No valid dump found. Exiting."
        exit 1
    fi

else
    echo "The database deployment has been canceled."
fi
