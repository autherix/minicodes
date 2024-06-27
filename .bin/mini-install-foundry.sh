#!/usr/bin/env bash
# The following command in from https://getfoundry.sh
curl -L https://foundry.paradigm.xyz | bash
wait $!
foundryup
source ~/.profile
