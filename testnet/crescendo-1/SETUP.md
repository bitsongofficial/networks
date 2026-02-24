BINARY="docker run --rm -i -v $(pwd)/.data:/bitsongd/.data ghcr.io/bitsongofficial/go-bitsong:feat-hyperlane bitsongd"
VAL_NAME="val1"
CHAIN_ID="crescendo-1"
HOME="/bitsongd/.data"

## Generate Validator Mnemonic

```bash
$BINARY keys mnemonic > accounts/validator.txt
$BINARY keys mnemonic > accounts/faucet.txt
```

## Init chain

```bash
cat accounts/validator.txt | $BINARY init $VAL_NAME \
    --chain-id $CHAIN_ID \
    --default-denom utbtsg \
    --recover \
    --home $HOME
```

## Create keys

```bash
cat accounts/validator.txt | $BINARY keys add $VAL_NAME \
    --recover \
    --keyring-backend test \
    --home $HOME

cat accounts/faucet.txt | $BINARY keys add faucet \
    --recover \
    --keyring-backend test \
    --home $HOME
```

## Add genesis accounts

```bash
$BINARY genesis add-genesis-account $VAL_NAME 100000000000000utbtsg \
    --keyring-backend test \
    --home $HOME

$BINARY genesis add-genesis-account faucet 100000000000000utbtsg \
    --keyring-backend test \
    --home $HOME
```

## Create the gentx for the validator

```bash
$BINARY genesis gentx $VAL_NAME 1000000000000utbtsg \
    --keyring-backend test \
    --home $HOME \
    --chain-id $CHAIN_ID
```

## Collect gentxs

```bash
$BINARY genesis collect-gentxs --home $HOME
```

## Validate genesis

```bash
$BINARY genesis validate-genesis --home $HOME
```

## Configure

```bash
config="$(pwd)/.data/config/config.toml"
app_toml="$(pwd)/.data/config/app.toml"

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
sed -i 's/^minimum-gas-prices = ".*"/minimum-gas-prices = "0utbtsg"/' "$app_toml"
```

## Start the chain

```bash
docker run -d \
    --name $CHAIN_ID \
    -v $(pwd)/.data:/bitsongd/.data \
    -p 26656:26656 \
    -p 26657:26657 \
    -p 1317:1317 \
    -p 9090:9090 \
    ghcr.io/bitsongofficial/go-bitsong:feat-hyperlane \
    bitsongd start --home $HOME
```

View logs:

```bash
docker logs -f $CHAIN_ID
```

Stop the chain:

```bash
docker stop $CHAIN_ID
```