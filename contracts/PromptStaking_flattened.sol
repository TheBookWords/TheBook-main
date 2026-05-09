// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

pragma solidity >=0.4.16;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/interfaces/IERC20.sol


// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC20.sol)

pragma solidity >=0.4.16;


// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts (last updated v5.4.0) (utils/introspection/IERC165.sol)

pragma solidity >=0.4.16;

/**
 * @dev Interface of the ERC-165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[ERC].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[ERC section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/interfaces/IERC165.sol


// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC165.sol)

pragma solidity >=0.4.16;


// File: @openzeppelin/contracts/interfaces/IERC1363.sol


// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC1363.sol)

pragma solidity >=0.6.2;



/**
 * @title IERC1363
 * @dev Interface of the ERC-1363 standard as defined in the https://eips.ethereum.org/EIPS/eip-1363[ERC-1363].
 *
 * Defines an extension interface for ERC-20 tokens that supports executing code on a recipient contract
 * after `transfer` or `transferFrom`, or code on a spender contract after `approve`, in a single transaction.
 */
interface IERC1363 is IERC20, IERC165 {
    /*
     * Note: the ERC-165 identifier for this interface is 0xb0202a11.
     * 0xb0202a11 ===
     *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
     *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
     */

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @param data Additional data with no specified format, sent in call to `spender`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol


// OpenZeppelin Contracts (last updated v5.5.0) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.20;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC-20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    /**
     * @dev An operation with an ERC-20 token failed.
     */
    error SafeERC20FailedOperation(address token);

