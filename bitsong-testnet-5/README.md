# bitsong-testnet-5

Please [follow the guide](./GUIDE.md)

```
$ shasum -a 256 genesis.json
9b413d0a10a3d97e211bf68fb938daa7a835ad8e9aeffe48048892d9bdf5dd48  genesis.json
```

## Public lcd availables

```
---
```

## Console

---

## Setup instructions

### Make sure your node is updated

```
rm -rf ~/go-bitsong
git clone https://github.com/bitsongofficial/go-bitsong
cd go-bitsong
git checkout v0.7.0-rc1
make install
bitsongd version --long
```

you should have an output similar to this

```
$ bitsongd version --long
name: go-bitsong
server_name: bitsongd
client_name: bitsongcli
version: 0.7.0-rc1
commit: 26a277a67b8d3e0052ace21be7f3a2754171b06b
build_tags: netgo,ledger
```

### 1. Delete the old genesis

```
rm -f ~/.bitsongd/config/genesis.json
```

### 2. Download the new genesis, and copy it to the correct directory

```
wget https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-testnet-5/genesis.json -P ~/.bitsongd/config
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

Now we have to wait for the launch of the network which will take place on [March 24th, 2021 at 16:00 UTC](https://www.timeanddate.com/countdown/launch?iso=20210324T16&p0=1440&msg=bitsong-testnet-5&font=slab&csz=1)

After the network has reached the quorum, the testnet will start automatically!

**If the quorum is not reached, we will give further communications in the validator’s chat**

## Public Seeds

```

```

## Blockexplorer

--

## General configurations

[Genesis start at 20210324T16](https://www.timeanddate.com/countdown/launch?iso=20210324T16&p0=1440&msg=bitsong-testnet-4&font=slab&csz=1)

```
  "genesis_time": "2021-03-24T16:00:0.0Z",
  "chain_id": "bitsong-testnet-5",
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
      "pub_key_types": [
        "ed25519"
      ]
    }
  },
```

## Bank params

```
    "bank": {
      "send_enabled": false
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
        "blocks_per_year": "5733820" // ~5.5sec per block
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
        "max_deposit_period": "1296000000000000" // 15 days
      },
      "voting_params": {
        "voting_period": "1296000000000000" // 15 days
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
        "unbonding_time": "1814400000000000", // 21 days
        "max_validators": 64,
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
        "signed_blocks_window": "10000", // ~15.2h @ 5.50s block time
        "min_signed_per_window": "0.050000000000000000", // can be down for up ~14.4h without slashing
        "downtime_jail_duration": "3600000000000", // 1h
        "slash_fraction_double_sign": "0.050000000000000000", // 5%
        "slash_fraction_downtime": "0.010000000000000000" // 1%
      },
      "signing_infos": {},
      "missed_blocks": {}
    },
```
