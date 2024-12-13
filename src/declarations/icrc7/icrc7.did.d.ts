import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Account {
  'owner' : Principal,
  'subaccount' : [] | [Subaccount],
}
export interface Account__1 {
  'owner' : Principal,
  'subaccount' : [] | [Subaccount],
}
export interface Account__2 {
  'owner' : Principal,
  'subaccount' : [] | [Uint8Array | number[]],
}
export interface ArchivedTransactionResponse {
  'args' : Array<TransactionRange__1>,
  'callback' : GetTransactionsFn,
}
export type BalanceOfRequest = Array<Account__2>;
export type BalanceOfResponse = Array<bigint>;
export interface BlockType { 'url' : string, 'block_type' : string }
export interface BlockType__1 { 'url' : string, 'block_type' : string }
export type CandyShared = { 'Int' : bigint } |
  { 'Map' : Array<[string, CandyShared]> } |
  { 'Nat' : bigint } |
  { 'Set' : Array<CandyShared> } |
  { 'Nat16' : number } |
  { 'Nat32' : number } |
  { 'Nat64' : bigint } |
  { 'Blob' : Uint8Array | number[] } |
  { 'Bool' : boolean } |
  { 'Int8' : number } |
  { 'Ints' : Array<bigint> } |
  { 'Nat8' : number } |
  { 'Nats' : Array<bigint> } |
  { 'Text' : string } |
  { 'Bytes' : Uint8Array | number[] } |
  { 'Int16' : number } |
  { 'Int32' : number } |
  { 'Int64' : bigint } |
  { 'Option' : [] | [CandyShared] } |
  { 'Floats' : Array<number> } |
  { 'Float' : number } |
  { 'Principal' : Principal } |
  { 'Array' : Array<CandyShared> } |
  { 'ValueMap' : Array<[CandyShared, CandyShared]> } |
  { 'Class' : Array<PropertyShared> };
export interface CreateLibraryRequest {
  'creator_name' : string,
  'thumbnail' : string,
  'owner' : Account__1,
  'name' : string,
  'description' : string,
}
export interface CreateUserRequest {
  'name' : string,
  'email' : string,
  'image' : string,
}
export interface DataCertificate {
  'certificate' : Uint8Array | number[],
  'hash_tree' : Uint8Array | number[],
}
export interface Example {
  'burn_nft' : ActorMethod<[bigint], Result>,
  'change_library' : ActorMethod<[Account__1, LibraryID, bigint], Result>,
  'create_library' : ActorMethod<[CreateLibraryRequest], Result_2>,
  'create_user' : ActorMethod<[Account__1, CreateUserRequest], Result_2>,
  'get_libraries' : ActorMethod<[Array<LibraryID>], Array<Library>>,
  'get_tip' : ActorMethod<[], Tip>,
  'get_user_id' : ActorMethod<[Account__1], Result_2>,
  'get_user_libraries' : ActorMethod<[Account__1], Array<Library>>,
  'get_user_library_ids' : ActorMethod<[Account__1], Array<LibraryID>>,
  'get_user_nft_metadatas' : ActorMethod<
    [Account__1],
    Array<[] | [Array<[string, Value]>]>
  >,
  'get_users_from_accounts' : ActorMethod<
    [Array<Account__1>],
    Array<UserProfile>
  >,
  'get_users_from_ids' : ActorMethod<[Array<string>], Array<UserProfile>>,
  'icrc10_supported_standards' : ActorMethod<[], SupportedStandards__1>,
  'icrc3_get_archives' : ActorMethod<[GetArchivesArgs], GetArchivesResult>,
  'icrc3_get_blocks' : ActorMethod<
    [Array<TransactionRange>],
    GetTransactionsResult
  >,
  'icrc3_get_tip_certificate' : ActorMethod<[], [] | [DataCertificate]>,
  'icrc3_supported_block_types' : ActorMethod<[], Array<BlockType__1>>,
  'icrc7_atomic_batch_transfers' : ActorMethod<[], [] | [boolean]>,
  'icrc7_balance_of' : ActorMethod<[BalanceOfRequest], BalanceOfResponse>,
  'icrc7_collection_metadata' : ActorMethod<[], Array<[string, Value]>>,
  'icrc7_default_take_value' : ActorMethod<[], [] | [bigint]>,
  'icrc7_description' : ActorMethod<[], [] | [string]>,
  'icrc7_logo' : ActorMethod<[], [] | [string]>,
  'icrc7_max_memo_size' : ActorMethod<[], [] | [bigint]>,
  'icrc7_max_query_batch_size' : ActorMethod<[], [] | [bigint]>,
  'icrc7_max_take_value' : ActorMethod<[], [] | [bigint]>,
  'icrc7_max_update_batch_size' : ActorMethod<[], [] | [bigint]>,
  'icrc7_name' : ActorMethod<[], string>,
  'icrc7_owner_of' : ActorMethod<[OwnerOfRequest], OwnerOfResponse>,
  'icrc7_permitted_drift' : ActorMethod<[], [] | [bigint]>,
  'icrc7_supply_cap' : ActorMethod<[], [] | [bigint]>,
  'icrc7_symbol' : ActorMethod<[], string>,
  'icrc7_token_metadata' : ActorMethod<
    [Array<bigint>],
    Array<[] | [Array<[string, Value]>]>
  >,
  'icrc7_tokens' : ActorMethod<[[] | [bigint], [] | [bigint]], Array<bigint>>,
  'icrc7_tokens_of' : ActorMethod<
    [Account__1, [] | [bigint], [] | [bigint]],
    Array<bigint>
  >,
  'icrc7_total_supply' : ActorMethod<[], bigint>,
  'icrc7_transfer' : ActorMethod<
    [Array<TransferArgs>],
    Array<[] | [TransferResult]>
  >,
  'icrc7_tx_window' : ActorMethod<[], [] | [bigint]>,
  'mint_nft' : ActorMethod<[Account__1, MintNFTRequest], Result_1>,
  'update_downloads' : ActorMethod<[bigint, number], Result>,
}
export interface GetArchivesArgs { 'from' : [] | [Principal] }
export type GetArchivesResult = Array<GetArchivesResultItem>;
export interface GetArchivesResultItem {
  'end' : bigint,
  'canister_id' : Principal,
  'start' : bigint,
}
export type GetTransactionsFn = ActorMethod<
  [Array<TransactionRange__1>],
  GetTransactionsResult__1
