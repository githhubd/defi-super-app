// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {GovernanceToken} from "../../src/token/GovernanceToken.sol";
import {SuperGovernor} from "../../src/governance/SuperGovernor.sol";

contract GovernorTest is Test {
    GovernanceToken token;
    SuperGovernor governor;

    function setUp() public {
        token = new GovernanceToken();

        governor = new SuperGovernor(token);

        token.delegate(address(this));
    }

    function testProposalThreshold() public {
        assertEq(governor.proposalThreshold(), 1e18);
    }

    function testVotingDelay() public {
        assertEq(governor.votingDelay(), 86400);
    }
    function testVotingPeriod() public view {
    assertEq(governor.votingPeriod(), 604800);
}


function testTokenVotingPower() public {
    vm.roll(block.number + 1);

    assertGt(token.getVotes(address(this)), 0);
}
function testGovernorName() public view {
    assertEq(governor.name(), "SuperGovernor");
}

function testGovernorVersion() public view {
    assertEq(governor.version(), "1");
}
}
