pragma solidity ^0.4.22;
contract dreidelGame {

    // Every member variable is temporarily public.

    address owner; // Creator
    address[6] players;
    // Uninitialized values except up to players
    uint8 public id; // Unique
    uint8 public players; // Starts at 1
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

    function join() payable {
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

    function execute() {
        // Calls game logic; creates reportable outcome; stores in plot
    }

    function kill() {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

}
