// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ChainlinkOracle} from "../../src/oracle/ChainlinkOracle.sol";

contract MockAggregator {
    int256 private price;
    uint256 private updatedAt;

    function setPrice(int256 _price) external {
        price = _price;
        updatedAt = block.timestamp;
    }

    function setStalePrice(int256 _price, uint256 _updatedAt) external {
        price = _price;
        updatedAt = _updatedAt;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (1, price, 1, updatedAt, 1);
    }
}

contract ChainlinkOracleTest is Test {
    MockAggregator mockFeed;
    ChainlinkOracle oracle;

    function setUp() public {
        mockFeed = new MockAggregator();
        mockFeed.setPrice(2000e8);

        oracle = new ChainlinkOracle(address(mockFeed), 1 hours);
    }

    function testGetPrice() public view {
        assertEq(oracle.getPrice(), 2000e8);
    }

    function testRevertIfPriceIsStale() public {
    vm.warp(10 hours);

    mockFeed.setStalePrice(2000e8, block.timestamp - 2 hours);

    vm.expectRevert(ChainlinkOracle.StalePrice.selector);
    oracle.getPrice();
}

    function testRevertIfPriceIsInvalid() public {
        mockFeed.setPrice(0);

        vm.expectRevert(ChainlinkOracle.InvalidPrice.selector);
        oracle.getPrice();
    }
}