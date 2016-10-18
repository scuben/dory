#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y -o Dpkg::Options::='--force-confnew' install docker.io openssl libssl-dev nmap

bundle install
