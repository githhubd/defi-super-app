// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AssemblyMath {

    function addSolidity(
        uint256 a,
        uint256 b
    ) external pure returns (uint256) {

        return a + b;
    }

    function addAssembly(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {

        assembly {
            result := add(a, b)
        }
    }

    function multiplySolidity(
        uint256 a,
        uint256 b
    ) external pure returns (uint256) {

        return a * b;
    }

    function multiplyAssembly(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {

        assembly {
            result := mul(a, b)
        }
    }
}