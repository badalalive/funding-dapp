pragma solidity ^0.8.0;

contract Demo {

    // address of owner
    address public owner;

    constructor() {
        owner = msg.sender;
    }

}
