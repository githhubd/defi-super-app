// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SuperAMM is ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable tokenA;
    IERC20 public immutable tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 public constant FEE = 3;

    event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB);

    event Swapped(address indexed user, uint256 amountIn, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        require(amountA > 0, "amountA = 0");
        require(amountB > 0, "amountB = 0");

        tokenA.safeTransferFrom(msg.sender, address(this), amountA);
        tokenB.safeTransferFrom(msg.sender, address(this), amountB);

        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    function swapAForB(uint256 amountIn, uint256 minAmountOut) external nonReentrant {
        require(amountIn > 0, "amountIn = 0");
        require(reserveA > 0 && reserveB > 0, "No liquidity");

        uint256 amountInWithFee = amountIn * (1000 - FEE) / 1000;

        uint256 amountOut = (reserveB * amountInWithFee) / (reserveA + amountInWithFee);

        require(amountOut >= minAmountOut, "Slippage");

        tokenA.safeTransferFrom(msg.sender, address(this), amountIn);

        tokenB.safeTransfer(msg.sender, amountOut);

        reserveA += amountIn;
        reserveB -= amountOut;

        emit Swapped(msg.sender, amountIn, amountOut);
    }
}
