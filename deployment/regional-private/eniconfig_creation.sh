#!/bin/bash

while getopts n:r:v: flag
do
    case "${flag}" in
        n) cluster_name=${OPTARG};;
        r) region=${OPTARG};;
        v) vpc_id=${OPTARG};;
    esac
done
# echo "Cluster Name $cluster_name, region $region, vpc $vpc_id"
# exit

if [ -z $cluster_name ]; then
  echo "Please provide cluster name"
  exit 1
fi

if [ -z $region ]; then
  echo "No region passed, using default us-west-2 region. If your cluster is different region, please pass in valid region."
  echo ""
  echo ""
  region="us-west-2"
else
  echo "Using $region for this script"
fi


if [ -z $vpc_id ]; then
  echo "No VPC ID passed. If there are more than one VPC in the region, this script picks ramdonly!"
  echo "Searching for VPC in $region"
  vpc_ids=(`aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId]' --region $region --output text`)
  if [ ${#vpc_ids[@]} -ne 1 ]; then 
    echo "There are more one VPC found in region $region, please pass in the right VPC while running the program"
    echo ${vpc_ids[*]// /|}
    exit 1
  else 
    vpc_id=${vpc_ids[0]}
    echo "Proceed with VPC $vpc_id in region $region"
  fi
fi

echo "Creating pod-netconfig.template file"

cat <<EOF >pod-netconfig.template
apiVersion: crd.k8s.amazonaws.com/v1alpha1
kind: ENIConfig
metadata:
 name: \${AZ}
spec:
 subnet: \${SUBNET_ID}
 securityGroups: [ \${NETCONFIG_SECURITY_GROUPS} ]
EOF


INSTANCE_IDS=(`aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --filters "Name=tag-key,Values=eks:cluster-name" "Name=tag-value,Values=$cluster_name*" --region $region --output text`)

NETCONFIG_SECURITY_GROUPS=$(for i in "${INSTANCE_IDS[@]}"; do  aws ec2 describe-instances --instance-ids $i --region $region --output json| jq -r '.Reservations[].Instances[].SecurityGroups[].GroupId'; done  | sort | uniq | awk -vORS=, '{print $1 }' | sed 's/,$//')

if [ -z $NETCONFIG_SECURITY_GROUPS ]; then
  echo "No security group or instance found for the Cluster $cluster_name. Please ensure the node pool is created and running."
  exit 1
fi

echo "Security group used by node group is $NETCONFIG_SECURITY_GROUPS"

echo "Creating eniconfig files in $cluster_name"

mkdir -p $cluster_name
while IFS= read -r line
do
 arr=($line)
 OUTPUT=`AZ=${arr[0]} NETCONFIG_SECURITY_GROUPS=${NETCONFIG_SECURITY_GROUPS} SUBNET_ID=${arr[1]} envsubst < pod-netconfig.template | yq eval -P`
 FILENAME=${arr[0]}.yaml
 echo "Creating ENIConfig file:  $cluster_name/$FILENAME"
 cat <<EOF >$cluster_name/$FILENAME
$OUTPUT
EOF
done< <(aws ec2 describe-subnets  --filters "Name=cidr-block,Values=100.*.*" "Name=vpc-id,Values=$vpc_id" --query 'Subnets[*].[AvailabilityZone,SubnetId]' --region ${region} --output text)
