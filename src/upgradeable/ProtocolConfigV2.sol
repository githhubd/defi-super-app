// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ProtocolConfigV1} from "./ProtocolConfigV1.sol";

contract ProtocolConfigV2 is ProtocolConfigV1 {
    uint256 public maxLtv;

    function setMaxLtv(uint256 _maxLtv) external onlyOwner {
        require(_maxLtv <= 90, "ltv too high");
        maxLtv = _maxLtv;
    }

    function version() external pure override returns (string memory) {
        return "V2";
    }
}
