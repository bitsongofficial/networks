# bitsong-testnet-2

## Blockexplorer

```
```

## Changelog

```
- Cosmos-SDK v0.36
- Faucet address
- Send disabled (you can enable it by gov)
- Initial supply 116,289,228 btsg
- New slashing parameters
- Max validators capped to 32
- Supply module
```

## General configurations

[Genesis start at](https://www.timeanddate.com/countdown/launch?iso=20190812T15&p0=1440&msg=bitsong-testnet-2&font=slab&csz=1)

```
"genesis_time": "2019-08-12T15:00:00Z",
"chain_id": "bitsong-testnet-2",
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

Start with txs disabled and use governance to enable them. Note: faucet won't work.

```
"bank": {
  "send_enabled": false
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

Currently set to cosmoshub-2's value (https://github.com/cosmos/cosmos-sdk/tree/master/docs/spec/crisis)

```
"crisis": {
  "constant_fee": {
    "denom": "ubtsg",
    "amount": "1333000000"
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

Mint has same parameters as hubs 1 and 2 except **block_per_year**


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
    "max_deposit_period": "604800000000000"  // 1 week
  },
  "voting_params": {
    "voting_period": "259200000000000" // 3 days, has to be ≤ unbonding time
  },
  "tally_params": {
    "quorum": "0.400000000000000000",
    "threshold": "0.500000000000000000",
    "veto": "0.334000000000000000"
  }
},
```

## Staking params

Params same as hub 1 & 2 except for unbonding time which is 3 days and max_validators. (gaia testnet 13k uses 3 days)

```
"staking": {
  "pool": {
    "not_bonded_tokens": "0",
    "bonded_tokens": "0"
  },
  "params": {
    "unbonding_time": "259200000000000", // 3 days
    "max_validators": 32,
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
    "max_evidence_age": "259200000000000", // 3 days, must be same as unbonding period
    "signed_blocks_window": "120", // 10min @ 5.00s block time
    "min_signed_per_window": "0.050000000000000000", // can be down for up 9.5min without slashing
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