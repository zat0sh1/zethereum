// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IZethereumCore
 * @dev Core interface for Zethereum privacy features
 */
interface IZethereumCore {
    /**
     * @dev Emitted when a new shielded transfer is initiated
     */
    event ShieldedTransfer(
        bytes32 indexed nullifier,
        bytes32 indexed commitment,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a note is spent
     */
    event NoteSpent(bytes32 indexed nullifier);

    /**
     * @dev Initialize the contract
     * @param verifier Address of the ZK proof verifier contract
     */
    function initialize(address verifier) external;

    /**
     * @dev Create a new shielded transfer
     * @param commitment The commitment to the new note
     * @param proof The zero-knowledge proof
     */
    function createShieldedTransfer(
        bytes32 commitment,
        bytes calldata proof
    ) external payable;

    /**
     * @dev Spend a note
     * @param nullifier The nullifier of the note being spent
     * @param recipient The recipient's address
     * @param proof The zero-knowledge proof
     */
    function spendNote(
        bytes32 nullifier,
        address recipient,
        bytes calldata proof
    ) external;

    /**
     * @dev Check if a nullifier has been spent
     * @param nullifier The nullifier to check
     * @return True if the nullifier has been spent
     */
    function isSpent(bytes32 nullifier) external view returns (bool);
}