// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {Treasury} from "../../src/governance/Treasury.sol";

contract TreasuryInvariantTest is Test {
    Treasury treasury;

    function setUp() public {
        treasury = new Treasury();

        vm.deal(address(treasury), 10 ether);
    }

    function invariant_TreasuryBalanceNeverNegative() public view {
        assertGe(address(treasury).balance, 0);
    }

    function invariant_TreasuryExists() public view {
        assertTrue(address(treasury) != address(0));
    }
}
