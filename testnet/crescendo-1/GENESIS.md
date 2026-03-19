chain_id = crescendo-1

crisis.constant_fee.denom = utbtsg

fantoken.params.issue_fee.denom = utbtsg
fantoken.params.issue_fee.amount = 0
fantoken.params.mint_fee.denom = utbtsg
fantoken.params.burn_fee.denom = utbtsg

gov.params.min_deposit[0].denom = utbtsg
gov.params.max_deposit_period = 600s
gov.params.voting_period = 900s
gov.params.expedited_voting_period = 300s
gov.params.expedited_min_deposit[0].denom = utbtsg

mint.minter.inflation = 0.001000000000000000
mint.params.mint_denom = utbtsg

protocolpool.params.enabled_distribution_denoms[0] = utbtsg

staking.params.unbonding_time = 14400s
staking.params.max_validators = 10
staking.params.bond_denom = utbtsg

slashing.params.signed_blocks_window = 10000
slashing.params.downtime_jail_duration = 6000s

wasm.params.code_upload_access.permission = Everybody
wasm.params.instantiate_default_permission.permission = Everybody

consensus.params.block.max_gas = 50000000
