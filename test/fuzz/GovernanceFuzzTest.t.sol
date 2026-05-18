// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {GovernanceToken} from "../../src/token/GovernanceToken.sol";

contract GovernanceFuzzTest is Test {
    GovernanceToken token;

    address user = address(1);

    function setUp() public {
        token = new GovernanceToken();
        token.transfer(user, 100_000 ether);
    }

    function testFuzzVotingPower(uint256 amount) public {
        amount = bound(amount, 1 ether, 10_000 ether);

        vm.startPrank(user);
        token.delegate(user);
        vm.roll(block.number + 1);
        vm.stopPrank();

        assertGt(token.getVotes(user), 0);
    }

    function testFuzzTransferVotingToken(uint256 amount) public {
        amount = bound(amount, 1 ether, 1000 ether);

        vm.prank(user);
        token.transfer(address(2), amount);

        assertEq(token.balanceOf(address(2)), amount);
    }
    function testFuzzDelegateVotingPower(uint256 amount) public {
    amount = bound(amount, 1 ether, 10_000 ether);

    vm.prank(user);
    token.delegate(user);

    vm.roll(block.number + 1);

    assertGe(token.getVotes(user), amount);
}

function testFuzzTransferDoesNotChangeTotalSupply(uint256 amount) public {
    amount = bound(amount, 1 ether, 1000 ether);

    uint256 supplyBefore = token.totalSupply();

    vm.prank(user);
    token.transfer(address(3), amount);

    assertEq(token.totalSupply(), supplyBefore);
}
}
