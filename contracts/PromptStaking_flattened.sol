// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

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


// OpenZeppelin Contracts (last updated v5.3.0) (token/ERC20/utils/SafeERC20.sol)

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
        _callOptionalReturn(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transferFrom, (from, to, value)));
    }

    /**
     * @dev Variant of {safeTransfer} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransfer(IERC20 token, address to, uint256 value) internal returns (bool) {
        return _callOptionalReturnBool(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Variant of {safeTransferFrom} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransferFrom(IERC20 token, address from, address to, uint256 value) internal returns (bool) {
        return _callOptionalReturnBool(token, abi.encodeCall(token.transferFrom, (from, to, value)));
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
        bytes memory approvalCall = abi.encodeCall(token.approve, (spender, value));

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeCall(token.approve, (spender, 0)));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Performs an {ERC1363} transferAndCall, with a fallback to the simple {ERC20} transfer if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
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
     * has no code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
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
     * Opposedly, when the recipient address (`to`) has code, this function only attempts to call {ERC1363-approveAndCall}
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
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturnBool} that reverts if call fails to meet the requirements.
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        uint256 returnSize;
        uint256 returnValue;
        assembly ("memory-safe") {
            let success := call(gas(), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            // bubble errors
            if iszero(success) {
                let ptr := mload(0x40)
                returndatacopy(ptr, 0, returndatasize())
                revert(ptr, returndatasize())
            }
            returnSize := returndatasize()
            returnValue := mload(0)
        }

        if (returnSize == 0 ? address(token).code.length == 0 : returnValue != 1) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silently catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly ("memory-safe") {
            success := call(gas(), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            returnSize := returndatasize()
            returnValue := mload(0)
        }
        return success && (returnSize == 0 ? address(token).code.length > 0 : returnValue == 1);
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

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

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
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
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
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
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

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: @openzeppelin/contracts/security/Pausable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;


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
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

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
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
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

// File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/utils/ERC721Holder.sol)

pragma solidity ^0.8.20;


/**
 * @dev Implementation of the {IERC721Receiver} interface.
 *
 * Accepts all token transfers.
 * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or
 * {IERC721-setApprovalForAll}.
 */
