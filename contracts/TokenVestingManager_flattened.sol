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

// File: @openzeppelin/contracts/utils/Errors.sol


// OpenZeppelin Contracts (last updated v5.1.0) (utils/Errors.sol)

pragma solidity ^0.8.20;

/**
 * @dev Collection of common custom errors used in multiple contracts
 *
 * IMPORTANT: Backwards compatibility is not guaranteed in future versions of the library.
 * It is recommended to avoid relying on the error API for critical functionality.
 *
 * _Available since v5.1._
 */
library Errors {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error InsufficientBalance(uint256 balance, uint256 needed);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedCall();

    /**
     * @dev The deployment failed.
     */
    error FailedDeployment();

    /**
     * @dev A necessary precompile is missing.
     */
    error MissingPrecompile(address);
}

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v5.4.0) (utils/Address.sol)

pragma solidity ^0.8.20;


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev There's no code at `target` (it is not a contract).
     */
    error AddressEmptyCode(address target);

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert Errors.InsufficientBalance(address(this).balance, amount);
        }

        (bool success, bytes memory returndata) = recipient.call{value: amount}("");
        if (!success) {
            _revert(returndata);
        }
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason or custom error, it is bubbled
     * up by this function (like regular Solidity function calls). However, if
     * the call reverted with no returned reason, this function reverts with a
     * {Errors.FailedCall} error.
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
     * was not a contract or bubbling up the revert reason (falling back to {Errors.FailedCall}) in case
     * of an unsuccessful call.
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            // only check if target is a contract if the call was successful and the return data is empty
            // otherwise we already know that it was a contract
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
     * revert reason or with a default {Errors.FailedCall} error.
     */
    function verifyCallResult(bool success, bytes memory returndata) internal pure returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    /**
     * @dev Reverts with returndata if present. Otherwise reverts with {Errors.FailedCall}.
     */
    function _revert(bytes memory returndata) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            assembly ("memory-safe") {
                revert(add(returndata, 0x20), mload(returndata))
            }
        } else {
            revert Errors.FailedCall();
        }
    }
}

// File: @openzeppelin/contracts/finance/VestingWallet.sol


// OpenZeppelin Contracts (last updated v5.3.0) (finance/VestingWallet.sol)
pragma solidity ^0.8.20;






/**
 * @dev A vesting wallet is an ownable contract that can receive native currency and ERC-20 tokens, and release these
 * assets to the wallet owner, also referred to as "beneficiary", according to a vesting schedule.
 *
 * Any assets transferred to this contract will follow the vesting schedule as if they were locked from the beginning.
 * Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly)
 * be immediately releasable.
 *
 * By setting the duration to 0, one can configure this contract to behave like an asset timelock that holds tokens for
 * a beneficiary until a specified time.
 *
 * NOTE: Since the wallet is {Ownable}, and ownership can be transferred, it is possible to sell unvested tokens.
 * Preventing this in a smart contract is difficult, considering that: 1) a beneficiary address could be a
 * counterfactually deployed contract, 2) there is likely to be a migration path for EOAs to become contracts in the
 * near future.
 *
 * NOTE: When using this contract with any token whose balance is adjusted automatically (i.e. a rebase token), make
 * sure to account the supply/balance adjustment in the vesting schedule to ensure the vested amount is as intended.
 *
 * NOTE: Chains with support for native ERC20s may allow the vesting wallet to withdraw the underlying asset as both an
 * ERC20 and as native currency. For example, if chain C supports token A and the wallet gets deposited 100 A, then
 * at 50% of the vesting period, the beneficiary can withdraw 50 A as ERC20 and 25 A as native currency (totaling 75 A).
 * Consider disabling one of the withdrawal methods.
 */
