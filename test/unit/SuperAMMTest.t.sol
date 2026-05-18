// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {SuperAMM} from "../../src/amm/SuperAMM.sol";

contract SuperAMMTest is Test {
    GovernanceToken tokenA;
    GovernanceToken tokenB;

    SuperAMM amm;

    address user = address(1);

    function setUp() public {
        tokenA = new GovernanceToken();
        tokenB = new GovernanceToken();

        amm = new SuperAMM(address(tokenA), address(tokenB));

        tokenA.transfer(user, 10_000 ether);
        tokenB.transfer(user, 10_000 ether);
    }

    function testAddLiquidity() public {
        vm.startPrank(user);

        tokenA.approve(address(amm), 1000 ether);
        tokenB.approve(address(amm), 1000 ether);

        amm.addLiquidity(1000 ether, 1000 ether);

        vm.stopPrank();

        assertEq(amm.reserveA(), 1000 ether);

        assertEq(amm.reserveB(), 1000 ether);
    }

    function testSwapAForB() public {
        vm.startPrank(user);

        tokenA.approve(address(amm), 2000 ether);
        tokenB.approve(address(amm), 2000 ether);

        amm.addLiquidity(1000 ether, 1000 ether);

        amm.swapAForB(100 ether, 1 ether);

        vm.stopPrank();

        assertGt(amm.reserveA(), 1000 ether);
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

    function testInitialReservesAreZero() public view {
        assertEq(amm.reserveA(), 0);
        assertEq(amm.reserveB(), 0);
    }

    function testTokenAAddress() public view {
        assertEq(address(amm.tokenA()), address(tokenA));
    }

    function testTokenBAddress() public view {
        assertEq(address(amm.tokenB()), address(tokenB));
    }

    function testFeeIsThree() public view {
        assertEq(amm.FEE(), 3);
    }

    function testAddLiquidityTwice() public {
        vm.startPrank(user);

        tokenA.approve(address(amm), 2000 ether);
        tokenB.approve(address(amm), 2000 ether);

        amm.addLiquidity(1000 ether, 1000 ether);
        amm.addLiquidity(500 ether, 500 ether);

        vm.stopPrank();

        assertEq(amm.reserveA(), 1500 ether);
        assertEq(amm.reserveB(), 1500 ether);
    }
}
