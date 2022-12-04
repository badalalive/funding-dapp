pragma solidity ^0.8.0;

contract Demo {

    // address of owner
    address public owner;

    // no of funders
    uint256 public noOfFunder;

    mapping (uint256 => address) funder;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function transfer() external payable {
        funder[noOfFunder++] = msg.sender;
    }

    function withdraw(uint256 _withdrawAmount) external {
        require(_withdrawAmount <= 2e18,"Can not withdraw more than 2 ether");
        payable(msg.sender).transfer(_withdrawAmount);
    }


}
