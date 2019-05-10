# BitSong Testnets

This repo collects the genesis and configuration files for the various BitSong testnets. It exists so the [BitSong](https://github.com/BitSongOfficial/go-bitsong) repo does not get bogged down with large genesis files and status updates.

## Genesis & Seeds

### bitsong-test-network-1

Fetch the testnet's `genesis.json` file into `bitsongd`'s config directory.

```bash
mkdir -p $HOME/.bitsongd/config
curl https://raw.githubusercontent.com/BitSongOfficial/networks/master/bitsong-test-network-1/genesis.json > $HOME/.bitsongd/config/genesis.json
```

**persistent peers**

```bash
0edd27d5880fc7c5a25986c7451e33c40440ce48@165.22.92.107:26656,5ee57666f17c0307aa6641fc153a528c3c2f9781@142.93.110.219:26657
```