// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Interface for verifying zero-knowledge proofs
interface IZethereumVerifier {
    /// @notice Verify a zero-knowledge proof for shielded transfer
    function verifyTransferProof(
        bytes calldata proof,
        bytes32 commitment
    ) external view returns (bool);

    /// @notice Verify a zero-knowledge proof for spending a note
    function verifySpendProof(
        bytes calldata proof,
        bytes32 nullifier,
        address recipient
    ) external view returns (bool);
}