>;
export interface GetTransactionsResult {
  'log_length' : bigint,
  'blocks' : Array<{ 'id' : bigint, 'block' : Value__2 }>,
  'archived_blocks' : Array<ArchivedTransactionResponse>,
}
export interface GetTransactionsResult__1 {
  'log_length' : bigint,
  'blocks' : Array<{ 'id' : bigint, 'block' : Value__2 }>,
  'archived_blocks' : Array<ArchivedTransactionResponse>,
}
export type IndexType = { 'Stable' : null } |
  { 'StableTyped' : null } |
  { 'Managed' : null };
export type InitArgs = [] | [InitArgs__1];
export interface InitArgs__1 {
  'maxRecordsToArchive' : bigint,
  'archiveIndexType' : IndexType,
  'maxArchivePages' : bigint,
  'settleToRecords' : bigint,
  'archiveCycles' : bigint,
  'maxActiveRecords' : bigint,
  'maxRecordsInArchiveInstance' : bigint,
  'archiveControllers' : [] | [[] | [Array<Principal>]],
  'supportedBlocks' : Array<BlockType>,
}
export type InitArgs__2 = [] | [
  {
    'deployer' : Principal,
    'allow_transfers' : [] | [boolean],
    'supply_cap' : [] | [bigint],
    'tx_window' : [] | [bigint],
    'burn_account' : [] | [Account],
    'default_take_value' : [] | [bigint],
    'logo' : [] | [string],
    'permitted_drift' : [] | [bigint],
    'name' : [] | [string],
    'description' : [] | [string],
    'max_take_value' : [] | [bigint],
    'max_update_batch_size' : [] | [bigint],
    'max_query_batch_size' : [] | [bigint],
    'max_memo_size' : [] | [bigint],
    'supported_standards' : [] | [SupportedStandards],
    'symbol' : [] | [string],
  }
];
export interface Library {
  'creator_name' : string,
  'thumbnail' : string,
  'owner' : Account__1,
  'name' : string,
  'description' : string,
  'nft_ids' : Array<bigint>,
  'library_id' : LibraryID,
}
export type LibraryID = string;
export interface MintNFTRequest {
  'bpm' : number,
  'duration' : number,
  'creator_name' : string,
  'audio_provider_spec' : Array<[NFTInput, NFTInput]>,
  'name' : string,
  'audio_identifier' : string,
  'description' : string,
  'genre' : string,
  'library_id' : LibraryID,
  'music_key' : string,
  'audio_provider' : string,
}
export type NFTInput = { 'Int' : bigint } |
  { 'Map' : Array<[string, CandyShared]> } |
  { 'Nat' : bigint } |
  { 'Set' : Array<CandyShared> } |
  { 'Nat16' : number } |
  { 'Nat32' : number } |
  { 'Nat64' : bigint } |
  { 'Blob' : Uint8Array | number[] } |
  { 'Bool' : boolean } |
  { 'Int8' : number } |
  { 'Ints' : Array<bigint> } |
  { 'Nat8' : number } |
  { 'Nats' : Array<bigint> } |
  { 'Text' : string } |
  { 'Bytes' : Uint8Array | number[] } |
  { 'Int16' : number } |
  { 'Int32' : number } |
  { 'Int64' : bigint } |
  { 'Option' : [] | [CandyShared] } |
  { 'Floats' : Array<number> } |
  { 'Float' : number } |
  { 'Principal' : Principal } |
  { 'Array' : Array<CandyShared> } |
  { 'ValueMap' : Array<[CandyShared, CandyShared]> } |
  { 'Class' : Array<PropertyShared> };
