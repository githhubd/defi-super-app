// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {ProtocolBadge} from "../../src/nft/ProtocolBadge.sol";

contract ProtocolBadgeTest is Test {
    ProtocolBadge badge;

    address user = address(1);

    function setUp() public {
        badge = new ProtocolBadge();
    }

    function testMintBadge() public {
        badge.mint(user, 1, 1);

        assertEq(badge.balanceOf(user, 1), 1);
    }

    function testBurnBadge() public {
        badge.mint(user, 1, 1);

        badge.burn(user, 1, 1);

        assertEq(badge.balanceOf(user, 1), 0);
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(user);

        vm.expectRevert();

        badge.mint(user, 1, 1);
    }

    function testOnlyOwnerCanBurn() public {
        badge.mint(user, 1, 1);

        vm.prank(user);

        vm.expectRevert();

        badge.burn(user, 1, 1);
    }

    function testUriIsCorrect() public view {
        assertEq(badge.uri(1), "https://defi-super-app.xyz/api/{id}.json");
    }
}
