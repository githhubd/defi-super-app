// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract ChainlinkOracle {
    AggregatorV3Interface public immutable PRICE_FEED;
    uint256 public immutable STALE_TIME;

    error StalePrice();
    error InvalidPrice();

    constructor(address priceFeed, uint256 staleTime) {
        require(priceFeed != address(0), "priceFeed = 0");
        PRICE_FEED = AggregatorV3Interface(priceFeed);
        STALE_TIME = staleTime;
    }

    function getPrice() external view returns (uint256) {
        (, int256 price,, uint256 updatedAt,) = PRICE_FEED.latestRoundData();

        if (price <= 0) revert InvalidPrice();
        if (block.timestamp - updatedAt > STALE_TIME) revert StalePrice();

        return uint256(price);
    }
}
