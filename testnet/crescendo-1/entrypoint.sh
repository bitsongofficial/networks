#!/bin/sh
set -e

HOME_DIR="/bitsongd/.data"
ACCOUNTS_DIR="/accounts"
CHAIN_ID="${CHAIN_ID:-crescendo-1}"
VAL_NAME="${VAL_NAME:-val1}"
MODE="${MODE:-genesis}"
GENESIS_URL="${GENESIS_URL:-}"
SEEDS="${SEEDS:-}"

if [ "$MODE" = "genesis" ]; then

    # Generate mnemonics if not present
    if [ ! -f "$ACCOUNTS_DIR/validator.txt" ]; then
        echo "Generating validator mnemonic..."
        bitsongd keys mnemonic > "$ACCOUNTS_DIR/validator.txt"
    fi

    if [ ! -f "$ACCOUNTS_DIR/faucet.txt" ]; then
        echo "Generating faucet mnemonic..."
        bitsongd keys mnemonic > "$ACCOUNTS_DIR/faucet.txt"
    fi

    if [ ! -f "$HOME_DIR/config/genesis.json" ]; then
        echo "Genesis not found, running setup..."

        # Init chain
        cat "$ACCOUNTS_DIR/validator.txt" | bitsongd init "$VAL_NAME" \
            --chain-id "$CHAIN_ID" \
            --default-denom ubtsg \
            --recover \
            --home "$HOME_DIR"

        # Create keys
        cat "$ACCOUNTS_DIR/validator.txt" | bitsongd keys add "$VAL_NAME" \
            --recover \
            --keyring-backend test \
            --home "$HOME_DIR"

        cat "$ACCOUNTS_DIR/faucet.txt" | bitsongd keys add faucet \
            --recover \
            --keyring-backend test \
            --home "$HOME_DIR"

        # Add genesis accounts
        bitsongd genesis add-genesis-account "$VAL_NAME" 100000000000000ubtsg \
            --keyring-backend test \
            --home "$HOME_DIR"

        bitsongd genesis add-genesis-account faucet 100000000000000ubtsg \
            --keyring-backend test \
            --home "$HOME_DIR"

        # Create gentx
        bitsongd genesis gentx "$VAL_NAME" 1000000000000ubtsg \
            --keyring-backend test \
            --home "$HOME_DIR" \
            --chain-id "$CHAIN_ID"

        # Collect gentxs
        bitsongd genesis collect-gentxs --home "$HOME_DIR"

        # Apply genesis parameters
        GENESIS="$HOME_DIR/config/genesis.json"
        jq '
          .app_state.crisis.constant_fee.denom = "ubtsg" |
          .app_state.fantoken.params.issue_fee.denom = "ubtsg" |
          .app_state.fantoken.params.issue_fee.amount = "0" |
          .app_state.fantoken.params.mint_fee.denom = "ubtsg" |
          .app_state.fantoken.params.burn_fee.denom = "ubtsg" |
          .app_state.gov.params.min_deposit[0].denom = "ubtsg" |
          .app_state.gov.params.max_deposit_period = "600s" |
          .app_state.gov.params.voting_period = "900s" |
          .app_state.gov.params.expedited_voting_period = "300s" |
          .app_state.gov.params.expedited_min_deposit[0].denom = "ubtsg" |
          .app_state.mint.minter.inflation = "0.001000000000000000" |
          .app_state.mint.params.mint_denom = "ubtsg" |
          .app_state.protocolpool.params.enabled_distribution_denoms = ["ubtsg"] |
          .app_state.staking.params.unbonding_time = "14400s" |
          .app_state.staking.params.max_validators = 10 |
          .app_state.staking.params.bond_denom = "ubtsg" |
          .app_state.slashing.params.signed_blocks_window = "10000" |
          .app_state.slashing.params.downtime_jail_duration = "6000s" |
          .app_state.wasm.params.code_upload_access.permission = "Everybody" |
          .app_state.wasm.params.instantiate_default_permission = "Everybody" |
          .consensus.params.block.max_gas = "50000000"
        ' "$GENESIS" > /tmp/genesis_tmp.json && mv /tmp/genesis_tmp.json "$GENESIS"

        # Validate genesis
        bitsongd genesis validate-genesis --home "$HOME_DIR"

        # Configure
        config="$HOME_DIR/config/config.toml"
        app_toml="$HOME_DIR/config/app.toml"

        sed -i 's/timeout_propose = "3s"/timeout_propose = "2s"/' "$config"
        sed -i 's/timeout_prevote = "1s"/timeout_prevote = "500ms"/' "$config"
        sed -i 's/timeout_precommit = "1s"/timeout_precommit = "500ms"/' "$config"
        sed -i 's/timeout_commit = "5s"/timeout_commit = "2s"/' "$config"
        sed -i 's/seeds = ".*"/seeds = ""/' "$config"
        sed -i 's|laddr = "tcp://127.0.0.1:26657"|laddr = "tcp://0.0.0.0:26657"|' "$config"
        sed -i 's/cors_allowed_origins = \[\]/cors_allowed_origins = ["*"]/' "$config"
        sed -i '/^\[api\]/,/^\[/{s/^enable = false/enable = true/}' "$app_toml"
        sed -i 's/^swagger = false/swagger = true/' "$app_toml"
        sed -i 's/^enabled-unsafe-cors = false/enabled-unsafe-cors = true/' "$app_toml"
        sed -i 's/^minimum-gas-prices = ".*"/minimum-gas-prices = "0ubtsg"/' "$app_toml"

        echo "Setup complete."
    fi

