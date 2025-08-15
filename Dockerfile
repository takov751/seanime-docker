FROM node:latest AS node-builder

COPY ./seanime-git/seanime-web /tmp/build

WORKDIR /tmp/build

RUN npm ci
RUN npm run build

# Stage 2: Go Builder
FROM golang:latest AS go-builder

COPY ./seanime-git /tmp/build
COPY --from=node-builder /tmp/build/out /tmp/build/web

WORKDIR /tmp/build

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o seanime -trimpath -ldflags="-s -w"

FROM alpine:latest as FINAL

RUN apk add --no-cache \
   jellyfin-ffmpeg

RUN mkdir /downloads && mkdir /app
WORKDIR /app/

COPY --from=go-builder /tmp/build/seanime/seanime /app/seanime
CMD ["./seanime"]
