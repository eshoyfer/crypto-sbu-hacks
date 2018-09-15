pragma solidity ^0.4.22;
contract dreidelGame {

    //

    address owner; // Creator
    uint8 id; // Unique
    uint8 players; // Starts at 1
    uint8 playersUpper; // Player defined 2-6
    uint32 startTime; // Block
    uint8 status; // 0 = joinable; 1 = in progress; 2 = ended
    uint8 stake; // Player defined stake per player; sent to join

    // Create
    constructor(uint8 _stake, uint8 _playersUpper) public payable {
        owner = msg.sender;
        stake = _stake;
        playersUpper = _playersUpper;
        players = 1;

        if (playersUpper < 2 || playersUpper > 6) {
            kill();
        }
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

}
