import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Soodio "Soodio";
import Cycles "mo:base/ExperimentalCycles";

shared(init_msg) actor class SoodioAdmin() = this {
    type CreateUserRequest = Soodio.CreateUserRequest;
    type CreateLibraryRequest = Soodio.CreateLibraryRequest;
    type MintNFTRequest = Soodio.MintNFTRequest;
    type Account = Soodio.Account;
    
    stable var owner: Principal = init_msg.caller;

    stable var authorizedPrincipals: [Principal] = [owner];

    stable var soodioPrincipal: ?Principal = null;

    public shared(msg)func createSoodio() : async Result.Result<Text, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");
        let canisterCreationCost = 100_000_000_000;
        let initialBalance = 100_000_000_000;
        Cycles.add<system>(canisterCreationCost + initialBalance);
        let soodioContract: Soodio.Soodio = await Soodio.Soodio();
        let principal: Principal = Principal.fromActor(soodioContract);
        soodioPrincipal := ?principal;
        return #ok(Principal.toText(principal));
    };

    public shared(msg) func upgradeSoodio() : async Result.Result<Bool, Text> {
        if(msg.caller != owner) return #err("Unauthorized admin");
                switch (soodioPrincipal) {
            case (?principal) {
                try {
                    let _existingActor : Soodio.Soodio = actor(Principal.toText(principal));
                    // let upgradedActor = await (system Soodio.Soodio)(#upgrade(existingActor))();
                    #ok(true);
                } catch (_error) {
                    #err("Failed to upgrade canister")
                }
            };
            case (null) {
                #err("Soodio canister not created yet")
            };
        };

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

        switch (soodioPrincipal) {
            case (?principal) {
                let soodioActor : Soodio.Soodio = actor(Principal.toText(principal));
                return await soodioActor.create_library(libreq);
            };
            case (null) {
                #err("Soodio canister not created yet")
            };
        };
    };

    public shared(msg) func create_user(
        account: Account,
        user_req: CreateUserRequest
    ): async Result.Result<Text, Text> {
        if (is_authorized(msg.caller) != true) {
            return #err("Unauthorized admin");
        };
        switch (soodioPrincipal) {
            case (?principal) {
                let soodioActor : Soodio.Soodio = actor(Principal.toText(principal));
                return await soodioActor.create_user(account, user_req);
            };
            case (null) {
                #err("Soodio canister not created yet")
            };
        };
    };

    public shared(msg) func mint_nft(
        token_owner: Account, nft_data: MintNFTRequest
    ) : async Result.Result<Nat, Text> {
        if (is_authorized(msg.caller) != true) {
            return #err("Unauthorized admin");
        };
        switch (soodioPrincipal) {
            case (?principal) {
                let soodioActor : Soodio.Soodio = actor(Principal.toText(principal));
                return await soodioActor.mint_nft(token_owner, nft_data);
            };
            case (null) {
                #err("Soodio canister not created yet")
            };
        };
    };

    public shared(msg) func update_downloads(
        nft_id: Nat, downloads: Nat32
    ): async Result.Result<Bool, Text> {
        if (is_authorized(msg.caller) != true) {
            return #err("Unauthorized admin");
        };
        switch (soodioPrincipal) {
            case (?principal) {
                let soodioActor : Soodio.Soodio = actor(Principal.toText(principal));
                return await soodioActor.update_downloads(nft_id, downloads);
            };
            case (null) {
                #err("Soodio canister not created yet")
            };
        };
    };

};