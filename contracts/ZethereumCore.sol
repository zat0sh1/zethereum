// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IZethereumCore.sol";
import "./interfaces/IZethereumVerifier.sol";
import "./access/ZethereumAccess.sol";

/// @title Implementation of Zethereum privacy features
contract ZethereumCore is IZethereumCore, ZethereumAccess {
    // State variables
    IZethereumVerifier private _verifier;
    mapping(bytes32 => bool) private _nullifiers;

    /// @notice Initialize the contract
    function initialize(address verifier) external override initializer {
        require(verifier != address(0), "ZethereumCore: zero address");
        __ZethereumAccess_init();
        _verifier = IZethereumVerifier(verifier);
    }

    /// @notice Create a new shielded transfer
    function createShieldedTransfer(
        bytes32 commitment,
        bytes calldata proof
    ) external payable override {
        require(msg.value > 0, "ZethereumCore: zero value");
        require(
            _verifier.verifyTransferProof(proof, commitment),
            "ZethereumCore: invalid proof"
        );

        emit ShieldedTransfer(bytes32(0), commitment, block.timestamp);
    }

    /// @notice Spend a note
    function spendNote(
        bytes32 nullifier,
        address recipient,
        bytes calldata proof
    ) external override {
        require(!_nullifiers[nullifier], "ZethereumCore: note already spent");
        require(recipient != address(0), "ZethereumCore: zero address");
        require(
            _verifier.verifySpendProof(proof, nullifier, recipient),
            "ZethereumCore: invalid proof"
        );

        _nullifiers[nullifier] = true;
        emit NoteSpent(nullifier);

        // Transfer funds to recipient
        (bool success, ) = recipient.call{value: 1 ether}("");
        require(success, "ZethereumCore: transfer failed");
    }

    /// @notice Check if a nullifier has been spent
    function isSpent(bytes32 nullifier) external view override returns (bool) {
        return _nullifiers[nullifier];
    }
}