contract VestingWallet is Context, Ownable {
    event EtherReleased(uint256 amount);
    event ERC20Released(address indexed token, uint256 amount);

    uint256 private _released;
    mapping(address token => uint256) private _erc20Released;
    uint64 private immutable _start;
    uint64 private immutable _duration;

    /**
     * @dev Sets the beneficiary (owner), the start timestamp and the vesting duration (in seconds) of the vesting
     * wallet.
     */
    constructor(address beneficiary, uint64 startTimestamp, uint64 durationSeconds) payable Ownable(beneficiary) {
        _start = startTimestamp;
        _duration = durationSeconds;
    }

    /**
     * @dev The contract should be able to receive Eth.
     */
    receive() external payable virtual {}

    /**
     * @dev Getter for the start timestamp.
     */
    function start() public view virtual returns (uint256) {
        return _start;
    }

    /**
     * @dev Getter for the vesting duration.
     */
    function duration() public view virtual returns (uint256) {
        return _duration;
    }

    /**
     * @dev Getter for the end timestamp.
     */
    function end() public view virtual returns (uint256) {
        return start() + duration();
    }

    /**
     * @dev Amount of eth already released
     */
    function released() public view virtual returns (uint256) {
        return _released;
    }

    /**
     * @dev Amount of token already released
     */
    function released(address token) public view virtual returns (uint256) {
        return _erc20Released[token];
    }

    /**
     * @dev Getter for the amount of releasable eth.
     */
    function releasable() public view virtual returns (uint256) {
        return vestedAmount(uint64(block.timestamp)) - released();
    }

    /**
     * @dev Getter for the amount of releasable `token` tokens. `token` should be the address of an
     * {IERC20} contract.
     */
    function releasable(address token) public view virtual returns (uint256) {
        return vestedAmount(token, uint64(block.timestamp)) - released(token);
    }

    /**
     * @dev Release the native token (ether) that have already vested.
     *
     * Emits a {EtherReleased} event.
     */
    function release() public virtual {
        uint256 amount = releasable();
        _released += amount;
        emit EtherReleased(amount);
        Address.sendValue(payable(owner()), amount);
    }

    /**
     * @dev Release the tokens that have already vested.
     *
     * Emits a {ERC20Released} event.
     */
    function release(address token) public virtual {
        uint256 amount = releasable(token);
        _erc20Released[token] += amount;
        emit ERC20Released(token, amount);
        SafeERC20.safeTransfer(IERC20(token), owner(), amount);
    }

    /**
     * @dev Calculates the amount of ether that has already vested. Default implementation is a linear vesting curve.
     */
    function vestedAmount(uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(address(this).balance + released(), timestamp);
    }

    /**
     * @dev Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
     */
    function vestedAmount(address token, uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(IERC20(token).balanceOf(address(this)) + released(token), timestamp);
    }

    /**
     * @dev Virtual implementation of the vesting formula. This returns the amount vested, as a function of time, for
     * an asset given its total historical allocation.
     */
    function _vestingSchedule(uint256 totalAllocation, uint64 timestamp) internal view virtual returns (uint256) {
        if (timestamp < start()) {
            return 0;
        } else if (timestamp >= end()) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start())) / duration();
        }
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

// File: contracts/MonthlyVesting.sol


pragma solidity ^0.8.20;




/**
 * @title MonthlyVesting
 * @notice Simple monthly vesting: splits a total allocation into `months` equal
 *         monthly portions and allows anyone to trigger distribution to the
 *         beneficiary.
 *
 * @dev Compatibility note: this contract assumes the vesting token transfers
 *      1:1 (no transfer fees or burns). For production we recommend using
 *      non-deflationary ERC20 tokens (no fee-on-transfer or burn mechanics).
 *
 *      When a deflationary token is used, the contract protects itself by
 *      only releasing months that can be fully funded with the current token
 *      balance (see `releasableAmount()` / `payableMonths()`). If the balance
 *      is insufficient to fully pay any available month, `release()` will
 *      revert with `insufficient funds for any month` to avoid partial
 *      payouts and inconsistent on-chain accounting.
 *
 * Design notes:
 *  - `start` is the timestamp when the first month's portion becomes claimable.
 *  - Each call to `release()` transfers the accumulated, currently claimable
 *    portions (may be multiple months if no one called earlier).
 */
