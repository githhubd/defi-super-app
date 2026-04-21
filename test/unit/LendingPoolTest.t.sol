// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {LendingPool} from "../../src/lending/LendingPool.sol";

contract LendingPoolTest is Test {

    GovernanceToken collateralToken;
    GovernanceToken borrowToken;

    LendingPool lending;

    address user = address(1);

    function setUp() public {

        collateralToken = new GovernanceToken();
        borrowToken = new GovernanceToken();

        lending = new LendingPool(
            address(collateralToken),
            address(borrowToken)
        );

        collateralToken.transfer(
            user,
            10_000 ether
        );

        borrowToken.transfer(
            address(lending),
            10_000 ether
        );
    }

    function testDepositCollateral() public {

        vm.startPrank(user);

        collateralToken.approve(
            address(lending),
            1000 ether
        );

        lending.depositCollateral(
            1000 ether
        );

        vm.stopPrank();

        assertEq(
            lending.collateral(user),
            1000 ether
        );
    }

    function testBorrow() public {

        vm.startPrank(user);

        collateralToken.approve(
            address(lending),
            1000 ether
        );

        lending.depositCollateral(
            1000 ether
        );

        lending.borrow(
            500 ether
        );

        vm.stopPrank();

        assertEq(
            lending.debt(user),
            500 ether
        );
    }

    function testRepay() public {

        vm.startPrank(user);

        collateralToken.approve(
            address(lending),
            1000 ether
        );

        lending.depositCollateral(
            1000 ether
        );

        lending.borrow(
            500 ether
        );

        borrowToken.approve(
            address(lending),
            500 ether
        );

        lending.repay(
            500 ether
        );

        vm.stopPrank();

        assertEq(
            lending.debt(user),
            0
        );
    }
}