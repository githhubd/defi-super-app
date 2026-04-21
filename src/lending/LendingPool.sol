// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract LendingPool is ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable collateralToken;
    IERC20 public immutable borrowToken;

    uint256 public constant LTV = 50;
    uint256 public constant LIQUIDATION_THRESHOLD = 75;

    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt;

    constructor(address _collateralToken, address _borrowToken) {
        collateralToken = IERC20(_collateralToken);
        borrowToken = IERC20(_borrowToken);
    }

    function depositCollateral(uint256 amount) external nonReentrant {
        require(amount > 0, "amount = 0");

        collateralToken.safeTransferFrom(msg.sender, address(this), amount);
        collateral[msg.sender] += amount;
    }

    function borrow(uint256 amount) external nonReentrant {
        require(amount > 0, "amount = 0");

        uint256 maxBorrow = collateral[msg.sender] * LTV / 100;
        require(debt[msg.sender] + amount <= maxBorrow, "LTV exceeded");

        debt[msg.sender] += amount;
        borrowToken.safeTransfer(msg.sender, amount);
    }

    function repay(uint256 amount) external nonReentrant {
        require(amount > 0, "amount = 0");

        borrowToken.safeTransferFrom(msg.sender, address(this), amount);

        if (amount >= debt[msg.sender]) {
            debt[msg.sender] = 0;
        } else {
            debt[msg.sender] -= amount;
        }
    }

    function healthFactor(address user) public view returns (uint256) {
        if (debt[user] == 0) {
            return type(uint256).max;
        }

        return collateral[user] * LIQUIDATION_THRESHOLD / debt[user];
    }

    function liquidate(address user) external nonReentrant {
        require(healthFactor(user) < 100, "healthy");

        uint256 userDebt = debt[user];
        uint256 userCollateral = collateral[user];

        debt[user] = 0;
        collateral[user] = 0;

        borrowToken.safeTransferFrom(msg.sender, address(this), userDebt);
        collateralToken.safeTransfer(msg.sender, userCollateral);
    }
}