const fs = require('fs')
var genesis = require('./bitsong-1-migrated.json')

const replace = {
    old_validator_address: "DE31D79BFE9887985844210664A1C0CABB70AEAD",
    old_operator_address: "bitsongvaloper1ech3swu5jeuenxzgd0rq9xz6yz3yn6t0v2x0tw",
    old_consensus_address: "",
    old_consensus_public_key: "pwkVEVYtgUv3ROcK9hxV3kH3+8sJMC7MxSiRnon5aMg=",
    new_validator_address: "AAD14426E33AADC5F7147A2BE4ADC244C4F58679",
    new_operator_address: "bitsongvaloper1vgpsha4f8grmsqr6krfdxwpcf3x20h0qsxh5zh",
    new_consensus_address: "",
    new_consensus_public_key: "rNrNp8w2FFT74TxmxwV1yvd3azw6SkuyDxMUdvcVAPM="
}

const stakingValidatorsLength = genesis.app_state.staking.validators.length
console.log(`Staking Validators: ${stakingValidatorsLength}`)

const tmValidatorsLength = genesis.validators.length
console.log(`Tm Validators: ${tmValidatorsLength}`)


let staking = genesis.app_state.staking
let distribution = genesis.app_state.distribution
let slashing = genesis.app_state.slashing

// TM Validators
for (const val of genesis.validators) {
    if (val.address == replace.old_validator_address) {
        val.address = replace.new_validator_address
        val.pub_key.value = replace.new_consensus_public_key
        genesis.validators = [val]
    }
}

// Validators
for (const val of staking.validators) {
    if (val.operator_address == replace.old_operator_address) {
        val.operator_address = replace.new_operator_address
        val.consensus_pubkey.key = replace.new_consensus_public_key
        staking.validators = [val]
    }
}

// Last voting power
for (const last_validator_power of staking.last_validator_powers) {
    if (last_validator_power.address == replace.old_operator_address) {
        last_validator_power.address = replace.new_operator_address
        staking.last_validator_powers = [last_validator_power]
        staking.last_total_power = last_validator_power.power
    }
}

// Delegations
let replacement_delegations = []
for (const delegation of staking.delegations) {
    if (delegation.validator_address == replace.old_operator_address) {
        delegation.validator_address = replace.new_operator_address
        replacement_delegations.push(delegation)
    }
}
staking.delegations = replacement_delegations

// Redelegations
staking.redelegations = []

// Unbonding delegations
let replacement_unbonding_delegations = []
for (const unbonding_delegation in staking.unbonding_delegations) {
    if (unbonding_delegation.validator_address == replace.old_operator_address) {
        unbonding_delegation.validator_address = replace.new_operator_address
        replacement_unbonding_delegations.push(unbonding_delegation)
    }
}
staking.unbonding_delegations = replacement_unbonding_delegations

// Delegator starting infos
let replacement_delegator_starting_infos = []
for (const delegator_starting_info in distribution.delegator_starting_infos) {
    if (delegator_starting_info.validator_address == replace.old_operator_address) {
        delegator_starting_info.validator_address = replace.new_operator_address
        replacement_delegator_starting_infos.push(delegator_starting_info)
    }
}
distribution.delegator_starting_infos = replacement_delegator_starting_infos

// Outstanding rewards
let replacement_outstanding_rewards = []
for (const outstanding_reward in distribution.outstanding_rewards) {
    if (outstanding_reward.validator_address == replace.old_operator_address) {
        outstanding_reward.validator_address = replace.new_operator_address
        replacement_outstanding_rewards.push(outstanding_reward)
    }
}
distribution.outstanding_rewards = replacement_outstanding_rewards

// Validator accumulated commissions
let replacement_validator_accumulated_commissions = []
for (const validator_accumulated_commission in distribution.validator_accumulated_commissions) {
    if (validator_accumulated_commission.validator_address == replace.old_operator_address) {
        validator_accumulated_commission.validator_address = replace.new_operator_address
        replacement_validator_accumulated_commissions.push(validator_accumulated_commission)
    }
}
distribution.outstanding_rewards = replacement_validator_accumulated_commissions

// Validator current rewards
let replacement_validator_current_rewards = []
for (const validator_current_reward in distribution.validator_current_rewards) {
    if (validator_current_reward.validator_address == replace.old_operator_address) {
        validator_current_reward.validator_address = replace.new_operator_address
        replacement_validator_current_rewards.push(validator_current_reward)
    }
}
distribution.validator_current_rewards = replacement_validator_current_rewards

// Validator historical rewards
let replacement_validator_historical_rewards = []
for (const validator_historical_reward in distribution.validator_historical_rewards) {
    if (validator_historical_reward.validator_address == replace.old_operator_address) {
        validator_historical_reward.validator_address = replace.new_operator_address
        replacement_validator_historical_rewards.push(validator_historical_reward)
    }
}
distribution.validator_historical_rewards = replacement_validator_historical_rewards

// Signing infos
slashing.signing_infos = [{
    "address": "bitsongvalcons14tg5gfhr82kutac50g47ftwzgnz0tpnep3atew",
    "validator_signing_info": {
        "address": "bitsongvalcons14tg5gfhr82kutac50g47ftwzgnz0tpnep3atew",
        "index_offset": "2",
        "jailed_until": "2021-09-15T09:35:14.394281371Z",
        "missed_blocks_counter": "2",
        "start_height": "0",
        "tombstoned": false
    }
}]
slashing.missed_blocks = []

// Governance
genesis.app_state.gov.voting_params.voting_period = "86400s"

// Enable ibc transfers
// genesis.app_state.transfer.params.receive_enabled = true
// genesis.app_state.transfer.params.send_enabled = true

console.log(`Staking Validators: ${genesis.app_state.staking.validators.length}`)
console.log(`TM Validators: ${genesis.validators.length}`)

fs.writeFile('genesis.json', JSON.stringify(genesis), err => {
    if (err) {
        console.error(err)
        return
    }
})