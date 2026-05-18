// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract ChainlinkForkTest is Test {
    string MAINNET_RPC_URL;

    AggregatorV3Interface ethUsdFeed;

    function setUp() public {
        MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

        vm.createSelectFork(MAINNET_RPC_URL);

        ethUsdFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
    }

    function testForkReadsChainlinkPrice() public view {
        (, int256 price,,,) = ethUsdFeed.latestRoundData();

        assertGt(price, 0);
    }

    function testForkReadsChainlinkDecimals() public view {
        uint8 decimals = ethUsdFeed.decimals();

        assertEq(decimals, 8);
    }

    function testForkReadsChainlinkDescription() public view {
        string memory description = ethUsdFeed.description();

        assertEq(description, "ETH / USD");
    }
}