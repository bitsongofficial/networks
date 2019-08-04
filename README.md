# BitSong Testnets

This repo collects the genesis and configuration files for the various BitSong testnets. It exists so the [BitSong](https://github.com/BitSongOfficial/go-bitsong) repo does not get bogged down with large genesis files and status updates.

## Genesis & Seeds

### bitsong-testnet-1

Fetch the testnet's `genesis.json` file into `bitsongd`'s config directory.

```bash
mkdir -p $HOME/.bitsongd/config
curl https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-testnet-1/genesis.json > $HOME/.bitsongd/config/genesis.json
```

**persistent peers**

```bash

```