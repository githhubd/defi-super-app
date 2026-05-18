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

        vault.deposit(1000 ether, user);

        vm.stopPrank();

        assertEq(vault.totalAssets(), 1000 ether);
    }

    function testWithdraw() public {
        vm.startPrank(user);

        token.approve(address(vault), 1000 ether);

        vault.deposit(1000 ether, user);

        vault.withdraw(500 ether, user, user);

        vm.stopPrank();

        assertEq(vault.totalAssets(), 500 ether);
    }

    function testPreviewDeposit() public {
        uint256 shares = vault.previewDeposit(1000 ether);

        assertEq(shares, 1000 ether);
    }

    function testPreviewWithdraw() public {
        vm.startPrank(user);

        token.approve(address(vault), 1000 ether);
        vault.deposit(1000 ether, user);

        vm.stopPrank();

        uint256 shares = vault.previewWithdraw(500 ether);

        assertEq(shares, 500 ether);
    }

    function testRedeem() public {
        vm.startPrank(user);

        token.approve(address(vault), 1000 ether);
        vault.deposit(1000 ether, user);

        vault.redeem(500 ether, user, user);

        vm.stopPrank();

        assertEq(vault.totalAssets(), 500 ether);
    }

    function testMaxDeposit() public view {
        assertEq(vault.maxDeposit(user), type(uint256).max);
    }

    function testMaxWithdrawAfterDeposit() public {
        vm.startPrank(user);

        token.approve(address(vault), 1000 ether);
        vault.deposit(1000 ether, user);

        vm.stopPrank();

        assertEq(vault.maxWithdraw(user), 1000 ether);
    }

    function testAssetAddress() public view {
        assertEq(address(vault.asset()), address(token));
    }

    function testVaultName() public view {
        assertEq(vault.name(), "DeFi Super App Vault Share");
    }

    function testVaultSymbol() public view {
        assertEq(vault.symbol(), "DSAV");
    }

    function testConvertToShares() public view {
        assertEq(vault.convertToShares(100 ether), 100 ether);
    }

    function testConvertToAssets() public view {
        assertEq(vault.convertToAssets(100 ether), 100 ether);
    }
}
