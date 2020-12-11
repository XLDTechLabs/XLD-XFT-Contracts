const networks = require('../networks');

const XLDToken = artifacts.require('Token')
const XFTToken = artifacts.require('NFT')
const TokenPaymaster = artifacts.require('TokenPaymaster')

// test uniswap
const TestUniswap = artifacts.require('TestUniswap')

module.exports = async function (deployer, network, accounts) {

    // Deploy XLD Token
    await deployer.deploy(XLDToken, web3.utils.toWei('10000000', 'ether'), networks.relayHub);
    const xld = await XLDToken.deployed()

    // Deploy XIT Token
    await deployer.deploy(XFTToken, "https://xld-token-local.df.r.appspot.com/api/xft/")

    // Deploy Test Uniswap
    await deployer.deploy(TestUniswap, web3.utils.toWei('0.1', 'ether'), web3.utils.toWei('1000', 'ether'));
    const uniswap = await TestUniswap.deployed();

    // Deploy Paymaster
    await deployer.deploy(TokenPaymaster, uniswap.address, xld.address);
    paymaster = await TokenPaymaster.deployed();

    await paymaster.setRelayHub(networks.relayHub);
    await paymaster.setTrustedForwarder(networks.forwarder);
}