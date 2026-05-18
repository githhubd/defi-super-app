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
}
