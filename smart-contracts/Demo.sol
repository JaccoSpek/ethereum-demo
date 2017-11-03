pragma solidity ^0.4.0;


contract Demo {
    // owner of the contract
    address public owner;

    // number of pepernoten
    uint pepernoten;

    // mapping of guesses
    mapping (address => number) guesses;
    mapping (address => bool) guessed;

    // constructor
    function Demo(){
        owner = msg.sender;
    }

    // register guess
    function guess(uintt number) notOwner {
        // see if caller has guessed
        if (!pepernoten && !guessed[address]) {
            // can only guess once
            guessed[address] = true;
            // register guess
            guesses[msg.sender] = number;
        }
    }

    // verify my guess
    function getMyGuess() constant returns(uint) {
        return guesses[msg.sender];
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
