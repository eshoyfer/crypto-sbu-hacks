pragma solidity ^0.4.22;
contract dreidelGame {

    //

    address owner; // Creator
    address[6] players;
    // Uninitialized values except up to players
    uint8 id; // Unique
    uint8 players; // Starts at 1
    uint8 playersUpper; // Player defined 2-6
    uint256 startTime; // Block
    uint8 status; // 0 = joinable; 1 = ended
    uint stake; // Player defined stake per player; sent to join
    unit8 MIN_PLAYERS = 2;
    unit8 TIMEOUT = 240;
    unit8 PIECES = 10;
    uint32 plot;

    // Create
    constructor(uint8 _playersUpper) public payable {
        owner = msg.sender;
        playersUpper = _playersUpper;
        players = 1;
        stake = msg.value;

        if (playersUpper < 2 || playersUpper > 6) {
            kill();
            // WARNING: Kill should neve rbe called outside of this
            // constructor!
        }

        startTime = block.number;

        // Executer incentive to follow; watchdog for timed
        // kill() by startTime + TIMEOUT
    }

    function join() payable public {
        if (msg.value != stake) return;
        if (players + 1 > playersUpper) return;

        players++;
        address[players - 1] = msg.sender;
        // Add his money to the pot


        // Executer incentive to follow; watchdog for
        // timed game execution by startTime + TIMEOUT
        // Additionally, cancel the previous watchdog
        // or make it invalid (whichever is a more natural implementation)

        }
    }

    function execute() public {
        // Calls game logic; creates reportable outcome; stores in plot
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

}
