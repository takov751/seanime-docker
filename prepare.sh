#!/usr/bin/env bash

set -e

#Download latest jellyfin-ffmpeg
VERSION_CODENAME=$(awk -F= '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release)
#VERSION_CODENAME="trixie"
REG="jellyfin-ffmpeg...*${VERSION_CODENAME}_amd64.deb$"
LINK=$(curl -s https://api.github.com/repos/jellyfin/jellyfin-ffmpeg/releases/latest| jq -r --arg REG "$REG" '.assets[] | select(.name? | match($REG)) | .browser_download_url')
echo "LINK: ${LINK}"
curl -L --output jellyfin-ffmpeg.deb ${LINK}


VERSION_NO_V=$(echo ${SEANIME_VERSION} | sed 's/v//')
echo "Latest version: ${SEANIME_VERSION}"
echo "Version without v: ${VERSION_NO_V}"
curl -L --output seanime.tar.gz "https://github.com/5rahim/seanime/releases/download/${SEANIME_VERSION}/seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz"
tar -xzf seanime.tar.gz
rm seanime.tar.gz
chmod +x seanime