# bitsong-testnet-3

```
$ shasum -a 256 genesis.json
7581743bfe7f4ed2f5e3aa489c2e3a1a9bc03264fd5d238856867f2168234474  genesis.json
```

## Public Seeds

```
4e7f4c766c3f1c0f930e12967dcc4b989ec93c37@49.12.9.221:26656 # bitangel-seed
30477f65784354d74d00134d3699ca7dabe4c62c@5.189.181.62:16656 # syncnode
be2c3d97f30012a15b8e615e81b7f8dcf7825494@46.166.138.203:26656 # simplyvc
```

## Persistent Peers

```
e52306bef94c74c96d63e9aeb1391e879dc64748@34.92.215.136:26656 # Forbole
d1ed90b4e269e66fd1e16ed5319590025be7a31a@88.99.143.175:26656 # BasBlock
```

## Blockexplorer

```
https://testnet.explorebitsong.com # BitSong
```

## Changelog

```
- Module Track (alpha)
- Module Reward (alpha)
- Artist payout: 60
- Rest api
- Cli integration
- Cosmos-SDK v0.37.6
- Tendermint v0.32.9
- Initial supply 116,289,228 btsg
- Max validators capped to 48
```

## General configurations

[Genesis start at 20200127T15](https://www.timeanddate.com/countdown/launch?iso=20200127T15&p0=1440&msg=bitsong-testnet-3&font=slab&csz=1)

```
"genesis_time": "2020-01-27T15:00:00Z",
"chain_id": "bitsong-testnet-3",
```

## Consensus params

These are the same as cosmoshub-2. hub 1 was slightly different.

```
"consensus_params": {
  "block": {
    "max_bytes": "200000",
    "max_gas": "2000000",
    "time_iota_ms": "1000"
  },
  "evidence": {
    "max_age": "100000"
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
  "send_enabled": true
},
```

## Genutil

Normal list of gentxs generated automatically

```
"genutil": {
    "gentxs": [...]
},
```

## Crisis params

Currently set to cosmoshub-3's value

```
"crisis": {
  "constant_fee": {
    "denom": "ubtsg",
    "amount": "133333000000"
  }
},
```

## Distribution params

Main params are the same as cosmoshub-2

```
"distr": {
  "fee_pool": {
    "community_pool": []
  },
  "community_tax": "0.020000000000000000",
  "base_proposer_reward": "0.010000000000000000",
  "bonus_proposer_reward": "0.040000000000000000",
  "withdraw_addr_enabled": true,
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

Mint has same parameters as hubs 1, 2 and 3 except **block_per_year**

```
"mint": {
  "minter": {
    "inflation": "0.130000000000000000",
    "annual_provisions": "0.000000000000000000"
  },
  "params": {
    "mint_denom": "ubtsg",
    "inflation_rate_change": "0.130000000000000000",
    "inflation_max": "0.200000000000000000",
    "inflation_min": "0.070000000000000000",
    "goal_bonded": "0.670000000000000000",
    "blocks_per_year": "5733820"
  }
},
```

## Gov params

Same params as the cosmos hubs except voting_period is capped by the unbonding time, and deposit_period is a week because that seemed reasonable. Note: voting period must be less than unbonding period otherwise people could vote, redelegate, then vote again.

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
    "max_deposit_period": "172800000000000"  // 2 days
  },
  "voting_params": {
    "voting_period": "172800000000000" // 2 days, has to be ≤ unbonding time
  },
  "tally_params": {
    "quorum": "0.400000000000000000",
    "threshold": "0.500000000000000000",
    "veto": "0.334000000000000000"
  }
},
```

## Staking params

Params same as hub 1, 2 & 3 except for unbonding time which is 5 days and max_validators.

```
"staking": {
  "pool": {
    "not_bonded_tokens": "0",
    "bonded_tokens": "0"
  },
  "params": {
    "unbonding_time": "432000000000000", // 5 days
    "max_validators": 48,
    "max_entries": 7,
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
    "max_evidence_age": "432000000000000", // 5 days, must be same as unbonding period
    "signed_blocks_window": "1000", // ~83min @ 5.00s block time
    "min_signed_per_window": "0.050000000000000000", // can be down for up 78.85min without slashing
    "downtime_jail_duration": "600000000000", // 10min
    "slash_fraction_double_sign": "0.050000000000000000",
    "slash_fraction_downtime": "0.010000000000000000"
  },
  "signing_infos": {},
  "missed_blocks": {}
},
```

## Accounts

Automatically added

```
"accounts": [...]
```

## Reward params

```
"reward": {
  "reward_pool": {
    "reward_pool": []
  },
  "reward_tax": "0.030000000000000000", // 3% of minted tokens
  "rewards": null
},
```

## Track params

```
"track": {
  "starting_track_id": "1",
  "tracks": null,
  "deposits": null,
  "deposit_params": {
    "min_deposit": [
      {
        "denom": "ubtsg",
        "amount": "100000000"
      }
    ],
    "max_deposit_period": "259200000000000" // 3 days
  }
},
"
```
