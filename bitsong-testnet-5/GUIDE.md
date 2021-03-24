## Requirements

First of all, you need to make some preparations on your server (dedicated or cloud). Using a dedicated server ensures high performance (even in high load situations). The network uses Tendermint’s consensus, which elects a leader for each block. If your validator is offline, the consensus will delay the inclusion of the block and you may be slashed!

For this guide we used the following specifications:

- Ubuntu 18.04 OS
- 2 vCPU
- 4GB RAM
- 24GB SSD
- Unlock input connections on gate 26656
- Static IP address (Elastic IP for AWS, floating IP for DigitalOcean)
- You can find these features at any cloud provider (AWS, DigitalOcean, Google Cloud, Hetzner, Linode, etc.)
