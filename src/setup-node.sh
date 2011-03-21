#!/bin/sh

#
# This script installs all dependencies for the distivia backend on an EC2 instance.
#
#  Dependencies:
#    * Riak        - masterless data base store
#    * protobuf    - Required by python riak client
#    * python-riak - python riak client
#    * flask       - Web app framework for python
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

# Install python flask library
sudo easy_install flask

# Install python riak client library
sudo easy_install riak

# Install git commandline client
sudo yum -y install git
git clone git://github.com/bgianfo/distributed-systems.git

# Remove left over package files
rm -rf riak-0.14.0-1.el5.x86_64.rpm
rm -rf protobuf-2.3.0-1.fc12.i686.rpm
