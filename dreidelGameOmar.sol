pragma solidity ^0.4.22;
contract Dreidel {
    address public owner; //contract owner
    address[6] public players; //players in the game
    uint8 public playersUpper; //max players before game auto-starts
    uint8 public playerCount; //starts at 1
    uint public stake; //amt of ETH staked
    uint8 public status;
    uint public startTime; //block that game started on
    uint public endTime;
    uint8 public MIN_PLAYERS = 2; //constant : number of players n
    uint8 public PIECE_AMT = 7;
    uint8 public TIMEOUT = 240; //time elapsed before timeout
    uint public ONE_ETH = 1000000000000000000;

    constructor(uint8 _playersUpper) public payable {
        owner = msg.sender;
        playersUpper = _playersUpper;
        playerCount = 1;
        status = 0;
        stake = msg.value;
        players[0] = owner;
        if (playersUpper < 2 || playersUpper > 6 || stake <  ONE_ETH / 100) {
            kill();
            // WARNING: Kill should never be called outside of this
            // constructor!
        }

        startTime = block.number;
        // Executer incentive to follow; watchdog for timed
        // kill() by startTime + TIMEOUT
    }

    function duplicate(address cheater) public view returns(bool) {
        for (uint8 i = 0; i < playerCount; i++) {
            if (cheater == players[i])
                return true;
        }
        return false;
    }
    function join() payable public{
        require(msg.value == stake && !duplicate(msg.sender) && status == 0);
        require(playerCount + 1 <= playersUpper);
        playerCount++;
        players[playerCount - 1] = msg.sender;
        if (playerCount == playersUpper)
            computeGame();
    }

    function computeGame() public payable returns(uint256) {
        //come on Barbie let's go party
        require(playerCount > 1);
        uint256 game = generateRandomNumber();
        /* Here lies actual dreidel code 
        uint8 rounds = 0;
        uint8[] memory pieceCount = new uint8[](playerCount);
        uint8 pot = 0;
        for (uint i = 0; i < playerCount; i++)  pieceCount[i] = PIECE_AMT;
        uint8 playerIndex = 0;
        while (!isOver(pieceCount, playerCount)) {
            while(pieceCount[playerIndex] == 0) 
                playerIndex = (playerIndex + 1) % uint8(playerCount);
            uint256 ourTurn = game % 4; 
            if (ourTurn == 1) { //gimel
                pieceCount[playerIndex] += pot;
                pot = 0;
            } else if (ourTurn == 2) { //hei
                uint8 takeAway = (pot + (pot % 2)) / 2;
                pieceCount[playerIndex] += takeAway;
                pot -= takeAway;
            } else if (ourTurn == 3) { //shin
                if (pieceCount[playerIndex] >= 3) {
                    pot += 3;
                    pieceCount[playerIndex] -= 3;
                } else {
                    pot += pieceCount[playerIndex];
                    pieceCount[playerIndex] = 0;
                }//takes 3 away from player, or as much as they have
            }
            //ourTurn == 0 is "nun" - nothing happens
            playerIndex = (playerIndex + 1) % uint8(playerCount);
            for(uint8 j = 0; j < playerCount; j++) {
                if (pieceCount[j] > 0) {
                pot += 1;
                pieceCount[j] -= 1;
                }
            }
            game = game >> 2;
            rounds++;
        }
        address winner;
        for (uint k = 0; k < playerCount; i++) {
            if(pieceCount[playerCount] > 0) {
                winner = players[i];
            }
        }*/
        address winner = players[game % playerCount];
        winner.transfer(stake * playerCount);
        status = 1;
        return (game);
        
    }
    function isOver(uint8[] pieces, uint8 size) public pure returns (bool) {
        uint8 player = 0;
        for (uint8 i = 0; i < size; i++) {
            if (pieces[i] > 0) player++;
        }
    }

    function generateRandomNumber() public view returns (uint256) {
        //DEEPLY unsafe - change before production
        return uint256(keccak256(block.timestamp));
    }

    function kill() private { 
        if (msg.sender == owner) 
        selfdestruct(owner); 
    }

}