// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// import contract from hardhat/console to be able to use `console.log`
import "hardhat/console.sol";

contract MyContract {
    uint number;

    // public --> able to execute from public
    // private --> only able to execute inside this contract

    // view --> write normal (add/edit state)
    function setNumber(uint newNumber) public {
        number = newNumber;
    }

    // view --> read state
    function getNumber() public view returns (uint) {
        return number;
    }

    // view --> read non-state (hardcoded value)
    function getRandomNumber() public pure returns (uint) {
        return 9;
    }

    // view --> write payable (similar to normal and have access to `msg` instance)
    function payMeBackLess() public payable {
        console.log("msg.value: ", msg.value);

        // require
        // if (condition met) {
        //   // execute the next line of code
        // }
        // else { revert() }
        // revert() --> revert the transaction that has been executed
        require(msg.value >= 1 ether, "Must send at least 1 ETH");

        uint randomNumber = getRandomNumber();
        uint ethRefund = msg.value / randomNumber;
        payable(msg.sender).transfer(ethRefund);
    }
}
