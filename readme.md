# Google Cloud Compute Instance Management for Benchmarking Project

This guide provides instructions on how to use the provided scripts to create and delete virtual machine instances on Google Cloud Platform (GCP).

## Prerequisites

1. You should have [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed.
2. Make sure you've authenticated with GCP: `gcloud auth login`
3. Set your GCP project: `gcloud config set project [PROJECT_ID]`
4. Ensure that the Google Compute Engine API is enabled for your project.

## Creating Instances

### Script: `create_instances.sh`

This script allows you to create multiple virtual machine instances on GCP.

#### Usage:

1. Make the script executable:
\```bash
chmod +x create_instances.sh
\```

2. Run the script:
\```bash
./create_instances.sh
\```

3. Follow the on-screen prompts. You'll be asked for:
   - Number of instances you'd like to create.
   - Prefix for your instances.
   - Desired name for your output CSV file (which will store the instance names along with their internal and external IPs).

### Output:

A CSV file with the following format:

\```
Instance Name,Internal IP,External IP
benchmark-instance-1,10.128.0.2,34.86.145.210
...
\```

## Deleting Instances

### Script: `delete_instances.sh`

This script allows you to delete virtual machine instances on GCP based on a given CSV file.

#### Usage:

1. Make the script executable:
\```bash
chmod +x delete_instances.sh
\```

2. Run the script with the CSV file as an argument:
\```bash
./delete_instances.sh instances_ip.csv
\```

Replace `instances_ip.csv` with the name of your CSV file if it's different.

### Note:

The provided CSV file should have the instance names you want to delete in the format produced by `create_instances.sh`.

---

**IMPORTANT**: Always ensure you understand what a script is doing before executing it, especially when it comes to creating or deleting resources on a cloud platform to avoid unexpected costs or data loss.
