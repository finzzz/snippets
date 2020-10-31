#! /bin/bash

#Folder Structures
#.
#├── appimagetool-x86_64.AppImage
#└── file.AppImage

APPIMAGE="./file.AppImage" # change this
APPIMAGETOOL="./appimagetool-x86_64.AppImage" # check if exists
CHROME_PATH="/usr/lib/chromium/chrome-sandbox" # check if exists

TARGET=$(basename "$APPIMAGE" .AppImage)

[ ! -f "$APPIMAGE" ] && echo "$APPIMAGE" doesn\'t exist && exit
[ ! -f "$APPIMAGETOOL" ] && echo "$APPIMAGETOOL" doesn\'t exist && exit

chmod +x "$APPIMAGETOOL"
chmod +x "$APPIMAGE"
"$APPIMAGE" --appimage-extract
mv squashfs-root "$TARGET"
rm "$TARGET"/chrome-sandbox
ln -s "$CHROME_PATH" "$TARGET"/
ARCH=$(uname -m) "$APPIMAGETOOL" "$TARGET"
rm -rf "$TARGET"
