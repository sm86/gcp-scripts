#!/bin/bash

MACHINE_IMAGE_NAME="base-image"

# Prompt the user for the number of instances
read -p "Enter the number of instances you'd like to create (default is 4): " TOTAL_INSTANCES

# If the user doesn't provide input for number of instances, default to 4
if [[ -z "$TOTAL_INSTANCES" ]]; then
    TOTAL_INSTANCES=4
fi

# Prompt the user for the instance prefix
read -p "Enter the prefix for your instances (default is benchmark-instance): " INSTANCE_PREFIX

# If the user doesn't provide input for instance prefix, default to "benchmark-instance"
if [[ -z "$INSTANCE_PREFIX" ]]; then
    INSTANCE_PREFIX="benchmark-instance"
fi

# Prompt the user for the output file name
read -p "Enter the desired name for your output CSV file (default is instances_ip.csv): " OUTPUT_FILE

# If the user doesn't provide input for output file, default to "output.csv"
if [[ -z "$OUTPUT_FILE" ]]; then
    OUTPUT_FILE="instances_ip.csv"
fi

# Check if OUTPUT_FILE already exists
if [[ -f "$OUTPUT_FILE" ]]; then
    read -p "The file $OUTPUT_FILE already exists. Do you want to replace it? (y/N): " REPLACE
    if [[ "$REPLACE" != "y" && "$REPLACE" != "Y" ]]; then
        echo "Exiting without creating instances."
        exit 1
    fi
fi

# Ask the user if they want to set up SSH access
read -p "Do you want to set up SSH access for the instances? (y/N): " response

# Create or overwrite the CSV file with headers
echo "Instance Name,Internal IP,External IP" > $OUTPUT_FILE

for ((i=1; i<=TOTAL_INSTANCES; i++)); do
    INSTANCE_NAME="$INSTANCE_PREFIX-$i"

    # Check if instance already exists
    if gcloud compute instances describe $INSTANCE_NAME &> /dev/null; then
        echo "Error: VM Instance $INSTANCE_NAME already exists!"
        continue
    fi

    echo "Creating VM Instance: $INSTANCE_NAME"
    
    # Create the instance
    gcloud compute instances create $INSTANCE_NAME --source-machine-image=$MACHINE_IMAGE_NAME --machine-type=e2-standard-4 --provisioning-model=STANDARD 
    
    # Retrieve its internal IP
    INSTANCE_INTERNAL_IP=$(gcloud compute instances describe $INSTANCE_NAME --format='get(networkInterfaces[0].networkIP)')
    
    # Retrieve its external IP
    INSTANCE_EXTERNAL_IP=$(gcloud compute instances describe $INSTANCE_NAME --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

    # Append to the CSV
    echo "$INSTANCE_NAME,$INSTANCE_INTERNAL_IP,$INSTANCE_EXTERNAL_IP" >> $OUTPUT_FILE
done

echo "CSV file created at $OUTPUT_FILE"

if [[ "$response" == "y" || "$response" == "Y" ]]; then
    # Skip the header line and read the file line by line
    echo "Setting up SSH access for the instances..."
    tail -n +2 "$OUTPUT_FILE" | while IFS=, read -r instance_name internal_ip external_ip; do
        # Establish SSH connection
        gcloud compute ssh "$instance_name" --command="exit"
    done
else
    echo "SSH setup skipped."
fi