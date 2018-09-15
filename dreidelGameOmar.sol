pragma solidity ^0.4.22;
//import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
contract Dreidel {
    address public owner; //contract owner
    address[6] public players; //players in the game
    uint8 public playersUpper; //max players before game auto-starts
    uint8 public playerCount; //starts at 1
    uint public stake; //amt of ETH staked
    uint8 public status; //0 = joinable; 1 = completed 
    uint public startTime; //block that game started on
    uint public endTime;
    uint8 public MIN_PLAYERS = 2; //constant : number of players n
    uint8 public PIECE_AMT = 10;
    uint8 public TIMEOUT = 240; //time elapsed before timeout
    uint public ONE_ETH = 1000000000000000000;
    constructor(uint8 _playersUpper) public payable {
        owner = msg.sender;
        playersUpper = _playersUpper;
        playerCount = 1;
        stake = msg.value;
        players[0] = owner;
        if (playersUpper < 2 || playersUpper > 6) {
            kill();
            // WARNING: Kill should never be called outside of this
            // constructor!
        }

        startTime = block.number;

        // Executer incentive to follow; watchdog for timed
        // kill() by startTime + TIMEOUT
    }


    function join() payable public{
        if (msg.value != stake) return;
        if (playerCount + 1 > playersUpper) return;
        playerCount++;
        players[playerCount - 1] = msg.sender;
        //if (players == playersUpper) //tell owner to cancel watchdog & start game

    }

    function computeGame() public payable {

    }
    
    function kill() private { 
        if (msg.sender == owner) 
        selfdestruct(owner); 
    }

}