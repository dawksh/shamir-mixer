// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SMixer {
    error InvalidValueSize();

    event Deposit(address depositer, uint256 value);

    mapping(bytes32 => uint256) internal withdrawHashMapping;

    modifier checkSendSize() {
        if (
            msg.value != 0.01 ether ||
            msg.value != 0.1 ether ||
            msg.value != 1 ether
        ) revert InvalidValueSize();
        _;
    }

    function deposit(bytes32 _hash) external payable checkSendSize {
        withdrawHashMapping[_hash] = msg.value;
        emit Deposit(msg.sender, msg.value);
    }
}
