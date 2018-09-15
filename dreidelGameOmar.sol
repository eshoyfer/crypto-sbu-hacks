pragma solidity ^0.4.22;

contract Dreidel {
    address owner; //contract owner
    address[6] players; //players in the game
    uint8 upperPlayers; //max players before game auto-starts
    uint8 players; //starts at 1
    uint stake; //amt of ETH staked
    uint8 status; //0 = joinable; 1 = completed 
    uint startTime; //block that game started on
    uint endTime;
    uint8 MIN_PLAYERS = 2; //constant : number of players n
    uint8 PIECE_AMT = 10;
    uint8 TIMEOUT = 240; //time elapsed before timeout
    
    constructor(uint8 _upperPlayers) public payable {
        if (_upperPlayers < 2 || _upperPlayers > 6) kill();
        owner = msg.sender;
        stake = msg.value;
        startTime = block.number;
        players[0] = owner;
        endTime = block.number + TIMEOUT;
    }

    function computeGame(address[6] players) {

    }

    function join(uint8 playerSize) {
    }
    
    function kill() public { 
        if (msg.sender == owner) 
        selfdestruct(owner); 
    }

}