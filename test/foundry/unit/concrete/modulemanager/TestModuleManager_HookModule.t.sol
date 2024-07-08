// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../../../utils/Imports.sol";
import "../../../utils/NexusTest_Base.t.sol";
import "../../../shared/TestModuleManagement_Base.t.sol";

/// @title TestModuleManager_HookModule
/// @notice Tests for installing and uninstalling the hook module in a smart account.
contract TestModuleManager_HookModule is TestModuleManagement_Base {
    /// @notice Sets up the base module management environment.
    function setUp() public {
        setUpModuleManagement_Base();
    }

    /// @notice Tests the successful installation of the hook module.
    function test_InstallHookModule_Success() public {
        // Ensure the hook module is not installed initially
        assertFalse(BOB_ACCOUNT.isModuleInstalled(MODULE_TYPE_HOOK, address(HOOK_MODULE), ""), "Hook module should not be installed initially");

        // Prepare call data for installing the hook module
        bytes memory callData = abi.encodeWithSelector(IModuleManager.installModule.selector, MODULE_TYPE_HOOK, address(HOOK_MODULE), "");

        // Install the hook module
        installModule(callData, MODULE_TYPE_HOOK, address(HOOK_MODULE), EXECTYPE_DEFAULT);

        // Assert that the hook module is now installed
        assertTrue(BOB_ACCOUNT.isModuleInstalled(MODULE_TYPE_HOOK, address(HOOK_MODULE), ""), "Hook module should be installed");
    }

    /// @notice Tests reversion when trying to reinstall an already installed hook module.
    function test_RevertIf_ReinstallHookModule() public {
        // Ensure the hook module is not installed initially
        assertFalse(BOB_ACCOUNT.isModuleInstalled(MODULE_TYPE_HOOK, address(HOOK_MODULE), ""), "Hook Module should not be installed initially");

        // Install the hook module
        test_InstallHookModule_Success();
        assertTrue(BOB_ACCOUNT.isModuleInstalled(MODULE_TYPE_HOOK, address(HOOK_MODULE), ""), "Hook Module should be installed");

        // Attempt to install a new hook module
        MockHook newHook = new MockHook();
        assertFalse(BOB_ACCOUNT.isModuleInstalled(MODULE_TYPE_HOOK, address(newHook), ""), "Hook Module should not be installed initially");

        bytes memory callData = abi.encodeWithSelector(IModuleManager.installModule.selector, MODULE_TYPE_HOOK, address(newHook), "");

        Execution[] memory execution = new Execution[](1);
        execution[0] = Execution(address(BOB_ACCOUNT), 0, callData);

        PackedUserOperation[] memory userOps = buildPackedUserOperation(BOB, BOB_ACCOUNT, EXECTYPE_DEFAULT, execution, address(VALIDATOR_MODULE));

        bytes32 userOpHash = ENTRYPOINT.getUserOpHash(userOps[0]);

        bytes memory expectedRevertReason = abi.encodeWithSignature("HookAlreadyInstalled(address)", address(HOOK_MODULE));

        // Expect the UserOperationRevertReason event
        vm.expectEmit(true, true, true, true);
        emit UserOperationRevertReason(
            userOpHash, // userOpHash
            address(BOB_ACCOUNT), // sender
            userOps[0].nonce, // nonce
            expectedRevertReason
        );

        ENTRYPOINT.handleOps(userOps, payable(address(BOB.addr)));
    }

    /// @notice Tests the successful uninstallation of the hook module.
    function test_UninstallHookModule_Success() public {
        // Ensure the module is installed first
        test_InstallHookModule_Success();

        // Uninstall the hook module
        bytes memory callData = abi.encodeWithSelector(IModuleManager.uninstallModule.selector, MODULE_TYPE_HOOK, address(HOOK_MODULE), "");
        uninstallHook(callData, address(HOOK_MODULE), EXECTYPE_DEFAULT);

        // Verify hook module is uninstalled
        assertFalse(BOB_ACCOUNT.isModuleInstalled(MODULE_TYPE_HOOK, address(HOOK_MODULE), ""), "Hook module should be uninstalled");
    }

    /// @notice Tests that the hook is triggered on module installation.
    function test_HookTriggeredOnModuleInstallation() public {
        // Install the hook module
        test_InstallHookModule_Success();

        // Install the executor module to trigger the hooks
        bytes memory installCallData = abi.encodeWithSelector(
            IModuleManager.installModule.selector,
            MODULE_TYPE_EXECUTOR,
            address(EXECUTOR_MODULE),
            ""
        );

        // Prepare and execute the installation operation
        Execution[] memory executions = new Execution[](1);
        executions[0] = Execution(address(BOB_ACCOUNT), 0, installCallData);
        PackedUserOperation[] memory userOps = buildPackedUserOperation(BOB, BOB_ACCOUNT, EXECTYPE_DEFAULT, executions, address(VALIDATOR_MODULE));

        // Expect the PreCheckCalled and PostCheckCalled events to be emitted
        vm.expectEmit(true, true, true, true);
        emit PreCheckCalled();
        vm.expectEmit(true, true, true, true);
        emit PostCheckCalled();

        ENTRYPOINT.handleOps(userOps, payable(address(BOB.addr)));
    }

    /// @notice Tests getting the active hook after successful installation.
    function test_GetActiveHook_Success() public {
        // Install the hook module
        test_InstallHookModule_Success();

        // Verify the hook module is installed
        address activeHook = BOB_ACCOUNT.getActiveHook();
        assertEq(activeHook, address(HOOK_MODULE), "getActiveHook did not return the correct hook address");
    }

    /// @notice Uninstalls the hook module with the provided call data.
    /// @param callData The call data for uninstallation.
    /// @param module The address of the module to uninstall.
    /// @param execType The execution type for the operation.
    function uninstallHook(bytes memory callData, address module, ExecType execType) internal {
        Execution[] memory execution = new Execution[](1);
        execution[0] = Execution(address(BOB_ACCOUNT), 0, callData);

        PackedUserOperation[] memory userOps = buildPackedUserOperation(BOB, BOB_ACCOUNT, execType, execution, address(VALIDATOR_MODULE));

        // Emitting an event to capture the uninstallation attempt for assertion in tests
        vm.expectEmit(true, true, true, true);
        emit ModuleUninstalled(MODULE_TYPE_HOOK, module);

        // Handling the operation which includes calling the uninstallModule function on the smart account
        ENTRYPOINT.handleOps(userOps, payable(address(BOB.addr)));
    }
}
