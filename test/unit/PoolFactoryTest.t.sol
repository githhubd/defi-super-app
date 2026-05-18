// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {PoolFactory} from "../../src/factory/PoolFactory.sol";

contract PoolFactoryTest is Test {
    GovernanceToken tokenA;
    GovernanceToken tokenB;
    PoolFactory factory;

    function setUp() public {
        tokenA = new GovernanceToken();
        tokenB = new GovernanceToken();
        factory = new PoolFactory();
    }

    function testCreatePool() public {
        address pool = factory.createPool(address(tokenA), address(tokenB));

        assertTrue(pool != address(0));
        assertEq(factory.getPoolCount(), 1);
    }

    function testCreatePoolDeterministic() public {
        bytes32 salt = keccak256("POOL_1");

        address predicted = factory.predictPoolAddress(address(tokenA), address(tokenB), salt);

        address pool = factory.createPoolDeterministic(address(tokenA), address(tokenB), salt);

        assertEq(pool, predicted);
        assertEq(factory.getPoolCount(), 1);
    }
    function testPoolCountStartsAtZero() public view {
    assertEq(factory.getPoolCount(), 0);
}

function testCreateTwoPools() public {
    factory.createPool(address(tokenA), address(tokenB));
    factory.createPool(address(tokenB), address(tokenA));

    assertEq(factory.getPoolCount(), 2);
}

function testPredictAddressIsNotZero() public view {
    bytes32 salt = keccak256("POOL_TEST");

    address predicted = factory.predictPoolAddress(
        address(tokenA),
        address(tokenB),
        salt
    );

    assertTrue(predicted != address(0));
}
function testFactoryAddressIsNotZero() public view {
    assertTrue(address(factory) != address(0));
}

function testCreatedPoolIsNotFactory() public {
    address pool = factory.createPool(address(tokenA), address(tokenB));

    assertTrue(pool != address(factory));
}
}
