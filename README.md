# BitSong Testnets

This repo collects the genesis and configuration files for the various BitSong testnets. It exists so the [BitSong](https://github.com/BitSongOfficial/go-bitsong) repo does not get bogged down with large genesis files and status updates.

## Genesis & Seeds

### bitsong-testnet-4

Fetch the testnet's `genesis.json` file into `bitsongd`'s config directory.

```bash
mkdir -p $HOME/.bitsongd/config
curl https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-testnet-4/genesis.json > $HOME/.bitsongd/config/genesis.json
```

### bitsong-testnet-2

Fetch the testnet's `genesis.json` file into `bitsongd`'s config directory.

```bash
mkdir -p $HOME/.bitsongd/config
curl https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-testnet-2/genesis.json > $HOME/.bitsongd/config/genesis.json
```

**persistent peers**

```bash
f9d91f1f553a945ccb621ea43c49f5fe43a08d0d@88.99.143.175:26656
```

### bitsong-testnet-1

Fetch the testnet's `genesis.json` file into `bitsongd`'s config directory.

```bash
mkdir -p $HOME/.bitsongd/config
curl https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-testnet-1/genesis.json > $HOME/.bitsongd/config/genesis.json
```

**persistent peers**

```bash

```
