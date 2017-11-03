pragma solidity ^0.4.0;


contract Demo {
    struct Guess {
        address guesser;
        uint guess;
    }

    // owner of the contract
    address public owner;

    // number of pepernoten
    uint pepernoten;

    // mapping of addresses that guessed
    mapping (address => bool) guessed;
    mapping (address => uint) guesses;

    // array of guesses
    Guess[] public guessesArray;

    // winner
    address winner;

    // is the game still open
    bool open = true;

    // constructor
    function Demo(){
        owner = msg.sender;
    }

    // register guess, can only be called by participants (not owner)
    function guess(uint number) notOwner {
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
    function getMyGuess() constant returns(uint) {
        return guesses[msg.sender];
    }

    // verify anyones guess
    function getGuess(address guesser) constant returns(uint){
        return guesses[guesser];
    }

    // close game, and determine winner
    function close(uint number) onlyOwner {
        if (open && number > 0) {
            open = false;
            pepernoten = number;

            address closest;
            int closestDist = -1;
            for (uint i = 0; i < guessesArray.length; i++) {
                // distance from real value
                int dist = (pepernoten - guessesArray[i].guess) * -1;
                // if first
                if (closestDist == -1) {
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
        }
    }

    // check if I won the game
    function didIWin() constant returns(bool) {
        return msg.sender == winner;
    }

    function winner() constant returns(address) {
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
