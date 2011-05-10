from __future__ import with_statement
from fabric.api import *

env.key_filename = "/Users/burny/.ec2/id_rsa-brian-keypair"
env.user = "ec2-user"
env.hosts = ['ec2-50-17-133-27.compute-1.amazonaws.com',
             'ec2-184-73-37-124.compute-1.amazonaws.com',
             'ec2-50-16-110-52.compute-1.amazonaws.com',
             'ec2-50-17-21-159.compute-1.amazonaws.com',
             'ec2-50-17-163-21.compute-1.amazonaws.com']

def killall():
    server = "distributed-systems/src/server"
    with cd(server):
        sudo('make kill')

def restart():
    server = "distributed-systems/src/server"
    with cd(server):
        sudo('make run')

def update():
    distrivia = "distributed-systems"
    with cd(distrivia):
        run('git pull')

def deploy():
    update()
    restart()

def status():
    try:
        run('pgrep -fl server.py')
    except:
        print "Not running..."
