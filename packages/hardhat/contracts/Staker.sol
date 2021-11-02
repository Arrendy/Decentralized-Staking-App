pragma solidity >=0.6.0 <0.7.0;

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

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  event Stake(address, uint256);

  function stake(uint256 qty) public payable {
    address payable sender = msg.sender;
    balances[sender] += qty;
    (bool sent, bytes memory data) = sender.call{value: qty}("");
    require(sent, "Failed to send Ether");
    // payable(sender).transfer(value);
    // payable(address(this)).balance += value;
    // bool sent = payable(address(this)).send(msg.value);
    // require(sent, "didn't send");
    
    emit Stake(sender, balances[sender]);
  }

function execute() public payable {
  require(address(this).balance >= threshold, "below threshold");
  exampleExternalContract.complete({value: address(this).balance});
}

function withdraw() public payable{
 require(address(this).balance >= threshold, "below threshold");
}

function timeleft() view public {

}

  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value



  // if the `threshold` was not met, allow everyone to call a `withdraw()` function



  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


}
