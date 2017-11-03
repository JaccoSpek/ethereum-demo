pragma solidity ^0.4.0;


contract Demo {
    // guess struct
    struct Guess {
        address guesser;
        int guess;
    }

    // owner of the contract
    address public owner;

    // number of pepernoten
    int public pepernoten;

    // mapping of addresses that guessed
    mapping (address => bool) guessed;
    mapping (address => int) guesses;

    // array of guesses
    Guess[] guessesArray;

    // winner
    address winner;

    // is the game still open
    bool public open = true;
    int public diff;

    // constructor
    function Demo(){
        owner = msg.sender;
    }

    // register guess, can only be called by participants (not owner)
    function guess(int number) notOwner {
        // see if caller has guessed can only guess when final number hasn't been set
        if (open && !guessed[msg.sender]) {
            // can only guess once
            guessed[msg.sender] = true;
            // register guess
            guesses[msg.sender] = number;
            guessesArray.push(Guess(msg.sender,number));
        }
    }

    // verify my guess
    function getMyGuess() constant returns(int) {
        return guesses[msg.sender];
    }

    // verify anyones guess
    function getGuess(address guesser) constant returns(int){
        return guesses[guesser];
    }

    // close game, and determine winner
    function close(int number) onlyOwner {
        if (open && number > 0) {
            open = false;
            pepernoten = number;

            address closest;
            int closestDist;
            for (uint i = 0; i < guessesArray.length; i++) {
                // distance from real value
                int dist = pepernoten - guessesArray[i].guess;
                // make absolute
                if (dist < 0) {
                    dist = dist * -1;
                }
                // if first
                if (i == 0) {
                    closest = guessesArray[i].guesser;
                    closestDist = dist;
                } else { // rest
                    if (dist < closestDist) {
                        closestDist = dist;
                        closest = guessesArray[i].guesser;
                    }
                }
            }
            winner = closest;
            diff = closestDist;
        }
    }

    // check if I won the game
    function didIWin() constant returns(bool) {
        return msg.sender == winner;
    }

    function getWinner() constant returns(address) {
        return winner;
    }

    // modifier: Function can not be called by owner
    modifier notOwner {
        require(msg.sender != owner);
        _;
    }

    // modifier: Function can only be called by owner
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}
