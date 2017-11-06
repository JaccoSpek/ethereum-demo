pragma solidity ^0.4.0;


contract Demo {
    // guess struct
    struct Guess {
        address guesser;
        int guess;
    }

    // owner of the contract
    address owner;

    // number of pepernoten
    int public pepernoten;

    // mapping of addresses that guessed
    mapping (address => bool) guessed;
    mapping (address => int) guesses;

    // array of guesses
    Guess[] guessesArray;

    // winners
    address[] winners;

    // is the game still open
    bool public open = true;
    int public diff;

    // constructor
    function Demo(){
        owner = msg.sender;
    }

    event Vote(address);
    // register guess, can only be called by participants (not owner)
    function guess(int number) notOwner {
        // see if caller has guessed can only guess when final number hasn't been set
        if (open && !guessed[msg.sender]) {
            // can only guess once
            guessed[msg.sender] = true;
            // register guess
            guesses[msg.sender] = number;
            guessesArray.push(Guess(msg.sender,number));
            Vote(msg.sender);
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

    // get number of votes
    function getGuessCount() constant returns(uint) {
        return guessesArray.length;
    }

    // close game, and determine winner
    function close(int number) onlyOwner {
        if (open && number > 0) {
            open = false;
            pepernoten = number;

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
                    winners.push(guessesArray[i].guesser);
                    closestDist = dist;
                } else { // rest
                    if (dist == closestDist) {
                        winners.push(guessesArray[i].guesser);
                    } else if (dist < closestDist) {
                        closestDist = dist;
                        winners.length = 0;
                        winners.push(guessesArray[i].guesser);
                    }
                }
            }
            diff = closestDist;
        }
    }

    // check if caller won the game
    function did_i_win() constant returns(bool) {
        for(uint i = 0; i < winners.length; i++) {
            if (winners[i] == msg.sender) {
                return true;
            }
        }
        return false;
    }

    // check if address won the game
    function did_addr_win(address addr) constant returns(bool) {
        for(uint i = 0; i < winners.length; i++) {
            if (winners[i] == addr) {
                return true;
            }
        }
        return false;
    }

    // get winner
    function getWinner(uint i) constant returns(address){
        if (i >= winners.length) return;

        return winners[i];
    }

    // total number of winners
    function numWinners() constant returns(uint) {
        return winners.length;
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
