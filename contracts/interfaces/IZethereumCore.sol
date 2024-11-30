// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IZethereumCore
interface IZethereumCore {
    /// @notice Emitted when a new shielded transfer is initiated
    event ShieldedTransfer(
        bytes32 indexed nullifier,
        bytes32 indexed commitment,
        uint256 timestamp
    );

    /// @notice Emitted when a note is spent
    event NoteSpent(bytes32 indexed nullifier);

    /// @notice Initialize the contract
    function initialize(address verifier) external;

    /// @notice Create a new shielded transfer
    function createShieldedTransfer(
        bytes32 commitment,
        bytes calldata proof
    ) external payable;

    /// @notice Spend a note
    function spendNote(
        bytes32 nullifier,
        address recipient,
        bytes calldata proof
    ) external;

    /// @notice Check if a nullifier has been spent
    function isSpent(bytes32 nullifier) external view returns (bool);
}