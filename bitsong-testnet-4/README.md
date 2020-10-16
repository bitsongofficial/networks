# bitsong-testnet-4

```
$ shasum -a 256 genesis.json
e41be4d3de2ac1966bd4247d19229f64b1b0bd35fdefcae5316d1c36662b716e  genesis.json
```

## Setup instructions

### Make sure your node is updated

```
rm -rf ~/go-bitsong
git clone https://github.com/bitsongofficial/go-bitsong
cd go-bitsong
git checkout v0.6.0-beta1
make install
bitsongd version --long
```

you should have an output similar to this

```
$ bitsongd version --long
name: go-bitsong
server_name: bitsongd
client_name: bitsongcli
version: 0.6.0-beta1
commit: ed1332e344a28984e5bce8e4b87ea6597aa6384c
build_tags: netgo,ledger
go: go version go1.13.6 linux/amd64
```

### 1. Delete the old genesis

```
rm -f ~/.bitsongd/config/genesis.json
```

### 2. Download the new genesis, and copy it to the correct directory

```
wget https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-testnet-4/genesis.json -P ~/.bitsongd/config
```

### 3. Run the node

```
bitsongd start
```

Optional, if you wish, you can create a systemd file (edit <your_user> where necessary)

```
sudo tee /etc/systemd/system/bitsongd.service > /dev/null <<EOF
[Unit]
Description=BitSong Network Daemon
After=network-online.target

[Service]
User=<your_user>
ExecStart=/home/<your_user>/go/bin/bitsongd start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl enable bitsongd
sudo systemctl start bitsongd
```

_To check the status of the node, you can use the following commands_

```
bitsongcli status
sudo journalctl -u bitsongd -f
```

Now we have to wait for the launch of the network which will take place on [October 16th, 2020 at 15:00 UTC](https://www.timeanddate.com/countdown/launch?iso=20201016T15&p0=1440&msg=bitsong-testnet-4&font=slab&csz=1)

After the network has reached the quorum, the testnet will start automatically!

**If the quorum is not reached, we will give further communications in the validator’s chat**

## Public Seeds

```
6190e5e52eea8e676c5c4e8f9c7830afcc4ffbf9@37.120.178.44:26656
65fb280c387a55e36b4a2cea774bb3e4f6a10081@172.104.136.83:26656
5f13d0373781effbf87608be9da8021f755fc03e@35.192.159.190:26656
6de901ea0a01450939ac960019ad77bc04ccc228@176.37.214.146:26656
72060750a8ebae54bb169f3f6124a6906974bf39@207.154.237.221:26656
ef8b1520a43f34c5eeff3b675d6e6c42a2750f41@159.89.1.177:26656
61aff01468b90bc1edff94c384639764d5c0b8d6@35.184.73.176:26656
2ea686121879c5e38efbd80ae2d59fa0dc1d8e17@159.89.110.77:26656
ebec86c3283263d5cd5c4944eee2645b3e5649e1@45.239.19.7:26656
c85bd4793e8c56fbcd3183875a4733ddc8a11046@129.213.52.33:27656
209b95486552016d8efd91d46323439d0498df09@144.91.123.104:26656
7f9edf97a353aca41b1af74b8897a7a5fc15665a@135.181.59.225:26656
```

## Persistent Peers

[TODO]

## Blockexplorer

[TODO]

## Changelog

```
- Remove Module Track (alpha)
- Remove Module Reward (alpha)
- Cosmos-SDK v0.39.1
- Tendermint v0.33.7
- Initial supply 116,289,228 btsg
- Max validators capped to 100
```

## General configurations

[Genesis start at 20201016T15](https://www.timeanddate.com/countdown/launch?iso=20201016T15&p0=1440&msg=bitsong-testnet-4&font=slab&csz=1)

```
  "genesis_time": "2020-10-16T15:00:00Z",
  "chain_id": "bitsong-testnet-4",
```

## Consensus params

```
  "consensus_params": {
    "block": {
      "max_bytes": "200000",
      "max_gas": "2000000",
      "time_iota_ms": "1000"
    },
    "evidence": {
      "max_age_num_blocks": "100000",
      "max_age_duration": "172800000000000"
    },
    "validator": {
      "pub_key_types": ["ed25519"]
    }
  },
```

## Bank params

```
    "bank": {
      "send_enabled": true
    },
```

## Crisis params

```
    "crisis": {
      "constant_fee": {
        "denom": "ubtsg",
        "amount": "133333000000"
      }
    },
```

## Distribution params

```
    "distribution": {
      "params": {
        "community_tax": "0.020000000000000000", // 2%
        "base_proposer_reward": "0.010000000000000000", // 1%
        "bonus_proposer_reward": "0.040000000000000000", // 4%
        "withdraw_addr_enabled": true
      },
      "fee_pool": {
        "community_pool": []
      },
      "delegator_withdraw_infos": [],
      "previous_proposer": "",
      "outstanding_rewards": [],
      "validator_accumulated_commissions": [],
      "validator_historical_rewards": [],
      "validator_current_rewards": [],
      "delegator_starting_infos": [],
      "validator_slash_events": []
    },
```

## Mint params

```
    "mint": {
      "minter": {
        "inflation": "0",
        "annual_provisions": "0"
      },
      "params": {
        "mint_denom": "ubtsg",
        "inflation_rate_change": "0.130000000000000000", // 13%
        "inflation_max": "0.200000000000000000", // 20%
        "inflation_min": "0.070000000000000000", // 7%
        "goal_bonded": "0.670000000000000000", // 67%
        "blocks_per_year": "5733820"
      }
    },
```

## Gov params

```
    "gov": {
      "starting_proposal_id": "1",
      "deposits": null,
      "votes": null,
      "proposals": null,
      "deposit_params": {
        "min_deposit": [
          {
            "denom": "ubtsg",
            "amount": "512000000"
          }
        ],
        "max_deposit_period": "172800000000000" // 2 days
      },
      "voting_params": {
        "voting_period": "172800000000000" // 2 days
      },
      "tally_params": {
        "quorum": "0.400000000000000000", // 40%
        "threshold": "0.500000000000000000", // 50%
        "veto": "0.334000000000000000" // 33.4%
      }
    },
```

## Staking params

```
    "staking": {
      "params": {
        "unbonding_time": "432000000000000", // 5 days
        "max_validators": 100,
        "max_entries": 7,
        "historical_entries": 0,
        "bond_denom": "ubtsg"
      },
      "last_total_power": "0",
      "last_validator_powers": null,
      "validators": null,
      "delegations": null,
      "unbonding_delegations": null,
      "redelegations": null,
      "exported": false
    },
```

## Slashing params

```
    "slashing": {
      "params": {
        "signed_blocks_window": "1000", // ~83min @ 5.00s block time
        "min_signed_per_window": "0.050000000000000000", // can be down for up 78.85min without slashing
        "downtime_jail_duration": "600000000000", // 10min
        "slash_fraction_double_sign": "0.050000000000000000", // 5%
        "slash_fraction_downtime": "0.010000000000000000" // 1%
      },
      "signing_infos": {},
      "missed_blocks": {}
    },
```
