pragma solidity ^0.4.22;
contract dreidelGame {

    //

    address owner; // Creator
    uint8 id; // Unique
    uint8 players; // Starts at 1
    uint8 playersUpper; // Player defined 2-6
    uint256 startTime; // Block
    uint8 status; // 0 = joinable; 1 = ended
    uint stake; // Player defined stake per player; sent to join

    // Create
    constructor(uint8 _playersUpper) public payable {
        owner = msg.sender;
        playersUpper = _playersUpper;
        players = 1;
        stake = msg.value;

        if (playersUpper < 2 || playersUpper > 6) {
            kill();
        }

        startTime = block.number;
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

}
