pragma solidity ^0.4.11;

contract CrowdFunding {
  struct Investor {
    address addr;
    uint amount;
  }

  address public owner;
  uint public numInvestors;
  uint public deadline;
  string public status;
  bool public ended;
  uint public goalAmount;
  uint public totalAmount;
  mapping (uint => Investor) public investors;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /// constructor
  function CrowdFunding(uint _duration, uint _goalAmount) {
    owner = msg.sender;

    deadline = now + _duration;

    goalAmount = _goalAmount;
    status = 'キャンペーン実施中';
    ended = false;

    numInvestors = 0;
    totalAmount = 0;
  }

  function fund() payable {
    require(!ended);

    Investor investor = investors[numInvestors++];
    investor.addr = msg.sender;
    investor.amount = msg.value;
    totalAmount += investor.amount;
  }

  function checkGoalReached() public onlyOwner {
    require(!ended);

    require(now >= deadline);

    if(totalAmount >= goalAmount) {
      status = 'キャンペーン成功';
      ended = true;

      if(!owner.send(this.balance)) {
        throw;
      }
    } else {
      uint i = 0;
      status = 'キャンペーン失敗';
      ended = true;

      while(i <= numInvestors) {
        if(!investors[i].addr.send(investors[i].amount)) {
          throw;
        }
        i++;
      }
    }
  }

  function kill() public onlyOwner {
    selfdestruct(owner);
  }
}
