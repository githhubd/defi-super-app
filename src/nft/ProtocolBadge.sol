// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ProtocolBadge is ERC1155, Ownable {

    uint256 public constant LP_BADGE = 1;
    uint256 public constant GOVERNANCE_BADGE = 2;

    constructor() ERC1155("https://defi-super-app.xyz/api/{id}.json")
        Ownable(msg.sender)
    {}

    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) external onlyOwner {

        _mint(to, id, amount, "");
    }

    function burn(
        address from,
        uint256 id,
        uint256 amount
    ) external onlyOwner {

        _burn(from, id, amount);
    }
}