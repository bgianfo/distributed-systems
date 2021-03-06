#!/bin/sh

#
# This script installs all dependencies for the distivia backend on an EC2 instance.
#
#  Dependencies:
#    * Riak        - masterless data base store
#    * protobuf    - Required by python riak client
#    * python-riak - python riak client
#    * flask       - Web app framework for python
#    * tornado     - Tornado webserver
#    * git         - Version control for our application
#
#
#

# Install Riak Server
wget http://downloads.basho.com/riak/CURRENT/riak-0.14.0-1.el5.x86_64.rpm
sudo yum -y install --nogpgcheck riak-0.14.0-1.el5.x86_64.rpm

# Install Protocol buffers library C/C++/Python
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/updates/testing/12/x86_64/protobuf-2.3.0-1.fc12.i686.rpm
sudo yum -y install --nogpgcheck protobuf-2.3.0-1.fc12.i686.rpm

wget http://packages.sw.be/monit/monit-5.2.4-1.el6.rf.x86_64.rpm
sudo yum -y install --nogpgcheck monit-5.2.4-1.el6.rf.x86_64.rpm

sudo yum -y install nginx

sudo yum -y install python26-devel

# Install python flask library
sudo easy_install flask

# Install python riak client library
sudo easy_install riak

# Install python tornado server
sudo easy_install tornado

# Install python bcrypt module
sudo easy_install bcrypt

# Install git commandline client
sudo yum -y install git
git clone git://github.com/bgianfo/distributed-systems.git

# Remove left over package files
rm -rf riak-0.14.0-1.el5.x86_64.rpm
rm -rf protobuf-2.3.0-1.fc12.i686.rpm
rm -rf monit-5.2.4-1.el6.rf.x86_64.rpm

# Setup our Riak config's
#INTERNALIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
#sudo sed -i "s/127.0.0.1/$INTERNALIP/g" /etc/riak/vm.args
#sudo sed -i "s/127.0.0.1/$INTERNALIP/g" /etc/riak/app.config
sudo python ~/distributed-systems/src/node-config/re-ip.py
sudo cp  ~/distributed-systems/src/node-config/monit.conf /etc/monit.conf

