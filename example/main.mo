// Base library imports
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import D "mo:base/Debug";
import Map "mo:map/Map";
import Set "mo:map/Set";
// import { n32hash } "mo:map/Map";
import { nhash } "mo:map/Map";
import { thash } "mo:map/Map";
import Result "mo:base/Result";
import Vec "mo:vector";


// Certified data for ICRC-3
import CertifiedData "mo:base/CertifiedData";
import Bool "mo:base/Bool";
import CertTree "mo:cert/CertTree";

// Standards
import ICRC7 "mo:icrc7-mo";
import ICRC37 "mo:icrc37-mo";
import ICRC3 "mo:icrc3-mo";
import {ahash} "types";

// Default init args
import ICRC7Default "./initial_state/icrc7";
import ICRC37Default "./initial_state/icrc37";
import ICRC3Default "./initial_state/icrc3";

// UUID
import Source "mo:uuid/async/SourceV4";
import UUID "mo:uuid/UUID";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";




// _init_msg is used to get the principal of the deployer
shared(_init_msg) actor class Example(_args : {
  icrc7_args: ?ICRC7.InitArgs;
  icrc37_args: ?ICRC37.InitArgs;
  icrc3_args: ICRC3.InitArgs;
}) = this {

  type Account =                          ICRC7.Account;
  type Environment =                      ICRC7.Environment;
  type Value =                            ICRC7.Value;
  type NFT =                              ICRC7.NFT;
  type NFTShared =                        ICRC7.NFTShared;
  type NFTMap =                           ICRC7.NFTMap;
  type SetNFTRequest = ICRC7.SetNFTRequest;
  type SetNFTItemRequest = ICRC7.SetNFTItemRequest;
  type NFTInput = ICRC7.NFTInput;

  type OwnerOfResponse =                    ICRC7.Service.OwnerOfResponse;
  type OwnerOfRequest =                    ICRC7.Service.OwnerOfRequest;
  type TransferArgs =                     ICRC7.Service.TransferArg;
  type TransferResult =                   ICRC7.Service.TransferResult;
  type TransferError =                    ICRC7.Service.TransferError;
  type BalanceOfRequest =                 ICRC7.Service.BalanceOfRequest;
  type BalanceOfResponse =                ICRC7.Service.BalanceOfResponse;
  type TokenApproval =                    ICRC37.Service.TokenApproval;
  type CollectionApproval =               ICRC37.Service.CollectionApproval;
  type ApprovalInfo =                     ICRC37.Service.ApprovalInfo;
  type ApproveTokenResult =                 ICRC37.Service.ApproveTokenResult;
  type ApproveTokenArg =                   ICRC37.Service.ApproveTokenArg; 
  type ApproveCollectionArg =              ICRC37.Service.ApproveCollectionArg; 
  type IsApprovedArg =                     ICRC37.Service.IsApprovedArg;

  type ApproveCollectionResult =       ICRC37.Service.ApproveCollectionResult;
  type RevokeTokenApprovalArg =                 ICRC37.Service.RevokeTokenApprovalArg;

  type RevokeCollectionApprovalArg =             ICRC37.Service.RevokeCollectionApprovalArg;

  type TransferFromArg =                 ICRC37.Service.TransferFromArg;
  type TransferFromResult =             ICRC37.Service.TransferFromResult;
  type RevokeTokenApprovalResult =             ICRC37.Service.RevokeTokenApprovalResult;
  type RevokeCollectionApprovalResult =         ICRC37.Service.RevokeCollectionApprovalResult;

  stable var init_msg = _init_msg; //preserves original initialization;

  // Data types for Management
  public type LibraryID = Nat;
  type LibraryIDS = Set.Set<LibraryID>;

  public type Library = {
    library_id: LibraryID;
    name: Text;
    description: Text;
    thumbnail: Text;
    owner: Account;
    nft_ids: [Nat];
  };

  public type CreateLibraryRequest = {
    name: Text;
    description: Text;
    thumbnail: Text;
    owner: Account;
  };

  public type CreateUserRequest = {
    name: Text;
    email: Text;
    image: Text;
  };

  public type UserProfile = {
    name: Text;
    email: Text;
    image: Text;
    account: Account;
  };

  // Stable variables
  stable var userslibraries = Map.new<Account, LibraryIDS>();
  stable var libraries = Map.new<LibraryID, Library>();
  stable var userids = Map.new<Account, Text>();
  stable var userprofiles = Map.new<Text, UserProfile>();

// User related functions
  // Get user from ID
  public query func get_users_from_ids(user_ids: [Text]): async [UserProfile] {
    return get_users(user_ids);
  };

  // Get user from Account
  public query func get_users_from_accounts(accounts: [Account]): async [UserProfile] {
    let user_ids_vec = Vec.new<Text>();
    for (account in accounts.vals()) {
      let uid: ?Text = Map.get(userids, ahash, account);
      switch uid {
        case (?val) {
          Vec.add(user_ids_vec, val);
        };
        case (null) {};
      };
    };
    let user_ids = Vec.toArray(user_ids_vec);
    return get_users(user_ids);
  };

  public query  func get_user_id(account: Account): async Result.Result<Text, Text> {
    let user_id: ?Text = Map.get(userids, ahash, account);
    switch (user_id) {
      case (?val) {
        return (#ok(val));
      };
      case (null) {
        return #err("Non existent profile");
      }
    }
  };

  private func get_users(user_ids: [Text]): [UserProfile] {
    let users = Vec.new<UserProfile>();
    for (user_id in user_ids.vals()) {
      let user: ?UserProfile = Map.get(userprofiles, thash, user_id);
      switch user {
        case (?val) {
          Vec.add(users, val);
        };
        case (null) {};
      };
    };
    return Vec.toArray(users);
  };

  // Create user
  public shared(msg) func create_user(
    account: Account,
    user_req: CreateUserRequest
  ): async Result.Result<Text, Text> {
    // Only the admin can create a user
    if(msg.caller != icrc7().get_state().owner) return #err("Unauthorized admin");
    let acc: ?Text = Map.get(userids, ahash, account);
    switch (acc) {
      case (?_val) {
        return #err("User already exists");
      };
      case null{}
    };

    let uuid: Text = await generate_uuid_text();

    let user: UserProfile = {
      name= user_req.name;
      email= user_req.email;
      image= user_req.image;
      account= account;
    };

    // Map Account to uuid
    Map.set(userids, ahash, account, uuid);

    // Map uuid to profile
    Map.set(userprofiles, thash, uuid, user);
    return #ok(uuid);
  };


// Library related functions

  // Create a library
  public shared(msg) func create_library(
    libreq: CreateLibraryRequest
  ): async Result.Result<Nat, Text> {
    // Only the admin can create a library
    if(msg.caller != icrc7().get_state().owner) return #err("Unauthorized admin");

    // UUID
    let uuid = await generate_uuid_nat();

    let library: Library = {
      description = libreq.description;
      library_id = uuid;
      name = libreq.name;
      owner = libreq.owner;
      thumbnail = libreq.thumbnail;
      nft_ids = [];
    };
  
    // 1) Create the library
    Map.set(libraries, nhash, uuid , library);

    // 2) Update the user libraries
    let userlibs: ?LibraryIDS = Map.get(userslibraries, ahash, library.owner);

    switch userlibs {
      case (?val) {
        // User account exists, and hence add the new library to user account
        let _result: Bool = Set.put(val, nhash, library.library_id);
        let _result1 = Map.put(userslibraries, ahash, library.owner, val);
      };
      case (null) {
        // User account doesn't exist, hence add new account to the mapping
        let newSet = Set.new<LibraryID>();
        let _result: Bool = Set.put(newSet, nhash, library.library_id);
        let _result1 = Map.put(userslibraries, ahash, library.owner, newSet);
      };
    };

    return #ok(library.library_id);
  };


  // Get multiple Libraries
  public query func get_libraries(library_ids: [LibraryID]): async [Library] {
    return get_libraries_private(library_ids);
  };

  private func get_libraries_private(library_ids: [LibraryID]): [Library] {
    let libs = Vec.new<Library>();
    for (lib_id in library_ids.vals()) {
      let lib: ?Library = Map.get(libraries, nhash, lib_id);
      switch lib {
        case (?val) {
          Vec.add(libs, val);
        };
        case (null) {};
      };
    };
    return Vec.toArray(libs);
  };

  // Change library or assign a  library
  // Access restricted to only the admin
  public shared(msg) func change_library(
    owner: Account, library_id_from: ?LibraryID,
    library_id_to: LibraryID, nft_id: Nat
  ): async Result.Result<Bool,Text> {
    // Checks

    // 1) Caller must be the admin of the NFT collection
    let admin = icrc7().get_state().owner;
    if (admin != msg.caller) return #err("Unauthorized caller");

    // 2) Account must be the owner of the NFT
    switch( icrc7().get_token_owner_canonical(nft_id) ){
      case(#ok(val)) {
        let acc = val;
        if (owner != acc) {
          return #err("Unauthorized token owner");
        }
      };
      case _ return #err("Invalid Tokenid");
    };

    // 3) Account must be the owner of the library two
    let lib_quer: ?Library = Map.get(libraries, nhash, library_id_to);
    switch lib_quer {
      case(?val) {
        if (val.owner != owner) {
          return #err("Unauthorized library to");
        };
      };
      case(null) {
        return #err("Invalid library to");
      };
    };


    // Changes

    // 1) Remove NFT from library 1 if present in the input
    switch library_id_from {
      case (?lib_id_from) {
        let lib_from: ?Library = Map.get(libraries, nhash, lib_id_from);
        switch lib_from {
          case (?val) {
            // Remove item
            // Warn: O(N) operation
            // Couldn't implement a hash set due to stable memory limitation
            // let new_list = List.filter<Nat>(val.nft_ids, func(item: Nat): Bool{
            //   item != nft_id
            // });

            let arr: [Nat] = Array.filter<Nat>(val.nft_ids, func x = x!= nft_id);

            let updated_lib: Library = {
              description = val.description;
              library_id = val.library_id;
              name = val.name;
              nft_ids = arr;
              owner = val.owner;
              thumbnail = val.thumbnail;
            };

            Map.set(libraries, nhash, lib_id_from, updated_lib);
          };
          case (null) {};
        };
      };
      // If there is no from library, then the nft must not have a field called library_id
      case (null) {
        let metadatas = icrc7().token_metadata([nft_id]);
        let metadata = metadatas[0];
        let hasLibraryId: Bool = switch (metadata) {
          case null { false };
          case (?map) {
            switch (Array.find(map, func((key, _): (Text, Value)): Bool {
              key == "library_id"
            })) {
              case null { false };
              case (?_) { true };
            }
          };
        };
        if (hasLibraryId) return #err("library id exists")
      };
    };


    // 2) Add the NFT to library to
    let lib_to: ?Library = Map.get(libraries, nhash, library_id_to);
    switch lib_to {
      case (?val) {
        // Add item
        // Warn: O(n) operation, could not implement better data structure due to stable
        // structure limitation
        // let new_list = List.push(nft_id, val.nft_ids);
        let buffer = Buffer.fromArray<Nat>(val.nft_ids);
        buffer.add(nft_id);

        let updated_lib: Library = {
          description = val.description;
          library_id = val.library_id;
          name = val.name;
          nft_ids = Buffer.toArray(buffer);
          owner = val.owner;
          thumbnail = val.thumbnail;
        };

        Map.set(libraries, nhash, library_id_to, updated_lib);
      };
      case (null) {
      };
    };

    // 3) Update the NFT metadata
    let update_request: ICRC7.UpdateNFTRequest = 
    [
      {
        token_id = nft_id;
        created_at_time = null;
        memo = null;
        updates = [
          {
            name = "library_id";
            mode = #Set(#Nat(library_id_to));
          }
        ];
      }
    ];

    let result = icrc7().update_nfts<system>(msg.caller, update_request);
    switch (result) {
      case (#ok(_val)) return #ok(true);
      case (#err(error)) return #err(error);
    };
  };

  // Get list of library ids of users
  public query func get_user_library_ids(user: Account): async [LibraryID] {
    return get_user_library_ids_private(user);
  };

  private func get_user_library_ids_private(user: Account): [LibraryID] {
    let result: ?LibraryIDS = Map.get(userslibraries, ahash, user);
    switch(result) {
      case(?val) {
        let array = Set.toArray(val);
        return array;
      };
      case null {
        return [];
      };
    };
  };

  // Get list of libraries of users
  public query func get_user_libraries(user: Account): async [Library] {
    // 1) Get user ids
    let ids: [LibraryID] = get_user_library_ids_private(user);
    let libraries = get_libraries_private(ids);
    return libraries;
  };

  // Update the downloads of an NFT
  // Only admin can access
  // Set to take a variable to allow batch updates in the future
  public shared(msg) func update_downloads(
    nft_id: Nat, downloads: Nat32
  ): async Result.Result<Bool, Text> {
    // Admin check
    if (msg.caller != icrc7().get_state().owner) return #err("Unauthorized");

    // Token must exist
    switch( icrc7().get_token_owner_canonical(nft_id) ){
      case(#ok(_val)) {};
      case (#err(_msg)) return #err("Invalid Tokenid");
    };


    let update_request: ICRC7.UpdateNFTRequest = 
    [
      {
        token_id = nft_id;
        created_at_time = null;
        memo = null;
        updates = [
          {
            name = "downloads";
            mode = #Set(#Nat32(downloads));
          }
        ];
      }
    ];

    let result = icrc7().update_nfts<system>(msg.caller, update_request);
    switch (result) {
      case (#ok(_val)) return #ok(true);
      case (#err(error)) return #err(error);
    };
  };

  public shared(msg) func mint_nft(
    owner: ?Account, metadata: NFTInput
  ) : async Result.Result<Nat, Text> {

    // 1) Generate UUID
    let uuid: Nat = await generate_uuid_nat();

    let req: SetNFTItemRequest = {
      token_id= uuid;
      owner= owner;
      metadata = metadata;
      created_at_time = null;
      memo = null;
      override = true;
    };

    // 2) Add that into the metadata

    // Official function provided by ICRC-7 to mint an NFT
    // Must be careful as calling set_nfts on existing token will replace it with new metadata
    // Only the deployer can call this function
    switch(icrc7().set_nfts<system>(msg.caller, [req], true)){
      // The value is just the transaction id, not required
      case(#ok(_val)) {
        return #ok(uuid);
      };
      case(#err(err)) #err(err)
    };
  };

  public shared(msg) func burn_nft(
    tokens: [Nat]
  ) : async Result.Result<Bool, Text> {
    let burnrequest = {
      tokens = tokens;
      memo = null;
      created_at_time = null;
    };

    // Check if the account is the owner of the tokens
    // Removal of a token from library in case of a burn

    // 1) Obtain the library id of the nft to clear it after success
    /*
      let metadatas = icrc7().token_metadata(tokens);
      let metadata = metadatas[0];
      var lib_id = 0;
      switch(metadata) {
        case(?val) {  
          // This operation depends on the structure of the metadata
          for ((k, v) in val.vals()) {
            if (k == "library_id") {
                lib_id := ?v;
            }
          };
        };
        case(null) { };
      };
    */

    switch(icrc7().burn_nfts<system>(msg.caller, burnrequest)){
      case(#ok(_val)) {
        return #ok(true);
      };
      case(#err(err)) #err(err);
    };
    /*
      // Iterate over the list of BurnNFTItemResponse
      for (response in burnResponses) {
        switch (response.result) {
          case (#Ok(tokenId)) {
            // Access the token_id
            let nftId = response.token_id;
            // Process the token_id as needed
          };
          case (#Err(burnError)) {
            // Handle the burn error as needed
          };
        };
      };
      case (#Err(batchError)) {
        // Handle the batch error as needed
      };
    */
  };

  public func get_user_nft_metadatas(user: Account): async [?[(Text, Value)]] {
    // 1) Get all the token ids of the user
    let token_ids = icrc7().get_tokens_of_paginated(user, null, null);
    // 2) Get the metadata
    return icrc7().token_metadata(token_ids);
  };

  // Function to generate unique id
  private func generate_uuid_nat(): async Nat {
    let g = Source.Source();
    let val = await g.new();
    var result : Nat = 0;
    for (byte in val.vals()) {
      result := result * 256 + Nat8.toNat(byte);
    };
    result
  };

  private func generate_uuid_text(): async Text {
    let g = Source.Source();
    UUID.toText(await g.new());
  };

  // Initializing Migration state for migrating to future versions
  stable var icrc7_migration_state = ICRC7.init(
    ICRC7.initialState() , 
    #v0_1_0(#id), 
    switch(_args.icrc7_args){
      case(null) ICRC7Default.defaultConfig(init_msg.caller);
      case(?val) val;
      }, 
    init_msg.caller);

  let #v0_1_0(#data(icrc7_state_current)) = icrc7_migration_state;

  stable var icrc37_migration_state = ICRC37.init(
    ICRC37.initialState() , 
    #v0_1_0(#id), 
    switch(_args.icrc37_args){
      case(null) ICRC37Default.defaultConfig(init_msg.caller);
      case(?val) val;
      }, 
    init_msg.caller);

  let #v0_1_0(#data(icrc37_state_current)) = icrc37_migration_state;

  stable var icrc3_migration_state = ICRC3.init(
    ICRC3.initialState() ,
    #v0_1_0(#id), 
    switch(_args.icrc3_args){
      case(null) ICRC3Default.defaultConfig(init_msg.caller);
      case(?val) ?val : ICRC3.InitArgs;
      }, 
    init_msg.caller);

  let #v0_1_0(#data(icrc3_state_current)) = icrc3_migration_state;

  private var _icrc7 : ?ICRC7.ICRC7 = null;
  private var _icrc37 : ?ICRC37.ICRC37 = null;
  private var _icrc3 : ?ICRC3.ICRC3 = null;

  // Obtaining the current state
  private func get_icrc7_state() : ICRC7.CurrentState {
    return icrc7_state_current;
  };

  private func get_icrc37_state() : ICRC37.CurrentState {
    return icrc37_state_current;
  };

  // Unused - Why?
  private func get_icrc3_state() : ICRC3.CurrentState {
    return icrc3_state_current;
  };

  // Certification functions - ICRC-3

  // CertTree is from another package
  stable let cert_store : CertTree.Store = CertTree.newStore();
  let ct = CertTree.Ops(cert_store);

  private func get_certificate_store() : CertTree.Store {
    D.print("returning cert store " # debug_show(cert_store));
    return cert_store;
  };

  private func updated_certification(_cert: Blob, _lastIndex: Nat) : Bool{

    D.print("updating the certification " # debug_show(CertifiedData.getCertificate(), ct.treeHash()));
    ct.setCertifiedData();
    D.print("did the certification " # debug_show(CertifiedData.getCertificate()));
    return true;
  };

  D.print("Initargs: " # debug_show(_args));

  func ensure_block_types(icrc3Class: ICRC3.ICRC3) : () {
    D.print("in ensure_block_types: ");
    let supportedBlocks = Buffer.fromIter<ICRC3.BlockType>(icrc3Class.supported_block_types().vals());

    let blockequal = func(a : {block_type: Text}, b : {block_type: Text}) : Bool {
      a.block_type == b.block_type;
    };

    for(thisItem in icrc7().supported_blocktypes().vals()){
      if(Buffer.indexOf<ICRC3.BlockType>({block_type = thisItem.0; url=thisItem.1;}, supportedBlocks, blockequal) == null){
        supportedBlocks.add({block_type = thisItem.0; url = thisItem.1});
      };
    };

    for(thisItem in icrc37().supported_blocktypes().vals()){
      if(Buffer.indexOf<ICRC3.BlockType>({block_type = thisItem.0; url=thisItem.1;}, supportedBlocks, blockequal) == null){
        supportedBlocks.add({block_type = thisItem.0; url = thisItem.1});
      };
    };

    icrc3Class.update_supported_blocks(Buffer.toArray(supportedBlocks));
  };

  // Initializing instances of the standards
  private func get_icrc3_environment() : ICRC3.Environment{
    ?{
      updated_certification = ?updated_certification;
      get_certificate_store = ?get_certificate_store;
    };
  };

  func icrc3() : ICRC3.ICRC3 {
    switch(_icrc3){
      case(null){
        let initclass : ICRC3.ICRC3 = ICRC3.ICRC3(?icrc3_migration_state, Principal.fromActor(this), get_icrc3_environment());
        
        D.print("ensure should be done: " # debug_show(initclass.supported_block_types()));
        _icrc3 := ?initclass;
        ensure_block_types(initclass);
        
        initclass;
      };
      case(?val) val;
    };
  };

  type TransferNotification = {
    from : Account;
    to : Account;
    token_id : Nat;
    memo : ?Blob;
    created_at_time : ?Nat64;
  };
  public type Transaction = Value;

  private func get_icrc7_environment() : ICRC7.Environment {
    {
      canister = get_canister;
      get_time = get_time;
      refresh_state = get_icrc7_state;
      add_ledger_transaction = ?icrc3().add_record;
      can_mint = null;
      can_burn = null;
      can_transfer = null;
      // Potential function to disable transfer permanently
      // can_transfer = ?(
      //   func<system>(trx: Transaction, trxtop: ?Transaction, notification: TransferNotification)
      //       : Result.Result<(Transaction, ?Transaction, TransferNotification), Text> {
      //       // Return an appropriate error or result
      //       return #err("Transfer is not allowed: This token is non-transferable.");
      //   });
      can_update = null;
    };
  };

  private func get_icrc37_environment() : ICRC37.Environment {
    {
      canister = get_canister;
      get_time = get_time;
      refresh_state = get_icrc37_state;
      icrc7 = icrc7();
      can_transfer_from = null;
      can_approve_token = null;
      can_approve_collection = null;
      can_revoke_token_approval = null;
      can_revoke_collection_approval = null;
    };
  };

  func icrc7() : ICRC7.ICRC7 {
    switch(_icrc7){
      case(null){
        let initclass : ICRC7.ICRC7 = ICRC7.ICRC7(?icrc7_migration_state, Principal.fromActor(this), get_icrc7_environment());
        _icrc7 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  func icrc37() : ICRC37.ICRC37 {
    switch(_icrc37){
      case(null){
        let initclass : ICRC37.ICRC37 = ICRC37.ICRC37(?icrc37_migration_state, Principal.fromActor(this), get_icrc37_environment());
        _icrc37 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  // Helper functions for environment
  private var canister_principal : ?Principal = null;

  private func get_canister() : Principal {
    switch (canister_principal) {
        case (null) {
            canister_principal := ?Principal.fromActor(this);
            Principal.fromActor(this);
        };
        case (?val) {
            val;
        };
    };
  };

  private func get_time() : Int{
      //note: you may want to implement a testing framework where you can set this time manually
      /* switch(state_current.testing.time_mode){
          case(#test){
              state_current.testing.test_time;
          };
          case(#standard){
               Time.now();
          };
      }; */
    Time.now();
  };

  /////////
  // ICRC-37 endpoints
  /////////
  public query func icrc7_symbol() : async Text {
    return switch(icrc7().get_ledger_info().symbol){
      case(?val) val;
      case(null) "";
    };
  };

  public query func icrc7_name() : async Text {
    return switch(icrc7().get_ledger_info().name){
      case(?val) val;
      case(null) "";
    };
  };

  public query func icrc7_description() : async ?Text {
    return icrc7().get_ledger_info().description;
  };

  public query func icrc7_logo() : async ?Text {
    return icrc7().get_ledger_info().logo;
  };

  public query func icrc7_max_memo_size() : async ?Nat {
    return ?icrc7().get_ledger_info().max_memo_size;
  };

  public query func icrc7_tx_window() : async ?Nat {
    return ?icrc7().get_ledger_info().tx_window;
  };

  public query func icrc7_permitted_drift() : async ?Nat {
    return ?icrc7().get_ledger_info().permitted_drift;
  };

  public query func icrc7_total_supply() : async Nat {
    return icrc7().get_stats().nft_count;
  };

  public query func icrc7_supply_cap() : async ?Nat {
    return icrc7().get_ledger_info().supply_cap;
  };

  public query func icrc37_max_approvals_per_token_or_collection() : async ?Nat {
    return icrc37().max_approvals_per_token_or_collection();
  };

  public query func icrc7_max_query_batch_size() : async ?Nat {
    return icrc7().max_query_batch_size();
  };

  public query func icrc7_max_update_batch_size() : async ?Nat {
    return icrc7().max_update_batch_size();
  };

  public query func icrc7_default_take_value() : async ?Nat {
    return icrc7().default_take_value();
  };

  public query func icrc7_max_take_value() : async ?Nat {
    return icrc7().max_take_value();
  };

  public query func icrc7_atomic_batch_transfers() : async ?Bool {
    return icrc7().atomic_batch_transfers();
  };

  public query func icrc37_max_revoke_approvals() : async ?Nat {
    return ?icrc37().get_ledger_info().max_revoke_approvals;
  };

  public query func icrc7_collection_metadata() : async [(Text, Value)] {

    let ledger_info = icrc7().collection_metadata();
    let ledger_info37 = icrc37().metadata();
    let results = Vec.new<(Text, Value)>();

    Vec.addFromIter(results, ledger_info.vals());
    Vec.addFromIter(results, ledger_info37.vals());

    ///add any addtional metadata here
    //Vec.addFromIter(results, [
    //  ("ICRC-7", #Text("your value"))
    //].vals());
    
    return Vec.toArray(results);
  };

  public query func icrc7_token_metadata(token_ids: [Nat]) : async [?[(Text, Value)]]{
     return icrc7().token_metadata(token_ids);
  };

  public query func icrc7_owner_of(token_ids: OwnerOfRequest) : async OwnerOfResponse {
   
     switch( icrc7().get_token_owners(token_ids)){
        case(#ok(val)) val;
        case(#err(err)) D.trap(err);
      };
  };

  public query func icrc7_balance_of(
    accounts: BalanceOfRequest
  ) : async BalanceOfResponse {
    return icrc7().balance_of(accounts);
  };

  public query func icrc7_tokens(prev: ?Nat, take: ?Nat) : async [Nat] {
    return icrc7().get_tokens_paginated(prev, take);
  };

  public query func icrc7_tokens_of(
    account: Account, prev: ?Nat, take: ?Nat
  ) : async [Nat] {
    return icrc7().get_tokens_of_paginated(account, prev, take);
  };

  /////////
  // ICRC-37 endpoints
  /////////
  public query func icrc37_is_approved(args: [IsApprovedArg]) : async [Bool] {
    return icrc37().is_approved(args);
  };

  public query func icrc37_get_token_approvals(
    token_ids: [Nat], prev: ?TokenApproval, take: ?Nat
  ) : async [TokenApproval] {
    
    return icrc37().get_token_approvals(token_ids, prev, take);
  };

  public query func icrc37_get_collection_approvals(
    owner : Account, prev: ?CollectionApproval, take: ?Nat
  ) : async [CollectionApproval] {
    
    return icrc37().get_collection_approvals(owner, prev, take);
  };

  // Icrc-10 is the standard of exhibiting the standards the contract implements
  public query func icrc10_supported_standards() : async ICRC7.SupportedStandards {
    return [
      {name = "ICRC-7"; url = "https://github.com/dfinity/ICRC/ICRCs/ICRC-7"},
      {name = "ICRC-37"; url = "https://github.com/dfinity/ICRC/ICRCs/ICRC-37"}];
  };


  //Update calls

  public shared(msg) func icrc37_approve_tokens(
    args: [ApproveTokenArg]
  ) : async [?ApproveTokenResult] {

    switch(icrc37().approve_transfers<system>(msg.caller, args)){
        case(#ok(val)) val;
        case(#err(err)) D.trap(err);
      };
  };

  public shared(msg) func icrc37_approve_collection(
    approvals: [ApproveCollectionArg]
  ) : async [?ApproveCollectionResult] {
      icrc37().approve_collection<system>( msg.caller, approvals);
  };

  // System capabililties not provided to the functions, Why?
  // Warn: Potential error and debugging point
  public shared(msg) func icrc7_transfer<system>(
    args: [TransferArgs]
  ) : async [?TransferResult] {
      icrc7().transfer<system>(msg.caller, args);
  };

  public shared(msg) func icrc37_transfer_from<system>(
    args: [TransferFromArg]
  ) : async [?TransferFromResult] {
      icrc37().transfer_from<system>(msg.caller, args)
  };

  public shared(msg) func icrc37_revoke_token_approvals<system>(
    args: [RevokeTokenApprovalArg]
  ) : async [?RevokeTokenApprovalResult] {
      icrc37().revoke_token_approvals<system>(msg.caller, args);
  };

  public shared(msg) func icrc37_revoke_collection_approvals(
    args: [RevokeCollectionApprovalArg]
  ) : async [?RevokeCollectionApprovalResult] {
      icrc37().revoke_collection_approvals<system>(msg.caller, args);
  };

  /////////
  // ICRC3 endpoints
  /////////

  public query func icrc3_get_blocks(
    args: [ICRC3.TransactionRange]
  ) : async ICRC3.GetTransactionsResult{
    return icrc3().get_blocks(args);
  };

  public query func icrc3_get_archives(
    args: ICRC3.GetArchivesArgs
  ) : async ICRC3.GetArchivesResult{
    return icrc3().get_archives(args);
  };

  public query func icrc3_supported_block_types() : async [ICRC3.BlockType] {
    return icrc3().supported_block_types();
  };

  public query func icrc3_get_tip_certificate() : async ?ICRC3.DataCertificate {
    return icrc3().get_tip_certificate();
  };

  public query func get_tip() : async ICRC3.Tip {
    return icrc3().get_tip();
  };
};