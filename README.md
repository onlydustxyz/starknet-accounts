<p align="center">
    <img src="resources/img/logo.png">
</p>
<div align="center">
  <h1 align="center">StarkNet Accounts</h1>
  <p align="center">
    <a href="https://discord.gg/onlydust">
        <img src="https://img.shields.io/badge/Discord-6666FF?style=for-the-badge&logo=discord&logoColor=white">
    </a>
    <a href="https://twitter.com/intent/follow?screen_name=onlydust_xyz">
        <img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white">
    </a>
    <a href="https://contributions.onlydust.xyz/">
        <img src="https://img.shields.io/badge/Contribute-6A1B9A?style=for-the-badge&logo=notion&logoColor=white">
    </a>
  </p>
  
  <h3 align="center">Custom StarkNet accounts implementations</h3>
</div>

> ## ⚠️ WARNING! ⚠️
>
> This repo contains highly experimental code.
> Expect rapid iteration.

## 🎟️ Description

## 🎗️ Prerequisites

Make sure your protostar is up-to-date:

```sh
protostar upgrade
```

## 📦 Compile

```sh
protostar build
```

## 🔬 Deploy

First, create a signer (public/private key pair).
To do so, you can follow these steps:

1. deploy an account with Braavos
2. extract the account's public key
3. then, deploy the account contract and pass the public key as input:

```sh
protostar -p testnet deploy ./build/timestamp_based_account.json --inputs <signer-public-key>
```

```sh
protostar -p testnet deploy ./build/nonce_2d_account.json --inputs <signer-public-key>
```

or in local:

```sh
protostar -p local deploy ./build/nonce_2d_account.json --inputs <signer-public-key>
```

### Deploy Marketplace and Signup accounts on devnet

As a convenience, a script is provided to deploy 2d nonce accounts for Marketplace (ie. a Feeder) and Signup (ie. a Registerer) backends.
It is meant to be used with devnet `--seed 0` provided accounts.

With the `--seed 0` option, a list of 10 accounts are provided by starknet-devnet.
Those accounts will be used as follow:

```txt
Account #0 : Not used
Account #1 : Sign-up backend signer (public/private key pair is used by the 2d nonce account)
Account #2 : Marketplace backend signer (public/private key pair is used by the 2d nonce account)
Account #3 : Not used
Account #4 : Not used
Account #5 : Not used
Account #6 : Not used
Account #7 : Not used
Account #8 : Not used
Account #9 : Not used
Account #10: Not used
```

```sh
starknet-devnet --seed 0
./scripts/deploy-e2e-tests-devnet.sh
```

## 🌡️ Testing

Go to <https://faucet.goerli.starknet.io/> to send ETH to the newly deployed account.

TODO: provide a little tool to test the account contract quickly.

## 🫶 Contributing

## 📄 License

**ProjectName** is released under the [MIT](LICENSE).
