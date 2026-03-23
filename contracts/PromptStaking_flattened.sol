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
// NFT质押合约
//
// 支持三种NFT（Memory、Prompt、Memes），按权重分配PTC奖励。
// 权重：Prompt=50，Memory=1，Memes=2500。
// 质押挖矿的总数量：30亿
// 总周期数量：共 6 个周期T1-T6，每个周期是2年，周期内线性释放，一共 12 年发完。
// 周期T1 释放12亿
// 周期T2 释放9亿
// 周期T3 释放4.5亿
// 周期T4 释放2.25亿
// 周期T5 释放1.125亿
// 周期T6 释放1.125亿
// 提现限制：从整体生息开始时间之后的t时间内，用户最多只能提取x比例。t时间外，用户可以提取全部。。

// 奖励采用全局积分累加器模型，近似连续产出。
// 支持质押/解押/领取奖励单个或批量操作，支持随时领取全部或部分奖励。
// 支持批量质押和解押NFT，支持同类型和不同类型的批量操作。
// 支持救援功能，允许合约所有者提取误转入的ERC20代币、ETH和非质押NFT。

pragma solidity ^0.8.20;








using SafeERC20 for IERC20;

/// @title PromptStaking
/// @author Thebook
contract PromptStaking is Ownable, ReentrancyGuard, Pausable, ERC721Holder {
    // -------------------- 质押结构体 --------------------
    /// @notice 用户单个NFT质押信息
    struct StakeInfo {
        address nft;        // NFT合约地址
        uint256 tokenId;    // NFT编号
        uint256 stakedAt;   // 质押时间戳
    }

    /// @notice 用户质押及奖励信息
    struct UserInfo {
        StakeInfo[] stakes;     // 用户所有质押NFT
        uint256 weight;         // 当前总权重
        uint256 rewardDebt;     // 上次操作时的accRewardPerWeight * weight
        uint256 pendingReward;  // 待领取奖励
        uint256 claimed;        // 累计已领取奖励
    }

    /// @notice 用户质押信息
    mapping(address => UserInfo) public users;

    /// @notice 质押反向索引，记录每个NFT(tokenId)当前质押所属用户
    mapping(address => mapping(uint256 => address)) public nftOwners;

    // -------------------- 合约参数 --------------------
    IERC20 public immutable ptc;           // PTC代币合约
    address public immutable memoryNFT;    // Memory NFT合约地址
    address public immutable promptNFT;    // Prompt NFT合约地址
    address public immutable memesNFT;     // Memes NFT合约地址

    // Reward schedule: 6 periods (T1..T6), each 2 years, linear release within each period.
    uint256 public constant SCHEDULE_PERIODS = 6;
    uint256 public constant SCHEDULE_PERIOD_DURATION = 2 * 365 days; // 2 years per period
    // Total PTC to release per period (units: wei)
    uint256[6] public schedulePeriodTotals;

    uint256 public startRewardTimestamp; // 奖励产出起始时间
    uint256 public endRewardTimestamp;   // 奖励产出结束时间

    uint256 public accRewardPerWeight;   // 全局积分累加器（1e18精度）
    uint256 public lastRewardTimestamp;  // 上次奖励计算时间戳
    uint256 public totalWeight;          // 全局总权重（所有用户权重之和）

    // -------------------- 提现限制 --------------------
    // 限制定义：从全局奖励开始时间 `startRewardTimestamp` 开始的前 `withdrawalLimitDuration` 秒内，
    // 用户每次最多可提取其 `pendingReward` 的 `withdrawalLimitRate/10000`；在该限制期之后，用户可以提取全部。
    uint256 public withdrawalLimitDuration; // 提现限制时间，单位秒（相对于 `startRewardTimestamp`）
    uint256 public withdrawalLimitRate;     // 允许在限制时间内提取的最大比例，单位1e4（10000=100%）

    uint256 public pendingWithdrawalLimitDuration; // 待变更的提现限制时间
    uint256 public pendingWithdrawalLimitRate;     // 待变更的提现限制比例
    uint256 public withdrawalLimitChangeTime;      // 提现限制变更时间锁
    uint256 public constant WITHDRAWAL_CHANGE_DELAY = 1 days;// 提现限制变更时间锁延迟（1天）

    // -------------------- 手续费参数 --------------------
    address public feeRecipient; // 手续费接收地址
    uint256 public feeRate;      // 手续费率，单位1e4（100=1%）
    uint256 public pendingFee;   // 累计未提取手续费

    address public pendingFeeRecipient; // 待变更的手续费接收地址
    uint256 public pendingFeeRate;      // 待变更的手续费率
    uint256 public feeRateChangeTime;   // 手续费变更时间锁
    uint256 public constant FEE_CHANGE_DELAY = 1 days;// 手续费变更时间锁延迟（1天）

    // -------------------- 事件定义 --------------------
    event Staked(address indexed user, address indexed nft, uint256 tokenId);
    event Unstaked(address indexed user, address indexed nft, uint256 tokenId);
    event Claimed(address indexed user, uint256 amount);
    event EmergencyUnstake(address indexed user, address indexed nft, uint256 tokenId);
    event ERC20Rescued(address indexed operator, address token, uint256 amount);
    event ERC721Rescued(address indexed operator, address nft, uint256 tokenId);
    event GASRescued(address indexed operator, uint256 amount);
    event FeeRateProposed(address indexed proposer, address newRecipient, uint256 newRate, uint256 executeTime);
    event FeeRateChanged(address indexed executor, address newRecipient, uint256 newRate);
    event FeeClaimed(address indexed recipient, uint256 amount);
    event WithdrawalLimitProposed(address indexed proposer, uint256 newDuration, uint256 newRate, uint256 executeTime);
    event WithdrawalLimitChanged(address indexed executor, uint256 newDuration, uint256 newRate);

    // -------------------- 构造函数 --------------------
    /// @notice 构造函数，初始化PTC和NFT合约地址及奖励起始时间
    /// @param _ptc PTC代币地址
    /// @param _memoryNFT Memory NFT地址
    /// @param _promptNFT Prompt NFT地址
    /// @param _memesNFT Memes NFT地址
    /// @param _startTime 奖励产出起始时间（0为立即开始）
    /// @param _feeRecipient 手续费接收地址
    /// @param _withdrawalLimitDuration 提现限制窗口，单位秒（相对于 `startRewardTimestamp`）
    /// @param _withdrawalLimitRate 提现限制内允许提取比例，单位1e4（10000=100%）
    constructor(
        address _ptc,
        address _memoryNFT,
        address _promptNFT,
        address _memesNFT,
        uint256 _startTime,
        address _feeRecipient,
        uint256 _withdrawalLimitDuration,
        uint256 _withdrawalLimitRate // in 1e4, 10000 == 100%
    ) Ownable(msg.sender) {
        require(_ptc != address(0), "address zero");
        require(_memoryNFT != address(0), "address zero");
        require(_promptNFT != address(0), "address zero");
        require(_memesNFT != address(0), "address zero");
        require(_feeRecipient != address(0), "address zero");
        require(_withdrawalLimitRate <= 10000, "Invalid withdrawal rate");

        ptc = IERC20(_ptc);
        memoryNFT = _memoryNFT;
        promptNFT = _promptNFT;
        memesNFT = _memesNFT;
        feeRecipient = _feeRecipient;

        // 初始化提现限制
        withdrawalLimitDuration = _withdrawalLimitDuration;
        withdrawalLimitRate = _withdrawalLimitRate;

        if (_startTime == 0) {
            startRewardTimestamp = block.timestamp;
        } else {
            require(_startTime >= block.timestamp, "StartTime must be in the future");
            startRewardTimestamp = _startTime;
        }
        // Set end timestamp to cover all schedule periods (6 * 2 years = 12 years)
        endRewardTimestamp = startRewardTimestamp + SCHEDULE_PERIODS * SCHEDULE_PERIOD_DURATION;

        // Initialize schedule totals (单位: 亿 = 100,000,000)
        // T1: 12亿, T2: 9亿, T3: 4.5亿, T4: 2.25亿, T5: 1.125亿, T6: 1.125亿
        schedulePeriodTotals[0] = 1200000000 ether; // 12亿
        schedulePeriodTotals[1] = 900000000 ether;  // 9亿
        schedulePeriodTotals[2] = 450000000 ether;  // 4.5亿
        schedulePeriodTotals[3] = 225000000 ether;  // 2.25亿
        schedulePeriodTotals[4] = 112500000 ether;  // 1.125亿
        schedulePeriodTotals[5] = 112500000 ether;  // 1.125亿
    }

    // -------------------- 辅助查询函数 ------------------
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
    function getStakedNFTOwner(address nft, uint256 tokenId) external view returns (address) {
        return nftOwners[nft][tokenId];
    }

    /// @notice 获取用户概览信息，便于链下一次性读取常用字段
    /// @param user 用户地址
    /// @return stakeCount 质押项数量
    /// @return weight 总权重
    /// @return claimableAmount 当前可领取（包含未写入 pending 的部分）
    /// @return claimed 已累计领取总量
    function getUserSummary(address user) external view returns (uint256 stakeCount, uint256 weight, uint256 claimableAmount, uint256 claimed) {
        stakeCount = users[user].stakes.length;
        weight = users[user].weight;
        claimableAmount = claimable(user);
        claimed = users[user].claimed;
    }

    /// @notice 获取提现限制配置信息及当前是否处于限制期
    /// @return duration 限制期时长
    /// @return rate 限制内允许提取比例，单位 1e4（10000 == 100%）
    /// @return restricted 当前是否仍在限制期
    function getWithdrawalLimitInfo() external view returns (uint256 duration, uint256 rate, bool restricted) {
        duration = withdrawalLimitDuration;
        rate = withdrawalLimitRate;
        // 仅在 startRewardTimestamp 至 startRewardTimestamp + duration 之间视为限制期
        restricted = (duration != 0 && block.timestamp >= startRewardTimestamp && block.timestamp < startRewardTimestamp + duration);
    }

    /// @notice 获取合约关键全局统计信息，便于链下监控
    /// @return _totalWeight 全局总权重
    /// @return _accRewardPerWeight 全局 accRewardPerWeight
    /// @return _lastRewardTimestamp 上次奖励计算时间戳
    /// @return _startRewardTimestamp 奖励开始时间戳
    /// @return _endRewardTimestamp 奖励结束时间戳
    function getSystemStats() external view returns (uint256 _totalWeight, uint256 _accRewardPerWeight, uint256 _lastRewardTimestamp, uint256 _startRewardTimestamp, uint256 _endRewardTimestamp) {
        _totalWeight = totalWeight;
        _accRewardPerWeight = accRewardPerWeight;
        _lastRewardTimestamp = lastRewardTimestamp;
        _startRewardTimestamp = startRewardTimestamp;
        _endRewardTimestamp = endRewardTimestamp;
    }

    // -------------------- 核心函数 --------------------
    /// @notice 修饰符：检查NFT是否为支持的三种NFT之一
    modifier onlySupportedNFT(address nft) {
        require(nft == promptNFT || nft == memoryNFT || nft == memesNFT, "Unsupported NFT");
        _;
    }

    /// @notice 内部函数：判断NFT是否为支持的三种NFT
    function _isSupportedNFT(address nft) internal view returns (bool) {
        return nft == memoryNFT || nft == promptNFT || nft == memesNFT;
    }

    /// @notice 内部函数：获取NFT权重
    function _getWeight(address nft) internal view returns (uint256) {
        if (nft == promptNFT) return 50;
        if (nft == memoryNFT) return 1;
        if (nft == memesNFT) return 2500;
        revert("Unsupported NFT");
    }

    /// @notice 更新全局奖励状态（分段累加，自动处理减半）
    function _updateGlobal() internal {
        uint256 nowTime = block.timestamp > endRewardTimestamp ? endRewardTimestamp : block.timestamp;
        if (lastRewardTimestamp == 0) lastRewardTimestamp = startRewardTimestamp;
        if (nowTime <= lastRewardTimestamp) return;
        if (totalWeight == 0) {
            lastRewardTimestamp = nowTime;
            return;
        }
        uint256 from = lastRewardTimestamp;
        uint256 to = nowTime;

        // Compute total emitted up to 'to' and up to 'from', then take difference.
        uint256 reward = _emittedUntil(to) - _emittedUntil(from);
        // 计算本次应收手续费
        uint256 fee = reward * feeRate / 1e4;
        pendingFee += fee;
        // 分配给用户
        accRewardPerWeight += (reward - fee) * 1e18 / totalWeight;
        lastRewardTimestamp = nowTime;
    }

    /// @notice Returns total amount emitted from schedule start up to time `t`
    function _emittedUntil(uint256 t) public view returns (uint256) {
        if (t <= startRewardTimestamp) return 0;
        if (t > endRewardTimestamp) t = endRewardTimestamp;
        uint256 total = 0;
        uint256 periodDuration = SCHEDULE_PERIOD_DURATION;
        for (uint256 i = 0; i < SCHEDULE_PERIODS; i++) {
            uint256 periodStart = startRewardTimestamp + i * periodDuration;
            if (t <= periodStart) break;
            uint256 periodEnd = periodStart + periodDuration;
            uint256 elapsed = t < periodEnd ? t - periodStart : periodDuration;
            total += schedulePeriodTotals[i] * elapsed / periodDuration;
        }
        return total;
    }

    /// @notice 更新指定用户的奖励（全局积分累加器模型）
    // 该函数会在每次质押、解押和领取奖励时调用，确保用户的奖励状态是最新的
    function _updateReward(address user) internal {
        _updateGlobal();
        UserInfo storage u = users[user];
        if (u.weight > 0) {
            uint256 pending = u.weight * (accRewardPerWeight - u.rewardDebt) / 1e18;
            u.pendingReward += pending;
        }
        u.rewardDebt = accRewardPerWeight;
    }

    /// @notice 内部函数：计算在当前提现限制下，用户最多可领取的数量
    /// 注意，调用本函数前，须确保刚执行过_updateReward(msg.sender)以同步用户的 u.pendingReward
    function _allowedClaimAmount(UserInfo storage u) internal view returns (uint256) {
        uint256 totalPending = u.pendingReward;
        if (withdrawalLimitDuration == 0) return totalPending;
        // 如果不在限制窗口内：可以提取全部
        if (block.timestamp >= startRewardTimestamp + withdrawalLimitDuration) {
            return totalPending;
        }
        // 基数包含用户已累计领走的数量与当前可领取的数量（即“已提取 + 待提取”）
        uint256 baseTotal = u.claimed + totalPending; // 包含历史已领取 + 当前可领
        uint256 allowedTotal = baseTotal * withdrawalLimitRate / 1e4;
        if (allowedTotal <= u.claimed) return 0;
        uint256 remaining = allowedTotal - u.claimed;
        return totalPending <= remaining ? totalPending : remaining;
    }

    /// @notice 查询在提现限制下用户当前允许领取的数量
    /// @dev 基数为 `已累计领取 (u.claimed)` + `当前可领取 (claimable(user))`。
    function allowedClaimable(address user) external view returns (uint256) {
        uint256 total = claimable(user);
        UserInfo storage u = users[user];
        if (withdrawalLimitDuration == 0) return total;
        // 如果不在限制窗口期：可以提取全部
        if (block.timestamp >= startRewardTimestamp + withdrawalLimitDuration) return total;
        uint256 baseTotal = u.claimed + total;
        uint256 allowedTotal = baseTotal * withdrawalLimitRate / 1e4;
        if (allowedTotal <= u.claimed) return 0;
        uint256 remain = allowedTotal - u.claimed;
        return remain <= total ? remain : total;
    }

    // ========== 质押解押相关 ==========
    /// @notice 质押单个NFT
    function stake(address nft, uint256 tokenId) external nonReentrant whenNotPaused onlySupportedNFT(nft) {
        _updateReward(msg.sender); // 更新用户奖励
        uint256 weight = _getWeight(nft); // 获取NFT的权重
        users[msg.sender].stakes.push(StakeInfo({
            nft: nft,
            tokenId: tokenId,
            stakedAt: block.timestamp // 记录质押时间戳
        }));

        users[msg.sender].weight += weight; // 更新用户权重
        totalWeight += weight; // 更新总权重

    nftOwners[nft][tokenId] = msg.sender;

        emit Staked(msg.sender, nft, tokenId); // 触发质押事件
        IERC721(nft).safeTransferFrom(msg.sender, address(this), tokenId); // 转移NFT到合约地址
    }

    /// @notice 批量质押同类型NFT
    function stakeBatch(address nft, uint256[] calldata tokenIds) external nonReentrant whenNotPaused onlySupportedNFT(nft) {
        require(tokenIds.length > 0, "No token IDs provided");
        _updateReward(msg.sender);
        uint256 weight = _getWeight(nft);
        uint256 totalAdd = weight * tokenIds.length;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            users[msg.sender].stakes.push(StakeInfo(nft, tokenId, block.timestamp));
            nftOwners[nft][tokenId] = msg.sender;
        }
        users[msg.sender].weight += totalAdd;
        totalWeight += totalAdd;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            emit Staked(msg.sender, nft, tokenIds[i]);
            IERC721(nft).safeTransferFrom(msg.sender, address(this), tokenIds[i]);
        }
    }

    /// @notice 批量质押不同类型NFT
    function stakeBatch(address[] calldata nfts, uint256[] calldata tokenIds) external nonReentrant whenNotPaused {
        require(nfts.length == tokenIds.length, "Length mismatch");
        _updateReward(msg.sender);
        uint256 totalAdd = 0;
        for (uint256 i = 0; i < nfts.length; i++) {
            address nft = nfts[i];
            require(_isSupportedNFT(nft), "Unsupported NFT");
            uint256 weight = _getWeight(nft);
            users[msg.sender].stakes.push(StakeInfo(nft, tokenIds[i], block.timestamp));
            nftOwners[nft][tokenIds[i]] = msg.sender;
            totalAdd += weight;
        }
        users[msg.sender].weight += totalAdd;
        totalWeight += totalAdd;

        for (uint256 i = 0; i < nfts.length; i++) {
            emit Staked(msg.sender, nfts[i], tokenIds[i]);
            IERC721(nfts[i]).safeTransferFrom(msg.sender, address(this), tokenIds[i]);
        }
    }

    /// @notice 解押单个NFT
    function unstake(address nft, uint256 tokenId) external nonReentrant whenNotPaused onlySupportedNFT(nft) {
        _updateReward(msg.sender);
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        uint256 len = stakes.length;
        for (uint256 i = 0; i < len; i++) {
            if (stakes[i].nft == nft && stakes[i].tokenId == tokenId) {
                uint256 weight = _getWeight(nft);
                // 状态更新
                totalWeight -= weight;
                users[msg.sender].weight -= weight;
                if (i != len - 1) {
                    stakes[i] = stakes[len - 1];
                }
                stakes.pop();
                delete nftOwners[nft][tokenId];
                emit Unstaked(msg.sender, nft, tokenId);

                IERC721(nft).safeTransferFrom(address(this), msg.sender, tokenId);
                return;
            }
        }
        revert("Token ID not found in stake");
    }

    /// @notice 批量解押同类型NFT
    function unstakeBatch(address nft, uint256[] calldata tokenIds) external nonReentrant whenNotPaused onlySupportedNFT(nft) {
        require(tokenIds.length > 0, "No token IDs provided");
        _updateReward(msg.sender);
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        for (uint256 k = 0; k < tokenIds.length; k++) {
            uint256 tokenId = tokenIds[k];
            bool found = false;
            for (uint256 i = stakes.length; i > 0; i--) {
                uint256 idx = i - 1;
                if (stakes[idx].nft == nft && stakes[idx].tokenId == tokenId) {
                    uint256 weight = _getWeight(nft);
                    totalWeight -= weight;
                    users[msg.sender].weight -= weight;
                    if (idx != stakes.length - 1) {
                        stakes[idx] = stakes[stakes.length - 1];
                    }
                    stakes.pop();
                    delete nftOwners[nft][tokenId];
                    found = true;
                    emit Unstaked(msg.sender, nft, tokenId);
                    IERC721(nft).safeTransferFrom(address(this), msg.sender, tokenId);
                    break;
                }
            }
            require(found, "Token ID not found in stake");
        }
    }

    /// @notice 解押同类型所有NFT
    // 注意：用户质押nft数量太多可能导致gas高甚至超过上限而无法执行
    function unstake(address nft) external nonReentrant whenNotPaused onlySupportedNFT(nft) {
        _updateReward(msg.sender);
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        require(stakes.length > 0, "No NFT staked");
        for (uint256 i = stakes.length; i > 0; i--) {
            uint256 idx = i - 1;
            if (stakes[idx].nft == nft) {

                uint256 weight = _getWeight(nft);
                uint256 tid = stakes[idx].tokenId;
                totalWeight -= weight;
                users[msg.sender].weight -= weight;

                if (idx != stakes.length - 1) {
                    stakes[idx] = stakes[stakes.length - 1];
                }
                stakes.pop();
                delete nftOwners[nft][tid];

                emit Unstaked(msg.sender, nft, tid);
                IERC721(nft).safeTransferFrom(address(this), msg.sender, tid);
            }
        }
    }

    /// @notice 一键解押用户所有NFT
    /// 注意：用户质押nft数量太多可能导致gas高甚至超过上限而无法执行
    function unstakeAll() external nonReentrant whenNotPaused {
        _updateReward(msg.sender);
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        require(stakes.length > 0, "No NFT staked");
        for (uint256 i = stakes.length; i > 0; i--) {
            uint256 idx = i - 1;
            uint256 weight = _getWeight(stakes[idx].nft);
            address nftAddr = stakes[idx].nft;
            uint256 tid = stakes[idx].tokenId;
            totalWeight -= weight;
            users[msg.sender].weight -= weight;

            if (idx != stakes.length - 1) {
                stakes[idx] = stakes[stakes.length - 1];
            }
            stakes.pop();
            delete nftOwners[nftAddr][tid];
            emit Unstaked(msg.sender, nftAddr, tid);
            IERC721(nftAddr).safeTransferFrom(address(this), msg.sender, tid);
        }
    }

    /// @notice 领取所有可领取的PTC奖励
    function claim() external nonReentrant whenNotPaused {
        _updateReward(msg.sender);
        UserInfo storage u = users[msg.sender];
        // 使用 claimable() 作为权威的可领取值（包含未写入 pending 的部分）
        uint256 totalPending = u.pendingReward;
        require(totalPending > 0, "No claimable reward");

        uint256 allowed = _allowedClaimAmount(u);
        require(allowed > 0, "Claim amount limited to zero");

        uint256 amountToClaim = totalPending <= allowed ? totalPending : allowed;
        require(ptc.balanceOf(address(this)) >= amountToClaim, "Insufficient balance");

        // 扣减用户 pending（_updateReward 已保证 u.pendingReward 与 claimable 一致）
        u.pendingReward -= amountToClaim;
        u.claimed += amountToClaim;

        emit Claimed(msg.sender, amountToClaim);
        ptc.safeTransfer(msg.sender, amountToClaim);
    }

    /// @notice 领取指定数量的PTC奖励
    function claim(uint256 amount) external nonReentrant whenNotPaused {
        _updateReward(msg.sender); // 更新用户奖励
        UserInfo storage u = users[msg.sender];

        require(amount > 0, "Amount must be greater than zero");
        // 使用 claimable() 作为权威的可领取值
        uint256 totalPending = claimable(msg.sender);
        require(amount <= totalPending, "Amount exceeds claimable reward");

        uint256 allowed = _allowedClaimAmount(u);
        require(amount <= allowed, "Amount exceeds allowed claim limit");
        require(ptc.balanceOf(address(this)) >= amount, "Insufficient balance");

        u.pendingReward -= amount;
        u.claimed += amount;

        ptc.safeTransfer(msg.sender, amount); // 转移PTC到用户地址
        emit Claimed(msg.sender, amount); // 触发领取奖励事件
    }

    /// @notice 查询用户当前可领取的PTC奖励（包含未更新周期）
    function claimable(address user) public view returns (uint256) {
        UserInfo storage u = users[user];
        uint256 nowTime = block.timestamp > endRewardTimestamp ? endRewardTimestamp : block.timestamp;
        uint256 acc = accRewardPerWeight;
        if (nowTime > lastRewardTimestamp && totalWeight > 0) {
            uint256 reward = _emittedUntil(nowTime) - _emittedUntil(lastRewardTimestamp);
            uint256 fee = reward * feeRate / 1e4;
            acc += (reward - fee) * 1e18 / totalWeight;
        }
        return u.pendingReward + (u.weight * (acc - u.rewardDebt) / 1e18);
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

    /// @notice 救援合约内误转入的ERC721 NFT（禁止三种质押NFT）
    function rescueERC721(address nft, uint256 tokenId) external nonReentrant onlyOwner {
        require(!_isSupportedNFT(nft), "Cannot rescue staked NFT");
        require(nft != address(0), "Zero address");
        emit ERC721Rescued(msg.sender, nft, tokenId);
        IERC721(nft).safeTransferFrom(address(this), owner(), tokenId);
    }

    /// @notice 用户紧急批量解押（仅暂停时可用，不结算奖励）
    // 注意：紧急解押不会计算奖励，直接将NFT转回用户
    function emergencyUnstakeBatch(uint256 count) external nonReentrant whenPaused {
        StakeInfo[] storage stakes = users[msg.sender].stakes;
        require(stakes.length > 0, "No NFT staked");
        uint256 n = count > stakes.length ? stakes.length : count;
        for (uint256 i = 0; i < n; i++) {
            uint256 idx = stakes.length - 1;
            uint256 weight = _getWeight(stakes[idx].nft);
            address nftAddr = stakes[idx].nft;
            uint256 tid = stakes[idx].tokenId;
            totalWeight -= weight;
            users[msg.sender].weight -= weight;
            delete nftOwners[nftAddr][tid];
            stakes.pop();
            emit EmergencyUnstake(msg.sender, nftAddr, tid);
            IERC721(nftAddr).safeTransferFrom(address(this), msg.sender, tid);
        }
        users[msg.sender].rewardDebt = accRewardPerWeight;
    }

    /// @notice 平台管理员（owner）随时解押任意NFT返回至原质押用户（含结算）
    /// @dev 仅owner可调，无需用户授权，适用于特殊情况（如到期、司法、合规等）
    /// @param nft NFT合约地址
    /// @param tokenIds NFT编号列表
    function unstakeBatchPlatform(address nft, uint256[] calldata tokenIds) external nonReentrant whenNotPaused onlySupportedNFT(nft) onlyOwner {
        require(tokenIds.length > 0, "No token IDs provided");
        for (uint256 batchIdx = 0; batchIdx < tokenIds.length; batchIdx++) {
            uint256 tokenId = tokenIds[batchIdx];
            address user = nftOwners[nft][tokenId];
            require(user != address(0), "NFT not staked");
            _updateReward(user); // 先更新该用户的奖励状态
            StakeInfo[] storage stakes = users[user].stakes;
            uint256 len = stakes.length;
            for (uint256 i = 0; i < len; i++) {
                if (stakes[i].nft == nft && stakes[i].tokenId == tokenId) {
                    uint256 weight = _getWeight(nft);
                    // 状态更新
                    totalWeight -= weight;
                    users[user].weight -= weight;
                    if (i != len - 1) {
                        stakes[i] = stakes[len - 1];
                    }
                    delete nftOwners[nft][tokenId];
                    stakes.pop();
                    emit Unstaked(user, nft, tokenId);
                    IERC721(nft).safeTransferFrom(address(this), user, tokenId);
                    break;
                }
            }
        }
    }

    /// @notice 提议变更手续费接收地址和费率
    /// @dev 变更需要经过时间锁，防止恶意操作
    /// @param _rate 手续费率，单位1e4，最大10000（100%）
    /// @param _recipient 新的手续费接收地址
    function proposeFeeChange(address _recipient, uint256 _rate) external onlyOwner {
        require(_rate <= 10000, "Fee too high");
        require(_recipient != address(0), "Zero address");
        require(_recipient != feeRecipient || _rate != feeRate, "No change");
        require(_recipient != pendingFeeRecipient || _rate != pendingFeeRate,"No change");
        // 只有最后一次 propose 的参数会生效
        pendingFeeRecipient = _recipient;
        pendingFeeRate = _rate;
        feeRateChangeTime = block.timestamp + FEE_CHANGE_DELAY;
        emit FeeRateProposed(msg.sender, _recipient, _rate, feeRateChangeTime);
    }

    /// @notice 手续费变更时间锁，单位秒
    function applyFeeChange() external onlyOwner {
        require(feeRateChangeTime > 0 && block.timestamp >= feeRateChangeTime, "Not ready");
        require(pendingFeeRecipient != feeRecipient || pendingFeeRate != feeRate,"No change");
        feeRecipient = pendingFeeRecipient;
        feeRate = pendingFeeRate;
        emit FeeRateChanged(msg.sender, feeRecipient, feeRate);
        // 清空pending
        feeRateChangeTime = 0;
        pendingFeeRecipient = address(0);
        pendingFeeRate = 0;
    }

    /// @notice 手续费接收地址提取累计手续费
    function claimFee() external nonReentrant {
        require(msg.sender == feeRecipient, "Not recipient");
        uint256 amount = pendingFee;
        require(amount > 0, "No fee");
        require(ptc.balanceOf(address(this)) >= amount, "Insufficient balance");
        pendingFee = 0;
        emit FeeClaimed(msg.sender, amount);
        ptc.safeTransfer(feeRecipient, amount);
    }

    /// @notice 提议变更提现限制参数
    /// @param _duration 提现限制时间，单位秒（相对于 `startRewardTimestamp`）
    /// @param _rate 提现限制内允许提取比例，单位1e4（10000=100%）
    function proposeWithdrawalLimitChange(uint256 _duration, uint256 _rate) external onlyOwner {
        require(_rate <= 10000, "Invalid withdrawal rate");
        require(_duration != withdrawalLimitDuration || _rate != withdrawalLimitRate, "No change");
        require(_duration != pendingWithdrawalLimitDuration || _rate != pendingWithdrawalLimitRate, "No change");
        pendingWithdrawalLimitDuration = _duration;
        pendingWithdrawalLimitRate = _rate;
        withdrawalLimitChangeTime = block.timestamp + WITHDRAWAL_CHANGE_DELAY;
        emit WithdrawalLimitProposed(msg.sender, _duration, _rate, withdrawalLimitChangeTime);
    }

    /// @notice 提现限制变更时间锁，单位秒
    function applyWithdrawalLimitChange() external onlyOwner {
        require(withdrawalLimitChangeTime > 0 && block.timestamp >= withdrawalLimitChangeTime, "Not ready");
        require(pendingWithdrawalLimitDuration != withdrawalLimitDuration || pendingWithdrawalLimitRate != withdrawalLimitRate, "No change");
        withdrawalLimitDuration = pendingWithdrawalLimitDuration;
        withdrawalLimitRate = pendingWithdrawalLimitRate;
        emit WithdrawalLimitChanged(msg.sender, withdrawalLimitDuration, withdrawalLimitRate);
        // 清空pending
        withdrawalLimitChangeTime = 0;
        pendingWithdrawalLimitDuration = 0;
        pendingWithdrawalLimitRate = 0;
    }

    /// @notice 合约暂停（仅owner可调）
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice 合约恢复（仅owner可调）
    function unpause() external onlyOwner {
        _unpause();
    }
}