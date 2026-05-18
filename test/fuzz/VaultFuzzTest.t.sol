// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {YieldVault} from "../../src/vault/YieldVault.sol";

contract VaultFuzzTest is Test {
    GovernanceToken token;
    YieldVault vault;

    address user = address(1);

    function setUp() public {
        token = new GovernanceToken();
        vault = new YieldVault(token);

        token.transfer(user, 100_000 ether);

        vm.prank(user);
        token.approve(address(vault), type(uint256).max);
    }

    function testFuzzDeposit(uint256 amount) public {
        amount = bound(amount, 1 ether, 10_000 ether);

        vm.prank(user);
        vault.deposit(amount, user);

        assertEq(vault.totalAssets(), amount);
        assertGt(vault.balanceOf(user), 0);
    }

    function testFuzzWithdraw(uint256 amount) public {
        amount = bound(amount, 1 ether, 10_000 ether);

        vm.startPrank(user);
        vault.deposit(amount, user);
        vault.withdraw(amount, user, user);
        vm.stopPrank();

        assertEq(vault.totalAssets(), 0);
    }
    function testFuzzMint(uint256 shares) public {
    shares = bound(shares, 1 ether, 10_000 ether);

    vm.prank(user);
    vault.mint(shares, user);

    assertEq(vault.balanceOf(user), shares);
}

function testFuzzRedeem(uint256 amount) public {
    amount = bound(amount, 1 ether, 10_000 ether);

    vm.startPrank(user);
    vault.deposit(amount, user);
    vault.redeem(amount, user, user);
    vm.stopPrank();

    assertEq(vault.balanceOf(user), 0);
}
}
