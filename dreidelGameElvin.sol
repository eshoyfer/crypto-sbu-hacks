pragma solidity ^0.4.22;
contract dreidelGame {

    // Every member variable is temporarily public.

    address public owner; // Creator
    address[6] public players;
    // Uninitialized values except up to players
    uint8 public playerCount; // Starts at 1
    uint8 public playersUpper; // Player defined 2-6
    uint256 public startTime; // Block
    uint8 public status; // 0 = joinable; 1 = ended
    uint public stake; // Player defined stake per player; sent to join
    uint8 public MIN_PLAYERS = 2;
    uint8 public TIMEOUT = 240;
    uint8 public PIECES = 10;
    uint32 public plot;

    // Create
    constructor(uint8 _playersUpper) public payable {
        owner = msg.sender;
        players[0] = owner;
        playersUpper = _playersUpper;
        playerCount = 1;
        stake = msg.value;

        if (playersUpper < 2 || playersUpper > 6) {
            kill();
            // WARNING: Kill should never be called outside of this
            // constructor!
        }

        startTime = block.number;

        // Executer incentive to follow; watchdog for timed
        // kill() by startTime + TIMEOUT
    }

    function join() payable public {
        if (msg.value != stake) return;
        if (playerCount + 1 > playersUpper) return;

        // Important:
        // Need to find out what the logic is for returning or
        // retaining msg.value

        playerCount++;

        players[playerCount - 1] = msg.sender;
        // Add his money to the pot


        // Executer incentive to follow; watchdog for
        // timed game execution by startTime + TIMEOUT
        // Additionally, cancel the previous watchdog
        // or make it invalid (whichever is a more natural implementation)

    }
/*
    function execute() {
        // Calls game logic; creates reportable outcome; stores in plot
    }
*/
    function kill() private {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}
