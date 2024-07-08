// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// ──────────────────────────────────────────────────────────────────────────────
//     _   __    _  __
//    / | / /__ | |/ /_  _______
//   /  |/ / _ \|   / / / / ___/
//  / /|  /  __/   / /_/ (__  )
// /_/ |_/\___/_/|_\__,_/____/
//
// ──────────────────────────────────────────────────────────────────────────────
// Nexus: A suite of contracts for Modular Smart Accounts compliant with ERC-7579 and ERC-4337, developed by Biconomy.
// Learn more at https://biconomy.io. To report security issues, please contact us at: security@biconomy.io

import { ExecutionMode } from "../../lib/ModeLib.sol";

import { IExecutionHelperEventsAndErrors } from "./IExecutionHelperEventsAndErrors.sol";

/// @title Nexus - IExecutionHelper
/// @notice Interface for executing transactions on behalf of smart accounts within the Nexus system.
/// @dev Extends functionality for transaction execution with error handling as defined in IExecutionHelperEventsAndErrors.
/// @author @livingrockrises | Biconomy | chirag@biconomy.io
/// @author @aboudjem | Biconomy | adam.boudjemaa@biconomy.io
/// @author @filmakarov | Biconomy | filipp.makarov@biconomy.io
/// @author @zeroknots | Rhinestone.wtf | zeroknots.eth
/// Special thanks to the Solady team for foundational contributions: https://github.com/Vectorized/solady
interface IExecutionHelper is IExecutionHelperEventsAndErrors {
    /// @notice Executes a transaction with specified execution mode and calldata.
    /// @param mode The execution mode, defining how the transaction is processed.
    /// @param executionCalldata The calldata to execute.
    /// @dev This function ensures that the execution complies with smart account execution policies and handles errors appropriately.
    function execute(ExecutionMode mode, bytes calldata executionCalldata) external payable;

    /// @notice Allows an executor module to perform transactions on behalf of the account.
    /// @param mode The execution mode that details how the transaction should be handled.
    /// @param executionCalldata The transaction data to be executed.
    /// @return returnData The result of the execution, allowing for error handling and results interpretation by the executor module.
    function executeFromExecutor(ExecutionMode mode, bytes calldata executionCalldata) external payable returns (bytes[] memory returnData);
}
