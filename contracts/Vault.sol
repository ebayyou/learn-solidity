// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "../lib/@openzeppelin/contract/token/ERC20/ERC20.sol";
import {IERC20} from "../lib/@openzeppelin/contract/token/ERC20/ERC20.sol";

contract Vault is ERC20 {

    address public usdc;

    constructor(address _usdc) ERC20("Vault", "VAULT") {
        usdc = _usdc;
    }

    function deposit(uint256 amount) external {
        if (IERC20(usdc).balanceOf(msg.sender) < amount) {
            revert InsufficientBalance();
        }

        // require(IERC20(usdc).balanceOf(msg.sender) == amount, "Transfer amount exceeds allowance");

        uint256 totalAssets = IERC(usdc).balanceOf(address(this));
        uint256 totalShares= totalSupply();

        uint256 shares = 0;

        if (totalShares == 0) {
            shares = amount;
        } else {
            shares = amount * totalShares / totalAssets;
        }

        _mint(msg.sender, shares);

        IERC20(usdc).transferFrom(msg.sender, address(this), amount);

        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 shares) external {
        if (balanceOf(msg.sender) < shares) {
            revert InsufficientBalance();
        }

        uint256 totalAssets = IERC(usdc).balanceOf(address(this));
        uint256 totalShares= totalSupply();

        uint256 amount = shares * totalAssets / totalShares;

        _burn(msg.sender, shares);

        IERC20(usdc).transfer(msg.sender, amount);

        emit Deposit(msg.sender, amount);
    }

    function distributeYield(uint256 amount) external {
        if (IERC20(usdc).balanceOf(address(msg.sender)) < amount){
            revert InsufficientBalance();
        }

        IERC20(usdc).transferFrom(msg.sender, address(this), amount);

        emit DistributeYield(msg.sender, amount);
    }
}