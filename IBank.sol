// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IBank {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
    function getContractBalance() external view returns (uint256);
    function getTopDepositors() external view returns (address[3] memory);
    function balances(address account) external view returns (uint256);
}
