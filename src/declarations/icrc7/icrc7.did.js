export const idlFactory = ({ IDL }) => {
  const ArchivedTransactionResponse = IDL.Rec();
  const Value__1 = IDL.Rec();
  const Value__2 = IDL.Rec();
  const IndexType = IDL.Variant({
    'Stable' : IDL.Null,
    'StableTyped' : IDL.Null,
    'Managed' : IDL.Null,
  });
  const BlockType = IDL.Record({ 'url' : IDL.Text, 'block_type' : IDL.Text });
  const InitArgs__1 = IDL.Record({
    'maxRecordsToArchive' : IDL.Nat,
    'archiveIndexType' : IndexType,
    'maxArchivePages' : IDL.Nat,
    'settleToRecords' : IDL.Nat,
    'archiveCycles' : IDL.Nat,
    'maxActiveRecords' : IDL.Nat,
    'maxRecordsInArchiveInstance' : IDL.Nat,
    'archiveControllers' : IDL.Opt(IDL.Opt(IDL.Vec(IDL.Principal))),
    'supportedBlocks' : IDL.Vec(BlockType),
  });
  const InitArgs = IDL.Opt(InitArgs__1);
  const Subaccount = IDL.Vec(IDL.Nat8);
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  const SupportedStandards = IDL.Vec(
    IDL.Record({ 'url' : IDL.Text, 'name' : IDL.Text })
  );
  const InitArgs__2 = IDL.Opt(
    IDL.Record({
      'deployer' : IDL.Principal,
      'allow_transfers' : IDL.Opt(IDL.Bool),
      'supply_cap' : IDL.Opt(IDL.Nat),
      'tx_window' : IDL.Opt(IDL.Nat),
      'burn_account' : IDL.Opt(Account),
      'default_take_value' : IDL.Opt(IDL.Nat),
      'logo' : IDL.Opt(IDL.Text),
      'permitted_drift' : IDL.Opt(IDL.Nat),
      'name' : IDL.Opt(IDL.Text),
      'description' : IDL.Opt(IDL.Text),
      'max_take_value' : IDL.Opt(IDL.Nat),
      'max_update_batch_size' : IDL.Opt(IDL.Nat),
      'max_query_batch_size' : IDL.Opt(IDL.Nat),
      'max_memo_size' : IDL.Opt(IDL.Nat),
      'supported_standards' : IDL.Opt(SupportedStandards),
      'symbol' : IDL.Opt(IDL.Text),
    })
  );
  const LibraryID = IDL.Text;
  const Result = IDL.Variant({ 'ok' : IDL.Bool, 'err' : IDL.Text });
  const Account__1 = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  const CreateLibraryRequest = IDL.Record({
    'creator_name' : IDL.Text,
    'thumbnail' : IDL.Text,
    'owner' : Account__1,
    'name' : IDL.Text,
    'description' : IDL.Text,
  });
  const Result_2 = IDL.Variant({ 'ok' : IDL.Text, 'err' : IDL.Text });
  const CreateUserRequest = IDL.Record({
    'name' : IDL.Text,
    'email' : IDL.Text,
    'image' : IDL.Text,
  });
  const Library = IDL.Record({
    'creator_name' : IDL.Text,
    'thumbnail' : IDL.Text,
    'owner' : Account__1,
    'name' : IDL.Text,
    'description' : IDL.Text,
    'nft_ids' : IDL.Vec(IDL.Nat),
    'library_id' : LibraryID,
  });
  const Tip = IDL.Record({
    'last_block_index' : IDL.Vec(IDL.Nat8),
    'hash_tree' : IDL.Vec(IDL.Nat8),
    'last_block_hash' : IDL.Vec(IDL.Nat8),
  });
  Value__1.fill(
    IDL.Variant({
      'Int' : IDL.Int,
      'Map' : IDL.Vec(IDL.Tuple(IDL.Text, Value__1)),
      'Nat' : IDL.Nat,
      'Blob' : IDL.Vec(IDL.Nat8),
      'Text' : IDL.Text,
      'Array' : IDL.Vec(Value__1),
    })
  );
  const Value = IDL.Variant({
    'Int' : IDL.Int,
    'Map' : IDL.Vec(IDL.Tuple(IDL.Text, Value__1)),
    'Nat' : IDL.Nat,
    'Blob' : IDL.Vec(IDL.Nat8),
    'Text' : IDL.Text,
    'Array' : IDL.Vec(Value__1),
  });
  const UserProfile = IDL.Record({
    'name' : IDL.Text,
    'email' : IDL.Text,
    'account' : Account__1,
    'image' : IDL.Text,
  });
  const SupportedStandards__1 = IDL.Vec(
    IDL.Record({ 'url' : IDL.Text, 'name' : IDL.Text })
  );
  const GetArchivesArgs = IDL.Record({ 'from' : IDL.Opt(IDL.Principal) });
  const GetArchivesResultItem = IDL.Record({
    'end' : IDL.Nat,
    'canister_id' : IDL.Principal,
    'start' : IDL.Nat,
  });
  const GetArchivesResult = IDL.Vec(GetArchivesResultItem);
  const TransactionRange = IDL.Record({
    'start' : IDL.Nat,
    'length' : IDL.Nat,
  });
  Value__2.fill(
    IDL.Variant({
      'Int' : IDL.Int,
      'Map' : IDL.Vec(IDL.Tuple(IDL.Text, Value__2)),
      'Nat' : IDL.Nat,
      'Blob' : IDL.Vec(IDL.Nat8),
      'Text' : IDL.Text,
      'Array' : IDL.Vec(Value__2),
    })
  );
  const TransactionRange__1 = IDL.Record({
    'start' : IDL.Nat,
    'length' : IDL.Nat,
  });
  const GetTransactionsResult__1 = IDL.Record({
    'log_length' : IDL.Nat,
    'blocks' : IDL.Vec(IDL.Record({ 'id' : IDL.Nat, 'block' : Value__2 })),
    'archived_blocks' : IDL.Vec(ArchivedTransactionResponse),
  });
  const GetTransactionsFn = IDL.Func(
      [IDL.Vec(TransactionRange__1)],
      [GetTransactionsResult__1],
      ['query'],
    );
  ArchivedTransactionResponse.fill(
    IDL.Record({
      'args' : IDL.Vec(TransactionRange__1),
      'callback' : GetTransactionsFn,
    })
  );
  const GetTransactionsResult = IDL.Record({
    'log_length' : IDL.Nat,
    'blocks' : IDL.Vec(IDL.Record({ 'id' : IDL.Nat, 'block' : Value__2 })),
    'archived_blocks' : IDL.Vec(ArchivedTransactionResponse),
  });
  const DataCertificate = IDL.Record({
    'certificate' : IDL.Vec(IDL.Nat8),
    'hash_tree' : IDL.Vec(IDL.Nat8),
  });
  const BlockType__1 = IDL.Record({
    'url' : IDL.Text,
    'block_type' : IDL.Text,
  });
  const Account__2 = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(IDL.Vec(IDL.Nat8)),
  });
  const BalanceOfRequest = IDL.Vec(Account__2);
  const BalanceOfResponse = IDL.Vec(IDL.Nat);
  const OwnerOfRequest = IDL.Vec(IDL.Nat);
  const OwnerOfResponse = IDL.Vec(IDL.Opt(Account__2));
  const TransferArgs = IDL.Record({
    'to' : Account__2,
    'token_id' : IDL.Nat,
    'memo' : IDL.Opt(IDL.Vec(IDL.Nat8)),
    'from_subaccount' : IDL.Opt(IDL.Vec(IDL.Nat8)),
    'created_at_time' : IDL.Opt(IDL.Nat64),
  });
  const TransferError = IDL.Variant({
    'GenericError' : IDL.Record({
      'message' : IDL.Text,
      'error_code' : IDL.Nat,
    }),
    'Duplicate' : IDL.Record({ 'duplicate_of' : IDL.Nat }),
    'NonExistingTokenId' : IDL.Null,
    'Unauthorized' : IDL.Null,
    'CreatedInFuture' : IDL.Record({ 'ledger_time' : IDL.Nat64 }),
    'InvalidRecipient' : IDL.Null,
    'GenericBatchError' : IDL.Record({
      'message' : IDL.Text,
      'error_code' : IDL.Nat,
    }),
    'TooOld' : IDL.Null,
  });
  const TransferResult = IDL.Variant({ 'Ok' : IDL.Nat, 'Err' : TransferError });
  const MintNFTRequest = IDL.Record({
    'bpm' : IDL.Nat32,
    'duration' : IDL.Nat32,
    'creator_name' : IDL.Text,
    'name' : IDL.Text,
    'audio_identifier' : IDL.Text,
    'description' : IDL.Text,
    'genre' : IDL.Text,
    'library_id' : LibraryID,
    'music_key' : IDL.Text,
    'audio_provider' : IDL.Text,
  });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Nat, 'err' : IDL.Text });
  const Example = IDL.Service({
    'burn_nft' : IDL.Func([IDL.Nat, LibraryID], [Result], []),
    'change_library' : IDL.Func(
        [Account__1, LibraryID, LibraryID, IDL.Nat],
        [Result],
        [],
      ),
    'create_library' : IDL.Func([CreateLibraryRequest], [Result_2], []),
    'create_user' : IDL.Func([Account__1, CreateUserRequest], [Result_2], []),
    'get_libraries' : IDL.Func(
        [IDL.Vec(LibraryID)],
        [IDL.Vec(Library)],
        ['query'],
      ),
    'get_tip' : IDL.Func([], [Tip], ['query']),
    'get_user_id' : IDL.Func([Account__1], [Result_2], ['query']),
    'get_user_libraries' : IDL.Func(
        [Account__1],
        [IDL.Vec(Library)],
        ['query'],
      ),
    'get_user_library_ids' : IDL.Func(
        [Account__1],
        [IDL.Vec(LibraryID)],
        ['query'],
      ),
    'get_user_nft_metadatas' : IDL.Func(
        [Account__1],
        [IDL.Vec(IDL.Opt(IDL.Vec(IDL.Tuple(IDL.Text, Value))))],
        ['query'],
      ),
    'get_users_from_accounts' : IDL.Func(
        [IDL.Vec(Account__1)],
        [IDL.Vec(UserProfile)],
        ['query'],
      ),
    'get_users_from_ids' : IDL.Func(
        [IDL.Vec(IDL.Text)],
        [IDL.Vec(UserProfile)],
        ['query'],
      ),
    'icrc10_supported_standards' : IDL.Func(
        [],
        [SupportedStandards__1],
        ['query'],
      ),
    'icrc3_get_archives' : IDL.Func(
        [GetArchivesArgs],
        [GetArchivesResult],
        ['query'],
      ),
    'icrc3_get_blocks' : IDL.Func(
        [IDL.Vec(TransactionRange)],
        [GetTransactionsResult],
        ['query'],
      ),
    'icrc3_get_tip_certificate' : IDL.Func(
        [],
        [IDL.Opt(DataCertificate)],
        ['query'],
      ),
    'icrc3_supported_block_types' : IDL.Func(
        [],
        [IDL.Vec(BlockType__1)],
        ['query'],
      ),
    'icrc7_atomic_batch_transfers' : IDL.Func(
        [],
        [IDL.Opt(IDL.Bool)],
        ['query'],
      ),
    'icrc7_balance_of' : IDL.Func(
        [BalanceOfRequest],
        [BalanceOfResponse],
        ['query'],
      ),
    'icrc7_collection_metadata' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, Value))],
        ['query'],
      ),
    'icrc7_default_take_value' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'icrc7_description' : IDL.Func([], [IDL.Opt(IDL.Text)], ['query']),
    'icrc7_logo' : IDL.Func([], [IDL.Opt(IDL.Text)], ['query']),
    'icrc7_max_memo_size' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'icrc7_max_query_batch_size' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'icrc7_max_take_value' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'icrc7_max_update_batch_size' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'icrc7_name' : IDL.Func([], [IDL.Text], ['query']),
    'icrc7_owner_of' : IDL.Func([OwnerOfRequest], [OwnerOfResponse], ['query']),
    'icrc7_permitted_drift' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'icrc7_supply_cap' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'icrc7_symbol' : IDL.Func([], [IDL.Text], ['query']),
    'icrc7_token_metadata' : IDL.Func(
        [IDL.Vec(IDL.Nat)],
        [IDL.Vec(IDL.Opt(IDL.Vec(IDL.Tuple(IDL.Text, Value))))],
        ['query'],
      ),
    'icrc7_tokens' : IDL.Func(
        [IDL.Opt(IDL.Nat), IDL.Opt(IDL.Nat)],
        [IDL.Vec(IDL.Nat)],
        ['query'],
      ),
    'icrc7_tokens_of' : IDL.Func(
        [Account__1, IDL.Opt(IDL.Nat), IDL.Opt(IDL.Nat)],
        [IDL.Vec(IDL.Nat)],
        ['query'],
      ),
    'icrc7_total_supply' : IDL.Func([], [IDL.Nat], ['query']),
    'icrc7_transfer' : IDL.Func(
        [IDL.Vec(TransferArgs)],
        [IDL.Vec(IDL.Opt(TransferResult))],
        [],
      ),
    'icrc7_tx_window' : IDL.Func([], [IDL.Opt(IDL.Nat)], ['query']),
    'mint_nft' : IDL.Func([Account__1, MintNFTRequest], [Result_1], []),
    'update_downloads' : IDL.Func([IDL.Nat, IDL.Nat32], [Result], []),
  });
  return Example;
};
export const init = ({ IDL }) => {
  const IndexType = IDL.Variant({
    'Stable' : IDL.Null,
    'StableTyped' : IDL.Null,
    'Managed' : IDL.Null,
  });
  const BlockType = IDL.Record({ 'url' : IDL.Text, 'block_type' : IDL.Text });
  const InitArgs__1 = IDL.Record({
    'maxRecordsToArchive' : IDL.Nat,
    'archiveIndexType' : IndexType,
    'maxArchivePages' : IDL.Nat,
    'settleToRecords' : IDL.Nat,
    'archiveCycles' : IDL.Nat,
    'maxActiveRecords' : IDL.Nat,
    'maxRecordsInArchiveInstance' : IDL.Nat,
    'archiveControllers' : IDL.Opt(IDL.Opt(IDL.Vec(IDL.Principal))),
    'supportedBlocks' : IDL.Vec(BlockType),
  });
  const InitArgs = IDL.Opt(InitArgs__1);
  const Subaccount = IDL.Vec(IDL.Nat8);
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  const SupportedStandards = IDL.Vec(
    IDL.Record({ 'url' : IDL.Text, 'name' : IDL.Text })
  );
  const InitArgs__2 = IDL.Opt(
    IDL.Record({
      'deployer' : IDL.Principal,
      'allow_transfers' : IDL.Opt(IDL.Bool),
      'supply_cap' : IDL.Opt(IDL.Nat),
      'tx_window' : IDL.Opt(IDL.Nat),
      'burn_account' : IDL.Opt(Account),
      'default_take_value' : IDL.Opt(IDL.Nat),
      'logo' : IDL.Opt(IDL.Text),
      'permitted_drift' : IDL.Opt(IDL.Nat),
      'name' : IDL.Opt(IDL.Text),
      'description' : IDL.Opt(IDL.Text),
      'max_take_value' : IDL.Opt(IDL.Nat),
      'max_update_batch_size' : IDL.Opt(IDL.Nat),
      'max_query_batch_size' : IDL.Opt(IDL.Nat),
      'max_memo_size' : IDL.Opt(IDL.Nat),
      'supported_standards' : IDL.Opt(SupportedStandards),
      'symbol' : IDL.Opt(IDL.Text),
    })
  );
  return [
    IDL.Record({
      'icrc3_args' : InitArgs,
      'icrc7_args' : IDL.Opt(InitArgs__2),
    }),
  ];
};
