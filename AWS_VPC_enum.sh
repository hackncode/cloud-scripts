# VPC and VPC Peering Enumeration Script

# This  script allows you to specify whether you want to enumerate VPCs, VPC peering connections, or both, in addition to specifying the AWS profile, region, and output file as command-line options. It then performs the requested enumerations and writes the information to the specified output file.

#!/bin/bash

# Initialize variables with default values
profile="default"
region="us-east-1"
output_file="vpc-out.txt"
enumerate_vpcs=false
enumerate_peering_connections=false

# Function to display script usage
usage() {
  echo "Usage: $0 -p <profile> -r <region> [-o <output_file>] [-v] [-c]"
  echo "Options:"
  echo "  -p <profile>    AWS profile name from .aws/credentials file"
  echo "  -r <region>     AWS region"
  echo "  -o <output_file> Output file (default: vpc-out.txt)"
  echo "  -v              Enumerate VPCs"
  echo "  -c              Enumerate VPC peering connections"
  exit 1
}

# Parse command line options
while getopts ":p:r:o:vc" opt; do
  case $opt in
    p)
      profile="$OPTARG" # Set the AWS profile name from the command line
      ;;
    r)
      region="$OPTARG"  # Set the AWS region from the command line
      ;;
    o)
      output_file="$OPTARG" # Set the output file from the command line
      ;;
    v)
      enumerate_vpcs=true
      ;;
    c)
      enumerate_peering_connections=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

# Initialize AWS CLI command
aws_command="aws ec2 describe-vpcs --profile \"$profile\" --region \"$region\""
output_message=""

# Check if VPC enumeration is requested
if [ "$enumerate_vpcs" = true ]; then
  vpcs="$($aws_command)"
  output_message="VPCs enumerated and written to $output_file"
fi

# Check if VPC peering connections enumeration is requested
if [ "$enumerate_peering_connections" = true ]; then
  peering_connections="$($aws_command-peering-connections)"
  if [ -z "$output_message" ]; then
    output_message="VPC peering connections enumerated and written to $output_file"
  else
    output_message="$output_message, VPC peering connections enumerated and written to $output_file"
  fi
fi

# Output information to the specified output file
echo "$output_message" > "$output_file"
