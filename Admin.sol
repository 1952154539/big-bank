// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IBank.sol";

contract Admin {
    address public owner;

    event AdminWithdrawn(address indexed bank, uint256 amount);
    event OwnerTransferred(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Admin: caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function adminWithdraw(IBank bank) external onlyOwner {
        uint256 balance = bank.getContractBalance();
        require(balance > 0, "Admin: bank balance is zero");
        bank.withdraw(balance);
        emit AdminWithdrawn(address(bank), balance);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Admin: invalid owner address");
        emit OwnerTransferred(owner, newOwner);
        owner = newOwner;
    }

    receive() external payable {}

    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Admin: no balance to withdraw");
        payable(owner).transfer(balance);
    }
}
