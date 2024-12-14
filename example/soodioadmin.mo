import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Soodio "main";

shared(init_msg) actor class SoodioAdmin() = this {

    type CreateUserRequest = Soodio.CreateUserRequest;
    type CreateLibraryRequest = Soodio.CreateLibraryRequest;
    type MintNFTRequest = Soodio.MintNFTRequest;

    stable var owner: Principal = init_msg.caller;

    stable var authorized_principals: [Principal] = [owner];

    public shared(msg) func create_soodio_contract(
        principals: [Principal]
    ): async Result.Result<Bool, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");

    };

    public shared(msg) func add_authorized_principals(
        principals: [Principal]
    ): async Result.Result<Bool, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");
        let new_principals = Buffer.fromArray<Principal>(principals);
        let existing_principals = Buffer.fromArray<Principal>(authorized_principals);
        existing_principals.append(new_principals);
        authorizedPrincipals := Buffer.toArray(existing_principals);
        return #ok(true);
    };

    public shared(msg) func revoke_authorization (
        principal: Principal
    ): async Result.Result<Bool, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");
        let updated_arr: [Principal] = Array.filter<Principal>(authorized_principals, func x = x!= principal);
    };

    private func is_authorized(caller: Principal): Bool {
        for (principal in authorized_principals.vals()) {
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