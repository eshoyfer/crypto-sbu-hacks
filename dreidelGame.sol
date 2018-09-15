pragma solidity ^0.4.0;
contract dreidelGame {

    //

    uint id; // Unique
    uint players; // Starts at 1
    uint playersUpper; // Player defined 2-6
    uint startTime; // Block
    uint status; // 0 = joinable; 1 = in progress; 2 = ended
    uint stake; // Player defined stake per player; sent to join

    // Create
    function dreidelGame(uint8 _stake) public {
        // = msg.sender;
    }

}
