#!/usr/bin/env bash

INTERNALIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

sudo riak-admin reip riak@127.0.0.1 riak@$INTERNALIP

for IP in $@
do
    sudo riak-admin join riak@$IP
done

# Get the final status
sudo riak-admin status
