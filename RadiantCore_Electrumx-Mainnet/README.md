# Full Stack Deployment: Radiant Node + ElectrumX

One-command deployment for running a complete Radiant infrastructure with both the full node (radiant-node) and Radiant ElectrumX server.

**This deployment is fully self-contained** - both radiant-node and radiant-electrumx are built from source during the Docker build process:
- **Radiant Node**: Built using `Dockerfile.node`
- **ElectrumX**: Built using `Dockerfile.electrumx`

You can deploy by downloading just this `docker/full-stack/` directory.

## Quick Start

1. **Copy environment file and configure:**
   ```bash
   cp .env.example .env
   # Edit .env with your RPC credentials
   ```

2. **Start the stack:**
   ```bash
   docker-compose up -d
   ```

3. **Monitor logs:**
   ```bash
   docker-compose logs -f
   ```

## Services

| Service | Port | Description |
|---------|------|-------------|
| radiant-node | 7332 | RPC port |
| radiant-node | 7333 | P2P port |
| radiant-electrumx | 50010 | TCP connections |
| radiant-electrumx | 50012 | SSL connections |
| radiant-electrumx | 8000 | RPC interface |

## Build & Sync Times

**First-time build** (compiles from source):
- radiant-node: ~10-20 minutes
- radiant-electrumx: ~2-5 minutes

**Initial sync** (after build):
1. **radiant-node** must fully sync the blockchain first (1-4 hours)
2. **radiant-electrumx** will wait (via healthcheck) until radiant-node is ready
3. **radiant-electrumx** then indexes the blockchain (1-3 hours depending on hardware)

Monitor progress:
```bash
# Check radiant-node sync status
docker exec radiant-node radiant-cli -rpcuser=radiant -rpcpassword=your_pass getblockchaininfo

# Check electrumx status
docker logs -f electrumx_server
```

## Cloudflare SSL Setup

The `radiant-cloudflare-ssl` service automatically manages Let's Encrypt certificates using Cloudflare DNS verification.

1. **Get an API Token**: In Cloudflare, go to "My Profile" -> "API Tokens" -> "Create Token". Use the "Edit zone DNS" template.
2. **Update `.env`**: Set your `DOMAIN`, `EMAIL`, and `CLOUDFLARE_TOKEN`.
3. **Automatic Deployment**: The service will:
   - Request certificates for your domain and wildcard.
   - Copy `fullchain.pem` to `server.crt` and `privkey.pem` to `server.key` in the ElectrumX volume.
   - **Renewal Schedule**: The manager checks for renewal every **12 hours**. Certbot will only actually renew the certificate if it's within 30 days of expiry.
   - **Auto-Update**: When a renewal occurs, the new certificates are automatically copied to the ElectrumX directory.

Note: You may need to manualy restart the `radiant-electrumx` service after the first certificate generation so it picks up the new files.

```bash
docker-compose restart radiant-electrumx
```

## Data Persistence

Data is stored in Docker volumes:
- `radiant-node-data` - Blockchain data (~50GB+)
- `radiant-electrumx-data` - ElectrumX index database

## Graceful Shutdown

ElectrumX requires a graceful shutdown to avoid database corruption:
```bash
docker-compose down
# Or for immediate but safe shutdown:
docker kill --signal="TERM" electrumx_server
```

## Production Recommendations

1. **Use a reverse proxy** (nginx/traefik) for SSL termination
2. **Set secure RPC credentials** in `.env`
3. **Increase CACHE_MB** if you have available RAM (improves sync speed)
4. **Use SSD storage** for both volumes

## Original Docker
https://github.com/Radiant-Core/ElectrumX/tree/master/docker/full-stack