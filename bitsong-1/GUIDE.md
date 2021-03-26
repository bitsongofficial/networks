# How to participate in bitsong-1

## Requirements

First of all, you need to make some preparations on your server (dedicated or cloud). Using a dedicated server ensures high performance (even in high load situations). The network uses Tendermint’s consensus, which elects a leader for each block. If your validator is offline, the consensus will delay the inclusion of the block and you may be slashed!

For this guide we used the following specifications:

- Ubuntu 20.04 OS
- 2 vCPU
- 4GB RAM
- 24GB SSD
- Unlock input connections on gate 26656
- Static IP address (Elastic IP for AWS, floating IP for DigitalOcean)
- You can find these features at any cloud provider (AWS, DigitalOcean, Google Cloud, Hetzner, Linode, etc.)

## Installazione software necessario

1. First you need to access via ssh inside the server and install the security updates

```bash
sudo apt update && sudo apt upgrade -y
```

2. Install the necessary packages for Golang to work

```bash
sudo apt install build-essential git unzip -y
```

3. Install Golang (1.13.x)

```bash
wget https://dl.google.com/go/go1.13.15.linux-amd64.tar.gz
sudo tar -xvzf go1.13.15.linux-amd64.tar.gz
sudo mv go /usr/local
```

4. Update system variables

```bash
cat <<EOF >> ~/.profile
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
```

5. Update your env

```bash
source ~/.profile
```

6. Check that golang is working properly

```bash
go version
```

If all went well, we should have this type of output

```bash
go version go1.13.15 linux/amd64
```

## Install Go-BitSong

