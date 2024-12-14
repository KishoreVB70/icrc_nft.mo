import ICRC7 "mo:icrc7-mo";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";
import Set "mo:map/Set";



module {
    public type Account = ICRC7.Account;

    public type LibraryID = Text;
    public type LibraryIDS = Set.Set<LibraryID>;
    public type NFTInput = ICRC7.NFTInput;


    public type MintNFTRequest = {
        name: Text;
        description: Text;
        genre: Text;
        library_id: LibraryID;
        duration: Nat32;
        bpm: Nat32;
        music_key: Text;
        creator_name: Text;
        audio_provider: Text;
        audio_provider_spec: [(NFTInput, NFTInput)];
        audio_identifier: Text;
    };

    public type Library = {
        library_id: LibraryID;
        name: Text;
        description: Text;
        thumbnail: Text;
        owner: Account;
        creator_name: Text;
        nft_ids: [Nat];
    };

    public type CreateLibraryRequest = {
        name: Text;
        description: Text;
        thumbnail: Text;
        creator_name: Text;
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
}