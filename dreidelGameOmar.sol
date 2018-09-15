pragma solidity ^0.4.22;
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
    uint public STAKE_WORTH;
    uint8 public TIMEOUT = 240; //time elapsed before timeout
    uint public ONE_ETH = 1000000000000000000;


    event newRandomNumber_bytes(bytes);

    constructor(uint8 _playersUpper) public payable {
        owner = msg.sender;
        //playersUpper = _playersUpper;
        playersUpper = 2;
        playerCount = 1;
        stake = msg.value;
        players[0] = owner;
        if (playersUpper < 2 || playersUpper > 6) {
            kill();
            // WARNING: Kill should never be called outside of this
            // constructor!
        }

        startTime = block.number;
        STAKE_WORTH = stake / PIECE_AMT;
        // Executer incentive to follow; watchdog for timed
        // kill() by startTime + TIMEOUT
    }


    function join() payable public{
        require(msg.value == stake);
        require(playerCount + 1 <= playersUpper);
        playerCount++;
        players[playerCount - 1] = msg.sender;
        //if (players == playersUpper) //tell owner to cancel watchdog & start game

    }

    function computeGame() public view returns(uint8[]) {
        //come on Barbie let's go party
        require(playerCount > 1);
        uint8[] memory pieceCount = new uint8[](playerCount);
        uint8 pot = 0;
        for (uint i = 0; i < playerCount; i++)  pieceCount[i] = PIECE_AMT;
        bytes32 game = generateRandomNumber();
        uint8 playerIndex = 0;
        uint8 livingPlayers = playerCount;
        uint8 bytesIndex = 0;
        bytes1 three = bytes1(3*16);
        while (livingPlayers > 1 && bytesIndex < 32) {
            while(pieceCount[playerIndex] == 0) 
                playerIndex = (playerIndex + 1) % uint8(playerCount);
            bytes1 curr = game[bytesIndex];
            for(uint8 j = 0; j < 4; j++) {
                bytes1 ourTurn = (curr & three);
                curr = curr << 2;
                if (ourTurn == 0) { //nun
                    playerIndex = (playerIndex + 1) % uint8(playerCount); 
                } else if (ourTurn == 1) { //gimel
                    pieceCount[playerIndex] += pot;
                    playerIndex = (playerIndex + 1) % uint8(playerCount);
                } else if (ourTurn == 2) { //hei
                    pieceCount[playerIndex] += (pot + (pot % 2)) / 2;
                } else if (ourTurn == 3) { //shin
                    uint8 remove = 0;
                    for (uint8 k = 0; k < 2 && pieceCount[playerIndex] > 0; k++) {
                        remove++; pieceCount[playerIndex]--;
                    }
                    pot+= remove;
                }
            }
            bytesIndex++;
        }
        return pieceCount;
    }
    
    function generateRandomNumber() private view returns (bytes32) {
        //DEEPLY unsafe - change before production
        return keccak256(block.timestamp);
    }
    
    function rightShift() public view returns (bytes1, bytes1, bytes1) {
        bytes32 test = generateRandomNumber();
        return (test[0], bytes1(3*16), bytes1(test[0]) & bytes1(3*16));
    }
    function kill() private { 
        if (msg.sender == owner) 
        selfdestruct(owner); 
    }

}