# Contracts

- XLD - ERC20 Token
- XFT - ERC721 NFT that emits XLDs

# Overview

![Architecture](/images/architecture.png)

To test and audit things easily, we decoupled our Token and NFT project.

Here's an overview of the project:
- We will deploy our Token and NFT via Truffle.
- We will use [Infura](https://infura.io/) as our provider.
- We used [Web3](https://web3js.readthedocs.io/en/v1.3.0/) to build APIs for XLD and XFT on the XLOAD app
- XLD will be available on Uniswap
- XFT will be availble on OpenSea
