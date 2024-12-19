export const idlFactory = ({ IDL }) => {
  const ArchivedTransactionResponse = IDL.Rec();
  const CandyShared = IDL.Rec();
  const Value__1 = IDL.Rec();
  const Value__2 = IDL.Rec();
  const BoolResult = IDL.Variant({ 'ok' : IDL.Bool, 'err' : IDL.Text });
  const Subaccount = IDL.Vec(IDL.Nat8);
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  const LibraryID__1 = IDL.Text;
  const Account__2 = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  const CreateLibraryRequest = IDL.Record({
    'creator_name' : IDL.Text,
    'thumbnail' : IDL.Text,
    'owner' : Account__2,
    'name' : IDL.Text,
    'description' : IDL.Text,
  });
  const StringResult = IDL.Variant({ 'ok' : IDL.Text, 'err' : IDL.Text });
  const CreateUserRequest = IDL.Record({
    'name' : IDL.Text,
    'email' : IDL.Text,
    'image' : IDL.Text,
  });
  const PrincipalsResult = IDL.Variant({
    'ok' : IDL.Vec(IDL.Principal),
    'err' : IDL.Text,
  });
  const LibraryID = IDL.Text;
  const Library = IDL.Record({
    'creator_name' : IDL.Text,
    'thumbnail' : IDL.Text,
    'owner' : Account__2,
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
    'account' : Account__2,
    'image' : IDL.Text,
  });
  const SupportedStandards = IDL.Vec(
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
  const BlockType = IDL.Record({ 'url' : IDL.Text, 'block_type' : IDL.Text });
  const Account__1 = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(IDL.Vec(IDL.Nat8)),
  });
  const BalanceOfRequest = IDL.Vec(Account__1);
  const BalanceOfResponse = IDL.Vec(IDL.Nat);
  const OwnerOfRequest = IDL.Vec(IDL.Nat);
  const OwnerOfResponse = IDL.Vec(IDL.Opt(Account__1));
  const TransferArgs = IDL.Record({
    'to' : Account__1,
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
  const PropertyShared = IDL.Record({
    'value' : CandyShared,
    'name' : IDL.Text,
    'immutable' : IDL.Bool,
  });
  CandyShared.fill(
    IDL.Variant({
      'Int' : IDL.Int,
      'Map' : IDL.Vec(IDL.Tuple(IDL.Text, CandyShared)),
      'Nat' : IDL.Nat,
      'Set' : IDL.Vec(CandyShared),
      'Nat16' : IDL.Nat16,
      'Nat32' : IDL.Nat32,
      'Nat64' : IDL.Nat64,
      'Blob' : IDL.Vec(IDL.Nat8),
      'Bool' : IDL.Bool,
      'Int8' : IDL.Int8,
      'Ints' : IDL.Vec(IDL.Int),
      'Nat8' : IDL.Nat8,
      'Nats' : IDL.Vec(IDL.Nat),
      'Text' : IDL.Text,
      'Bytes' : IDL.Vec(IDL.Nat8),
      'Int16' : IDL.Int16,
      'Int32' : IDL.Int32,
      'Int64' : IDL.Int64,
      'Option' : IDL.Opt(CandyShared),
      'Floats' : IDL.Vec(IDL.Float64),
      'Float' : IDL.Float64,
      'Principal' : IDL.Principal,
      'Array' : IDL.Vec(CandyShared),
      'ValueMap' : IDL.Vec(IDL.Tuple(CandyShared, CandyShared)),
      'Class' : IDL.Vec(PropertyShared),
    })
  );
  const NFTInput = IDL.Variant({
    'Int' : IDL.Int,
    'Map' : IDL.Vec(IDL.Tuple(IDL.Text, CandyShared)),
    'Nat' : IDL.Nat,
    'Set' : IDL.Vec(CandyShared),
    'Nat16' : IDL.Nat16,
    'Nat32' : IDL.Nat32,
    'Nat64' : IDL.Nat64,
    'Blob' : IDL.Vec(IDL.Nat8),
    'Bool' : IDL.Bool,
    'Int8' : IDL.Int8,
    'Ints' : IDL.Vec(IDL.Int),
    'Nat8' : IDL.Nat8,
    'Nats' : IDL.Vec(IDL.Nat),
    'Text' : IDL.Text,
    'Bytes' : IDL.Vec(IDL.Nat8),
    'Int16' : IDL.Int16,
    'Int32' : IDL.Int32,
    'Int64' : IDL.Int64,
    'Option' : IDL.Opt(CandyShared),
    'Floats' : IDL.Vec(IDL.Float64),
    'Float' : IDL.Float64,
    'Principal' : IDL.Principal,
    'Array' : IDL.Vec(CandyShared),
    'ValueMap' : IDL.Vec(IDL.Tuple(CandyShared, CandyShared)),
    'Class' : IDL.Vec(PropertyShared),
  });
  const MintNFTRequest = IDL.Record({
    'bpm' : IDL.Nat32,
    'duration' : IDL.Nat32,
    'creator_name' : IDL.Text,
    'audio_provider_spec' : IDL.Vec(IDL.Tuple(NFTInput, NFTInput)),
    'name' : IDL.Text,
    'audio_identifier' : IDL.Text,
    'description' : IDL.Text,
    'genre' : IDL.Text,
    'library_id' : LibraryID,
    'music_key' : IDL.Text,
    'audio_provider' : IDL.Text,
  });
  const NatResult = IDL.Variant({ 'ok' : IDL.Nat, 'err' : IDL.Text });
  const Soodio = IDL.Service({
    'add_authorized_principals' : IDL.Func(
        [IDL.Vec(IDL.Principal)],
        [BoolResult],
        [],
      ),
    'burn_nft' : IDL.Func([IDL.Nat], [BoolResult], []),
    'change_library' : IDL.Func(
        [Account, LibraryID__1, IDL.Nat],
        [BoolResult],
        [],
      ),
    'create_library' : IDL.Func([CreateLibraryRequest], [StringResult], []),
    'create_user' : IDL.Func([Account, CreateUserRequest], [StringResult], []),
    'get_authorized_principals' : IDL.Func([], [PrincipalsResult], []),
    'get_libraries' : IDL.Func(
        [IDL.Vec(LibraryID__1)],
        [IDL.Vec(Library)],
        ['query'],
      ),
    'get_owner' : IDL.Func([], [IDL.Principal], ['query']),
    'get_tip' : IDL.Func([], [Tip], ['query']),
    'get_user_id' : IDL.Func([Account], [StringResult], ['query']),
    'get_user_libraries' : IDL.Func([Account], [IDL.Vec(Library)], ['query']),
    'get_user_library_ids' : IDL.Func(
        [Account],
        [IDL.Vec(LibraryID__1)],
        ['query'],
      ),
    'get_user_nft_metadatas' : IDL.Func(
        [Account],
        [IDL.Vec(IDL.Opt(IDL.Vec(IDL.Tuple(IDL.Text, Value))))],
        ['query'],
      ),
    'get_users_from_accounts' : IDL.Func(
        [IDL.Vec(Account)],
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
        [SupportedStandards],
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
        [IDL.Vec(BlockType)],
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
        [Account, IDL.Opt(IDL.Nat), IDL.Opt(IDL.Nat)],
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
    'is_library_unique' : IDL.Func([Account, IDL.Text], [IDL.Bool], ['query']),
    'is_username_unique' : IDL.Func([IDL.Text], [IDL.Bool], ['query']),
    'mint_nft' : IDL.Func([Account, MintNFTRequest], [NatResult], []),
    'revoke_authorization' : IDL.Func([IDL.Principal], [BoolResult], []),
    'update_downloads' : IDL.Func([IDL.Nat, IDL.Nat32], [BoolResult], []),
  });
  return Soodio;
};
export const init = ({ IDL }) => { return []; };
