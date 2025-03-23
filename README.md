# ICRC Token Standard Implementation

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

This repository contains a complete implementation of the Internet Computer ICRC token standards (ICRC-1, ICRC-2, ICRC-3, and ICRC-4) written in Motoko. This implementation can be forked and customized to create your own token on the Internet Computer.

## Features

- **ICRC-1**: Basic fungible token functionality (transfers, balances)
- **ICRC-2**: Token approval and transfer-from capability
- **ICRC-3**: Transaction history and archiving
- **ICRC-4**: Batch operations for transfers and balance queries

## Prerequisites

- [DFX SDK](https://internetcomputer.org/docs/current/developer-tools/install) (v0.14.0 or newer)
- [Mops package manager](https://docs.mops.one/quick-start)
- Internet Computer identity for deployment

## Quick Start

1. Clone the repository:

   ``` bash
   git clone https://github.com/Quantum-Leap-Labs-Inc/ICRC-Token.git
   ```

2. Navigate and deploy locally for testing:

   ```bash
   cd src/token_backend
   bash runner.sh
   ```

## Customization

To customize the token for your own use:

1. Modify the token parameters in `src/token-backend/Token.mo` or in the deployment script.
2. Key parameters to consider changing:
   - Token name
   - Token symbol
   - Logo (base64 encoded)
   - Decimals
   - Max supply
   - Fee structure

## Mainnet Deployment

To deploy to the Internet Computer mainnet:

1. Modify the deployment script to include the `--network ic` flag:

   ```bash
   # Example modification to deploy.sh
   dfx deploy token --network ic --argument "(...your token config...)"
   ```

2. Ensure you have sufficient cycles in your identity's wallet.

3. Run the deployment script:

   ```bash
   bash runner.sh
   ```

## Identity Configuration

The deployment script requires three different identities:

1. **Admin Principal**: Used to deploy the token canister
2. **Owner Principal**: Used for testing transfers
3. **Minter Principal**: Used for testing other operations

Configure these identities in your deployment script by replacing the placeholder principals with your own.

## API Reference

The token canister implements the standard ICRC interfaces:

### ICRC-1 (Basic Token Standard)

- `icrc1_name()`: Returns the token name
- `icrc1_symbol()`: Returns the token symbol
- `icrc1_decimals()`: Returns the token decimal places
- `icrc1_fee()`: Returns the transfer fee
- `icrc1_metadata()`: Returns token metadata
- `icrc1_total_supply()`: Returns total token supply
- `icrc1_balance_of(account)`: Returns balance of an account
- `icrc1_transfer(args)`: Transfers tokens between accounts
- `mint(args)`: Mints new tokens (admin only)

### ICRC-2 (Approval Standard)

- `icrc2_allowance(args)`: Returns the allowance for a spender
- `icrc2_approve(args)`: Approves a spender to transfer tokens
- `icrc2_transfer_from(args)`: Transfers tokens on behalf of another account

### ICRC-3 (Transaction History Standard)

- `icrc3_get_blocks(args)`: Returns transaction blocks
- `icrc3_get_archives(args)`: Returns archive information
- `icrc3_get_tip_certificate()`: Returns the latest block certificate
- `icrc3_supported_block_types()`: Returns supported block types

### ICRC-4 (Batch Operations Standard)

- `icrc4_transfer_batch(args)`: Performs multiple transfers in one call
- `icrc4_balance_of_batch(args)`: Queries multiple balances in one call
- `icrc4_maximum_update_batch_size()`: Returns max batch size for updates
- `icrc4_maximum_query_batch_size()`: Returns max batch size for queries

## Advanced Configuration

For advanced configuration, the admin can update various parameters after deployment:

- `admin_update_owner(new_owner)`: Updates the owner principal
- `admin_update_icrc1(requests)`: Updates ICRC-1 ledger parameters
- `admin_update_icrc2(requests)`: Updates ICRC-2 ledger parameters
- `admin_update_icrc4(requests)`: Updates ICRC-4 ledger parameters

## Resources

- [ICRC-1 Standard](https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-1)
- [ICRC-2 Standard](https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-2)
- [ICRC-3 Standard](https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3)
- [ICRC-4 Standard](https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-4)
- [ICRC-Fungible](https://github.com/PanIndustrial-Org/ICRC_fungible)
