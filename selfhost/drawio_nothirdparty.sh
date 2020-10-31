#! /bin/bash

# download release
VERSION=$(curl -s https://github.com/jgraph/drawio/releases/latest/ | grep -E -o "tag/.*[0-9]" | cut -d '/' -f 2)
wget -O - https://github.com/jgraph/drawio/archive/"$VERSION".tar.gz | tar -xzf -

FOLDERNAME="drawio-${VERSION:1}"
JS_FILE="$FOLDERNAME/src/main/webapp/js/app.min.js"

cp "$JS_FILE" "$JS_FILE".bak
sed -ie "s#https://apis.google.com/#notexist/#" "$JS_FILE"
sed -ie "s#https://app.diagrams.net#notexist/#" "$JS_FILE"
sed -ie "s#https://api.trello.com/#notexist/#" "$JS_FILE"
sed -ie "s#https://api.trello.com/#notexist/#" "$JS_FILE"
sed -ie "s#https://code.jquery.com/#notexist/#" "$JS_FILE" # trello jquery url
sed -ie "s#https://www.dropbox.com/#notexist/#" "$JS_FILE"

