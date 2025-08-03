FROM alpine:latest

RUN apk add --no-cache \
   jellyfin-ffmpeg

RUN mkdir /downloads && mkdir /app
WORKDIR /app/

ARG SEANIME_VERSION
RUN VERSION_NO_V=$(echo ${SEANIME_VERSION} | sed 's/v//') && \
    echo "Installing seanime version: ${VERSION_NO_V}" && \
    wget "https://github.com/5rahim/seanime/releases/download/${SEANIME_VERSION}/seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz" && \
    tar -xzf "seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz" && \
    rm "seanime-${VERSION_NO_V}_Linux_x86_64.tar.gz" && \
    chmod +x seanime
CMD ["./seanime"]
