# bitsong-testnet-1

## Blockexplorer

```
https://testnet-1.bitsong.bigdipper.live
```

## General configurations

[Genesis start at](https://www.timeanddate.com/countdown/generic?p0=1440&iso=20190711T15&year=2019&month=7&day=11&hour=15&min=0&sec=0&msg=bitsong-testnet-1&csz=1)

```
"genesis_time": "2019-07-11T15:00:00Z",
"chain_id": "bitsong-testnet-1",
```

## Consensus params

```
"consensus_params": {
  "block": {
    "max_bytes": "22020096",
    "max_gas": "-1",
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

```
"crisis": {
  "constant_fee": {
    "denom": "ubtsg",
    "amount": "1000"
  }
},
```

## Distribution params

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
    "blocks_per_year": "6311520"
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
        "amount": "10000000"
      }
    ],
    "max_deposit_period": "172800000000000"
  },
  "voting_params": {
    "voting_period": "172800000000000"
  },
  "tally_params": {
    "quorum": "0.334000000000000000",
    "threshold": "0.500000000000000000",
    "veto": "0.334000000000000000"
  }
},
```

## Staking params

```
"staking": {
  "pool": {
    "not_bonded_tokens": "0",
    "bonded_tokens": "0"
  },
  "params": {
    "unbonding_time": "10800000000000",
    "max_validators": 100,
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
    "max_evidence_age": "120000000000",
    "signed_blocks_window": "10000",
    "min_signed_per_window": "0.050000000000000000",
    "downtime_jail_duration": "60000000000",
    "slash_fraction_double_sign": "0.050000000000000000",
    "slash_fraction_downtime": "0.000100000000000000"
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