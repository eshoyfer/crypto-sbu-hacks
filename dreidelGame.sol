pragma solidity ^0.4.22;
contract dreidelGame {

    //

    address owner; // Creator
    uint id; // Unique
    uint players; // Starts at 1
    uint playersUpper; // Player defined 2-6
    uint startTime; // Block
    uint status; // 0 = joinable; 1 = in progress; 2 = ended
    uint stake; // Player defined stake per player; sent to join

    // Create
    constructor(uint8 _stake, uint) public payable {
        owner = msg.sender;
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

}
