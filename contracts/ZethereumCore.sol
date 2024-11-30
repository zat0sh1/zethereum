// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./interfaces/IZethereumCore.sol";
import "./interfaces/IZethereumVerifier.sol";
import "./access/ZethereumAccess.sol";

/**
 * @title ZethereumCore
 * @dev Implementation of the core Zethereum privacy features
 */
contract ZethereumCore is IZethereumCore, ZethereumAccess {
    // State variables
    IZethereumVerifier private _verifier;
    mapping(bytes32 => bool) private _nullifiers;

    /**
     * @dev Initialize the contract
     * @param verifier Address of the ZK proof verifier contract
     */
    function initialize(address verifier) external override initializer {
        require(verifier != address(0), "ZethereumCore: zero address");
        __ZethereumAccess_init();
        _verifier = IZethereumVerifier(verifier);
    }

    /**
     * @dev Create a new shielded transfer
     * @param commitment The commitment to the new note
     * @param proof The zero-knowledge proof
     */
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

    /**
     * @dev Check if a nullifier has been spent
     * @param nullifier The nullifier to check
     * @return True if the nullifier has been spent
     */
    function isSpent(bytes32 nullifier) external view override returns (bool) {
        return _nullifiers[nullifier];
    }
}