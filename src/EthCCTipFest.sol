// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract EthCCTipFest is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    address public constant ETH_ADDRESS = address(0);
    address public constant USDC_BASE = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913; 

    event TipSent(
        address indexed from,
        address indexed to,
        uint256 amount,
        address token,
        string message,
        uint256 timestamp
    );

    constructor() Ownable(msg.sender) {}

    function sendTip(
        address to,
        uint256 amount,
        address token,
        string calldata message
    ) external payable nonReentrant {
        require(to != address(0), "Invalid recipient");
        require(to != msg.sender, "Cannot tip yourself");
        require(amount > 0, "Amount must be > 0");
        require(
            token == ETH_ADDRESS || token == USDC_BASE,
            "Only ETH or USDC allowed"
        );

        if (token == ETH_ADDRESS) {
            require(msg.value == amount, "ETH value mismatch");
            (bool sent, ) = to.call{value: amount}("");
            require(sent, "ETH transfer failed");
        } else {
            require(msg.value == 0, "No ETH allowed for token tips");
            IERC20(token).safeTransferFrom(msg.sender, to, amount);
        }

        emit TipSent(msg.sender, to, amount, token, message, block.timestamp);
    }

    function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
        if (token == ETH_ADDRESS) {
            (bool sent, ) = owner().call{value: amount}("");
            require(sent, "ETH withdraw failed");
        } else {
            IERC20(token).safeTransfer(owner(), amount);
        }
    }

    receive() external payable {}
}
