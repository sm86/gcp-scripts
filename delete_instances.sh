#!/bin/bash

# Check if the user has provided an input file, otherwise default to instances_ip.csv
INPUT_FILE="${1:-instances_ip.csv}"

# Check if the file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "File $INPUT_FILE not found!"
    exit 1
fi

# Read the file line by line
while IFS=, read -r instance_name external_ip; do
    # Skip the header line
    if [[ "$instance_name" == "Instance Name" ]]; then
        continue
    fi

    # Delete the instance
    echo "Deleting VM Instance: $instance_name"
    gcloud compute instances delete "$instance_name" --quiet

done < "$INPUT_FILE"

echo "All instances from $INPUT_FILE have been deleted."

# Offer to delete the CSV output file upon successful deletion
read -p "Do you want to delete the CSV file $INPUT_FILE? (y/N): " DELETE_CSV

if [[ "$DELETE_CSV" == "y" || "$DELETE_CSV" == "Y" ]]; then
    rm "$INPUT_FILE"
    echo "$INPUT_FILE has been deleted."
else
    echo "Kept $INPUT_FILE."
fi