#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y install docker.io openssl libssl-dev ncat

bundle install
