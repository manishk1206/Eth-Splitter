const ConvertLib = artifacts.require("Splitter");

module.exports = function(deployer) {
  deployer.deploy(Splitter);
};
