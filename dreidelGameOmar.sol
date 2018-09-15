pragma solidity ^0.4.22;
//import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
contract Dreidel {
    address public owner; //contract owner
    address[6] public playerAddresses; //players in the game
    uint8 public upperPlayers; //max players before game auto-starts
    uint8 public players; //starts at 1
    uint public stake; //amt of ETH staked
    uint8 public status; //0 = joinable; 1 = completed 
    uint public startTime; //block that game started on
    uint public endTime;
    uint8 public MIN_PLAYERS = 2; //constant : number of players n
    uint8 public PIECE_AMT = 10;
    uint8 public TIMEOUT = 240; //time elapsed before timeout
    
    constructor(uint8 _upperPlayers) public payable {
        if (_upperPlayers < 2 || _upperPlayers > 6) kill();
        owner = msg.sender;
        stake = msg.value;
        startTime = block.number;
        playerAddresses[0] = owner;
        players = 1;
        endTime = block.number + TIMEOUT;
    }

    function join() payable public{
        if (msg.value != stake) return;
        if (players + 1 > players) return;
        players++;
        playerAddresses[players - 1] = msg.sender;
        //if (players == playersUpper) //tell owner to cancel watchdog & start game

    }

    function computeGame() public payable {

    }
    
    function kill() public { 
        if (msg.sender == owner) 
        selfdestruct(owner); 
    }

}