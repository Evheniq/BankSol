const Migrations = artifacts.require("BankSol");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
