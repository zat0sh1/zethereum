// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title IZethereumVerifier
 * @dev Interface for verifying zero-knowledge proofs
 */
interface IZethereumVerifier {
    /**
     * @dev Verify a zero-knowledge proof for shielded transfer
     * @param proof The proof data
     * @param commitment The commitment to verify
     * @return True if the proof is valid
     */
    function verifyTransferProof(
        bytes calldata proof,
        bytes32 commitment
    ) external view returns (bool);

    /**
     * @dev Verify a zero-knowledge proof for spending a note
     * @param proof The proof data
     * @param nullifier The nullifier to verify
     * @param recipient The recipient's address
     * @return True if the proof is valid
     */
    function verifySpendProof(
        bytes calldata proof,
        bytes32 nullifier,
        address recipient
    ) external view returns (bool);
}