#!/usr/bin/env bash

# nodejs download page url: https://nodejs.org/en/download

DOWNLOAD_URL="https://nodejs.org/en/download"

# curl to get the download page and save result to a var
DOWNLOAD_PAGE=$(curl -s $DOWNLOAD_URL)

# if error happened or response code is not 200, exit with error
if [ $? -ne 0 ]; then
  echo "Error: failed to get download page."
  exit 1
fi

# https://nodejs.org/dist/v18.17.0/node-v18.17.0-linux-x64.tar.xz
# Linux Binaries<!-- --> (x64)</th><td colSpan="4"><a href="https://nodejs.org/dist/v18.17.0/node-v18.17.0-linux-x64.tar.xz">64-bit</a>

# Use regex to find the download url, between Linux Binaries<!-- --> (x64)</th><td colSpan="4"><a href=" and ">64-bit</a> and save result to a var
DOWNLOAD_URL=$(echo $DOWNLOAD_PAGE | grep -oP '(?<=Linux Binaries<!-- --> \(x64\)<\/th><td colSpan="4"><a href=")[^"]+(?=">64-bit</a>)')

# Extract file name from download url
FILE_NAME=$(echo $DOWNLOAD_URL | grep -oP '(?<=\/)[^\/]+(?=$)')

# remove last 4 chars (.tar)
DIR_NAME=${FILE_NAME%.*}
DIR_NAME=${DIR_NAME%.*}

# use wget to download the file to /tmp/ directory
wget -P /tmp/ $DOWNLOAD_URL

# if error happened or response code is not 200, exit with error
if [ $? -ne 0 ]; then
  echo "Error: failed to download nodejs."
  exit 1
fi

mkdir -p /usr/local/lib/nodejs
tar -xJvf /tmp/$FILE_NAME -C /usr/local/lib/nodejs

echo "export PATH=/usr/local/lib/nodejs/${DIR_NAME}/bin:\$PATH" >> /ptv/add_to_path.sh

source /ptv/add_to_path.sh

. ~/.profile

node -v

npm version

npx -v