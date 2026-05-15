// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IBank.sol";

contract Bank is IBank {
    address public admin;

    mapping(address => uint256) public balances;
    address[3] public topDepositors;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed admin, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Bank: caller is not the admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    receive() external payable virtual {
        _deposit(msg.sender, msg.value);
    }

    function deposit() external payable virtual {
        _deposit(msg.sender, msg.value);
    }

    function _deposit(address user, uint256 amount) internal virtual {
        require(amount > 0, "Bank: amount must be greater than zero");
        balances[user] += amount;
        _updateTopDepositors(user);
        emit Deposited(user, amount);
    }

    function withdraw(uint256 amount) external virtual onlyAdmin {
        require(amount > 0, "Bank: amount must be greater than zero");
        require(address(this).balance >= amount, "Bank: insufficient contract balance");
        payable(admin).transfer(amount);
        emit Withdrawn(admin, amount);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getTopDepositors() external view returns (address[3] memory) {
        return topDepositors;
    }

    function _setAdmin(address newAdmin) internal {
        admin = newAdmin;
    }

    function _updateTopDepositors(address user) private {
        uint256 userBalance = balances[user];

        int256 found = -1;
        for (uint256 i = 0; i < 3; i++) {
            if (topDepositors[i] == user) {
                found = int256(i);
                break;
            }
        }

        address[4] memory candidates;
        uint256[4] memory candidateBals;
        uint256 count;

        for (uint256 i = 0; i < 3; i++) {
            address addr = topDepositors[i];
            if (addr == address(0)) break;
            if (found >= 0 && addr == user) continue;
            candidates[count]   = addr;
            candidateBals[count] = balances[addr];
            count++;
        }

        candidates[count]   = user;
        candidateBals[count] = userBalance;
        count++;

        for (uint256 i = 0; i < count; i++) {
            for (uint256 j = 0; j < count - 1 - i; j++) {
                if (candidateBals[j] < candidateBals[j + 1]) {
                    (candidateBals[j], candidateBals[j + 1]) = (candidateBals[j + 1], candidateBals[j]);
                    (candidates[j], candidates[j + 1])       = (candidates[j + 1], candidates[j]);
                }
            }
        }

        for (uint256 i = 0; i < 3; i++) {
            topDepositors[i] = i < count ? candidates[i] : address(0);
        }
    }
}
