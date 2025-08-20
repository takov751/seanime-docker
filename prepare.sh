#!/usr/bin/env bash

set -e

#Download latest jellyfin-ffmpeg
VERSION_CODENAME=$(awk -F= '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release)
REG="jellyfin-ffmpeg...*${VERSION_CODENAME}_amd64.deb$"
LINK=$(curl -s https://api.github.com/repos/jellyfin/jellyfin-ffmpeg/releases/latest| jq -r '.assets[] | select(.name? | match("'$REG'")) | .browser_download_url')
curl -L --output jellyfin-ffmpeg.deb ${LINK}

#Download latest seanime
git clone https://github.com/5rahim/seanime.git

# Checkout the specified release tag
cd seanime
git checkout $SEANIME_VERSION


