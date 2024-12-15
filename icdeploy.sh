set -ex
ADMIN_PRINCIPAL=$(dfx identity get-principal)
echo admin principal: $ADMIN_PRINCIPAL
dfx deploy soodioadminyes
SOODIO_ADMIN_CANISTER=$(dfx canister id soodioadmin)
echo soodio canister: $SOODIO_ADMIN_CANISTER
dfx canister call soodioadmin createSoodio
dfx canister call soodioadmin addController
dfx canister status $SOODIO_ADMIN_CANISTER