export type OwnerOfRequest = Array<bigint>;
export type OwnerOfResponse = Array<[] | [Account__2]>;
export interface PropertyShared {
  'value' : CandyShared,
  'name' : string,
  'immutable' : boolean,
}
export type Result = { 'ok' : boolean } |
  { 'err' : string };
export type Result_1 = { 'ok' : bigint } |
  { 'err' : string };
export type Result_2 = { 'ok' : string } |
  { 'err' : string };
export type Subaccount = Uint8Array | number[];
export type SupportedStandards = Array<{ 'url' : string, 'name' : string }>;
export type SupportedStandards__1 = Array<{ 'url' : string, 'name' : string }>;
export interface Tip {
  'last_block_index' : Uint8Array | number[],
  'hash_tree' : Uint8Array | number[],
  'last_block_hash' : Uint8Array | number[],
}
export interface TransactionRange { 'start' : bigint, 'length' : bigint }
export interface TransactionRange__1 { 'start' : bigint, 'length' : bigint }
export interface TransferArgs {
  'to' : Account__2,
  'token_id' : bigint,
  'memo' : [] | [Uint8Array | number[]],
  'from_subaccount' : [] | [Uint8Array | number[]],
  'created_at_time' : [] | [bigint],
}
export type TransferError = {
    'GenericError' : { 'message' : string, 'error_code' : bigint }
  } |
  { 'Duplicate' : { 'duplicate_of' : bigint } } |
  { 'NonExistingTokenId' : null } |
  { 'Unauthorized' : null } |
  { 'CreatedInFuture' : { 'ledger_time' : bigint } } |
  { 'InvalidRecipient' : null } |
  { 'GenericBatchError' : { 'message' : string, 'error_code' : bigint } } |
  { 'TooOld' : null };
export type TransferResult = { 'Ok' : bigint } |
  { 'Err' : TransferError };
export interface UserProfile {
  'name' : string,
  'email' : string,
  'account' : Account__1,
  'image' : string,
}
export type Value = { 'Int' : bigint } |
  { 'Map' : Array<[string, Value__1]> } |
  { 'Nat' : bigint } |
  { 'Blob' : Uint8Array | number[] } |
  { 'Text' : string } |
  { 'Array' : Array<Value__1> };
export type Value__1 = { 'Int' : bigint } |
  { 'Map' : Array<[string, Value__1]> } |
  { 'Nat' : bigint } |
  { 'Blob' : Uint8Array | number[] } |
  { 'Text' : string } |
  { 'Array' : Array<Value__1> };
export type Value__2 = { 'Int' : bigint } |
  { 'Map' : Array<[string, Value__2]> } |
  { 'Nat' : bigint } |
  { 'Blob' : Uint8Array | number[] } |
  { 'Text' : string } |
  { 'Array' : Array<Value__2> };
export interface _SERVICE extends Example {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
