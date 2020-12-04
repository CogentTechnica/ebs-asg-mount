#!/bin/bash 

#getting instance
azabzone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

#getting available ebs  volume-id
ebsvolume=$(aws ec2 describe-volumes --region us-east-2 --filters Name=tag-value,Values=author Name=tag-value,Values=dev Name=tag-value,Values=aem Name=availability-zone,Values=`echo $azabzone` --query 'Volumes[*].[VolumeId, State==`available`]' --output text  | grep True | awk '{print $1}' | head -n 1)

#check if there are available ebs vloumes
 if [ -n "$ebsvolume" ]; then #getting instance id

# Retrieve instance ID
instanceid=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

#attaching ebs    
aws ec2 attach-volume --region us-east-2 --volume-id `echo $ebsvolume` --instance-id `echo $instanceid` --device /dev/sdh

sleep 10 

# partition volume
mkfs -t ext3 /dev/sdh

# create directory for mount
mkdir /mnt/(dirctory)

# mount ebs to /mnt
mount /dev/sdh /mnt/(directory)
fi