abstract contract ERC721Holder is IERC721Receiver {
    /**
     * @dev See {IERC721Receiver-onERC721Received}.
     *
     * Always returns `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

// File: contracts/PromptStaking.sol


// PromptStaking.sol
// NFT质押合约 V4.0
//
// 支持1种NFT（Prompt），按权重分配PTC奖励。
// 质押挖矿的总数量：30亿
// 释放规则：第一年25%，第二年15%，第三年12%，第四年10%，第五年8%，从第六年开始把剩余数量按照每年释放50%逐年减半的逻辑释放。
// 奖励计算：每次计算时使用当前基数乘以（已销售NFT数量/NFT发行总数）的比例，已销售数量 = NFT发行总数 - 销售地址持有量。
// 奖励分配：用户收益 = 总释放奖励 × 销售比例，剩余部分进入缓冲池。
// 提现：管理员控制，用户不能自行提现，支持随时为用户提现全部奖励。
// 奖励采用全局积分累加器模型，近似连续产出。
// 支持质押/解押/领取奖励单个或批量操作，支持随时领取全部或部分奖励。
// 支持救援功能，允许合约所有者提取误转入的ERC20代币、ETH和非质押NFT。
// 安全性：使用OpenZeppelin库，包含重入保护和可暂停功能。管理员操作（如救援、调整参数）需要谨慎执行。
// 注意：用户质押NFT数量过多可能导致单次操作gas过高，建议分批操作。
// Author: Thebook

pragma solidity ^0.8.20;








using SafeERC20 for IERC20;

/// @title PromptStaking
/// @author Thebook
contract PromptStaking is Ownable, ReentrancyGuard, Pausable, ERC721Holder {
    // -------------------- 质押结构体 --------------------
    /// @notice 用户单个NFT质押信息
    struct StakeInfo {
        uint256 tokenId;    // NFT编号
        uint256 stakedAt;   // 质押时间戳
    }

    /// @notice 用户质押及奖励信息
    struct UserInfo {
        StakeInfo[] stakes;     // 用户所有质押NFT
        uint256 rewardDebt;     // 上次操作时的accRewardPerNFT * stakeCount
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

    uint256 public constant TOTAL_REWARD = 3000000000 ether; // 总奖励 30亿

    // Reward schedule: 前5年固定，第6年开始动态释放
    uint256 public constant SCHEDULE_PERIODS = 6;
    uint256 public constant SCHEDULE_PERIOD_DURATION = 365 days; // 1 year per period
    // Total PTC to release per period (units: wei)
    uint256[6] public schedulePeriodTotals;

    uint256 public startRewardTimestamp; // 奖励产出起始时间
    uint256 public endRewardTimestamp;   // 奖励产出结束时间

    uint256 public accRewardPerWeight;   // 全局积分累加器（1e18精度）
    uint256 public lastRewardTimestamp;  // 上次奖励计算时间戳
    uint256 public totalStakeCount;      // 全局质押的NFT总数
    uint256 public totalPendingReward;   // 全局待领取奖励总量

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

    // -------------------- 缓冲池提现延迟参数 --------------------
    uint256 public constant BUFFER_WITHDRAWAL_DELAY = 1 days; // 缓冲池提取延迟时间

    // -------------------- 销售比例保护参数 --------------------
    uint256 public maxSalesRatio; // 最大销售比例上限（1e18精度）
    uint256 private lastSalesRatioUpdate; // 上次销售比例更新时间
    uint256 private cachedSalesRatio; // 缓存的销售比例（1e18精度）

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

    /// @notice 设置最大销售比例上限（1e18精度，<=100%）
    /// @param _maxSalesRatio 新的最大销售比例
    function setMaxSalesRatio(uint256 _maxSalesRatio) external onlyOwner {
        require(_maxSalesRatio > 0 && _maxSalesRatio <= 1e18, "invalid maxSalesRatio");
        maxSalesRatio = _maxSalesRatio;
        emit MaxSalesRatioSet(msg.sender, _maxSalesRatio);
    }

    // -------------------- 事件定义 --------------------
    event Staked(address indexed user, uint256 indexed tokenId);
    event Unstaked(address indexed user, uint256 indexed tokenId);
    event Claimed(address indexed user, uint256 amount);
    event EmergencyUnstake(address indexed user, uint256 indexed tokenId);
    event ERC20Rescued(address indexed operator, address token, uint256 amount);
    event ERC721Rescued(address indexed operator, address nft, uint256 tokenId);
    event GASRescued(address indexed operator, uint256 amount);
    event PoolAdded(address indexed admin, uint256 amount);
    event BufferPoolWithdrawn(address indexed admin, uint256 amount);
    event BufferPoolSet(address indexed admin, address newBufferPool);
    event BufferPoolWithdrawalRequested(address indexed admin, uint256 amount, uint256 requestTime);
    event BufferPoolWithdrawalCancelled(address indexed admin);
    event SalesRatioUpdatePaused(address indexed admin);
    event SalesRatioUpdateResumed(address indexed admin);
    event MaxSalesRatioSet(address indexed admin, uint256 maxSalesRatio);
    
    // -------------------- 构造函数 --------------------
    /// @notice 构造函数，初始化PTC和NFT合约地址及奖励起始时间
    /// @param _ptc PTC代币地址
    /// @param _promptNFT Prompt NFT地址
    /// @param _startTime 奖励产出起始时间（0为立即开始）
    /// @param _feeRecipient 手续费接收地址
    /// @param _totalNFTSupply NFT发行总数
    /// @param _salesAddress 销售地址
    constructor(
        address _ptc,
        address _promptNFT,
        uint256 _startTime,
        address _feeRecipient,
        uint256 _totalNFTSupply,
        address _salesAddress
    ) Ownable(msg.sender)
    {
        require(_ptc != address(0), "address zero");
        require(_promptNFT != address(0), "address zero");
        require(_feeRecipient != address(0), "address zero");
        require(_salesAddress != address(0), "address zero");
        require(_totalNFTSupply > 0, "Invalid total NFT supply");

        ptc = IERC20(_ptc);
        promptNFT = _promptNFT;
        feeRecipient = _feeRecipient;
        totalNFTSupply = _totalNFTSupply;
        salesAddress = _salesAddress;

        if (_startTime == 0) {
            startRewardTimestamp = block.timestamp;
        } else {
            require(_startTime >= block.timestamp, "StartTime must be in the future");
            startRewardTimestamp = _startTime;
        }
        // 初始化销售比例缓存
        cachedSalesRatio = 0;
        lastSalesRatioUpdate = 0;
        // 默认允许最高100%销售比例
        maxSalesRatio = 1e18;

        // Initialize schedule totals (单位: 亿 = 100,000,000)
        // 第一年: 25% = 7.5亿
        schedulePeriodTotals[0] = TOTAL_REWARD * 25 / 100;
        // 第二年: 15% = 4.5亿
        schedulePeriodTotals[1] = TOTAL_REWARD * 15 / 100;
        // 第三年: 12% = 3.6亿
        schedulePeriodTotals[2] = TOTAL_REWARD * 12 / 100;
        // 第四年: 10% = 3亿
        schedulePeriodTotals[3] = TOTAL_REWARD * 10 / 100;
        // 第五年: 8% = 2.4亿
        schedulePeriodTotals[4] = TOTAL_REWARD * 8 / 100;
        // 第六年及以后: 动态释放
        schedulePeriodTotals[5] = 0;
    }

    // -------------------- 辅助查询函数 ------------------
    /// @dev 计算当前销售比例（不修改状态）
    /// @return 销售比例（1e18精度）
    function _computeProtectedSalesRatio() internal view returns (uint256) {
        uint256 sold = totalNFTSupply - IERC721(promptNFT).balanceOf(salesAddress);
        uint256 rawRatio = sold * 1e18 / totalNFTSupply;
        return rawRatio > maxSalesRatio ? maxSalesRatio : rawRatio;
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
    /// @return _totalStakeCount 全局质押NFT总数
    /// @return _accRewardPerWeight 全局 accRewardPerWeight
    /// @return _lastRewardTimestamp 上次奖励计算时间戳
    /// @return _startRewardTimestamp 奖励开始时间戳
    /// @return _endRewardTimestamp 奖励结束时间戳
    /// @return _bufferPoolReward 缓冲池总量
    function getSystemStats() external view returns (uint256 _totalStakeCount, uint256 _accRewardPerWeight, uint256 _lastRewardTimestamp, uint256 _startRewardTimestamp, uint256 _endRewardTimestamp, uint256 _bufferPoolReward) {
        _totalStakeCount = totalStakeCount;
        _accRewardPerWeight = accRewardPerWeight;
        _lastRewardTimestamp = lastRewardTimestamp;
        _startRewardTimestamp = startRewardTimestamp;
        _endRewardTimestamp = endRewardTimestamp;
        _bufferPoolReward = bufferPoolReward;
    }

    // -------------------- 核心函数 --------------------

    /// @notice 更新全局奖励状态（分段累加）
    function _updateGlobal() internal {
        uint256 nowTime = block.timestamp > endRewardTimestamp ? endRewardTimestamp : block.timestamp;
        if (lastRewardTimestamp == 0) lastRewardTimestamp = startRewardTimestamp;
        if (nowTime <= lastRewardTimestamp) return;
        if (totalStakeCount == 0) {
            lastRewardTimestamp = nowTime;
            return;
        }
        uint256 from = lastRewardTimestamp;
        uint256 to = nowTime;

        // Compute total emitted up to 'to' and up to 'from', then take difference.
        uint256 reward = _emittedUntil(to) - _emittedUntil(from);
        // 使用受保护的销售比例计算
        uint256 ratio = getProtectedSalesRatio();
        // 调整奖励
        uint256 adjustedReward = reward * ratio / 1e18;
        // 剩余部分进入缓冲池
        bufferPoolReward += reward - adjustedReward;
        // 分配给用户（手续费在提现时扣除）
        accRewardPerWeight += adjustedReward * 1e18 / totalStakeCount;
        lastRewardTimestamp = nowTime;
    }

    /// @dev 计算从奖励开始到时间`t`的总释放量，包含前5年固定释放和第6年开始的动态释放
    /// 修复：使用确定性计算，不依赖合约当前余额，避免循环依赖问题
    function _emittedUntil(uint256 t) public view returns (uint256) {
        if (t <= startRewardTimestamp) return 0;
        if (t > endRewardTimestamp) t = endRewardTimestamp;
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
        // 从第六年开始动态释放
        uint256 start6 = startRewardTimestamp + 5 * periodDuration;
        if (t > start6) {
            uint256 remaining = ptc.balanceOf(address(this)) - totalPendingReward - bufferPoolReward;
            uint256 fraction = 5000; // 50% = 5000/10000
            uint256 yearsPassed = (t - start6) / periodDuration;
            for (uint256 y = 0; y <= yearsPassed && remaining > 0; y++) {
                uint256 releaseThisYear = remaining * fraction / 10000;
                uint256 periodStart = start6 + y * periodDuration;
                if (t <= periodStart) break;
                uint256 periodEnd = periodStart + periodDuration;
                uint256 elapsed = t < periodEnd ? t - periodStart : periodDuration;
                total += releaseThisYear * elapsed / periodDuration;
                remaining -= releaseThisYear;
                if (fraction > 1) {
                    fraction /= 2;
                } else {
                    fraction = 0;
                }
            }
        }
        return total;
    }

    /// @notice 更新指定用户的奖励（全局积分累加器模型）
    // 该函数会在每次质押、解押和领取奖励时调用，确保用户的奖励状态是最新的
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

    /// @notice 内部函数：从用户stakes数组中移除指定tokenId的状态（不处理NFT转移）
    function _removeStakeState(address user, uint256 tokenId) internal {
        uint256 idxPlus = stakeIndex[user][tokenId];
        require(idxPlus != 0, "Token ID not staked");
        uint256 idx = idxPlus - 1;
        StakeInfo[] storage stakes = users[user].stakes;
        uint256 last = stakes.length - 1;
        if (idx != last) {
            uint256 lastTokenId = stakes[last].tokenId;
            stakes[idx] = stakes[last];
            // update moved token index
            stakeIndex[user][lastTokenId] = idx + 1;
        }
        stakes.pop();
        delete stakeIndex[user][tokenId];
        delete nftOwners[tokenId];
        totalStakeCount -= 1;
    }

    // ========== 质押解押相关 ==========
    /// @notice 质押单个NFT
    function stake(uint256 tokenId) external nonReentrant whenNotPaused {
        _updateReward(msg.sender);
        require(nftOwners[tokenId] == address(0), "Already staked");
        // push and record index+1
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
    function stakeBatch(uint256[] calldata tokenIds) external nonReentrant whenNotPaused {
        require(tokenIds.length > 0, "No token IDs provided");
        _updateReward(msg.sender);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            require(nftOwners[tokenId] == address(0), "Already staked");
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
        require(nftOwners[tokenId] == msg.sender, "Not stake owner");
        _removeStakeState(msg.sender, tokenId);
        emit Unstaked(msg.sender, tokenId);
        IERC721(promptNFT).safeTransferFrom(address(this), msg.sender, tokenId);
    }
    
    /// @notice 批量解押NFT
    function unstakeBatch(uint256[] calldata tokenIds) external nonReentrant whenNotPaused {
        require(tokenIds.length > 0, "No token IDs provided");
        _updateReward(msg.sender);
        for (uint256 k = 0; k < tokenIds.length; k++) {
            uint256 tokenId = tokenIds[k];
            require(nftOwners[tokenId] == msg.sender, "Not stake owner");
            _removeStakeState(msg.sender, tokenId);
            emit Unstaked(msg.sender, tokenId);
            IERC721(promptNFT).safeTransferFrom(address(this), msg.sender, tokenId);
        }
    }

    /// @notice 一键解押用户所有NFT
    /// 注意：用户质押nft数量太多可能导致gas高甚至超过上限而无法执行
    function unstakeAll() external nonReentrant whenNotPaused {
        _updateReward(msg.sender);
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        require(stakes.length > 0, "No NFT staked");
        uint256 count = stakes.length;
        // pop from end and remove mappings
        while (stakes.length > 0) {
            uint256 tid = stakes[stakes.length - 1].tokenId;
            stakes.pop();
            delete stakeIndex[msg.sender][tid];
            delete nftOwners[tid];
            emit Unstaked(msg.sender, tid);
            IERC721(promptNFT).safeTransferFrom(address(this), msg.sender, tid);
        }
        totalStakeCount -= count;
    }

    /// @notice 管理员为用户提现所有可领取的PTC奖励（扣除手续费）
    /// @param user 用户地址
    /// @param feeRate 手续费率，单位1e4（100=1%）
    function withdrawForUser(address user, uint256 feeRate) external nonReentrant whenNotPaused onlyOwner {
        require(feeRate <= 10000, "Invalid fee rate");
        _updateReward(user);
        UserInfo storage u = users[user];
        uint256 totalPending = u.pendingReward;
        require(totalPending > 0, "No claimable reward");

        uint256 amountToClaim = totalPending;
        require(ptc.balanceOf(address(this)) >= amountToClaim, "Insufficient balance");

        // 计算手续费
        uint256 fee = amountToClaim * feeRate / 1e4;
        uint256 netAmount = amountToClaim - fee;

        // 扣减用户 pending
        u.pendingReward -= amountToClaim;
        totalPendingReward -= amountToClaim;
        u.claimed += amountToClaim;

        emit Claimed(user, netAmount);
        ptc.safeTransfer(user, netAmount);
        // 手续费转给 feeRecipient
        if (fee > 0) {
            ptc.safeTransfer(feeRecipient, fee);
        }
    }

    /// @notice 管理员为用户提现指定数量的PTC奖励（扣除手续费）
    /// @param user 用户地址
    /// @param amount 提现金额
    /// @param feeRate 手续费率，单位1e4（100=1%）
    function withdrawForUser(address user, uint256 amount, uint256 feeRate) external nonReentrant whenNotPaused onlyOwner {
        require(feeRate <= 10000, "Invalid fee rate");
        _updateReward(user);
        UserInfo storage u = users[user];

        require(amount > 0, "Amount must be greater than zero");
        uint256 totalPending = claimable(user);
        require(amount <= totalPending, "Amount exceeds claimable reward");
        require(ptc.balanceOf(address(this)) >= amount, "Insufficient balance");

        // 计算手续费
        uint256 fee = amount * feeRate / 1e4;
        uint256 netAmount = amount - fee;

        u.pendingReward -= amount;
        totalPendingReward -= amount;
        u.claimed += amount;

        ptc.safeTransfer(user, netAmount);
        emit Claimed(user, netAmount);
        // 手续费转给 feeRecipient
        if (fee > 0) {
            ptc.safeTransfer(feeRecipient, fee);
        }
    }

    /// @notice 管理员批量为用户提现所有可领取的PTC奖励（扣除手续费）
    /// @param _users 用户地址数组
    /// @param feeRates 手续费率数组，单位1e4（100=1%），对应每个用户
    function withdrawForUsers(address[] calldata _users, uint256[] calldata feeRates) external nonReentrant whenNotPaused onlyOwner {
        require(_users.length == feeRates.length, "Users and feeRates length mismatch");
        for (uint256 i = 0; i < _users.length; i++) {
            require(feeRates[i] <= 10000, "Invalid fee rate");
        }
        for (uint256 i = 0; i < _users.length; i++) {
            address user = _users[i];
            uint256 feeRate = feeRates[i];
            _updateReward(user);
            UserInfo storage u = users[user];
            uint256 totalPending = u.pendingReward;
            if (totalPending == 0) continue;

            uint256 amountToClaim = totalPending;
            if (ptc.balanceOf(address(this)) < amountToClaim) continue; // 跳过不足的

            // 计算手续费
            uint256 fee = amountToClaim * feeRate / 1e4;
            uint256 netAmount = amountToClaim - fee;

            u.pendingReward -= amountToClaim;
            totalPendingReward -= amountToClaim;
            u.claimed += amountToClaim;

            emit Claimed(user, netAmount);
            ptc.safeTransfer(user, netAmount);
            // 手续费转给 feeRecipient
            if (fee > 0) {
                ptc.safeTransfer(feeRecipient, fee);
            }
        }
    }

    /// @notice 管理员批量为用户提现指定数量的PTC奖励（扣除手续费）
    /// @param _users 用户地址数组
    /// @param amounts 提现金额数组，对应每个用户
    /// @param feeRates 手续费率数组，单位1e4（100=1%），对应每个用户
    function withdrawForUsers(address[] calldata _users, uint256[] calldata amounts, uint256[] calldata feeRates) external nonReentrant whenNotPaused onlyOwner {
        require(_users.length == amounts.length && amounts.length == feeRates.length, "Length mismatch");
        for (uint256 i = 0; i < feeRates.length; i++) {
            require(feeRates[i] <= 10000, "Invalid fee rate");
        }
        for (uint256 i = 0; i < _users.length; i++) {
            address user = _users[i];
            uint256 amount = amounts[i];
            uint256 feeRate = feeRates[i];
            if (amount == 0) continue;

            _updateReward(user);
            UserInfo storage u = users[user];
            uint256 totalPending = claimable(user);
            if (amount > totalPending) continue;
            if (ptc.balanceOf(address(this)) < amount) continue;

            // 计算手续费
            uint256 fee = amount * feeRate / 1e4;
            uint256 netAmount = amount - fee;

            u.pendingReward -= amount;
            totalPendingReward -= amount;
            u.claimed += amount;

            ptc.safeTransfer(user, netAmount);
            emit Claimed(user, netAmount);
            // 手续费转给 feeRecipient
            if (fee > 0) {
                ptc.safeTransfer(feeRecipient, fee);
            }
        }
    }
        
    /// @notice 查询用户当前可领取的PTC奖励（包含未更新周期）
    function claimable(address user) public view returns (uint256) {
        UserInfo storage u = users[user];
        uint256 stakeCount = u.stakes.length;
        uint256 nowTime = block.timestamp > endRewardTimestamp ? endRewardTimestamp : block.timestamp;
        uint256 acc = accRewardPerWeight;
        if (nowTime > lastRewardTimestamp && totalStakeCount > 0) {
            uint256 ratio = getProtectedSalesRatioView();
            uint256 reward = _emittedUntil(nowTime) - _emittedUntil(lastRewardTimestamp);
            uint256 adjustedReward = reward * ratio / 1e18;
            acc += adjustedReward * 1e18 / totalStakeCount;
        }
        return u.pendingReward + (stakeCount * (acc - u.rewardDebt) / 1e18);
    }

    /// @notice Public view of total emitted tokens up to time `t` (t clipped to schedule end).
    function emittedUntil(uint256 t) external view returns (uint256) {
        return _emittedUntil(t);
    }

    /// @notice 救援合约内误转入的ERC20代币（禁止PTC）
    function rescueERC20(address token, uint256 amount) external nonReentrant onlyOwner {
        require(token != address(ptc), "Cannot rescue PTC");
        require(token != address(0), "Zero address");
        emit ERC20Rescued(msg.sender, token, amount);
        IERC20(token).safeTransfer(owner(), amount);
    }

    /// @notice 救援合约内误转入的主网币
    function rescueGAS(uint256 amount) external nonReentrant onlyOwner {
        require(amount <= address(this).balance, "Amount exceeds balance");
        emit GASRescued(msg.sender, amount);
        (bool success, ) = owner().call{value: amount}("");
        require(success, "Transfer failed");
    }

    /// @notice 救援合约内误转入的ERC721 NFT（禁止Prompt质押NFT）
    function rescueERC721(address nft, uint256 tokenId) external nonReentrant onlyOwner {
        require(nft != promptNFT, "Cannot rescue staked NFT type");
        require(nft != address(0), "Zero address");
        emit ERC721Rescued(msg.sender, nft, tokenId);
        IERC721(nft).safeTransferFrom(address(this), owner(), tokenId);
    }

    /// @notice 用户紧急批量解押（仅暂停时可用，不结算奖励）
    /// 修复：不重置rewardDebt，避免用户奖励丢失
    function emergencyUnstakeBatch(uint256 count) external nonReentrant whenPaused {
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        require(stakes.length > 0, "No NFT staked");
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
        // 移除：不再重置rewardDebt，避免奖励丢失
        // users[msg.sender].rewardDebt = accRewardPerWeight;
    }

    /// @notice 平台管理员（owner）随时解押任意NFT返回至原质押用户（含结算）
    /// @dev 仅owner可调，无需用户授权，适用于特殊情况（如到期、司法、合规等）
    /// @param tokenIds NFT编号列表
    function unstakeBatchPlatform(uint256[] calldata tokenIds) external nonReentrant whenNotPaused onlyOwner {
        require(tokenIds.length > 0, "No token IDs provided");
        for (uint256 batchIdx = 0; batchIdx < tokenIds.length; batchIdx++) {
            uint256 tokenId = tokenIds[batchIdx];
            address user = nftOwners[tokenId];
            require(user != address(0), "NFT not staked");
            _updateReward(user);
            _removeStakeState(user, tokenId);
            emit Unstaked(user, tokenId);
            IERC721(promptNFT).safeTransferFrom(address(this), user, tokenId);
        }
    }

    /// @notice 设置手续费接收地址
    /// @param _feeRecipient 新的手续费接收地址
    function setFeeRecipient(address _feeRecipient) external onlyOwner {
        require(_feeRecipient != address(0), "Zero address");
        feeRecipient = _feeRecipient;
    }

    /// @notice 管理员添加PTC到池子
    /// @param amount 添加的PTC数量
    function addToPool(uint256 amount) external onlyOwner nonReentrant {
        require(amount > 0, "Amount must be greater than zero");
        ptc.safeTransferFrom(msg.sender, address(this), amount);
        emit PoolAdded(msg.sender, amount);
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
        require(_bufferPool != address(0), "Zero address");
        bufferPool = _bufferPool;
        emit BufferPoolSet(msg.sender, _bufferPool);
    }

    /// @notice 管理员请求提现缓冲池奖励（时间锁保护）
    /// @param amount 请求提现的金额
    function requestBufferWithdrawal(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= bufferPoolReward, "Insufficient buffer pool reward");
        require(bufferPool != address(0), "Buffer pool not set");

        pendingBufferWithdrawal = amount;
        bufferWithdrawalRequestTime = block.timestamp;
        emit BufferPoolWithdrawalRequested(msg.sender, amount, bufferWithdrawalRequestTime);
    }

    /// @notice 管理员执行缓冲池提现（需等待延迟时间）
    function executeBufferWithdrawal() external onlyOwner nonReentrant {
        require(pendingBufferWithdrawal > 0, "No pending withdrawal");
        require(block.timestamp >= bufferWithdrawalRequestTime + BUFFER_WITHDRAWAL_DELAY,
                "Withdrawal delay not met");
        require(bufferPool != address(0), "Buffer pool not set");

        uint256 amount = pendingBufferWithdrawal;
        require(amount <= bufferPoolReward, "Insufficient buffer pool reward");

        // 清空待处理请求
        pendingBufferWithdrawal = 0;
        bufferWithdrawalRequestTime = 0;

        // 执行提现
        bufferPoolReward -= amount;
        ptc.safeTransfer(bufferPool, amount);
        emit BufferPoolWithdrawn(msg.sender, amount);
    }
}