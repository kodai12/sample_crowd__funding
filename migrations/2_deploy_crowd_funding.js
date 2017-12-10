var CrowdFunding = artifacts.require('./CrowdFunding');

module.exports = function(deployer) {
  var _duration = 600;
  var _goalAmount = 10;
  deployer.deploy(CrowdFunding, _duration, _goalAmount);
}
