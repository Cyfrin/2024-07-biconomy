// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "../../../shared/TestModuleManagement_Base.t.sol";

/// @title TestModuleManager_SupportsModule
/// @notice Tests for module management, verifying support for various module types in BOB_ACCOUNT.
contract TestModuleManager_SupportsModule is TestModuleManagement_Base {
    /// @notice Sets up the base environment for the module management tests.
    function setUp() public {
        setUpModuleManagement_Base();
    }

    /// @notice Tests the successful support of the Validator module.
    function test_SupportsModuleValidator_Success() public {
        assertTrue(BOB_ACCOUNT.supportsModule(MODULE_TYPE_VALIDATOR), "Validator module not supported");
    }

    /// @notice Tests the successful support of the Executor module.
    function test_SupportsModuleExecutor_Success() public {
        assertTrue(BOB_ACCOUNT.supportsModule(MODULE_TYPE_EXECUTOR), "Executor module not supported");
    }

    /// @notice Tests the successful support of the Fallback module.
    function test_SupportsModuleFallback_Success() public {
        assertTrue(BOB_ACCOUNT.supportsModule(MODULE_TYPE_FALLBACK), "Fallback module not supported");
    }

    /// @notice Tests the successful support of the Hook module.
    function test_SupportsModuleHook_Success() public {
        assertTrue(BOB_ACCOUNT.supportsModule(MODULE_TYPE_HOOK), "Hook module not supported");
    }

    /// @notice Tests the successful support of the MultiType module.
    function test_SupportsModuleMultiType_Success() public {
        assertTrue(BOB_ACCOUNT.supportsModule(MODULE_TYPE_MULTI), "Multitype module not supported");
    }

    /// @notice Tests that an unsupported module type returns false.
    function test_SupportsModule_FailsForUnsupportedModule() public {
        assertFalse(BOB_ACCOUNT.supportsModule(INVALID_MODULE_TYPE), "Invalid module type should not be supported");
    }
}
