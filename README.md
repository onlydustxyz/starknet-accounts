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

## 📦 Compile

```sh
protostar build --account-contract
```

## 🔬 Deploy

First create a signer (public/private key pair).
To do so, you can follow these steps:

1. deploy an account with Argent X
2. go on voyager to get the `signer` (ie. public key) of the account by calling `get_signer`
3. then, deploy the account contract and pass the public key as input:

```sh
protostar -p testnet deploy ./build/timestamp_based_account.json --inputs <signer-public-key>
```

```sh
protostar -p testnet deploy ./build/nonce_2d_account.json --inputs <signer-public-key>
```

## 🌡️ Testing

Go to <https://faucet.goerli.starknet.io/> to send ETH to the newly deployed account.

TODO: provide a little tool to test the account contract quickly.

## 🫶 Contributing

## 📄 License

**ProjectName** is released under the [MIT](LICENSE).