elif [ "$MODE" = "join" ]; then

    if [ -z "$GENESIS_URL" ]; then
        echo "ERROR: GENESIS_URL is required for MODE=join"
        exit 1
    fi

    # Generate validator mnemonic if not present
    if [ ! -f "$ACCOUNTS_DIR/validator.txt" ]; then
        echo "Generating validator mnemonic..."
        bitsongd keys mnemonic > "$ACCOUNTS_DIR/validator.txt"
    fi

    if [ ! -f "$HOME_DIR/config/genesis.json" ]; then
        echo "Node not initialized, running join setup..."

        # Init chain (creates config structure)
        cat "$ACCOUNTS_DIR/validator.txt" | bitsongd init "$VAL_NAME" \
            --chain-id "$CHAIN_ID" \
            --default-denom ubtsg \
            --recover \
            --home "$HOME_DIR"

        # Create validator key
        cat "$ACCOUNTS_DIR/validator.txt" | bitsongd keys add "$VAL_NAME" \
            --recover \
            --keyring-backend test \
            --home "$HOME_DIR"

        # Download genesis
        echo "Downloading genesis from $GENESIS_URL..."
        curl -sL -o "$HOME_DIR/config/genesis.json" "$GENESIS_URL"

        # Configure
        config="$HOME_DIR/config/config.toml"
        app_toml="$HOME_DIR/config/app.toml"

        sed -i 's/timeout_propose = "3s"/timeout_propose = "2s"/' "$config"
        sed -i 's/timeout_prevote = "1s"/timeout_prevote = "500ms"/' "$config"
        sed -i 's/timeout_precommit = "1s"/timeout_precommit = "500ms"/' "$config"
        sed -i 's/timeout_commit = "5s"/timeout_commit = "2s"/' "$config"
        sed -i "s|seeds = \".*\"|seeds = \"$SEEDS\"|" "$config"
        sed -i 's|laddr = "tcp://127.0.0.1:26657"|laddr = "tcp://0.0.0.0:26657"|' "$config"
        sed -i 's/cors_allowed_origins = \[\]/cors_allowed_origins = ["*"]/' "$config"
        sed -i '/^\[api\]/,/^\[/{s/^enable = false/enable = true/}' "$app_toml"
        sed -i 's/^swagger = false/swagger = true/' "$app_toml"
        sed -i 's/^enabled-unsafe-cors = false/enabled-unsafe-cors = true/' "$app_toml"
        sed -i 's/^minimum-gas-prices = ".*"/minimum-gas-prices = "0ubtsg"/' "$app_toml"

        echo "Join setup complete."
    fi

else
    echo "ERROR: Unknown MODE '$MODE'. Use 'genesis' or 'join'."
    exit 1
fi

echo "Starting bitsongd..."
exec bitsongd start --home "$HOME_DIR"
