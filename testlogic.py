import string 
digs = string.digits + string.ascii_letters


def int2base(x, base):
    if x < 0:
        sign = -1
    elif x == 0:
        return digs[0]
    else:
        sign = 1

    x *= sign
    digits = []

    while x:
        digits.append(digs[int(x % base)])
        x = int(x / base)

    if sign < 0:
        digits.append('-')

    digits.reverse()

    return ''.join(digits)
pieceCount = []
print(int2base(16, 8))
"""playerCount = 2
PIECE_AMT = 10
pot = 0;
for (i = 0; i < playerCount; i++)  pieceCount[i] = PIECE_AMT
game = int("0xa7eee082d34ccd81b147387e076ce93471bd9d5b3f0baa8f7871afe0143af38f", 0);
playerIndex = 0;
livingPlayers = playerCount;
bytesIndex = 0;
three = 3*16;
while (livingPlayers > 1 && bytesIndex < 32) 
    while(pieceCount[playerIndex] == 0) 
         playerIndex = (playerIndex + 1) % uint8(playerCount);
    curr = game[bytesIndex];
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
        return pieceCount;"""