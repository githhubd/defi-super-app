// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Treasury {

    receive() external payable {}

    function withdraw(
        address payable to,
        uint256 amount
    ) external {

        require(
            address(this).balance >= amount,
            "Insufficient balance"
        );

        (bool success,) = to.call{value: amount}("");

        require(success, "Transfer failed");
    }
}