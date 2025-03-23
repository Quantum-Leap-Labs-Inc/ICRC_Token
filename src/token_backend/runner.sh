set -ex
# This admin principal and others must be replaced with your own dfx identities, ie you will need three different identities
# for the admin, owner and minter roles. The admin principal is used to deploy the token canister.
# The admin and owner principal can be the same.

ADMIN_PRINCIPAL=$(dfx --identity dev identity get-principal)

# Use owner for testing transfers
dfx identity use owner
OWNER_PRINCIPAL=$(dfx identity get-principal)

# Use minter for testing other operations
dfx identity use minter
MINTER_PRINCIPAL=$(dfx identity get-principal)

# Switch back to dev for deployment
dfx identity use dev

# Deploy the token canister
dfx deploy token --argument "(opt record {icrc1 = opt record {
  name = opt \"Quantum Leap Labs\";
  symbol = opt \"QLL\";
  logo = opt \"data:image/png;base64,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\";
  decimals = 8;
  fee = opt variant { Fixed = 10000};
  minting_account = opt record{
    owner = principal \"$ADMIN_PRINCIPAL\";
    subaccount = null;
  };
  max_supply = opt 100_000_000_00000000;
  min_burn_amount = null;
  max_memo = opt 64;
  advanced_settings = null;
  metadata = null;
  fee_collector = opt record{
        owner = principal \"$ADMIN_PRINCIPAL\";
        subaccount = null;
    };
  transaction_window = null;
  permitted_drift = null;
  max_accounts = opt 100000000;
  settle_to_accounts = opt 99999000;
}; 
icrc2 = opt record{
  max_approvals_per_account = opt 1000;
  max_allowance = opt variant { TotalSupply };
  fee = opt variant { ICRC1 };
  advanced_settings = null;
  max_approvals = opt 10000000;
  settle_to_approvals = opt 9990000;
}; 
icrc3 = opt record {
  maxActiveRecords = 5000;
  settleToRecords = 4000;
  maxRecordsInArchiveInstance = 100000000;
  maxArchivePages = 62500;
  archiveIndexType = variant {Stable = null};
  maxRecordsToArchive = 8000;
  archiveCycles = 20_000_000_000_000;
  supportedBlocks = vec {
    record { block_type = \"1xfer\"; url = \"https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3\"; };
    record { block_type = \"2xfer\"; url = \"https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3\"; };
    record { block_type = \"2approve\"; url = \"https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3\"; };
    record { block_type = \"1mint\"; url = \"https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3\"; };
  };
  archiveControllers = null;
}; 
icrc4 = opt record {
  max_balances = opt 200;
  max_transfers = opt 200;
  fee = opt variant { ICRC1 = null};
};})" --mode reinstall

echo $ICRC_CANISTER