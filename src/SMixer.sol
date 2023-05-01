// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SMixer {
    error InvalidValueSize();
    error InvalidSecret();
    error TransferFailed();

    event Deposit(address depositer, uint256 value);

    mapping(bytes32 => uint256) internal withdrawHashMapping;

    struct Secrets {
        uint256 x;
        uint256 y;
    }

    modifier checkSendSize() {
        if (
            msg.value != 0.01 ether &&
            msg.value != 0.1 ether &&
            msg.value != 1 ether
        ) revert InvalidValueSize();
        _;
    }

    function deposit(bytes32 _hash) external payable checkSendSize {
        withdrawHashMapping[_hash] = msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(Secrets[2] calldata secrets) external {
        uint256 secretKey = _recoverSecret(secrets);
        bytes32 _hash = keccak256(abi.encodePacked(msg.sender, secretKey));
        uint256 amount = withdrawHashMapping[_hash];
        if (amount == 0) revert InvalidSecret();
        (bool s, ) = address(msg.sender).call{value: amount}("");
        if (!s) revert TransferFailed();
    }

    function _recoverSecret(
        Secrets[2] calldata _secrets
    ) internal pure returns (uint256 secret) {
        int256 l0 = int(_secrets[0].y * _secrets[1].x) /
            int(_secrets[1].x - _secrets[0].x);
        int256 l1 = int(_secrets[1].y * _secrets[0].x) /
            int(_secrets[0].x - _secrets[1].x);

        return uint256(l0 + l1);
    }
}
