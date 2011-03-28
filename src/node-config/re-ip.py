#!/usr/bin/python 

"""

  Script to setup Riak configuration on EC2 nodes.

"""

import socket
import os

ip = socket.gethostbyname(socket.gethostname()) 

def reipVMConfig():
    vm_args = open("/etc/riak/vm.args")
    newlines = ""
    for line in vm_args.readlines():
        if "-name" in line:
            newlines += "-name riak@"+ip + "\n"
            print "Was: " + line.strip("\n")
            print "Now: -name riak@"+ip 
            print ""
        else:
            newlines += line + "\n"

    vm_args.close()
    newfile = open("/etc/riak/vm.args", "w")
    newfile.write( newlines )
    newfile.close()

def reipAppConfig():
    newlines = ""
    x = open("/etc/riak/app.config")
    for line in x.readlines():
        if "{pb_ip," in line:
            now = "           {pb_ip, \""+ip+"\" }," 
            newlines += now  + "\n"
            print "Was: " + line.strip("\n")
            print "Now: " + now
            print ""
        elif "{http," in line:
            now = "            {http, [ {\""+ip+"\", 8098 } ] },"
            newlines += now + "\n"
            print "Was: " + line.strip("\n")
            print "Now: " + now 
            print ""
        else:
            newlines += line + "\n"
    x.close()

    newfile = open("/etc/riak/app.config", "w")
    newfile.write( newlines )
    newfile.close()

print ""
reipVMConfig()
reipAppConfig()
