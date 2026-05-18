// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";

import {GovernanceToken} from "../src/token/GovernanceToken.sol";
import {SuperAMM} from "../src/amm/SuperAMM.sol";
import {LendingPool} from "../src/lending/LendingPool.sol";
import {YieldVault} from "../src/vault/YieldVault.sol";
import {ProtocolBadge} from "../src/nft/ProtocolBadge.sol";
import {PoolFactory} from "../src/factory/PoolFactory.sol";
import {Treasury} from "../src/governance/Treasury.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        GovernanceToken tokenA = new GovernanceToken();
        GovernanceToken tokenB = new GovernanceToken();

        new SuperAMM(address(tokenA), address(tokenB));
        new LendingPool(address(tokenA), address(tokenB));
        new YieldVault(tokenA);
        new ProtocolBadge();
        new PoolFactory();
        new Treasury();

        vm.stopBroadcast();
    }
}
