#!/bin/bash

# Configuration
DOMAIN="${DOMAIN:-example.com}"
EMAIL="${EMAIL:-admin@example.com}"
CLOUDFLARE_TOKEN="${CLOUDFLARE_TOKEN}"
CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
DEST_DIR="/root/electrumdb"

# Create Cloudflare credentials file if token is provided
if [ -n "$CLOUDFLARE_TOKEN" ]; then
    echo "dns_cloudflare_api_token = $CLOUDFLARE_TOKEN" > /root/cloudflare.ini
    chmod 600 /root/cloudflare.ini
else
    echo "ERROR: CLOUDFLARE_TOKEN is not set."
    exit 1
fi

# Function to deploy certificates
deploy_certs() {
    echo "Deploying certificates for $DOMAIN to $DEST_DIR..."
    if [ -f "$CERT_DIR/fullchain.pem" ] && [ -f "$CERT_DIR/privkey.pem" ]; then
        cp "$CERT_DIR/fullchain.pem" "$DEST_DIR/server.crt"
        cp "$CERT_DIR/privkey.pem" "$DEST_DIR/server.key"
        chmod 644 "$DEST_DIR/server.crt"
        chmod 600 "$DEST_DIR/server.key"
        echo "Certificates deployed. Sending restart signal to ElectrumX..."
        # Usamos curl para hablar con el socket de Docker y reiniciar el contenedor
        curl --unix-socket /var/run/docker.sock -X POST http://localhost/containers/electrumx_server/restart
    else
        echo "ERROR: Certificates not found in $CERT_DIR"
    fi
}

# Initial cert request or renewal
echo "Requesting/Renewing certificate for $DOMAIN..."
certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /root/cloudflare.ini \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    -d "$DOMAIN" \
    -d "*.$DOMAIN" \
    --non-interactive \
    --keep-until-expiring

# Check if deploy is needed
deploy_certs

# Keep running to handle renewals
echo "Starting renewal daemon..."
while true; do
    sleep 12h
    certbot renew --dns-cloudflare --dns-cloudflare-credentials /root/cloudflare.ini --quiet
    # If renewal happened, deploy_certs will be called by post-hook or manually checked
    deploy_certs
done
