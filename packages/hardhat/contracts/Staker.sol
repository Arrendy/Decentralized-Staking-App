pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  // Address balances
  mapping(address => uint256) public balances;

  // Threshold
  uint256 public constant threshold = 1 ether;

  // Deadline
  uint256 public deadline = block.timestamp + 30 seconds;

  modifier stakeNotCompleted() {
    bool completed = exampleExternalContract.completed();
    require(!completed, "staking process already completed");
    _;
  }

  modifier deadlineReached( bool requireReached ) {
    uint256 timeRemaining = timeLeft();
    require(timeRemaining > 0);
    _;
  }

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  event Stake(address, uint256);

  function stake() public payable deadlineReached(false) stakeNotCompleted {
    address sender = msg.sender;
    balances[sender] += msg.value;
    
    emit Stake(sender, balances[sender]);
  }

function execute() public stakeNotCompleted deadlineReached(false) {
  uint256 contractBalance = address(this).balance;
  require(contractBalance >= threshold, "below threshold");
  
  (bool sent,) = address(exampleExternalContract).call{value: contractBalance}(abi.encodeWithSignature("complete()"));
  require(sent, "could not send");
}

function withdraw() public deadlineReached(true) stakeNotCompleted {
  uint256 userBalance = balances[msg.sender];
  require(userBalance >= 0, "no coins");

  balances[msg.sender] = 0;

  (bool sent,) = msg.sender.call{value: userBalance}("");
  require(sent, "withdraw failed");
}


function timeLeft() public view returns (uint256 timeleft) {
    // if( block.timestamp >= deadline ) {
    //   return 0;
    // } else {
    //   return deadline - block.timestamp;
    // }
    return 1;
  }
}