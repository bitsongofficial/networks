# BitSong 2b Instructions

## Upgrade procedure

Please follow this guide only if you come `bitsong-2` post-mortem

1. Stop your instance
```
bitsongd stop
```

2. Download the genesis
```
wget https://github.com/bitsongofficial/networks/raw/master/bitsong-2b/genesis.json -O ~/.bitsongd/config/genesis.json
```

3. Reset the state
```
bitsongd unsafe-reset-all
```

4. Start your node (the chain will start at 2021-10-21 11:00
```
bitsongd start
```