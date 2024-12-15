set -ex
ADMIN_PRINCIPAL=$(dfx identity get-principal)
echo admin principal: $ADMIN_PRINCIPAL
dfx deploy hacky
HACKY_CANISTER=$(dfx canister id hacky)
echo soodio canister: $HACKY_CANISTER
dfx canister status $HACKY_CANISTER
dfx canister call hacky add_authorized_principals '(vec { principal "pu244-xpkj4-vt5bn-4hgxt-st5ey-ofqmm-tme3j-py54z-zahuk-fcjwo-mqe" })'