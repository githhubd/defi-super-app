// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {SuperAMM} from "../amm/SuperAMM.sol";

contract PoolFactory {
    event PoolCreated(address indexed pool, address indexed tokenA, address indexed tokenB, bytes32 salt);

    address[] public allPools;

    function createPool(address tokenA, address tokenB) external returns (address pool) {
        pool = address(new SuperAMM(tokenA, tokenB));
        allPools.push(pool);

        emit PoolCreated(pool, tokenA, tokenB, bytes32(0));
    }

    function createPoolDeterministic(
        address tokenA,
        address tokenB,
        bytes32 salt
    ) external returns (address pool) {
        pool = address(new SuperAMM{salt: salt}(tokenA, tokenB));
        allPools.push(pool);

        emit PoolCreated(pool, tokenA, tokenB, salt);
    }

    function getPoolCount() external view returns (uint256) {
        return allPools.length;
    }

    function predictPoolAddress(
        address tokenA,
        address tokenB,
        bytes32 salt
    ) external view returns (address predicted) {
        bytes memory bytecode = abi.encodePacked(
            type(SuperAMM).creationCode,
            abi.encode(tokenA, tokenB)
        );

        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(bytecode)
            )
        );

        predicted = address(uint160(uint256(hash)));
    }
}