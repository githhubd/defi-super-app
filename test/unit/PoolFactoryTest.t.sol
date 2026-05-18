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
}
