
FROM alpine:3.21

LABEL maintainer="cabrelwilliam32"
LABEL description="WillyVPN - Optimized VLESS WebSocket Server"

RUN apk add --no-cache ca-certificates curl unzip \
    && ARCH="$(uname -m)" \
    && case "$ARCH" in \
         x86_64) XRAY_ARCH="64" ;; \
         aarch64) XRAY_ARCH="arm64-v8a" ;; \
         *) echo "Architecture non supportée: $ARCH"; exit 1 ;; \
       esac \
    && VERSION="$(curl -fsSL https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name"' | head -n1 | cut -d '"' -f4)" \
    && curl -fsSL "https://github.com/XTLS/Xray-core/releases/download/${VERSION}/Xray-linux-${XRAY_ARCH}.zip" -o /tmp/xray.zip \
    && mkdir -p /usr/local/bin /etc/xray \
    && unzip -o /tmp/xray.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/xray \
    && rm -f /tmp/xray.zip \
    && apk del curl unzip

WORKDIR /etc/xray

COPY config.json /etc/xray/config.json

ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "exec /usr/local/bin/xray run -config /etc/xray/config.json"]
