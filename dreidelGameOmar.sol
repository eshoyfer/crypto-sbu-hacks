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

    function computeGame() public view returns(uint8[], uint8, uint8) {
        //come on Barbie let's go party
        require(playerCount > 1);
        uint8 rounds = 0;
        uint8[] memory pieceCount = new uint8[](playerCount);
        uint8 pot = 0;
        for (uint i = 0; i < playerCount; i++)  pieceCount[i] = PIECE_AMT;
        uint256 game = generateRandomNumber();
        uint8 playerIndex = 0;
        uint8 livingPlayers = playerCount;
        while (livingPlayers > 1 && game >= 4) {
            while(pieceCount[playerIndex] == 0) 
                playerIndex = (playerIndex + 1) % uint8(playerCount);
                uint256 ourTurn = game % 4; 
                if (ourTurn == 0) { //nun
                    playerIndex = (playerIndex + 1) % uint8(playerCount); 
                } else if (ourTurn == 1) { //gimel
                    pieceCount[playerIndex] += pot;
                    pot = 0;
                    playerIndex = (playerIndex + 1) % uint8(playerCount);
                } else if (ourTurn == 2) { //hei
                    uint8 takeAway = (pot + (pot % 2)) / 2;
                    pieceCount[playerIndex] += takeAway;
                    pot -= takeAway;
                } else if (ourTurn == 3) { //shin
                    for (uint8 k = 0; k < 2 && pieceCount[playerIndex] > 0; k++) {
                        pot++; pieceCount[playerIndex]--;
                    }
                }
            for(uint8 j = 0; j < playerCount; j++) {
                if (pieceCount[j] == 0) {
                    livingPlayers--;
                    continue;
                }
                pot += 1;
                pieceCount[j] -= 1;
            }
            game = game >> 2;
            rounds++;
        }
        return (pieceCount, pot, rounds);
    }
    
    function generateRandomNumber() public view returns (uint256) {
        //DEEPLY unsafe - change before production
        return uint256(keccak256(block.timestamp));
    }
    
    function rightShift() public view returns (uint256, uint256, uint256) {
        uint256 test = generateRandomNumber();
        return (test, uint256(4), test % 4);
    }
    function kill() private { 
        if (msg.sender == owner) 
        selfdestruct(owner); 
    }

}