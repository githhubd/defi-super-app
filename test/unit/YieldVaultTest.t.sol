// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {YieldVault} from "../../src/vault/YieldVault.sol";

contract YieldVaultTest is Test {

    GovernanceToken token;
    YieldVault vault;

    address user = address(1);

    function setUp() public {

        token = new GovernanceToken();

        vault = new YieldVault(token);

        token.transfer(user, 10_000 ether);
    }

    function testDeposit() public {

        vm.startPrank(user);

        token.approve(address(vault), 1000 ether);

        vault.deposit(
            1000 ether,
            user
        );

        vm.stopPrank();

        assertEq(
            vault.totalAssets(),
            1000 ether
        );
    }

    function testWithdraw() public {

        vm.startPrank(user);

        token.approve(address(vault), 1000 ether);

        vault.deposit(
            1000 ether,
            user
        );

        vault.withdraw(
            500 ether,
            user,
            user
        );

        vm.stopPrank();

        assertEq(
            vault.totalAssets(),
            500 ether
        );
    }
}