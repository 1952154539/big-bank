// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Bank.sol";

contract BigBank is Bank {
    modifier minimumDeposit() {
        require(msg.value > 0.001 ether, "BigBank: deposit must exceed 0.001 ether");
        _;
    }

    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    function deposit() external payable override minimumDeposit {
        super.deposit();
    }

    receive() external payable override minimumDeposit {
        _deposit(msg.sender, msg.value);
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "BigBank: invalid admin address");
        emit AdminTransferred(admin, newAdmin);
        _setAdmin(newAdmin);
    }

    function getMinDeposit() external pure returns (uint256) {
        return 0.001 ether;
    }
}