After installing go-lang and the necessary packages, we can proceed with the installation of `go-bitsong` (BitSong's Blockchain)

1. Let's clone the BitSong repository

```bash
git clone https://github.com/bitsongofficial/go-bitsong.git
```

2. Select the correct tag

```bash
cd go-bitsong
git checkout v0.7.0
```

3. Fill in the binaries

```bash
make install
```

4. Check `go-bitsong` version

```bash
bitsongd version --long
```

If all went well, we should have an output like this

```bash
name: go-bitsong
server_name: bitsongd
client_name: bitsongcli
version: 0.7.0
commit: 26a277a67b8d3e0052ace21be7f3a2754171b06b
build_tags: netgo,ledger
go: go version go1.13.15 linux/amd64
build_deps:
....
```

## Setup Go-BitSong

Proceed with the configuration of `go-bitsong`, replace`<your-moniker>` with the public name you intend to assign to your validator, `bitsong-1` is the name of the testnet that we will use

1. Initialize `go-bitsong` indicating the name of your validator and the chain you want to connect to

```bash
bitsongd init --chain-id bitsong-1 <your-moniker>
```

> Note: `bitsongd init` set the `node-id` of your validator. You can get this data by typing the command `bitsongd tendermint show-node-id`. The value of `node-id` will be part of the transaction we will create for the genesis, so if you plan to send the `genesis-transaction`, **do not reset your `node-id` using the `bitsong unsafe-reset-all` command or by changing your IP address**

2. Create a wallet for your node

`<your-wallet-name>` must be replaced with the name you intend to give to the wallet. The name may differ from your `moniker`.

```bash
bitsongcli keys add <your-wallet-name> --recover
```

3. Paste your mnemonic phrase

```bash
> Enter your bip39 mnemonic

```

## Genesis transaction

1. Delete the old genesis

```bash
rm -f ~/.bitsongd/config/genesis.json
```

2. Download the new genesis, and copy it to the correct directory

```bash
wget https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-1/genesis.json -P ~/.bitsongd/config
```

3. Sign the `gentx` that will be included in `genesis`, if you want, you can add the `--ip` flag to indicate your public ip address

```bash
bitsongd gentx --name <your-wallet-name> --amount XXXXubtsg --ip <your-public-ip>
```

By running the command, a genesis transaction will be created and saved to the path `$HOME/.bitsongd/config/gentx/gentx-<gen-tx-hash>.json`. This should also be the only file in the `gentx` directory. If instead you find other files inside, we suggest you delete them and re-run the command for the `gentx` (as described above).

**DO NOT CHANGE NOTHING IN `gentx.json`**

5. Fork the repository dedicated to networks

![step1|690x220](https://btsg.community/uploads/default/original/1X/5b841738c2cd885a4842a8a5907512df5196e4c1.png)

**Make sure to fork the correct repository (https://github.com/bitsongofficial/networks) under your username.**

```
cd $HOME && git clone https://github.com/<YOUR-USERNAME>/networks.git && cd $HOME/networks
```

6. Create the branch dedicated to sending the TX

```
git checkout -b genesis-<your-moniker>
```

7. Check that there are no other TX inside

```
ls $HOME/.bitsongd/config/gentx
```

8. Copy the gentx

```
cp $HOME/.bitsongd/config/gentx/* $HOME/networks/bitsong-1/gentx/
```

9. If it's your first time using git, you need to do some configuration (optional)
   **Remember to change the data with your github account data**

```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

10. Add the files and commit the changes

```
git add bitsong-1/*
git commit -m 'feat: gentx for <your-moniker>'
```

11. Push the local branch to the remote repository

```
git push -u origin genesis-<your-moniker>
```

Great! If you have performed all the steps listed above, you only have to open a `Pull Request`

## Create a Pull Request

1. Click on the link [https://github.com/bitsongofficial/networks/pulls](https://github.com/bitsongofficial/networks/pulls)
2. Click on `New Pull Requst`
   ![step2|690x241](https://btsg.community/uploads/default/original/1X/beb01815bd5c356142fbd2dfc5c3c8936a450da5.png)

3. Click on `compare across forks`
   ![step3|690x236](https://btsg.community/uploads/default/original/1X/f0594ec0bbe457eee4350511f1d6d394f5c9068b.png)

4. Change the following parameters

```
base repository: bitsongofficial/networks
base: master

head repository: <YOUR-USERNAME>/networks
compare: genesis-<your-moniker>
```

![step4|690x262](https://btsg.community/uploads/default/original/1X/be6920121e59af9f448f9773de6e22f4f7c21456.png)

5. Continue by clicking on **"Create pull request"**
   ![step5|690x267](https://btsg.community/uploads/default/original/1X/e72a9f6e1caebc2b02c7079a2c4834a6907a0e1b.png)

6. Confirm by clicking on **"Create pull request"**
   ![step6|690x448](https://btsg.community/uploads/default/original/1X/eeea8c5af61d46d983e10d85113ef8be5c786806.png)

Make sure to check the previous steps before opening a PR.

Note: all `gentx` must be sent no later than **March 26th at 18:00 UTC**.

In case you do not have time to send the `gentx`, don't worry, you can launch your validator after the network has been started.

## Launching the testnet 🚀

Follow the instructions below:

1. Delete the old genesis

```bash
rm -f ~/.bitsongd/config/genesis.json
```

2. Download the new genesis, and copy it to the correct directory

```bash
wget https://raw.githubusercontent.com/bitsongofficial/networks/master/bitsong-1/genesis.json -P ~/.bitsongd/config
```

3. Check the shasum

```bash
$ shasum -a 256 genesis.json
c7c4559364cc15781011b3da4d853cce42b9f2ec1ac5e8b79f634969c0c13e41  genesis.json
```

**4. Run the node**

```bash
bitsongd start
```

_Optional, if you wish, you can create a systemd file (edit `<your_user>` where necessary)_

```bash
sudo tee /etc/systemd/system/bitsongd.service > /dev/null <<EOF
[Unit]
Description=BitSong Network Daemon
After=network-online.target

[Service]
User=<your_user>
ExecStart=/home/<your_user>/go/bin/bitsongd start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

Now we have to wait for the launch of the network which will take place on [March 26th, 2021 at 20:00 UTC](https://www.timeanddate.com/countdown/launch?iso=20210326T200000&p0=1440&msg=bitsong-1+launch&font=sanserif&csz=1)

```bash
sudo systemctl enable bitsongd
sudo systemctl start bitsongd
```

To check the status of the node, you can use the following commands

```bash
bitsongcli status
sudo journalctl -u bitsongd -f
```

After the network has reached the quorum, the testnet will start automatically!

**If the quorum is not reached, we will give further communications in the validator's chat**
https://discord.gg/ctv2QxnN
