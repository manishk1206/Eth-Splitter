const Splitter = artifacts.require("Splitter");

module.exports = function(deployer) {
  deployer.deploy(Splitter,true); //true for bool _state of Pausable
};
