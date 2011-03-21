#!/usr/bin/env bash

INSTANCE_IPS=`ec2-describe-instances | grep INSTANCE | cut -f4`
INTERNAL_IPS=`ec2-describe-instances | grep INSTANCE | cut -f18`
KEY=~/.ec2/id_rsa-brian-keypair

ec2-authorize default -p 8098
ec2-authorize default -p 8099
ec2-authorize default -p 80
ec2-authorize default -p 22

for IP in $INSTANCE_IPS
do
    # Copy over our provisioning script
    scp -i $KEY setup-node.sh ec2-user@$IP:.
    scp -i $KEY join-node.sh ec2-user@$IP:.

    # Execute the provisioning script
    ssh -t -i $KEY ec2-user@$IP ./setup-node.sh
done

for IP in $INSTANCE_IPS
do
    ssh -t -i $KEY ec2-user@$IP riak stop
    ssh -t -i $KEY ec2-user@$IP riak start
done

for IP in $INSTANCE_IPS
do
    ssh -t -i $KEY ec2-user@$IP ./join-node.sh  $INTERNAL_IPS
done


