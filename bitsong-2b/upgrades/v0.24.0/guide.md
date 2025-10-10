# Go-Bitsong v0.24.0 - Jimi

|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                 |
| Upgrade Version | [`v0.24.0`](https://github.com/bitsongofficial/go-bitsong/pull/292) |
| Upgrade Height  | [`24784361`](https://explorer.chainroot.io/bitsong/blocks/24784361) |

The target block for this upgrade is `24784361`, which is expected to arrive at `Mon, Oct 20 2025` [Go Playground](https://go.dev/play/p/c3Y6Cy_BrIc)

## PRE-UPGRADE-SCRIPT

> VALIDATORS MUST MODIFY THEIR `CONFIG.TOML` CONSENSUS PARAMETERS **AFTER** REACHING THE COORDINATED HALT HEIGHT, & BEFORE **INSTALLING** THE NEWEST VERSION OF GO-BITSONG

This can be done 1 of 3 ways:

1. **Manually**: Nodes not using cosmovisor will **wait until the network halts**, then **manually apply `config.toml` changes** before installing the v5.0.0 binary and restarting.
2. **With Default Cosmovisor**: Node operators must download the pre-upgrade script and set environment variables BEFORE reaching our coordinated halt height. Cosmovisor will automatically execute the script and upgrade when the halt height is reached.
3. **With Custom Cosmovisor**: A modified cosmovisor that automatically downloads and executes pre-upgrade scripts. Operators must install the custom cosmovisor binary BEFORE reaching the coordinated halt height - no manual script download required.

### A. WITHOUT COSMOVISOR: Manual Update to `config.toml`  

Upon reaching the coordinated halt height, apply the changes needed to your config files BEFORE installing the latest version:

```sh
# define your nodes config file location
export CONFIG_PATH=$HOME/.bitsongd/config/config.toml
# apply updates to the consensus params
sed -i.bak "/^\[consensus\]/,/^\[/ s/^[[:space:]]*timeout_commit[[:space:]]*=.*/timeout_commit = \"2400ms\"/" "$CONFIG_PATH"
sed -i.bak "/^\[consensus\]/,/^\[/ s/^[[:space:]]*timeout_propose[[:space:]]*=.*/timeout_propose = \"2400ms\"/" "$CONFIG_PATH"
# confirm updates were applied
grep -E "timeout_commit|timeout_propose" "$CONFIG_PATH"
# should see:
# timeout_propose = "2400ms"
# # How much timeout_propose increases with each round
# timeout_propose_delta = "500ms"
# timeout_commit = "2400ms"
# skip_timeout_commit = false
```

### B. WITH COSMOVISOR: Semi-Automatic Upgrade Via Cosmovisor

Cosmovisor support the execution of a pre-upgrade script, if one exists in the expected location within cosmovisors home directory. You can prepare your cosmovisor to execute the pre-upgrade-script via the following steps:

```sh
systemctl stop bitsongd.service
# download & verify the sh script, place in the correct location for cosmovisor
wget https://raw.githubusercontent.com/permissionlessweb/networks/refs/heads/master/bitsong-2b/upgrades/v0.24.0/preUpgradeScript.sh $DAEMON_HOME/cosmovisor/preUpgradeScript.sh
# confirm checksums match 
sha256sum preUpgradeScript.sh $DAEMON_HOME/cosmovisor/preUpgradeScript.sh
# output should be: 
# f4e88c199864094ae025e0ce3b8bd9ff0b5e648bfe00acd80e4062ef6d3d5d0b  preUpgradeScript.sh
# set the environment variable for cosmovisor (preferably in systemd file)
sudo sed -i '' 's/Environment="DAEMON_RESTART_AFTER_UPGRADE=true"/&\'$'\n''Environment="COSMOVISOR_CUSTOM_PREUPGRADE=preUpgradeScript.sh"/' /etc/systemd/system/bitsongd.service
# reload the daemon-process
sudo -S systemctl daemon-reload
sudo systemctl start bitsongd
```

Cosmovisor will now perform the pre-upgrade scripts once reaching the coordinated halt height & prior to installing and resuming with the latest go-btisong version.

### C. WITH CUSTOM COSMOVISOR: Fully-Automatic Upgrade Via Custom Cosmovisor
>
> If you would like to completely automate the pre-upgrade script, **we have released a version of cosmovisor** that will download any preUpgradeScript defined in the UpgradeInfo embedded in our upgrade proposal. You can review the modifications made [here](https://github.com/permissionlessweb/cosmos-sdk/compare/648633cc6d1eac408c87ad892f237cebd1ecc549...af61af47e79fd807559ec3148f5a0bea8ea749e9).

**If you ARE already running cosmovisor**, before reaching the coordinated upgrade height:

```sh
# kill existing cosmovisor process
systemctl stop bitsongd.service
# build/install custom cosmovisor
git clone -b feat/cosmovisor-preupgradescript https://github.com/permissionlessweb/cosmos-sdk cv-cosmos-sdk
cd cv-cosmos-sdk/tools/cosmovisor || exit
make cosmovisor
sudo mv cosmovisor /usr/local/bin/
# resume cosmovisor process
sudo -S systemctl daemon-reload
sudo systemctl start bitsongd
```

**If you ARE NOT running cosmovisor**, berfore reaching the coordinated upgrade height:

```sh
# kill any bitsongd process
systemctl stop bitsongd.service
# install custom cosmovisor version 
git clone -b feat/cosmovisor-preupgradescript https://github.com/permissionlessweb/cosmos-sdk cv-cosmos-sdk
# traverse into cosmovisor root
cd cv-cosmos-sdk/tools/cosmovisor || exit
# build cosmovisor image manually
make cosmovisor
# move binary into system-wide user binary directory
mv cosmovisor /usr/local/bin/
# cleanup workspace
cd ../../../ && rm -rf cv-cosmos-sdk
# initialize and configure
#
# define environment variables
export DAEMON_NAME=bitsongd
export DAEMON_HOME=$HOME/.bitsongd
# move existing binary into path cosmovisor accesses
cosmovisor init $HOME/go/bin/bitsongd
# setup systemd process
sudo bash -c 'cat > /etc/systemd/system/bitsongd.service << EOF
[Unit]
Description=Bitsongd Daemon (cosmovisor)
After=network-online.target

[Service]
User='$USER'
ExecStart=/home/'$USER'/go/bin/cosmovisor run start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment=DAEMON_NAME='bitsongd'
Environment=DAEMON_HOME='$HOME/.bitsongd'
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"

[Install]
WantedBy=multi-user.target
EOF'

# reload systemctl 
sudo -S systemctl daemon-reload
sudo -S systemctl enable bitsongd
# enable
sudo systemctl start bitsongd
```

Now, when cosmovisor recieves an upgrade plan, it will download & prepare the pre-upgrade script, if it exists, automatically.

> We have full e2e test for each method, located in the latest release. Its recommended to test the upgrade workflow you choose manually before voting on the proposal: <https://github.com/permissionlessweb/go-bitsong/tree/main/tests/bsh/upgrade>

## Building Manually

### 1. Verify that you are currently running the correct version (v0.23.0) of `bitsongd`

```sh
bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# version: 0.23.0
# commit: 
# build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `24505565`

```sh
perl -i -pe 's/^halt-height =.*/halt-height = 24505565/' ~/.bitsongd/config/app.toml
```

then restart your node `systemctl restart bitsongd`

### 3. After the chain has halted, make a backup of your `.bitsongd` directory

```sh
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-2b`.
~z

### Option A: Install Go-Bitsong binary

```sh
git clone https://github.com/bitsongofficial/go-bitsong
cd go-bitsong && git pull && git checkout v0.24.0
make install 
```

### 5. Verify you are currently running the correct version (v0.24.0) of the `go-bitsong`

```sh
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: TBD
# cosmos_sdk_version: v0.53.4
# version: v0.24.0
```

### Option B: Downloading Verified Build

```sh
# set target platform
export PLATFORM_TARGET=amd64 #arm64
 # delete if exists
rm -rf bitsongd_linux_$PLATFORM_TARGET.tar.gz
# download 
curl -L -o ~/bitsongd-linux-$PLATFORM_TARGET.tar.gz https://github.com/bitsongofficial/go-bitsong/releases/download/v0.24.0/bitsongd-linux-$PLATFORM_TARGET.tar.gz
# verify sha256sum 
sha256sum bitsongd-linux-$PLATFORM_TARGET.tar.gz
# Output: TBD  bitsongd-linux-amd64.tar.gz
# Output: TBD  bitsongd-linux-arm64.tar.gz

# decompress 
tar -xvzf bitsongd-linux-$PLATFORM_TARGET.tar.gz 

## move binary to go bin path
sudo mv build/bitsongd-linux-$PLATFORM_TARGET $HOME/go/bin/bitsongd

## change file ownership, if nessesary 
sudo chmod +x $HOME/go/bin/bitsongd

## confirm binary executable works 
bitsongd version --long 

# build_tags: netgo,ledger
# commit: TBD
# server_name: bitsongd
# version: v0.24.0
```
