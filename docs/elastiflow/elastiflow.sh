#!/bin/bash

apt-get update && apt-get upgrade --assume-yes --quiet
apt-get install --assume-yes --quiet python3 python3-pip

python3 -m pip install ansible

ansible --version
