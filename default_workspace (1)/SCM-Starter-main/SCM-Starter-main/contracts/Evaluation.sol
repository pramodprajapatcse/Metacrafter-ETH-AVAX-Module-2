

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract Evaluation {
    address payable public administrator;
    uint256 public funds;

    event Contribution(uint256 amount);
    event Removal(uint256 amount);

    constructor(uint initialFunds) payable {
        administrator = payable(msg.sender);
        funds = initialFunds;
    }

    function getFunds() public view returns(uint256){
        return funds;
    }

    function contribute(uint256 _amount) public payable {
        uint _formerFunds = funds;

        // make sure this is the administrator
        require(msg.sender == administrator, "You are not authorized to access this account");

        // perform transaction
        funds += _amount;

        // assert transaction completed successfully
        assert(funds == _formerFunds + _amount);

        // emit the event
        emit Contribution(_amount);
    }

    // custom error
    error InsufficientFunds(uint256 funds, uint256 removalAmount);

    function remove(uint256 _removalAmount) public {
        require(msg.sender == administrator, "You are not authorized to access this account");
        uint _formerFunds = funds;
        if (funds < _removalAmount) {
            revert InsufficientFunds({
                funds: funds,
                removalAmount: _removalAmount
            });
        }

        // remove the given amount
        funds -= _removalAmount;

        // assert the funds are correct
        assert(funds == (_formerFunds - _removalAmount));

        // emit the event
        emit Removal(_removalAmount);
    }
}
