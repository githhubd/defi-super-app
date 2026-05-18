// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {SuperAMM} from "../../src/amm/SuperAMM.sol";

contract AMMInvariantTest is Test {
    GovernanceToken tokenA;
    GovernanceToken tokenB;
    SuperAMM amm;

    address user = address(1);

    function setUp() public {
        tokenA = new GovernanceToken();
        tokenB = new GovernanceToken();

        amm = new SuperAMM(address(tokenA), address(tokenB));

        tokenA.transfer(user, 1_000_000 ether);
        tokenB.transfer(user, 1_000_000 ether);

        vm.startPrank(user);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);

        amm.addLiquidity(100_000 ether, 100_000 ether);
        vm.stopPrank();

        targetContract(address(amm));
    }

    function invariant_ReservesAreNeverZero() public view {
        assertGt(amm.reserveA(), 0);
        assertGt(amm.reserveB(), 0);
    }

    function invariant_AMMKIsPositive() public view {
        uint256 k = amm.reserveA() * amm.reserveB();
        assertGt(k, 0);
    }

    function invariant_TokenBalancesMatchReserves() public view {
        assertEq(tokenA.balanceOf(address(amm)), amm.reserveA());
        assertEq(tokenB.balanceOf(address(amm)), amm.reserveB());
    }
}
