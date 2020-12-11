const networks = {
    relayHub: require('./build/gsn/RelayHub.json').address,
    forwarder: require('./build/gsn/Forwarder.json').address,
    stakeManager: require('./build/gsn/StakeManager.json').address,
}

module.exports = networks;