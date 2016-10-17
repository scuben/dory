#!/usr/bin/env bash

sudo apt-get update
yes | sudo apt-get -y install docker.io openssl libssl-dev nmap

bundle install
