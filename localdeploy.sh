set -ex
ADMIN_PRINCIPAL=$(dfx identity get-principal)
echo admin principal: $ADMIN_PRINCIPAL
dfx deploy hacky
SOODIO_CANISTER=$(dfx canister id hacky)
echo soodio canister: $SOODIO_CANISTER
dfx canister status $SOODIO_CANISTER
dfx canister call soodio add_authorized_principals '(vec { principal "tcjmz-kd7ey-26lm2-7dgsk-nxg7h-s5xr3-pb25z-jrdh4-c3lud-dr6ei-kae" })'