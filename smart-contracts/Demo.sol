pragma solidity ^0.4.0;


contract Demo {
    // owner of the contract
    address public owner;

    // number of pepernoten
    uint pepernoten;

    // mapping of guesses
    mapping (address => uint) guesses;
    mapping (address => bool) guessed;

    // constructor
    function Demo(){
        owner = msg.sender;
    }

    // register guess
    function guess(uint number) notOwner {
        // see if caller has guessed
        if (pepernoten > 0 && !guessed[msg.sender]) {
            // can only guess once
            guessed[msg.sender] = true;
            // register guess
            guesses[msg.sender] = number;
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
