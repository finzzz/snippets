#! /bin/bash

[[ ! $(which unzip) ]] && echo "Please Install \"unzip\" first" && exit 1

installed_version=$([ -d src ] && grep -o "version: .*[0-9]" src/index.html | grep -o "[0-9].*$")
version=$(curl -s https://github.com/gchq/CyberChef/releases/latest | egrep -o "https://.*v.*[0-9]" | egrep -o "v.*$")
filename="CyberChef_"$version""

# check if update is needed
[[ "v"$installed_version"" == "$version" ]] && echo "Already Latest Version" && exit 1

# clean up previous files
rm -rf src 
mkdir src 

# install new release
wget --quiet https://github.com/gchq/CyberChef/releases/download/"$version"/"$filename".zip
unzip -q "$filename".zip -d src
rm "$filename".zip
cd src
mv "$filename".html index.html

# restart docker
#docker-compose pull
#docker-compose up -d --force-recreate
#docker image prune -af
