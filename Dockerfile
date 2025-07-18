FROM debian:bookworm-slim AS base

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        wget \
        tar \
        jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Jellyfin's FFmpeg, mpv, yt-dlp(using debian-backports to simplify)
RUN curl -fsSL https://repo.jellyfin.org/debian/jellyfin_team.gpg.key | gpg --dearmor -o /usr/share/keyrings/jellyfin-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/jellyfin-archive-keyring.gpg] https://repo.jellyfin.org/debian bookworm main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends jellyfin-ffmpeg6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/lib/jellyfin-ffmpeg/:$PATH"

WORKDIR /app/
RUN mkdir /downloads

FROM base AS final

ARG SEANIME_VERSION
# Download and install latest version
RUN VERSION_NO_V=$(echo ${SEANIME_VERSION} | sed 's/v//') && \
    echo "Installing seanime version: ${VERSION_NO_V}" && \
    wget "https://github.com/5rahim/seanime/releases/download/${SEANIME_VERSION}/seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz" && \
    tar -xzf "seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz" && \
    rm "seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz" && \
    chmod +x seanime

CMD ["./seanime"]
