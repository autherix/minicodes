#!/usr/bin/env bash

# Install Chrome
sudo apt update
sudo apt install -y wget
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

# Check the version of Chrome you installed
# google-chrome --version
gc_version_complete=$(google-chrome --version | cut -d ' ' -f 3 | cut -d '.' -f 1-3)
# echo $gc_version_complete
# Get the first part of the version number (e.g. 111)
gc_version=$(echo $gc_version_complete | cut -d '.' -f 1)
# echo $gc_version
# Download the appropriate version of the Chrome driver from the official website. You can find the download link here
# Send curl to https://sites.google.com/chromium.org/driver/ and save the response to a var
curl_response=$(curl https://sites.google.com/chromium.org/driver/)
# echo "curl_response: $curl_response"
# Find a tag with the href https://chromedriver.storage.googleapis.com/index.html?path=$gc_version and sth after it until the first "
curl_response_url=$(echo $curl_response | grep -o "href=\"https://chromedriver.storage.googleapis.com/index.html?path=$gc_version.*\"" | cut -d '"' -f 2)
# echo "curl_response_url: $curl_response_url"
# Now select the string between '?path=' and the first '/' after it
dl_url=$(echo $curl_response_url | grep -o "?path=.*\/" | cut -d '/' -f 1 | cut -d '=' -f 2)
echo "curl_response_url: $dl_url"
# Now wget the file https://chromedriver.storage.googleapis.com/$dl_url/chromedriver_linux64.zip
wget https://chromedriver.storage.googleapis.com/$dl_url/chromedriver_linux64.zip --show-progress

# Unzip the downloaded file
unzip chromedriver_linux64.zip

# Move the chromedriver binary to a directory in your system PATH
sudo mv chromedriver /usr/local/bin/

# Remove the downloaded files
rm google-chrome-stable_current_amd64.deb
rm chromedriver_linux64.zip

echo "google-chrome version: $(google-chrome --version)"
echo "chromedriver version: $(chromedriver --version)"

echo "All Done, You're ready to go!"

# Now, you should have Chrome and the Chrome driver installed on your Ubuntu server. You can run the Python script I provided earlier to test the installation.