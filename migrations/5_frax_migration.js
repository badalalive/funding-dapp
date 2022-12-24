const FRAX = artifacts.require("FraxToken");

module.exports = function (deployer) {
    deployer.deploy(FRAX);
};