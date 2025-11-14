#!/usr/bin/env bash

set -e

#Download latest jellyfin-ffmpeg
VERSION_CODENAME=$(awk -F= '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release)
REG="jellyfin-ffmpeg...*${VERSION_CODENAME}_amd64.deb$"
LINK=$(curl -s https://api.github.com/repos/jellyfin/jellyfin-ffmpeg/releases/latest| jq -r '.assets[] | select(.name? | match("'$REG'")) | .browser_download_url')
curl -L --output jellyfin-ffmpeg.deb ${LINK}

#Download latest seanime
<<<<<<< HEAD
VERSION_NO_V=$(echo ${SEANIME_VERSION} | sed 's/v//')
SURL=https://github.com/5rahim/seanime/releases/download/${SEANIME_VERSION}/seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz
echo $SURL
curl -L -v --output seanime.tar.gz $SURL 
ls -lahk
tar -xzf seanime.tar.gz
chmod +x seanime
=======
git clone https://github.com/5rahim/seanime.git

# Checkout the specified release tag
cd seanime
git checkout $SEANIME_VERSION


>>>>>>> parent of d3df853 (Update prepare.sh)