contract MonthlyVesting is ReentrancyGuard {
    using SafeERC20 for IERC20;

    /// Upper bound to avoid unbounded loops and excessive gas costs when
    /// iterating months in `releasableAmount()` / `release()`.
    /// This is intentionally large (1200 months = 100 years) but provides a
    /// practical guard against accidental or maliciously large `months` values.
    uint32 public constant MAX_MONTHS = 1200;

    IERC20 public immutable token;
    address public immutable beneficiary;
    uint64 public immutable start;         // timestamp when first portion unlocks
    uint64 public immutable monthSeconds;  // seconds per month (e.g. 30 days)
    uint32 public immutable months;        // total number of months
    uint256 public immutable totalAmount;  // total allocation
    uint256 public immutable monthlyAmount; // floor(totalAmount / months)
    uint256 public immutable remainder;     // totalAmount - monthlyAmount * months

    // How many monthly portions have been released already.
    uint32 public releasedMonths;

    /// Emitted when tokens are released to the beneficiary.
    event Released(address indexed to, uint256 amount, uint32 monthsReleased);

    /**
     * @param _token ERC20 token used for vesting
     * @param _beneficiary recipient of vested funds
     * @param _start timestamp when first portion becomes claimable
     * @param _monthSeconds length of a month in seconds (e.g. 30 days)
     * @param _months total number of monthly portions
     * @param _totalAmount total tokens allocated to this vesting
     */
    constructor(
        IERC20 _token,
        address _beneficiary,
        uint64 _start,
        uint64 _monthSeconds,
        uint32 _months,
        uint256 _totalAmount
    ) {
        require(address(_token) != address(0), "token address is zero");
        require(_start > 0, "start must be > 0");
        require(_beneficiary != address(0), "beneficiary is zero");
        require(_monthSeconds > 0, "monthSeconds is zero");
            require(_months > 0, "months is zero");
            require(_months <= MAX_MONTHS, "months exceeds max allowed");
        require(_totalAmount > 0, "amount is zero");

        token = _token;
        beneficiary = _beneficiary;
        start = _start;
        monthSeconds = _monthSeconds;
        months = _months;
        totalAmount = _totalAmount;

        // Compute per-month floor amount and exact remainder.
        // Use modulo to compute the remainder directly to avoid any
        // precision confusion from integer truncation in division.
        monthlyAmount = _totalAmount / _months;
        remainder = _totalAmount % uint256(_months);
        releasedMonths = 0;
    }

    /// @dev Number of months currently available for release (may be >1).
    function _availableMonths() internal view returns (uint32) {
        if (block.timestamp < start) return 0;
        // First month is available exactly at `start`.
        uint256 elapsed = (block.timestamp - start) / monthSeconds + 1;
        if (elapsed > months) elapsed = months;
        if (elapsed <= releasedMonths) return 0;
        return uint32(elapsed - releasedMonths);
    }

    /// @notice Amount currently claimable (aggregated across available months).
    function releasableAmount() public view returns (uint256) {
        // Compute how many of the currently available monthly portions can be
        // fully funded with the current token balance of this contract. This
        // avoids a situation where `release()` would attempt to transfer more
        // tokens than the contract actually holds (e.g., because of deflationary
        // tokens or prior burns), which would revert and permanently block
        // further releases.
        uint32 avail = _availableMonths();
        if (avail == 0) return 0;

        uint256 bal = token.balanceOf(address(this));
        uint256 amount = 0;
        uint32 curReleased = releasedMonths;

        for (uint32 i = 0; i < avail; i++) {
            uint32 willBeReleased = curReleased + i + 1;
            uint256 thisPortion = monthlyAmount;
            if (willBeReleased == months && remainder > 0) {
                thisPortion += remainder;
            }
            if (bal >= thisPortion) {
                amount += thisPortion;
                bal -= thisPortion;
            } else {
                break;
            }
        }
        return amount;
    }

    /// @notice Public helper returning the number of months currently available.
    function availableMonths() external view returns (uint32) {
        return _availableMonths();
    }

    /// @notice How many monthly portions remain locked.
    function monthsRemaining() external view returns (uint32) {
        if (releasedMonths >= months) return 0;
        return months - releasedMonths;
    }

    /// @notice Timestamp when the next (not-yet-released) portion becomes available, or 0.
    function nextReleasableTimestamp() external view returns (uint64) {
        if (releasedMonths >= months) return 0;
        uint256 next = uint256(start) + uint256(releasedMonths) * uint256(monthSeconds);
        return uint64(next);
    }

    /**
     * @notice Release all currently available portions to the beneficiary.
     * @return amount Amount actually transferred to the beneficiary.
     */
    function release() external nonReentrant returns (uint256) {
        uint32 avail = _availableMonths();
        require(avail > 0, "nothing releasable");

        uint256 bal = token.balanceOf(address(this));
        uint256 amount = 0;
        uint32 monthsToRelease = 0;
        uint32 curReleased = releasedMonths;

        // Iterate month-by-month and aggregate only fully-funded portions.
        for (uint32 i = 0; i < avail; i++) {
            uint32 willBeReleased = curReleased + i + 1;
            uint256 thisPortion = monthlyAmount;
            if (willBeReleased == months && remainder > 0) {
                thisPortion += remainder;
            }
            if (bal >= thisPortion) {
                amount += thisPortion;
                bal -= thisPortion;
                monthsToRelease++;
            } else {
                break;
            }
        }

        require(monthsToRelease > 0, "insufficient funds for any month");

        // Effects: update bookkeeping before external transfer.
        releasedMonths = releasedMonths + monthsToRelease;

        // Interactions: transfer tokens to beneficiary.
        token.safeTransfer(beneficiary, amount);

        emit Released(beneficiary, amount, releasedMonths);
        return amount;
    }

    /// @notice How many of the available months can be fully paid with current balance.
    function payableMonths() external view returns (uint32) {
        uint32 avail = _availableMonths();
        if (avail == 0) return 0;
        uint256 bal = token.balanceOf(address(this));
        uint32 curReleased = releasedMonths;
        uint32 monthsPayable = 0;
        for (uint32 i = 0; i < avail; i++) {
            uint32 willBeReleased = curReleased + i + 1;
            uint256 thisPortion = monthlyAmount;
            if (willBeReleased == months && remainder > 0) {
                thisPortion += remainder;
            }
            if (bal >= thisPortion) {
                bal -= thisPortion;
                monthsPayable++;
            } else {
                break;
            }
        }
        return monthsPayable;
    }

    /// @notice Balance remaining in this vesting contract.
    function remaining() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}

