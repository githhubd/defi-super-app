// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {ProtocolConfigV1} from "../../src/upgradeable/ProtocolConfigV1.sol";
import {ProtocolConfigV2} from "../../src/upgradeable/ProtocolConfigV2.sol";

contract ProtocolConfigUpgradeTest is Test {
    ProtocolConfigV1 implementationV1;
    ProtocolConfigV2 implementationV2;
    ProtocolConfigV1 proxyV1;
    ProtocolConfigV2 proxyV2;

    function setUp() public {
        implementationV1 = new ProtocolConfigV1();

        bytes memory initData = abi.encodeWithSelector(ProtocolConfigV1.initialize.selector, 30);

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementationV1), initData);

        proxyV1 = ProtocolConfigV1(address(proxy));
    }

    function testInitialVersionAndFee() public view {
        assertEq(proxyV1.version(), "V1");
        assertEq(proxyV1.protocolFee(), 30);
    }

    function testUpgradeToV2() public {
        implementationV2 = new ProtocolConfigV2();

        proxyV1.upgradeToAndCall(address(implementationV2), "");

        proxyV2 = ProtocolConfigV2(address(proxyV1));

        assertEq(proxyV2.version(), "V2");

        proxyV2.setMaxLtv(75);

        assertEq(proxyV2.maxLtv(), 75);
        assertEq(proxyV2.protocolFee(), 30);
    }

    function testSetProtocolFee() public {
        proxyV1.setProtocolFee(100);

        assertEq(proxyV1.protocolFee(), 100);
    }

    function testRevertIfProtocolFeeTooHigh() public {
        vm.expectRevert("fee too high");
        proxyV1.setProtocolFee(1001);
    }

    function testOnlyOwnerCanSetProtocolFee() public {
        vm.prank(address(1));

        vm.expectRevert();
        proxyV1.setProtocolFee(100);
    }

    function testOwnerIsThisContract() public view {
        assertEq(proxyV1.owner(), address(this));
    }

    function testProtocolConfigAddressIsNotZero() public view {
        assertTrue(address(proxyV1) != address(0));
    }
}
