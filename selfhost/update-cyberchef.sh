#! /bin/bash

CYBERCHEF_FOLDER="cyberchef"

[[ ! $(which unzip) ]] && echo "Please Install \"unzip\" first" && exit 1

installed_version=$([ -d "$CYBERCHEF_FOLDER" ] && grep -o "version: .*[0-9]" "$CYBERCHEF_FOLDER"/index.html | grep -o "[0-9].*$")
version=$(curl -s https://github.com/gchq/CyberChef/releases/latest | egrep -o "https://.*v.*[0-9]" | egrep -o "v.*$")
filename="CyberChef_"$version""

# check if update is needed
[[ "v"$installed_version"" == "$version" ]] && echo "Already Latest Version" && exit 1

# clean up previous files
rm -rf "$CYBERCHEF_FOLDER"
mkdir "$CYBERCHEF_FOLDER"

# install new release
wget --quiet https://github.com/gchq/CyberChef/releases/download/"$version"/"$filename".zip
unzip -q "$filename".zip -d "$CYBERCHEF_FOLDER"
rm "$filename".zip
mv "$CYBERCHEF_FOLDER"/{"$filename".html,index.html}