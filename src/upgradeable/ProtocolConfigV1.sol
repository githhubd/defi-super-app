// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract ProtocolConfigV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public protocolFee;

    function initialize(uint256 _protocolFee) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        protocolFee = _protocolFee;
    }

    function setProtocolFee(uint256 _protocolFee) external onlyOwner {
        require(_protocolFee <= 1000, "fee too high");
        protocolFee = _protocolFee;
    }

    function version() external pure returns (string memory) {
        return "V1";
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}