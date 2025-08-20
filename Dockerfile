FROM debian:trixie-slim AS downloader

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        wget \
        tar \
        jq \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
COPY ./prepare.sh /tmp/prepare.sh
# Download seanime git and jellyfin-ffmpeg
RUN bash /tmp/prepare.sh

FROM node:latest AS node-builder

COPY --from=downloader /tmp/seanime/seanime-web /tmp/build

WORKDIR /tmp/build

RUN npm ci
RUN npm run build

FROM golang:latest AS go-builder

COPY --from=downloader /tmp/seanime /tmp/build
COPY --from=node-builder /tmp/build/out /tmp/build/web

WORKDIR /tmp/build

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o seanime -trimpath -ldflags="-s -w"


FROM debian:trixie-slim AS final
COPY --from=downloader /tmp/jellyfin-ffmpeg.deb /tmp/
RUN apt-get update && \
    apt-get install -y --no-install-recommends /tmp/jellyfin-ffmpeg.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/jellyfin-ffmpeg.deb
ENV PATH="/usr/lib/jellyfin-ffmpeg/:$PATH"

WORKDIR /app/
RUN mkdir /downloads
COPY --from=go-builder /tmp/build/seanime /app/seanime
CMD ["./seanime"]
