# Gala Node Software V3 installation script

This script sets up a gala node software v3 and starts it.

Execution:

```
curl -sSL https://raw.githubusercontent.com/NivEz/gala-node-install-script/main/install-gala.sh | bash -s <GALA_API_KEY>
```

Just replace `GALA_API_KEY` with your actual api key.

Note that the `gala-node` executable might be accessed with non-root user but the config of the root user and non-root user might be different - that can cause `gala-node` commands to fail, so you might just use `sudo`.

Use `sudo gala-node status` to check the node status.

Use just `gala-node` for help.


