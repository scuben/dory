#!/usr/bin/env bash

# There's a dnsmasq container listening under user lxc-dnsmasq.
# This will interfere with our test
for i in $(lsof -i :53 | awk '{print $2}' | tail -n +2 | xargs); do
  echo ""
  echo "Killing PID $i cause it's listening on port 53"
  echo "PID $i info:"
  sudo ps -p $i -o user -o command
  sudo kill $i
  echo ""
done
