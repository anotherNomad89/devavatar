var DevAvatar = artifacts.require("./DevAvatar.sol");

contract("DevAvatar", function(accounts) {
  it("...balance should be zero.", function() {
    return DevAvatar.deployed()
      .then(function(instance) {
        dev = instance;

        return dev.balanceOf(accounts[0], { from: accounts[0] });
      })
      .then(function(bal) {
        assert.equal(bal, 0, "Balance is non zero.");
      });
  });
  it("...should mint a new token", function() {
    return DevAvatar.deployed()
      .then(function(instance) {
        dev = instance;

        return dev.mint("Name", { from: accounts[0] });
      })
      .then(function() {
        return dev.balanceOf(accounts[0], { from: accounts[0] });
      })
      .then(function(bal) {
        assert.equal(bal, 1, "Balance is not one.");
      });
  });
  it("...should mint get default child token", function() {
    return DevAvatar.deployed()
      .then(function(instance) {
        dev = instance;

        return dev.getTopic("Name", { from: accounts[0] });
      })
      .then(function() {
        return dev.totalChildContracts(1, { from: accounts[0] });
      })
      .then(function(bal) {
        assert.equal(bal, 1, "Balance is not one.");
      });
  });
  it("...should mint for different user", function() {
    return DevAvatar.deployed()
      .then(function(instance) {
        dev = instance;
      })
      .then(function() {
        return dev.mint("Name2", { from: accounts[1] });
      })
      .then(function() {
        return dev.getTopic("Name", { from: accounts[1] });
      })
      .then(function() {
        return dev.totalChildContracts(1, { from: accounts[1] });
      })
      .then(function(bal) {
        assert.equal(bal, 1, "Balance is not one.");
      });
  });
  it("...should transfer child token to new user", function() {
    return DevAvatar.deployed()
      .then(function(instance) {
        dev = instance;
        return dev._devAvatarTopics({ from: accounts[1] });
      })
      .then(function(addr) {
        address = addr;
        // console.log(addr);
      })

      .then(function() {
        /**transferChild(uint256 _fromTokenId, address _to, address _childContract, uint256 _childTokenId) */
        return dev.transferChild(1, accounts[1], address, 1, {
          from: accounts[0],
          gas: 5000000
        });
      })
      .then(function() {
        // return dev.balanceOf(accounts[0], { from: accounts[0] });
        return dev.totalChildContracts(1, { from: accounts[0] });
      })
      .then(function(bal) {
        assert.equal(bal, 0, "Balance is not zero.");
      });
  });
});
