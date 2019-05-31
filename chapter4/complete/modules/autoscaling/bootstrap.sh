#!/bin/bash
cd run
wget https://s3-us-west-2.amazonaws.com/terraform-in-action/deployment.zip -O deployment.zip
unzip deployment.zip
mv deployment/* .
rm -rf deployment*
./server