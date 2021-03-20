#!/bin/sh
DAEMON_HOME="/tmp/app$(date +%s)"
CLI_HOME="/tmp/appcli$(date +%s)"
DAEMON=bitsongd
CLI=bitsongcli
DENOM=ubtsg
RANDOM_KEY="validatorkeyxxxx"
CHAIN_ID=bitsong-testnet-4

GENTX_FILE=$(ls $CHAIN_ID/gentx | head -1)
LEN_GENTX=$(echo ${#GENTX_FILE})

GENTX_DEADLINE=$(date -d '2020-10-19 15:00:00' '+%d/%m/%Y %H:%M:%S');
now=$(date +"%d/%m/%Y %H:%M:%S")

if [ $LEN_GENTX -eq 0 ]; then
    echo "No new gentx file found."
else
    set -e

    ./scripts/check-gentx-amount.sh "./$CHAIN_ID/gentx/$GENTX_FILE" || exit 1

    echo "...........Install & Init Chain.............."
    
    git clone https://github.com/bitsongofficial/go-bitsong
    cd go-bitsong
    git checkout v0.7.0-rc1
    make build
    chmod +x ./build/$DAEMON
    chmod +x ./build/$CLI

    ./build/$DAEMON init validator --chain-id $CHAIN_ID --home $DAEMON_HOME -o
    echo "12345678" |  ./build/$CLI keys add $RANDOM_KEY --keyring-backend test --home $CLI_HOME

    echo "...........Fetching genesis.............."
    rm -rf $DAEMON_HOME/config/genesis.json
    curl -s https://raw.githubusercontent.com/bitsongofficial/networks/master/$CHAIN_ID/genesis.json > $DAEMON_HOME/config/genesis.json

    GENACC=$(cat ../$CHAIN_ID/gentx/$GENTX_FILE | sed -n 's|.*"delegator_address":"\([^"]*\)".*|\1|p')
    echo $GENACC

    echo "12345678" | ./build/$DAEMON add-genesis-account $RANDOM_KEY 1000000000000$DENOM --home $DAEMON_HOME --keyring-backend test --home-client $CLI_HOME
    ./build/$DAEMON add-genesis-account $GENACC 1000000000$DENOM --home $DAEMON_HOME

    echo "12345678" | ./build/$DAEMON gentx --name $RANDOM_KEY --amount 900000000000$DENOM --home $DAEMON_HOME --keyring-backend test --home-client $CLI_HOME
    cp ../$CHAIN_ID/gentx/$GENTX_FILE $DAEMON_HOME/config/gentx/

    echo "...........Collecting gentxs.............."

    ./build/$DAEMON collect-gentxs --home $DAEMON_HOME
    sed -i '/persistent_peers =/c\persistent_peers = ""' $DAEMON_HOME/config/config.toml

    echo "...........Validate genesis.............."
    ./build/$DAEMON validate-genesis --home $DAEMON_HOME

    echo "...........Starting node.............."
    ./build/$DAEMON start --home $DAEMON_HOME &

    sleep 5s

    echo "...checking network status.."

    ./build/$CLI status --chain-id $CHAIN_ID --node http://localhost:26657

    sleep 5s

    echo "...Cleaning the stuff..."
    killall $DAEMON >/dev/null 2>&1
    rm -rf $DAEMON_HOME >/dev/null 2>&1
fi