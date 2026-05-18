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
function testRevertAddLiquidityAmountAZero() public {
    vm.startPrank(user);
    tokenA.approve(address(amm), 1000 ether);
    tokenB.approve(address(amm), 1000 ether);

    vm.expectRevert("amountA = 0");
    amm.addLiquidity(0, 1000 ether);

    vm.stopPrank();
}

function testRevertAddLiquidityAmountBZero() public {
    vm.startPrank(user);
    tokenA.approve(address(amm), 1000 ether);
    tokenB.approve(address(amm), 1000 ether);

    vm.expectRevert("amountB = 0");
    amm.addLiquidity(1000 ether, 0);

    vm.stopPrank();
}

function testRevertSwapAmountInZero() public {
    vm.startPrank(user);
    tokenA.approve(address(amm), 1000 ether);
    tokenB.approve(address(amm), 1000 ether);
    amm.addLiquidity(1000 ether, 1000 ether);

    vm.expectRevert("amountIn = 0");
    amm.swapAForB(0, 1 ether);

    vm.stopPrank();
}

function testRevertSwapNoLiquidity() public {
    vm.startPrank(user);
    tokenA.approve(address(amm), 1000 ether);

    vm.expectRevert("No liquidity");
    amm.swapAForB(100 ether, 1 ether);

    vm.stopPrank();
}

function testRevertSwapSlippage() public {
    vm.startPrank(user);
    tokenA.approve(address(amm), 2000 ether);
    tokenB.approve(address(amm), 2000 ether);

    amm.addLiquidity(1000 ether, 1000 ether);

    vm.expectRevert("Slippage");
    amm.swapAForB(100 ether, 999 ether);

    vm.stopPrank();
}