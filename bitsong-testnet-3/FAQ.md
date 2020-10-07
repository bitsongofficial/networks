# Useful commands

## Check prevotes
```bash
curl -s localhost:26657/consensus_state | jq -r ".result.round_state.height_vote_set[].prevotes_bit_array"
```

## Numbers of connected peers

```bash
curl -s localhost:26657/net_info | grep n_peers
```

## Check if you voted

```bash
curl localhost:26657/consensus_state -s | grep $(bitsongcli status | jq -r .validator_info.address[:12])
```

## Check your validator address

```bash
bitsongcli status | jq ".validator_info.address"
```

## List of connected peers

```bash
curl -s http://localhost:26657/net_info 3 |grep moniker
```
## Check your voting power

```bash
bitsongcli status | jq ".validator_info.voting_power"
```