    /**
     * @dev Indicates a failed `decreaseAllowance` request.
     */
    error SafeERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        if (!_safeTransfer(token, to, value, true)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        if (!_safeTransferFrom(token, from, to, value, true)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Variant of {safeTransfer} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransfer(IERC20 token, address to, uint256 value) internal returns (bool) {
        return _safeTransfer(token, to, value, false);
    }

    /**
     * @dev Variant of {safeTransferFrom} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransferFrom(IERC20 token, address from, address to, uint256 value) internal returns (bool) {
        return _safeTransferFrom(token, from, to, value, false);
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     *
     * IMPORTANT: If the token implements ERC-7674 (ERC-20 with temporary allowance), and if the "client"
     * smart contract uses ERC-7674 to set temporary allowances, then the "client" smart contract should avoid using
     * this function. Performing a {safeIncreaseAllowance} or {safeDecreaseAllowance} operation on a token contract
     * that has a non-zero temporary allowance (for that particular owner-spender) will result in unexpected behavior.
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        forceApprove(token, spender, oldAllowance + value);
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `requestedDecrease`. If `token` returns no
     * value, non-reverting calls are assumed to be successful.
     *
     * IMPORTANT: If the token implements ERC-7674 (ERC-20 with temporary allowance), and if the "client"
     * smart contract uses ERC-7674 to set temporary allowances, then the "client" smart contract should avoid using
     * this function. Performing a {safeIncreaseAllowance} or {safeDecreaseAllowance} operation on a token contract
     * that has a non-zero temporary allowance (for that particular owner-spender) will result in unexpected behavior.
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 requestedDecrease) internal {
        unchecked {
            uint256 currentAllowance = token.allowance(address(this), spender);
            if (currentAllowance < requestedDecrease) {
                revert SafeERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
            }
            forceApprove(token, spender, currentAllowance - requestedDecrease);
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     *
     * NOTE: If the token implements ERC-7674, this function will not modify any temporary allowance. This function
     * only sets the "standard" allowance. Any temporary allowance will remain active, in addition to the value being
     * set here.
     */
    function forceApprove(IERC20 token, address spender, uint256 value) internal {
        if (!_safeApprove(token, spender, value, false)) {
            if (!_safeApprove(token, spender, 0, true)) revert SafeERC20FailedOperation(address(token));
            if (!_safeApprove(token, spender, value, true)) revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} transferAndCall, with a fallback to the simple {ERC20} transfer if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that relies on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            safeTransfer(token, to, value);
        } else if (!token.transferAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} transferFromAndCall, with a fallback to the simple {ERC20} transferFrom if the target
     * has no code. This can be used to implement an {ERC721}-like safe transfer that relies on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferFromAndCallRelaxed(
        IERC1363 token,
        address from,
        address to,
        uint256 value,
        bytes memory data
    ) internal {
        if (to.code.length == 0) {
            safeTransferFrom(token, from, to, value);
        } else if (!token.transferFromAndCall(from, to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} approveAndCall, with a fallback to the simple {ERC20} approve if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * NOTE: When the recipient address (`to`) has no code (i.e. is an EOA), this function behaves as {forceApprove}.
     * Oppositely, when the recipient address (`to`) has code, this function only attempts to call {ERC1363-approveAndCall}
     * once without retrying, and relies on the returned value to be true.
     *
     * Reverts if the returned value is other than `true`.
     */
    function approveAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            forceApprove(token, to, value);
        } else if (!token.approveAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity `token.transfer(to, value)` call, relaxing the requirement on the return value: the
     * return value is optional (but if data is returned, it must not be false).
     *
     * @param token The token targeted by the call.
     * @param to The recipient of the tokens
     * @param value The amount of token to transfer
     * @param bubble Behavior switch if the transfer call reverts: bubble the revert reason or return a false boolean.
     */
    function _safeTransfer(IERC20 token, address to, uint256 value, bool bubble) private returns (bool success) {
        bytes4 selector = IERC20.transfer.selector;

        assembly ("memory-safe") {
            let fmp := mload(0x40)
            mstore(0x00, selector)
            mstore(0x04, and(to, shr(96, not(0))))
            mstore(0x24, value)
            success := call(gas(), token, 0, 0x00, 0x44, 0x00, 0x20)
            // if call success and return is true, all is good.
            // otherwise (not success or return is not true), we need to perform further checks
            if iszero(and(success, eq(mload(0x00), 1))) {
                // if the call was a failure and bubble is enabled, bubble the error
                if and(iszero(success), bubble) {
                    returndatacopy(fmp, 0x00, returndatasize())
                    revert(fmp, returndatasize())
                }
                // if the return value is not true, then the call is only successful if:
                // - the token address has code
                // - the returndata is empty
                success := and(success, and(iszero(returndatasize()), gt(extcodesize(token), 0)))
            }
            mstore(0x40, fmp)
        }
    }

    /**
     * @dev Imitates a Solidity `token.transferFrom(from, to, value)` call, relaxing the requirement on the return
     * value: the return value is optional (but if data is returned, it must not be false).
     *
     * @param token The token targeted by the call.
     * @param from The sender of the tokens
     * @param to The recipient of the tokens
     * @param value The amount of token to transfer
     * @param bubble Behavior switch if the transfer call reverts: bubble the revert reason or return a false boolean.
     */
    function _safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value,
        bool bubble
    ) private returns (bool success) {
        bytes4 selector = IERC20.transferFrom.selector;

        assembly ("memory-safe") {
            let fmp := mload(0x40)
            mstore(0x00, selector)
            mstore(0x04, and(from, shr(96, not(0))))
            mstore(0x24, and(to, shr(96, not(0))))
            mstore(0x44, value)
            success := call(gas(), token, 0, 0x00, 0x64, 0x00, 0x20)
            // if call success and return is true, all is good.
            // otherwise (not success or return is not true), we need to perform further checks
            if iszero(and(success, eq(mload(0x00), 1))) {
                // if the call was a failure and bubble is enabled, bubble the error
                if and(iszero(success), bubble) {
                    returndatacopy(fmp, 0x00, returndatasize())
                    revert(fmp, returndatasize())
                }
                // if the return value is not true, then the call is only successful if:
                // - the token address has code
                // - the returndata is empty
                success := and(success, and(iszero(returndatasize()), gt(extcodesize(token), 0)))
            }
            mstore(0x40, fmp)
            mstore(0x60, 0)
        }
    }

    /**
     * @dev Imitates a Solidity `token.approve(spender, value)` call, relaxing the requirement on the return value:
     * the return value is optional (but if data is returned, it must not be false).
     *
     * @param token The token targeted by the call.
     * @param spender The spender of the tokens
     * @param value The amount of token to transfer
     * @param bubble Behavior switch if the transfer call reverts: bubble the revert reason or return a false boolean.
     */
    function _safeApprove(IERC20 token, address spender, uint256 value, bool bubble) private returns (bool success) {
        bytes4 selector = IERC20.approve.selector;

        assembly ("memory-safe") {
            let fmp := mload(0x40)
            mstore(0x00, selector)
            mstore(0x04, and(spender, shr(96, not(0))))
            mstore(0x24, value)
            success := call(gas(), token, 0, 0x00, 0x44, 0x00, 0x20)
            // if call success and return is true, all is good.
            // otherwise (not success or return is not true), we need to perform further checks
            if iszero(and(success, eq(mload(0x00), 1))) {
                // if the call was a failure and bubble is enabled, bubble the error
                if and(iszero(success), bubble) {
                    returndatacopy(fmp, 0x00, returndatasize())
                    revert(fmp, returndatasize())
                }
                // if the return value is not true, then the call is only successful if:
                // - the token address has code
                // - the returndata is empty
                success := and(success, and(iszero(returndatasize()), gt(extcodesize(token), 0)))
            }
            mstore(0x40, fmp)
        }
    }
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC721/IERC721.sol)

pragma solidity >=0.6.2;


/**
 * @dev Required interface of an ERC-721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC-721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC-721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/StorageSlot.sol


// OpenZeppelin Contracts (last updated v5.1.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

pragma solidity ^0.8.20;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC-1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(newImplementation.code.length > 0);
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {SlotDerivation}.
 */
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct Int256Slot {
        int256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Int256Slot` with member `value` located at `slot`.
     */
    function getInt256Slot(bytes32 slot) internal pure returns (Int256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns a `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }
}

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v5.5.0) (utils/ReentrancyGuard.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If EIP-1153 (transient storage) is available on the chain you're deploying at,
 * consider using {ReentrancyGuardTransient} instead.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 *
 * IMPORTANT: Deprecated. This storage-based reentrancy guard will be removed and replaced
 * by the {ReentrancyGuardTransient} variant in v6.0.
 *
 * @custom:stateless
 */
abstract contract ReentrancyGuard {
    using StorageSlot for bytes32;

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ReentrancyGuard")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant REENTRANCY_GUARD_STORAGE =
        0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00;

    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _reentrancyGuardStorageSlot().getUint256Slot().value = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    /**
     * @dev A `view` only version of {nonReentrant}. Use to block view functions
     * from being called, preventing reading from inconsistent contract state.
     *
     * CAUTION: This is a "view" modifier and does not change the reentrancy
     * status. Use it only on view functions. For payable or non-payable functions,
     * use the standard {nonReentrant} modifier instead.
     */
    modifier nonReentrantView() {
        _nonReentrantBeforeView();
        _;
    }

    function _nonReentrantBeforeView() private view {
        if (_reentrancyGuardEntered()) {
            revert ReentrancyGuardReentrantCall();
        }
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        _nonReentrantBeforeView();

        // Any calls to nonReentrant after this point will fail
        _reentrancyGuardStorageSlot().getUint256Slot().value = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _reentrancyGuardStorageSlot().getUint256Slot().value = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _reentrancyGuardStorageSlot().getUint256Slot().value == ENTERED;
    }

    function _reentrancyGuardStorageSlot() internal pure virtual returns (bytes32) {
        return REENTRANCY_GUARD_STORAGE;
    }
}

// File: @openzeppelin/contracts/utils/Pausable.sol


// OpenZeppelin Contracts (last updated v5.3.0) (utils/Pausable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    bool private _paused;

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    /**
     * @dev The operation failed because the contract is paused.
     */
    error EnforcedPause();

    /**
     * @dev The operation failed because the contract is not paused.
     */
    error ExpectedPause();

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        if (paused()) {
            revert EnforcedPause();
        }
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        if (!paused()) {
            revert ExpectedPause();
        }
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol


// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity >=0.5.0;

/**
 * @title ERC-721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC-721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be
     * reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// File: contracts/PromptStaking.sol


// PromptStaking.sol
// NFT质押合约 V4.0

// 支持1种NFT（Prompt），按权重分配PTC奖励。
// 质押挖矿的总数量：5亿
// 释放规则：第一年18%，第二年16%，第三年14%，第四年12%，第五年10%，从第六年开始把剩余数量（30%）和提前注入的数量按照每年释放50%逐年减半的逻辑释放。
// 奖励计算：每次计算时使用当前基数乘以（已销售NFT数量/NFT发行总数）的比例，已销售数量 = NFT发行总数 - 销售地址持有量。未销售数量对应的比例进入缓冲池，缓冲池中部分数量将在第六年开始前注入至合约，参与第六年之后的按年减半释放。
// 奖励分配：用户收益 = 总释放奖励 × 销售比例，剩余部分进入缓冲池。
// 提现：分发操作员（distributor）控制，支持随时为用户提现全部奖励。
// 平台代扣：分发操作员可将单个或多个用户的待领取奖励直接划转至预先配置的平台收款账户，无手续费。
// 权限分离：owner负责合约管理（暂停/恢复、设置参数、救援资产），distributor负责日常奖励分发和代扣。
// 奖励采用全局积分累加器模型，近似连续产出。
// 支持质押/解押/领取奖励单个或批量操作，支持随时领取全部或部分奖励。
// 支持救援功能，允许合约所有者提取误转入的ERC20代币和非质押NFT。
// 安全性：使用OpenZeppelin库，包含重入保护和可暂停功能。管理员操作（如救援、调整参数）需要谨慎执行。
// 注意：用户质押NFT数量过多可能导致单次操作gas过高，建议分批操作。
// Author: Thebook

pragma solidity ^0.8.20;








/// @title PromptStaking
/// @author Thebook
contract PromptStaking is Ownable, ReentrancyGuard, Pausable, IERC721Receiver {
    using SafeERC20 for IERC20;

    // -------------------- Custom Errors --------------------
    error ZeroAddress();
    error InvalidSupply();
    error StartTimeInvalid();
    error AlreadyStaked();
    error NotStakeOwner();
    error TokenNotStaked();
    error NoTokenIds();
    error NoStaked();
    error FeeRateTooHigh();
    error NoClaimable();
    error AmountZero();
    error AmountExceedsPending();
    error LengthMismatch();
    error CannotRescuePTC();
    error CannotRescueStakedNFT();
    error NoPendingWithdrawal();
    error WithdrawalDelayNotMet();
    error BufferPoolNotSet();
    error InsufficientBufferPool();
    error TooLateForAdditional();
    error PlatformReceiverNotSet();
    error EmptyUserList();
    error NotDistributor();
    error UnsolicitedNFTTransfer();
    error NotInWhitelist();

    // --------------- 允许质押用户白名单 ----------------
    mapping(address => bool) public stakeWhitelist;

    // -------------------- 质押结构体 --------------------
    /// @notice 用户单个NFT质押信息
    struct StakeInfo {
        uint256 tokenId;    // NFT编号
        uint256 stakedAt;   // 质押时间戳
    }

    /// @notice 用户质押及奖励信息
    struct UserInfo {
        StakeInfo[] stakes;     // 用户所有质押NFT
        uint256 rewardDebt;     // 上次结算时的 accRewardPerWeight 快照
        uint256 pendingReward;  // 待领取奖励
        uint256 claimed;        // 累计已领取奖励
    }

    /// @notice 用户质押信息
    mapping(address => UserInfo) public users;

    /// @notice 质押反向索引，记录每个NFT(tokenId)当前质押所属用户
    mapping(uint256 => address) public nftOwners;
    // 存储用户 stakes 数组中 tokenId 的索引加1（0 表示不存在）: stakeIndex[user][tokenId] = index+1
    mapping(address => mapping(uint256 => uint256)) public stakeIndex;

    // -------------------- 合约参数 --------------------
    IERC20 public immutable ptc;           // PTC代币合约
    address public immutable promptNFT;    // Prompt NFT合约地址

    uint256 public constant TOTAL_REWARD = 500000000 ether; // 总奖励 5亿

    uint256 public constant REMAINING_AFTER_5_YEARS = 150000000 ether; // 前5年释放21亿，剩余9亿用于第6年后动态释放
    uint256 public constant FRACTION = 5000; // 50% = 5000/10000，保持不变，第六年开始每年释放年初剩余的50%
    uint256 public constant MAX_DYNAMIC_YEARS = 64; // 第6年后动态释放的最大年数上限，防止循环耗尽gas
    uint256 public constant MAX_FEE_RATE = 10000; // 手续费率上限 100%

    uint256 public totalAdditionalReward; // 累计额外注入总量

    // 释放周期：前5年固定，第6年开始动态释放
    uint256 public constant SCHEDULE_PERIOD_DURATION = 365 days;
    uint256[5] public schedulePeriodTotals;

    uint256 public startRewardTimestamp; // 奖励产出起始时间

    uint256 public accRewardPerWeight;   // 全局积分累加器（1e18精度）
    uint256 public lastRewardTimestamp;  // 上次奖励计算时间戳
    uint256 public totalStakeCount;      // 全局质押的NFT总数
    uint256 public totalPendingReward;   // 全局待领取奖励总量
    uint256 public totalClaimedPTC;      // 全局已发放给用户的PTC总量（不含缓冲池和手续费）
    uint256 public totalFeesPaid;        // 全局累计手续费总量

    // -------------------- 销售参数 --------------------
    uint256 public totalNFTSupply;       // NFT发行总数
    address public salesAddress;         // 销售地址

    // -------------------- 缓冲池参数 --------------------
    address public bufferPool;
    uint256 public bufferPoolReward;
    uint256 public pendingBufferWithdrawal;
    uint256 public bufferWithdrawalRequestTime;

    // -------------------- 手续费参数 --------------------
    address public feeRecipient; // 手续费接收地址

    // -------------------- 分发权参数 --------------------
    address public distributor; // 奖励分发操作员地址（独立于owner）

    // -------------------- 平台代扣款参数 --------------------
    address public platformPaymentReceiver; // 平台代扣款收款账户地址
    uint256 public totalPlatformCharged;    // 全局累计平台代扣总量（PTC）

    // -------------------- 缓冲池提现延迟参数 --------------------
    uint256 public constant BUFFER_WITHDRAWAL_DELAY = 1 days; // 缓冲池提取延迟时间

    // -------------------- 销售比例保护参数 --------------------
    uint256 private lastSalesRatioUpdate;
    uint256 private cachedSalesRatio;

    // -------------------- 权限修饰符 --------------------
    modifier onlyDistributor() {
        if (msg.sender != distributor) revert NotDistributor();
        _;
    }

    // 白名单校验修饰符
    modifier onlyWhitelisted() {
        if (!stakeWhitelist[msg.sender]) revert NotInWhitelist();
        _;
    }

    // -------------------- 紧急控制参数 --------------------
    bool public salesRatioUpdatePaused; // 销售比例更新暂停标志

    /// @notice 紧急暂停销售比例更新（防止外部合约攻击）
    function emergencyPauseSalesRatioUpdate() external onlyOwner {
        salesRatioUpdatePaused = true;
        emit SalesRatioUpdatePaused(msg.sender);
    }

    /// @notice 恢复销售比例更新
    function resumeSalesRatioUpdate() external onlyOwner {
        salesRatioUpdatePaused = false;
        emit SalesRatioUpdateResumed(msg.sender);
    }

    // -------------------- 事件定义 --------------------
    event Staked(address indexed user, uint256 indexed tokenId);
    event Unstaked(address indexed user, uint256 indexed tokenId);
    event Claimed(address indexed user, uint256 amount);
    event EmergencyUnstake(address indexed user, uint256 indexed tokenId);
    event ERC20Rescued(address indexed operator, address token, uint256 amount);
    event ERC721Rescued(address indexed operator, address nft, uint256 tokenId);
    event BufferPoolWithdrawn(address indexed admin, uint256 amount);
    event BufferPoolSet(address indexed admin, address newBufferPool);
    event BufferPoolWithdrawalRequested(address indexed admin, uint256 amount, uint256 requestTime);
    event BufferPoolWithdrawalCancelled(address indexed admin);
    event SalesRatioUpdatePaused(address indexed admin);
    event SalesRatioUpdateResumed(address indexed admin);
    event AdditionalRewardAdded(address indexed admin, uint256 amount);
    event DistributorSet(address indexed admin, address newDistributor);
    event FeeRecipientSet(address indexed admin, address newFeeRecipient);
    event PlatformPaymentReceiverSet(address indexed admin, address newReceiver);
    event PlatformCharged(address indexed user, address indexed receiver, uint256 amount);
    event WhitelistAdded(address indexed account);
    event WhitelistRemoved(address indexed account);
    event WhitelistBatchAdded(address[] accounts);
    event WhitelistBatchRemoved(address[] accounts);

    // -------------------- 构造函数 --------------------
    /// @notice 构造函数，初始化PTC和NFT合约地址及奖励起始时间
    /// @param _ptc PTC代币地址
    /// @param _promptNFT Prompt NFT地址
    /// @param _startTime 奖励产出起始时间（0为立即开始）
    /// @param _feeRecipient 手续费接收地址
    /// @param _totalNFTSupply NFT发行总数
    /// @param _salesAddress 销售地址
    /// @param _bufferPool 缓冲池地址
    /// @param _distributor 分发操作员地址
    constructor(
        address _ptc,
        address _promptNFT,
        uint256 _startTime,
        address _feeRecipient,
        uint256 _totalNFTSupply,
        address _salesAddress,
        address _bufferPool,
        address _distributor
    ) Ownable(msg.sender)
    {
        if (_ptc == address(0)) revert ZeroAddress();
        if (_promptNFT == address(0)) revert ZeroAddress();
        if (_feeRecipient == address(0)) revert ZeroAddress();
        if (_salesAddress == address(0)) revert ZeroAddress();
        if (_bufferPool == address(0)) revert ZeroAddress();
        if (_distributor == address(0)) revert ZeroAddress();
        if (_totalNFTSupply == 0) revert InvalidSupply();

        ptc = IERC20(_ptc);
        promptNFT = _promptNFT;
        feeRecipient = _feeRecipient;
        distributor = _distributor;
        totalNFTSupply = _totalNFTSupply;
        salesAddress = _salesAddress;
        bufferPool = _bufferPool;

        if (_startTime == 0) {
            startRewardTimestamp = block.timestamp;
        } else {
            if (_startTime < block.timestamp) revert StartTimeInvalid();
            startRewardTimestamp = _startTime;
        }
        // 奖励永远释放，无结束时间

        // 初始化各年释放总量
        // 第一年: 18% = 0.9亿
        schedulePeriodTotals[0] = 90000000 ether;
        // 第二年: 16% = 0.8亿
        schedulePeriodTotals[1] = 80000000 ether;
        // 第三年: 14% = 0.7亿
        schedulePeriodTotals[2] = 70000000 ether;
        // 第四年: 12% = 0.6亿
        schedulePeriodTotals[3] = 60000000 ether;
        // 第五年: 10% = 0.5亿
        schedulePeriodTotals[4] = 50000000 ether;

        cachedSalesRatio = _computeProtectedSalesRatio();
        lastSalesRatioUpdate = block.timestamp;
    }

    // -------------------- 白名单管理函数（仅Owner） --------------------
    /// @notice 添加单个地址到白名单
    function addToWhitelist(address account) external onlyOwner {
        if (account == address(0)) revert ZeroAddress();
        stakeWhitelist[account] = true;
        emit WhitelistAdded(account);
    }

    /// @notice 从白名单移除单个地址
    function removeFromWhitelist(address account) external onlyOwner {
        if (account == address(0)) revert ZeroAddress();
        stakeWhitelist[account] = false;
        emit WhitelistRemoved(account);
    }

    /// @notice 批量添加白名单
    function batchAddToWhitelist(address[] calldata accounts) external onlyOwner {
        uint256 len = accounts.length;
        if (len == 0) revert EmptyUserList();
        for (uint256 i = 0; i < len; i++) {
            if (accounts[i] == address(0)) revert ZeroAddress();
            stakeWhitelist[accounts[i]] = true;
        }
        emit WhitelistBatchAdded(accounts);
    }

    /// @notice 批量移除白名单
    function batchRemoveFromWhitelist(address[] calldata accounts) external onlyOwner {
        uint256 len = accounts.length;
        if (len == 0) revert EmptyUserList();
        for (uint256 i = 0; i < len; i++) {
            if (accounts[i] == address(0)) revert ZeroAddress();
            stakeWhitelist[accounts[i]] = false;
        }
        emit WhitelistBatchRemoved(accounts);
    }

    /// @notice 查询账户是否在白名单内
    function isWhitelisted(address account) external view returns (bool) {
        return stakeWhitelist[account];
    }

    // -------------------- 辅助查询函数 ------------------
    /// @dev 计算当前销售比例（不修改状态）
    /// @return 销售比例（1e18精度）
    function _computeProtectedSalesRatio() internal view returns (uint256) {
        uint256 sold = totalNFTSupply - IERC721(promptNFT).balanceOf(salesAddress);
        uint256 rawRatio = sold * 1e18 / totalNFTSupply;
        return rawRatio;
    }

    /// @notice 获取受保护的销售比例（带缓存、上限保护和紧急暂停）
    /// @return 销售比例（1e18精度）
    function getProtectedSalesRatio() public returns (uint256) {
        if (salesRatioUpdatePaused) {
            return cachedSalesRatio;
        }
        if (block.timestamp - lastSalesRatioUpdate >= 1 hours) {
            cachedSalesRatio = _computeProtectedSalesRatio();
            lastSalesRatioUpdate = block.timestamp;
        }
        return cachedSalesRatio;
    }

    /// @notice 获取受保护的销售比例（视图版，不修改状态）
    /// @return 销售比例（1e18精度）
    function getProtectedSalesRatioView() public view returns (uint256) {
        if (salesRatioUpdatePaused) {
            return cachedSalesRatio;
        }
        return _computeProtectedSalesRatio();
    }

    /// @notice 获取用户所有质押NFT列表（分页）
    /// @param user 用户地址
    /// @param offset 偏移量
    /// @param limit 限制数量
    /// @return stakes 用户所有质押NFT StakeInfo[]
    function getStakedNFTs(address user, uint256 offset, uint256 limit) external view returns (StakeInfo[] memory stakes) {
        uint256 total = users[user].stakes.length;
        if (offset >= total) return new StakeInfo[](0);
        if (offset + limit > total) limit = total - offset;
        if (offset == 0 && limit == total) {
            return users[user].stakes;
        } else {
            stakes = new StakeInfo[](limit);
            for (uint256 i = 0; i < limit; i++) {
                stakes[i] = users[user].stakes[offset + i];
            }
            return stakes;
        }
    }

    /// @notice 获取用户质押nft总数量
    function getStakedNFTsCount(address user) external view returns (uint256) {
        return users[user].stakes.length;
    }

    /// @notice 获取质押中的nft的所属用户
    function getStakedNFTOwner(uint256 tokenId) external view returns (address) {
        return nftOwners[tokenId];
    }

    /// @notice 获取用户概览信息，便于链下一次性读取常用字段
    /// @param user 用户地址
    /// @return stakeCount 质押项数量
    /// @return claimableAmount 当前可领取（包含未写入 pending 的部分）
    /// @return claimed 已累计领取总量
    function getUserSummary(address user) external view returns (uint256 stakeCount, uint256 claimableAmount, uint256 claimed) {
        stakeCount = users[user].stakes.length;
        claimableAmount = claimable(user);
        claimed = users[user].claimed;
    }

    /// @notice 获取合约关键全局统计信息，便于链下监控
    function getSystemStats() external view returns (
        uint256 _totalStakeCount,
        uint256 _accRewardPerWeight,
        uint256 _lastRewardTimestamp,
        uint256 _startRewardTimestamp,
        uint256 _bufferPoolReward,
        uint256 _totalClaimedPTC,
        uint256 _totalFeesPaid,
        uint256 _totalPendingReward
    ) {
        _totalStakeCount = totalStakeCount;
        _accRewardPerWeight = accRewardPerWeight;
        _lastRewardTimestamp = lastRewardTimestamp;
        _startRewardTimestamp = startRewardTimestamp;
        _bufferPoolReward = bufferPoolReward;
        _totalClaimedPTC = totalClaimedPTC;
        _totalFeesPaid = totalFeesPaid;
        _totalPendingReward = totalPendingReward;
    }

    /// @notice 获取全局已分配给用户的PTC近似总量（已领取 + 待领取 + 未结算部分，不含缓冲池和手续费）
    function getTotalAllocatedPTC() external view returns (uint256) {
        uint256 unaccounted = 0;
        uint256 nowTime = block.timestamp;
        uint256 lastTime = lastRewardTimestamp == 0 ? startRewardTimestamp : lastRewardTimestamp;
        if (nowTime > lastTime && totalStakeCount > 0) {
            uint256 ratio = getProtectedSalesRatioView();
            uint256 reward = _emittedUntil(nowTime) - _emittedUntil(lastTime);
            uint256 adjustedReward = reward * ratio / 1e18;
            unaccounted = adjustedReward;
        }
        return totalClaimedPTC + totalPendingReward + unaccounted;
    }

    // -------------------- 核心函数 --------------------

    /// @notice 更新全局奖励状态（分段累加）
    function _updateGlobal() internal {
        uint256 nowTime = block.timestamp;
        if (lastRewardTimestamp == 0) lastRewardTimestamp = startRewardTimestamp;
        if (nowTime <= lastRewardTimestamp) return;

        uint256 from = lastRewardTimestamp;
        uint256 to = nowTime;
        uint256 reward = _emittedUntil(to) - _emittedUntil(from);
        lastRewardTimestamp = nowTime;

        if (reward == 0) return;

        if (totalStakeCount == 0) {
            bufferPoolReward += reward;
            return;
        }
        uint256 ratio = getProtectedSalesRatio();
        uint256 adjustedReward = reward * ratio / 1e18;
        bufferPoolReward += reward - adjustedReward;
        accRewardPerWeight += adjustedReward * 1e18 / totalStakeCount;
    }

    /// @dev 计算从奖励开始到时间 t 的累计释放量（确定性计算，不依赖合约余额）
    function _emittedUntil(uint256 t) internal view returns (uint256) {
        if (t <= startRewardTimestamp) return 0;
        uint256 total = 0;
        uint256 periodDuration = SCHEDULE_PERIOD_DURATION;
        // 前5年固定释放
        for (uint256 i = 0; i < 5; i++) {
            uint256 periodStart = startRewardTimestamp + i * periodDuration;
            if (t <= periodStart) break;
            uint256 periodEnd = periodStart + periodDuration;
            uint256 elapsed = t < periodEnd ? t - periodStart : periodDuration;
            total += schedulePeriodTotals[i] * elapsed / periodDuration;
        }
        // 从第六年开始动态释放（基础+额外注入）
        uint256 start6 = startRewardTimestamp + 5 * periodDuration;
        if (t > start6) {
           uint256 totalRemaining = REMAINING_AFTER_5_YEARS + totalAdditionalReward;
           total += _emittedTail(t, start6, periodDuration, totalRemaining);
        }
        return total;
    }

    /// @dev 计算单笔资金池从第六年开始按50%减半释放到时间 t 的累计释放量
    /// @param t 目标时间
    /// @param start6 第6年起始时间戳
    /// @param periodDuration 每年时长
    /// @param initialRemaining 该笔资金池初始总量
    function _emittedTail(
        uint256 t,
        uint256 start6,
        uint256 periodDuration,
        uint256 initialRemaining
    ) internal pure returns (uint256) {
        if (t <= start6 || initialRemaining == 0) {
            return 0;
        }
        uint256 yearsPassed = (t - start6) / periodDuration;
        uint256 maxYears = yearsPassed < MAX_DYNAMIC_YEARS ? yearsPassed : MAX_DYNAMIC_YEARS;

        uint256 remaining = initialRemaining;
        uint256 emitted = 0;

        for (uint256 y = 0; y <= maxYears && remaining > 0; y++) {
            uint256 releaseThisYear = remaining * FRACTION / 10000;
            if (releaseThisYear == 0) break;
            uint256 periodStart = start6 + y * periodDuration;
            uint256 periodEnd = periodStart + periodDuration;
            uint256 elapsed = t < periodEnd ? t - periodStart : periodDuration;
            emitted += releaseThisYear * elapsed / periodDuration;
            remaining -= releaseThisYear;
        }
        return emitted;
    }

    /// @dev 更新指定用户的奖励，在质押/解押/提现前调用
    function _updateReward(address user) internal {
        _updateGlobal();
        UserInfo storage u = users[user];
        uint256 stakeCount = u.stakes.length;
        if (stakeCount > 0) {
            uint256 pending = stakeCount * (accRewardPerWeight - u.rewardDebt) / 1e18;
            u.pendingReward += pending;
            totalPendingReward += pending;
        }
        u.rewardDebt = accRewardPerWeight;
    }

    /// @dev 从用户 stakes 数组中移除指定 tokenId 的状态（不处理NFT转移）
    function _removeStakeState(address user, uint256 tokenId) internal {
        uint256 idxPlus = stakeIndex[user][tokenId];
        if (idxPlus == 0) revert TokenNotStaked();
        uint256 idx = idxPlus - 1;
        StakeInfo[] storage stakes = users[user].stakes;
        uint256 last = stakes.length - 1;
        if (idx != last) {
            uint256 lastTokenId = stakes[last].tokenId;
            stakes[idx] = stakes[last];
            // 更新被移动元素的索引
            stakeIndex[user][lastTokenId] = idx + 1;
        }
        stakes.pop();
        delete stakeIndex[user][tokenId];
        delete nftOwners[tokenId];
        totalStakeCount -= 1;
    }

    // ========== 质押解押相关 ==========
    /// @notice 质押单个NFT
    function stake(uint256 tokenId) external nonReentrant whenNotPaused onlyWhitelisted {
        _updateReward(msg.sender);
        if (nftOwners[tokenId] != address(0)) revert AlreadyStaked();
        uint256 idx = users[msg.sender].stakes.length;
        users[msg.sender].stakes.push(StakeInfo({
            tokenId: tokenId,
            stakedAt: block.timestamp
        }));
        stakeIndex[msg.sender][tokenId] = idx + 1;
        totalStakeCount += 1;
        nftOwners[tokenId] = msg.sender;
        emit Staked(msg.sender, tokenId);
        IERC721(promptNFT).safeTransferFrom(msg.sender, address(this), tokenId);
    }

    /// @notice 批量质押NFT
    function stakeBatch(uint256[] calldata tokenIds) external nonReentrant whenNotPaused onlyWhitelisted {
        if (tokenIds.length == 0) revert NoTokenIds();
        _updateReward(msg.sender);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            if (nftOwners[tokenId] != address(0)) revert AlreadyStaked();
            uint256 idx = users[msg.sender].stakes.length;
            users[msg.sender].stakes.push(StakeInfo(tokenId, block.timestamp));
            stakeIndex[msg.sender][tokenId] = idx + 1;
            nftOwners[tokenId] = msg.sender;
        }
        totalStakeCount += tokenIds.length;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            emit Staked(msg.sender, tokenIds[i]);
            IERC721(promptNFT).safeTransferFrom(msg.sender, address(this), tokenIds[i]);
        }
    }

    /// @notice 解押单个NFT
    function unstake(uint256 tokenId) external nonReentrant whenNotPaused {
        _updateReward(msg.sender);
        if (nftOwners[tokenId] != msg.sender) revert NotStakeOwner();
        _removeStakeState(msg.sender, tokenId);
        emit Unstaked(msg.sender, tokenId);
        IERC721(promptNFT).safeTransferFrom(address(this), msg.sender, tokenId);
    }

    /// @notice 批量解押NFT
    /// @dev 循环中每次safeTransferFrom回调时，外部view调用可能观察到中间状态（已处理的NFT已移除，未处理的仍存在）。
    ///      nonReentrant已阻止状态变更重入，集成方应避免在onERC721Received回调中依赖本合约的view快照。
    function unstakeBatch(uint256[] calldata tokenIds) external nonReentrant whenNotPaused {
        if (tokenIds.length == 0) revert NoTokenIds();
        _updateReward(msg.sender);
        for (uint256 k = 0; k < tokenIds.length; k++) {
            uint256 tokenId = tokenIds[k];
            if (nftOwners[tokenId] != msg.sender) revert NotStakeOwner();
            _removeStakeState(msg.sender, tokenId);
            emit Unstaked(msg.sender, tokenId);
            IERC721(promptNFT).safeTransferFrom(address(this), msg.sender, tokenId);
        }
    }

    /// @notice 一键解押用户所有NFT
    /// @dev 注意：用户质押nft数量太多可能导致gas高甚至超过上限而无法执行。
    ///      循环中每次safeTransferFrom回调时，外部view调用可能观察到中间状态，集成方应避免在回调中依赖本合约的view快照。
    function unstakeAll() external nonReentrant whenNotPaused {
        _updateReward(msg.sender);
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        if (stakes.length == 0) revert NoStaked();
        uint256 count = stakes.length;
        totalStakeCount -= count;
        while (stakes.length > 0) {
            uint256 tid = stakes[stakes.length - 1].tokenId;
            stakes.pop();
            delete stakeIndex[msg.sender][tid];
            delete nftOwners[tid];
            emit Unstaked(msg.sender, tid);
            IERC721(promptNFT).safeTransferFrom(address(this), msg.sender, tid);
        }
    }

    /// @notice 分发操作员为用户提现所有可领取的PTC奖励（扣除手续费）
    /// @param user 用户地址
    /// @param feeRate 手续费率，单位1e4（100=1%）
    function withdrawForUser(address user, uint256 feeRate) external nonReentrant whenNotPaused onlyDistributor {
        if (feeRate > MAX_FEE_RATE) revert FeeRateTooHigh();
        _updateReward(user);
        UserInfo storage u = users[user];
        uint256 totalPending = u.pendingReward;
        if (totalPending == 0) revert NoClaimable();
        uint256 amountToClaim = totalPending;

        // 计算手续费
        uint256 fee = amountToClaim * feeRate / 1e4;
        uint256 netAmount = amountToClaim - fee;

        u.pendingReward -= amountToClaim;
        totalPendingReward -= amountToClaim;
        u.claimed += amountToClaim;
        totalClaimedPTC += netAmount;
        if (fee > 0) totalFeesPaid += fee;

        emit Claimed(user, netAmount);
        ptc.safeTransfer(user, netAmount);
        if (fee > 0) ptc.safeTransfer(feeRecipient, fee);
    }

    /// @notice 分发操作员为用户提现指定数量的PTC奖励（扣除手续费）
    /// @param user 用户地址
    /// @param amount 提现金额
    /// @param feeRate 手续费率，单位1e4（100=1%）
    function withdrawForUser(address user, uint256 amount, uint256 feeRate) external nonReentrant whenNotPaused onlyDistributor {
        if (feeRate > MAX_FEE_RATE) revert FeeRateTooHigh();
        _updateReward(user);
        UserInfo storage u = users[user];
        if (amount == 0) revert AmountZero();
        if (amount > u.pendingReward) revert AmountExceedsPending();

        // 计算手续费
        uint256 fee = amount * feeRate / 1e4;
        uint256 netAmount = amount - fee;

        u.pendingReward -= amount;
        totalPendingReward -= amount;
        u.claimed += amount;
        totalClaimedPTC += netAmount;
        if (fee > 0) totalFeesPaid += fee;

        emit Claimed(user, netAmount);
        ptc.safeTransfer(user, netAmount);
        if (fee > 0) ptc.safeTransfer(feeRecipient, fee);
    }

    /// @notice 分发操作员批量为用户提现所有可领取的PTC奖励（扣除手续费）
    /// @param _users 用户地址数组
    /// @param feeRates 手续费率数组，单位1e4（100=1%），对应每个用户
    function withdrawForUsers(address[] calldata _users, uint256[] calldata feeRates) external nonReentrant whenNotPaused onlyDistributor {
        if (_users.length != feeRates.length) revert LengthMismatch();
        for (uint256 i = 0; i < _users.length; i++) {
            if (feeRates[i] > MAX_FEE_RATE) revert FeeRateTooHigh();
        }
        for (uint256 i = 0; i < _users.length; i++) {
            address user = _users[i];
            uint256 feeRate = feeRates[i];
            _updateReward(user);
            UserInfo storage u = users[user];
            uint256 totalPending = u.pendingReward;
            if (totalPending == 0) continue;

            uint256 amountToClaim = totalPending;
            // 计算手续费
            uint256 fee = amountToClaim * feeRate / 1e4;
            uint256 netAmount = amountToClaim - fee;

            u.pendingReward -= amountToClaim;
            totalPendingReward -= amountToClaim;
            u.claimed += amountToClaim;
            totalClaimedPTC += netAmount;
            if (fee > 0) totalFeesPaid += fee;

            emit Claimed(user, netAmount);
            ptc.safeTransfer(user, netAmount);
            if (fee > 0) ptc.safeTransfer(feeRecipient, fee);
        }
    }

    /// @notice 分发操作员批量为用户提现指定数量的PTC奖励（扣除手续费）
    /// @param _users 用户地址数组
    /// @param amounts 提现金额数组，对应每个用户
    /// @param feeRates 手续费率数组，单位1e4（100=1%），对应每个用户
    function withdrawForUsers(address[] calldata _users, uint256[] calldata amounts, uint256[] calldata feeRates) external nonReentrant whenNotPaused onlyDistributor {
        if (_users.length != amounts.length || amounts.length != feeRates.length) revert LengthMismatch();
        for (uint256 i = 0; i < feeRates.length; i++) {
            if (feeRates[i] > MAX_FEE_RATE) revert FeeRateTooHigh();
        }
        for (uint256 i = 0; i < _users.length; i++) {
            address user = _users[i];
            uint256 amount = amounts[i];
            uint256 feeRate = feeRates[i];
            if (amount == 0) revert AmountZero();

            _updateReward(user);
            UserInfo storage u = users[user];
            if (amount > u.pendingReward) revert AmountExceedsPending();

            // 计算手续费
            uint256 fee = amount * feeRate / 1e4;
            uint256 netAmount = amount - fee;

            u.pendingReward -= amount;
            totalPendingReward -= amount;
            u.claimed += amount;
            totalClaimedPTC += netAmount;
            if (fee > 0) totalFeesPaid += fee;

            emit Claimed(user, netAmount);
            ptc.safeTransfer(user, netAmount);
            if (fee > 0) ptc.safeTransfer(feeRecipient, fee);
        }
    }

    /// @notice 查询用户当前可领取的PTC奖励（含未结算的实时累积部分）
    function claimable(address user) public view returns (uint256) {
        UserInfo storage u = users[user];
        uint256 stakeCount = u.stakes.length;
        uint256 nowTime = block.timestamp;
        uint256 lastTime = lastRewardTimestamp == 0 ? startRewardTimestamp : lastRewardTimestamp;
        uint256 acc = accRewardPerWeight;
        if (nowTime > lastTime && totalStakeCount > 0) {
            uint256 ratio = getProtectedSalesRatioView();
            uint256 reward = _emittedUntil(nowTime) - _emittedUntil(lastTime);
            uint256 adjustedReward = reward * ratio / 1e18;
            acc += adjustedReward * 1e18 / totalStakeCount;
        }
        return u.pendingReward + (stakeCount * (acc - u.rewardDebt) / 1e18);
    }

    /// @notice 查询从奖励开始到时间 t 的累计释放量
    function emittedUntil(uint256 t) external view returns (uint256) {
        return _emittedUntil(t);
    }

    /// @notice 救援合约内误转入的ERC20代币（禁止PTC）
    function rescueERC20(address token, uint256 amount) external nonReentrant onlyOwner {
        if (token == address(ptc)) revert CannotRescuePTC();
        if (token == address(0)) revert ZeroAddress();
        emit ERC20Rescued(msg.sender, token, amount);
        IERC20(token).safeTransfer(owner(), amount);
    }

    /// @notice 救援合约内误转入的ERC721 NFT（禁止Prompt质押NFT）
    function rescueERC721(address nft, uint256 tokenId) external nonReentrant onlyOwner {
        if (nft == promptNFT) revert CannotRescueStakedNFT();
        if (nft == address(0)) revert ZeroAddress();
        emit ERC721Rescued(msg.sender, nft, tokenId);
        IERC721(nft).safeTransferFrom(address(this), owner(), tokenId);
    }

    /// @notice 用户紧急批量解押（仅暂停时可用，基于已有accRewardPerWeight结算奖励到pendingReward后再解押）
    function emergencyUnstakeBatch(uint256 count) external nonReentrant whenPaused {
        if (count == 0) revert AmountZero();
        UserInfo storage u = users[msg.sender];
        StakeInfo[] storage stakes = u.stakes;
        if (stakes.length == 0) revert NoStaked();
        uint256 stakeCount = stakes.length;
        if (stakeCount > 0 && accRewardPerWeight > u.rewardDebt) {
            uint256 pending = stakeCount * (accRewardPerWeight - u.rewardDebt) / 1e18;
            u.pendingReward += pending;
            totalPendingReward += pending;
        }
        u.rewardDebt = accRewardPerWeight;
        uint256 n = count > stakes.length ? stakes.length : count;
        for (uint256 i = 0; i < n; i++) {
            uint256 idx = stakes.length - 1;
            uint256 tid = stakes[idx].tokenId;
            stakes.pop();
            delete stakeIndex[msg.sender][tid];
            delete nftOwners[tid];
            emit EmergencyUnstake(msg.sender, tid);
            IERC721(promptNFT).safeTransferFrom(address(this), msg.sender, tid);
        }
        totalStakeCount -= n;
    }

    /// @notice 分发操作员随时解押任意NFT返回至原质押用户（含结算）
    /// @dev 仅distributor可调，无需用户授权，适用于特殊情况（如到期、司法、合规等）
    /// @param tokenIds NFT编号列表
    function unstakeBatchPlatform(uint256[] calldata tokenIds) external nonReentrant whenNotPaused onlyDistributor {
        if (tokenIds.length == 0) revert NoTokenIds();
        _updateGlobal();
        address lastUser = address(0);
        for (uint256 batchIdx = 0; batchIdx < tokenIds.length; batchIdx++) {
            uint256 tokenId = tokenIds[batchIdx];
            address user = nftOwners[tokenId];
            if (user == address(0)) revert TokenNotStaked();
            if (user != lastUser) {
                _settleUser(user);
                lastUser = user;
            }
            _removeStakeState(user, tokenId);
            emit Unstaked(user, tokenId);
            IERC721(promptNFT).safeTransferFrom(address(this), user, tokenId);
        }
    }

    /// @dev 仅结算用户奖励（不调用 _updateGlobal），供已完成全局更新后使用
    function _settleUser(address user) internal {
        UserInfo storage u = users[user];
        uint256 stakeCount = u.stakes.length;
        if (stakeCount > 0) {
            uint256 pending = stakeCount * (accRewardPerWeight - u.rewardDebt) / 1e18;
            u.pendingReward += pending;
            totalPendingReward += pending;
        }
        u.rewardDebt = accRewardPerWeight;
    }

    /// @notice 设置手续费接收地址
    /// @param _feeRecipient 新的手续费接收地址
    function setFeeRecipient(address _feeRecipient) external onlyOwner {
        if (_feeRecipient == address(0)) revert ZeroAddress();
        feeRecipient = _feeRecipient;
        emit FeeRecipientSet(msg.sender, _feeRecipient);
    }

    /// @notice 设置分发操作员地址（仅owner可调）
    /// @param _distributor 新的分发操作员地址
    function setDistributor(address _distributor) external onlyOwner {
        if (_distributor == address(0)) revert ZeroAddress();
        distributor = _distributor;
        emit DistributorSet(msg.sender, _distributor);
    }

    /// @notice 设置平台代扣款收款账户地址
    /// @param _receiver 新的平台收款地址
    function setPlatformPaymentReceiver(address _receiver) external onlyOwner {
        if (_receiver == address(0)) revert ZeroAddress();
        platformPaymentReceiver = _receiver;
        emit PlatformPaymentReceiverSet(msg.sender, _receiver);
    }

    /// @dev 内部代扣逻辑：将用户 amount 的待领取奖励转入平台收款账户（无手续费）
    /// @param user 被代扣的用户地址
    /// @param amount 代扣金额（必须 >0 且 <= 用户 pendingReward）
    function _chargeUser(address user, uint256 amount) internal {
        UserInfo storage u = users[user];
        if (amount > u.pendingReward) revert AmountExceedsPending();

        u.pendingReward -= amount;
        totalPendingReward -= amount;
        u.claimed += amount;
        totalClaimedPTC += amount;
        totalPlatformCharged += amount;

        emit PlatformCharged(user, platformPaymentReceiver, amount);
        ptc.safeTransfer(platformPaymentReceiver, amount);
    }

    /// @notice 分发操作员代扣单个用户指定数量奖励至平台收款账户（无手续费）
    /// @param user 被代扣的用户地址
    /// @param amount 代扣金额
    function chargeUser(address user, uint256 amount) external nonReentrant whenNotPaused onlyDistributor {
        if (platformPaymentReceiver == address(0)) revert PlatformReceiverNotSet();
        if (amount == 0) revert AmountZero();
        _updateReward(user);
        _chargeUser(user, amount);
    }

    /// @notice 分发操作员批量代扣多个用户指定数量奖励至平台收款账户（无手续费）
    /// @param _users 被代扣的用户地址数组
    /// @param amounts 对应每个用户的代扣金额数组
    function chargeUsers(address[] calldata _users, uint256[] calldata amounts) external nonReentrant whenNotPaused onlyDistributor {
        if (platformPaymentReceiver == address(0)) revert PlatformReceiverNotSet();
        if (_users.length != amounts.length) revert LengthMismatch();
        if (_users.length == 0) revert EmptyUserList();
        for (uint256 i = 0; i < _users.length; i++) {
            uint256 amount = amounts[i];
            if (amount == 0) revert AmountZero();
            address user = _users[i];
            _updateReward(user);
            _chargeUser(user, amount);
        }
    }

    /// @notice 合约暂停（仅owner可调）
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice 合约恢复（仅owner可调）
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice 设置缓冲池地址
    /// @param _bufferPool 新的缓冲池地址
    function setBufferPool(address _bufferPool) external onlyOwner {
        if (_bufferPool == address(0)) revert ZeroAddress();
        bufferPool = _bufferPool;
        emit BufferPoolSet(msg.sender, _bufferPool);
    }

    /// @notice 管理员请求提现缓冲池奖励（时间锁保护）
    /// @param amount 请求提现的金额
    function requestBufferWithdrawal(uint256 amount) external onlyOwner {
        _updateGlobal();
        if (amount == 0) revert AmountZero();
        if (amount > bufferPoolReward) revert InsufficientBufferPool();
        if (bufferPool == address(0)) revert BufferPoolNotSet();

        pendingBufferWithdrawal = amount;
        bufferWithdrawalRequestTime = block.timestamp;
        emit BufferPoolWithdrawalRequested(msg.sender, amount, bufferWithdrawalRequestTime);
    }

    /// @notice 管理员取消缓冲池提现请求
    function cancelBufferWithdrawal() external onlyOwner {
        if (pendingBufferWithdrawal == 0) revert NoPendingWithdrawal();
        pendingBufferWithdrawal = 0;
        bufferWithdrawalRequestTime = 0;
        emit BufferPoolWithdrawalCancelled(msg.sender);
    }

    /// @notice 管理员执行缓冲池提现（需等待延迟时间）
    function executeBufferWithdrawal() external onlyOwner nonReentrant {
        if (pendingBufferWithdrawal == 0) revert NoPendingWithdrawal();
        if (block.timestamp < bufferWithdrawalRequestTime + BUFFER_WITHDRAWAL_DELAY) revert WithdrawalDelayNotMet();
        if (bufferPool == address(0)) revert BufferPoolNotSet();

        uint256 amount = pendingBufferWithdrawal;
        if (amount > bufferPoolReward) revert InsufficientBufferPool();

        // 清空待处理请求
        pendingBufferWithdrawal = 0;
        bufferWithdrawalRequestTime = 0;

        // 执行提现
        bufferPoolReward -= amount;
        ptc.safeTransfer(bufferPool, amount);
        emit BufferPoolWithdrawn(msg.sender, amount);
    }

    /// @notice 管理员注入额外奖励（第6年开始前可注入，第6年开始后不可注入。）
    /// @param amount 注入的PTC金额
    function addAdditionalReward(uint256 amount) external onlyOwner nonReentrant {
        if (amount == 0) revert AmountZero();
        uint256 start6 = startRewardTimestamp + 5 * SCHEDULE_PERIOD_DURATION;
        if (block.timestamp > start6) revert TooLateForAdditional();
        _updateGlobal();

        totalAdditionalReward += amount;
        ptc.safeTransferFrom(msg.sender, address(this), amount);
        emit AdditionalRewardAdded(msg.sender, amount);
    }

    /// @notice ERC721接收回调：promptNFT仅允许合约自身发起的转入（即通过stake流程），其他NFT无条件接受
    function onERC721Received(
        address operator,
        address,
        uint256,
        bytes calldata
    ) external view override returns (bytes4) {
        if (msg.sender == promptNFT && operator != address(this)) {
            revert UnsolicitedNFTTransfer();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}