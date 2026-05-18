// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {SuperAMM} from "../../src/amm/SuperAMM.sol";

contract AMMFuzzTest is Test {
    GovernanceToken tokenA;
    GovernanceToken tokenB;
    SuperAMM amm;

    address user = address(1);

    function setUp() public {
        tokenA = new GovernanceToken();
        tokenB = new GovernanceToken();

        amm = new SuperAMM(address(tokenA), address(tokenB));

        tokenA.transfer(user, 100_000 ether);
        tokenB.transfer(user, 100_000 ether);

        vm.startPrank(user);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        amm.addLiquidity(50_000 ether, 50_000 ether);
        vm.stopPrank();
    }

    function testFuzzSwapAForB(uint256 amountIn) public {
        amountIn = bound(amountIn, 1 ether, 1000 ether);

        vm.prank(user);
        amm.swapAForB(amountIn, 1);

        assertGt(amm.reserveA(), 50_000 ether);
        assertLt(amm.reserveB(), 50_000 ether);
    }

    function testFuzzAddLiquidity(uint256 amountA, uint256 amountB) public {
        amountA = bound(amountA, 1 ether, 1000 ether);
        amountB = bound(amountB, 1 ether, 1000 ether);

        vm.prank(user);
        amm.addLiquidity(amountA, amountB);

        assertGe(amm.reserveA(), 50_000 ether + amountA);
        assertGe(amm.reserveB(), 50_000 ether + amountB);
    }
    function testFuzzSwapKeepsReservesPositive(uint256 amountIn) public {
    amountIn = bound(amountIn, 1 ether, 1000 ether);

    vm.prank(user);
    amm.swapAForB(amountIn, 1);

    assertGt(amm.reserveA(), 0);
    assertGt(amm.reserveB(), 0);
}

function testFuzzSwapOutputChangesReserve(uint256 amountIn) public {
    amountIn = bound(amountIn, 1 ether, 500 ether);

    uint256 reserveBBefore = amm.reserveB();

    vm.prank(user);
    amm.swapAForB(amountIn, 1);

    assertLt(amm.reserveB(), reserveBBefore);
}
}
