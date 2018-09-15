pragma solidity ^0.4.22;

contract Dreidel {
    address owner; //contract owner
    uint8 upperPlayers; //max players before game auto-starts
    uint stake; //amt of ETH staked
    uint8 status; //0 = joinable; 1 = completed 
    uint startTime; //block that game started on
    uint8 MIN_PLAYERS = 2; //constant : number of players n
    uint8 PIECE_AMT = 10;
    uint8 TIMEOUT = 240; //time elapsed before timeout
    
    constructor(uint8 _upperPlayers) public payable {
        if (_upperPlayers < 2 || _upperPlayers > 6) kill();
        owner = msg.sender;
        stake = msg.value;
        startTime = block.number;
        endTime = block.number + TIMEOUT;
    }

    
    
    function kill() public { 
        if (msg.sender == owner) 
        selfdestruct(owner); 
    }

}