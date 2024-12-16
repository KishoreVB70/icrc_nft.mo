set -ex
ADMIN_PRINCIPAL=$(dfx identity get-principal)
echo admin principal: $ADMIN_PRINCIPAL
dfx deploy hacky
HACKY_CANISTER=$(dfx canister id hacky)
echo soodio canister: $HACKY_CANISTER
dfx canister status $HACKY_CANISTER
dfx canister call soodio add_authorized_principals '(vec { principal "2cfff-dmqj3-4k7sn-5bbwd-yzazl-2gksl-f6dco-sgtz5-rg52a-23hk5-sae" })'
dfx canister call soodio add_authorized_principals '(vec { principal "tcjmz-kd7ey-26lm2-7dgsk-nxg7h-s5xr3-pb25z-jrdh4-c3lud-dr6ei-kae" })'

dfx canister call soodio revoke_authorization '( principal "2cfff-dmqj3-4k7sn-5bbwd-yzazl-2gksl-f6dco-sgtz5-rg52a-23hk5-sae" )'

dfx canister call soodio add_authorized_principals '(vec { principal "pu244-xpkj4-vt5bn-4hgxt-st5ey-ofqmm-tme3j-py54z-zahuk-fcjwo-mqe" })'