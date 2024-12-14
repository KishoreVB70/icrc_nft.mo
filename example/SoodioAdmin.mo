import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Soodio "Soodio";
import Cycles "mo:base/ExperimentalCycles";
import ICRC7 "mo:icrc7-mo";
import ICRC3 "mo:icrc3-mo";

shared(init_msg) actor class SoodioAdmin() = this {
    type CreateUserRequest = Soodio.CreateUserRequest;
    type CreateLibraryRequest = Soodio.CreateLibraryRequest;
    type MintNFTRequest = Soodio.MintNFTRequest;
    type Account = Soodio.Account;
    
    stable var owner: Principal = init_msg.caller;
    stable var soodioContract: Text = "";

    stable var authorizedPrincipals: [Principal] = [owner];

    public shared(msg)func createSoodio() : async Result.Result<Text, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");
        let canisterCreationCost = 100_000_000_000;
        let initialBalance = 100_000_000_000;
        Cycles.add<system>(canisterCreationCost + initialBalance);
        let icrc3_args : ICRC3.InitArgs = ?{
            maxActiveRecords = 4000;
            settleToRecords = 2000;
            maxRecordsInArchiveInstance = 5_000_000;
            maxArchivePages  = 62500; //allows up to 993 bytes per record
            archiveIndexType = #Stable;
            maxRecordsToArchive = 10_000;
            archiveCycles = 2_000_000_000_000; //two trillion
            archiveControllers = null;
            supportedBlocks = [];
        };

        let icrc7_args = ?{
            symbol = ?"Sdo";
            name = ?"Soodio";
            description = ?"A Collection of Audio Libraries";
            logo = ?"https://picsum.photos/200/300";
            supply_cap = null;
            allow_transfers = ?false;
            max_query_batch_size = ?100;
            max_update_batch_size = ?100;
            default_take_value = ?1000;
            max_take_value = ?10000;
            max_memo_size = ?512;
            permitted_drift = null;
            tx_window = null;
            burn_account = null; //burned nfts are deleted
            deployer = Principal;
            supported_standards = null;
        };

        let soodioCon: Soodio.Soodio = await Soodio.Soodio(icrc3_args, icrc7_args);
        return #ok("hi");
    };

    public shared(msg) func add_authorized_principals(
        principals: [Principal]
    ): async Result.Result<Bool, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");
        let new_principals = Buffer.fromArray<Principal>(principals);
        let existing_principals = Buffer.fromArray<Principal>(authorizedPrincipals);
        existing_principals.append(new_principals);
        authorizedPrincipals := Buffer.toArray(existing_principals);
        return #ok(true);
    };

    public shared(msg) func revoke_authorization (
        principal: Principal
    ): async Result.Result<Bool, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");
        let updated_arr: [Principal] = Array.filter<Principal>(authorizedPrincipals, func x = x!= principal);
        authorizedPrincipals := updated_arr;
        return #ok(true);
    };

    private func is_authorized(caller: Principal): Bool {
        for (principal in authorizedPrincipals.vals()) {
            if (principal == caller) {
                return true;
            }
        };
        return false;
    };

    public shared(msg) func create_library(
        libreq: CreateLibraryRequest
    ): async Result.Result<Text, Text> {
        if (is_authorized(msg.caller) != true) {
            return #err("Unauthorized admin");
        };
        return await Soodio.create_library(libreq);
    };

    public shared(msg) func create_user(
        account: Account,
        user_req: CreateUserRequest
    ): async Result.Result<Text, Text> {
        if (is_authorized(msg.caller) != true) {
            return #err("Unauthorized admin");
        };
        return await Soodio.create_user(account, user_req);
    };

    public shared(msg) func mint_nft(
        token_owner: Account, nft_data: MintNFTRequest
    ) : async Result.Result<Nat, Text> {
        if (is_authorized(msg.caller) != true) {
            return #err("Unauthorized admin");
        };
        return await Soodio.mint_nft(token_owner, nft_data);
    };

    public shared(msg) func update_downloads(
        nft_id: Nat, downloads: Nat32
    ): async Result.Result<Bool, Text> {
        if (is_authorized(msg.caller) != true) {
            return #err("Unauthorized admin");
        };
        return await Soodio.update_downloads(nft_id, downloads);
    };
};