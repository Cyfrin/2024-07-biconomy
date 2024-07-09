# Biconomy

### Prize Pool

- Total Pool - $30,000
- H/M - $25,000
- Low - $2,750
- Community Judging - $2,250

- Starts: July 08, 2024 Noon UTC
- Ends: July 15, 2024 Noon UTC

- nSLOC: 1433

[//]: # (contest-details-open)

## About the Project

Nexus is a suite of contracts for Modular Smart Accounts compliant with ERC-7579 and ERC-4337, developed by Biconomy. It aims to enhance modularity and security for smart contract accounts, providing a flexible framework for various use cases.

[GitHub](https://github.com/bcnmy/nexus)
[Documentation](https://github.com/bcnmy/nexus/wiki)
[Website](https://biconomy.io)
[Twitter](https://twitter.com/biconomy)

## Actors

- **User:** Interacts with the smart account, initiating transactions and operations.
- **Validator:** Validates user operations, ensuring authenticity and compliance with predefined rules.
- **Executor:** Executes predefined operations within the smart account.
- **Hook:** Executes additional logic during transaction processing.
- **Fallback:** Handles unhandled transactions, providing error management.

### Access Control:

- **onlyEntryPointOrSelf:** Restricts access to the EntryPoint or the smart account itself.
- **onlyEntryPoint:** Limits access exclusively to the EntryPoint.
- **onlyExecutorModule:** Ensures only registered executor modules can call specific functions.
- **Modules:** Added via the installModule function, ensuring only valid modules are integrated.

[//]: # (contest-details-close)

[//]: # (scope-open)

## Scope (contracts)

All contracts in `contracts` except `contracts/mocks` are in scope.

```js
contracts/
├── Nexus.sol
├── base/
├── common/
├── factory/
├── interfaces/
├── lib/
├── modules/
├── types/
├── utils/
```

## Compatibilities

Blockchains:
    - Ethereum/Any EVM

[//]: # (scope-close)

[//]: # (getting-started-open)

## Setup

Clone the repo:
```bash
git clone https://github.com/Cyfrin/2024-07-biconomy.git
code 2024-07-biconomy
```

```bash
yarn install

yarn test
```

[//]: # (getting-started-close)

[//]: # (known-issues-open)

## Known Issues

### Validation Module Requirement
A validation module must always be present in the Nexus Smart Account to ensure transaction authenticity and integrity.

### Zero Value Deposits
The `addDeposit` function allows deposits without checking for zero values, potentially leading to unnecessary transactions.

### Delegate Call Absence
Nexus does not implement delegate calls to avoid complexities and vulnerabilities related to code injection attacks.

### Validator Removal
The system prevents the last validator from being removed to maintain account security.

### Selector Restrictions
Selectors `onInstall(bytes)` (0x6d61fe70) and `onUninstall(bytes)` (0x8a91b0e3) are forbidden to prevent unauthorized module operations.

### ERC-7201 Namespaced Storage
Nexus uses ERC-7201 namespaced storage to avoid data collision and ensure isolated module operations.

### Security Dependence on Modules
The security of Nexus smart accounts relies heavily on the modules used. Only secure and audited modules should be installed to maintain the overall security of the system.

### Additional Security Measures
Nexus employs pre-execution hooks, post-execution hooks, and fallback handlers for enhanced security and error management.

### Nonce Management
Nonce management is crucial to prevent replay attacks by ensuring unique transactions.

### Authorization and Access Control
Nexus uses various access control mechanisms, including `onlyEntryPointOrSelf`, `onlyEntryPoint`, and `onlyExecutorModule`, to secure function access.

### Validator management
A Nexus Smart Account could be locked forever if the owner installs a validator in the wrong way and does remove all other valid validators

### Additional Known Issues
Additional issues detected by LightChaser can be found [here](https://github.com/Cyfrin/2024-07-biconomy/issues/1)

[//]: # (known-issues-close)
