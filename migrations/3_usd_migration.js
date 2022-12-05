const UsdToken = artifacts.require("UsdToken");

module.exports = function (deployer) {
    deployer.deploy(UsdToken);
};