// File: contracts/TokenVestingManager.sol


pragma solidity ^0.8.20;







/**
 * @title TokenVestingManager
 * @notice Factory and administration contract to create token vestings for beneficiaries.
 *         Owner is expected to fund the manager (or approve transfers) prior to creating
 *         vestings. This manager supports direct one-time transfers and monthly equal
 *         vestings (MonthlyVesting). Linear OZ VestingWallet usage is retained for
 *         backward compatibility but can be deprecated if desired.
 *
 * @dev Compatibility note: prefer non-deflationary ERC20 tokens (no transfer
 *      fees or burn-on-transfer) for production use. For direct transfers the
 *      manager measures the recipient's balance change and will revert if the
 *      beneficiary receives less than the requested amount (to avoid
 *      inconsistent on-chain accounting).
 */
contract TokenVestingManager is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    uint256 public immutable tgeTimestamp;

    struct VestingRecord {
        address beneficiary;
        address vestingWallet; // address(0) => direct transfer (no vesting contract)
        uint256 amount;
        uint64 start;
        uint64 duration; // linear VestingWallet duration in seconds, 0 for direct/monthly
        bool monthly;    // true if this record points to a MonthlyVesting
        uint32 months;   // valid when monthly == true
        uint64 monthSeconds; // valid when monthly == true
    }

    VestingRecord[] public vestings;

    event VestingCreated(
        address indexed beneficiary,
        address indexed vestingWallet,
        uint256 amount,
        uint256 start,
        uint256 duration,
        bool monthly,
        uint32 months,
        uint64 monthSeconds
    );
    event ERC20Rescued(address indexed operator, address token, address to, uint256 amount);
    event DirectTransfer(address indexed beneficiary, uint256 amount);
    /// Emitted when a vesting record is removed from storage.
    event VestingRemoved(uint256 indexed index, address indexed beneficiary, address vestingWallet, uint256 amount);

    /**
     * @param _tgeTimestamp timestamp of TGE (seconds). If zero, uses deployment time.
     */
    constructor(IERC20 _token, uint256 _tgeTimestamp) Ownable(msg.sender) {
        require(address(_token) != address(0), "token address is zero");
        token = _token;
        // If caller passes 0, default to deployment time. This avoids start==0 pitfalls.
        tgeTimestamp = _tgeTimestamp == 0 ? block.timestamp : _tgeTimestamp;
    }

    /**
     * @dev Internal core creation logic. This function intentionally does not use
     *      the reentrancy guard so it can be called safely from batch routines.
     * @param beneficiary recipient address
     * @param amount tokens to allocate
     * @param cliffSeconds delay from TGE to vesting start
     * @param durationSeconds duration for linear VestingWallet (0 => direct or monthly)
     * @param monthly whether to deploy a MonthlyVesting contract
     * @param months number of months (for monthly mode)
     * @param monthSeconds seconds per month (for monthly mode)
     */
    function _createVesting(
        address beneficiary,
        uint256 amount,
        uint64 cliffSeconds,
        uint64 durationSeconds,
        bool monthly,
        uint32 months,
        uint64 monthSeconds
    ) internal {
        require(beneficiary != address(0), "beneficiary is zero");
        require(amount > 0, "amount is zero");

        uint256 start256 = tgeTimestamp + cliffSeconds;
        // Guard against overflow/truncation when casting to uint64 below.
        require(start256 <= type(uint64).max, "start timestamp overflow");
        uint64 start = uint64(start256);

        if (monthly) {
            require(months > 0, "months is zero");
            // (Note: no upper bound enforced here; MonthlyVesting enforces
            // its own MAX_MONTHS limit at construction time.)
            require(monthSeconds > 0, "monthSeconds is zero");
            // Deploy MonthlyVesting (checks -> effects). We will fund it next
            // and then record the *actual* received amount for accurate bookkeeping.
            MonthlyVesting mv = new MonthlyVesting(token, beneficiary, start, monthSeconds, months, amount);

            // Transfer funds to the new vesting contract (interactions)
            if (token.balanceOf(address(this)) >= amount) {
                token.safeTransfer(address(mv), amount);
            } else {
                token.safeTransferFrom(msg.sender, address(mv), amount);
            }

            // Record the actual balance held by the child vesting contract
            // after funding. This makes on-chain bookkeeping accurate even
            // when tokens are deflationary or fees are applied during transfer.
            uint256 finalBalMv = token.balanceOf(address(mv));
            require(finalBalMv > 0, "vesting received insufficient amount");

            vestings.push(VestingRecord({ beneficiary: beneficiary, vestingWallet: address(mv), amount: finalBalMv, start: start, duration: 0, monthly: true, months: months, monthSeconds: monthSeconds }));
            emit VestingCreated(beneficiary, address(mv), finalBalMv, start, 0, true, months, monthSeconds);
            return;
        }

        if (durationSeconds == 0) {
            // Direct one-time transfer: perform the transfer first, measure the
            // beneficiary's balance delta, and record the actual received amount.
            uint256 beforeBal = token.balanceOf(beneficiary);
            if (token.balanceOf(address(this)) >= amount) {
                token.safeTransfer(beneficiary, amount);
            } else {
                token.safeTransferFrom(msg.sender, beneficiary, amount);
            }
            uint256 afterBal = token.balanceOf(beneficiary);
            require(afterBal >= beforeBal, "balance underflow");
            uint256 received = afterBal - beforeBal;

            // Ensure the beneficiary actually received the intended funds.
            // If the token is deflationary (fee-on-transfer) this will revert
            // and prevent inaccurate on-chain accounting.
            require(received >= amount, "recipient received insufficient amount");

            // Record the actual received amount to keep on-chain accounting accurate.
            vestings.push(VestingRecord({ beneficiary: beneficiary, vestingWallet: address(0), amount: received, start: start, duration: 0, monthly: false, months: 0, monthSeconds: 0 }));
            emit DirectTransfer(beneficiary, received);
            return;
        }

        // Linear vesting path (uses OZ VestingWallet). Retained for backward compatibility.
        VestingWallet vw = new VestingWallet(beneficiary, start, uint64(durationSeconds));

        // Transfer funds to the VestingWallet and then record the actual
        // balance held by the child vesting contract for accurate bookkeeping.
        if (token.balanceOf(address(this)) >= amount) {
            token.safeTransfer(address(vw), amount);
        } else {
            token.safeTransferFrom(msg.sender, address(vw), amount);
        }

        uint256 finalBalVw = token.balanceOf(address(vw));
        require(finalBalVw > 0, "vesting received insufficient amount");

        vestings.push(VestingRecord({ beneficiary: beneficiary, vestingWallet: address(vw), amount: finalBalVw, start: start, duration: uint64(durationSeconds), monthly: false, months: 0, monthSeconds: 0 }));
        emit VestingCreated(beneficiary, address(vw), finalBalVw, start256, durationSeconds, false, 0, 0);
    }

    /// @notice Create a single vesting entry (only callable by owner).
    function createVesting(
        address beneficiary,
        uint256 amount,
        uint64 cliffSeconds,
        uint64 durationSeconds,
        bool monthly,
        uint32 months,
        uint64 monthSeconds
    ) public onlyOwner nonReentrant {
        _createVesting(beneficiary, amount, cliffSeconds, durationSeconds, monthly, months, monthSeconds);
    }

    struct VestingInput {
        address beneficiary;
        uint256 amount;
        uint64 cliffSeconds;
        uint64 durationSeconds;
        bool monthly;
        uint32 months;
        uint64 monthSeconds;
    }

    function createVestingBatch(VestingInput[] calldata inputs) external onlyOwner nonReentrant {
        uint256 n = inputs.length;
        require(n > 0, "empty input");
        for (uint256 i = 0; i < n; i++) {
            VestingInput calldata it = inputs[i];
            _createVesting(it.beneficiary, it.amount, it.cliffSeconds, it.durationSeconds, it.monthly, it.months, it.monthSeconds);
        }
    }

    /// @notice Number of vestings recorded.
    function vestingCount() external view returns (uint256) {
        return vestings.length;
    }

    /// @notice Return vesting record at index.
    function vestingAt(uint256 idx) external view returns (VestingRecord memory) {
        require(idx < vestings.length, "index out of range");
        return vestings[idx];
    }

    /**
     * @notice Returns true when the vesting at `idx` can be safely removed.
     *         A vesting is removable when it does not hold any tokens anymore.
     */
    function canRemoveVesting(uint256 idx) public view returns (bool) {
        if (idx >= vestings.length) return false;
        VestingRecord storage r = vestings[idx];
        // Direct transfers have no vesting contract and are safe to remove.
        if (r.vestingWallet == address(0)) return true;
        // If the vesting contract (MonthlyVesting or VestingWallet) holds zero tokens,
        // it is safe to remove the record.
        return token.balanceOf(r.vestingWallet) == 0;
    }

    /**
     * @notice Remove a vesting record from storage when it no longer holds funds.
     * @dev Owner only. Performs a swap-with-last + pop to keep gas costs predictable.
     */
    function removeVesting(uint256 idx) external onlyOwner nonReentrant {
        require(idx < vestings.length, "index out of range");
        require(canRemoveVesting(idx), "vesting not removable");
        _removeVestingAt(idx);
    }

    function _removeVestingAt(uint256 idx) internal {
        uint256 last = vestings.length - 1;
        VestingRecord memory removed = vestings[idx];
        if (idx != last) {
            // Move the last element into the slot being removed.
            vestings[idx] = vestings[last];
        }
        vestings.pop();
        emit VestingRemoved(idx, removed.beneficiary, removed.vestingWallet, removed.amount);
    }

    /**
     * @notice Rescue ERC20 tokens accidentally sent to this contract (cannot rescue the primary token).
     */
    function rescueERC20(address tokenAddr, address to, uint256 amount) external onlyOwner nonReentrant {
        require(tokenAddr != address(token), "cannot rescue main token");
        require(to != address(0), "recipient is zero");
        IERC20(tokenAddr).safeTransfer(to, amount);
        emit ERC20Rescued(msg.sender, tokenAddr, to, amount);
    }
}