FROM debian:trixie-slim AS downloader

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        tar \
        jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
COPY ./prepare.sh /tmp/prepare.sh
# Download seanime git and jellyfin-ffmpeg
RUN bash /tmp/prepare.sh

FROM debian:trixie-slim AS final
COPY --from=downloader /tmp/jellyfin-ffmpeg.deb /tmp/
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates /tmp/jellyfin-ffmpeg.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/jellyfin-ffmpeg.deb
ENV PATH="/usr/lib/jellyfin-ffmpeg/:$PATH"
WORKDIR /app/
RUN mkdir /downloads
COPY --from=downloader /tmp/seanime /app/seanime
CMD ["./seanime"]
