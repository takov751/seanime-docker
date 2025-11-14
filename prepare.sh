#!/usr/bin/env bash

set -e

#Download latest jellyfin-ffmpeg
VERSION_CODENAME=$(awk -F= '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release)
REG="jellyfin-ffmpeg...*${VERSION_CODENAME}_amd64.deb$"
LINK=$(curl -s https://api.github.com/repos/jellyfin/jellyfin-ffmpeg/releases/latest| jq -r '.assets[] | select(.name? | match("'$REG'")) | .browser_download_url')
curl -L --output jellyfin-ffmpeg.deb ${LINK}

#Download latest seanime
VERSION_NO_V=$(echo ${SEANIME_VERSION} | sed 's/v//')
curl -L --output seanime.tar.gz "https://github.com/5rahim/seanime/releases/download/${SEANIME_VERSION}/seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz"
ls -lahk
tar -xzf seanime.tar.gz
chmod +x seanime
