#!/bin/bash

### CONSTANTS
SCRIPT_DIR=`readlink -f $0 | xargs dirname`
ROOT=`readlink -f $SCRIPT_DIR/..`
PROTOSTAR_TOML_FILE=$ROOT/protostar.toml
CACHE_FILE=$ROOT/build/deployed_accounts.txt

### FUNCTIONS
. $SCRIPT_DIR/logging.sh # Logging utilities
. $SCRIPT_DIR/tools.sh   # script utilities

# build the protostar project
build() {
    log_info "Building contracts..."
    execute protostar build
    if [ $? -ne 0 ]; then exit_error "Problem during build"; fi
}

# get the network option from the profile in protostar config file
# $1 - profile
get_network_opt() {
    profile=$1
    grep profile.$profile $PROTOSTAR_TOML_FILE -A5 -m1 | sed -n 's@^.*network_opt="\(.*\)".*$@\1@p'
}

# wait for a transaction to be received
# $1 - transaction hash to check
wait_for_acceptance() {
    tx_hash=$1
    print -n $(magenta "Waiting for transaction to be accepted")
    while true 
    do
        tx_status=`starknet tx_status --hash $tx_hash $NETWORK_OPT | sed -n 's@^.*"tx_status": "\(.*\)".*$@\1@p'`
        case "$tx_status"
            in
                NOT_RECEIVED|RECEIVED|PENDING) print -n  $(magenta .);;
                REJECTED) return 1;;
                ACCEPTED_ON_L1|ACCEPTED_ON_L2) return 0; break;;
                *) exit_error "\nUnknown transaction status '$tx_status'";;
            esac
            sleep 2
    done
}

# send a transaction
# $* - command line to execute
# return The contract address
send_transaction() {
    transaction=$*

    while true
    do
        execute $transaction || exit_error "Error when sending transaction"
        
        contract_address=`sed -n 's@Contract address: \(.*\)@\1@p' logs.json`
        tx_hash=`sed -n 's@Transaction hash: \(.*\)@\1@p' logs.json`

        wait_for_acceptance $tx_hash

        case $? in
            0) log_success "\nTransaction accepted!"; break;;
            1) log_warning "\nTransaction rejected!"; ask "Do you want to retry";;
        esac
    done || exit_error

    echo $contract_address
}

# build the protostar project
add_funds() {
    account=$1
    log_info "Adding funds to account $account"
    curl -H 'Content-Type: application/json' -X POST --data "{\"address\":\"$account\", \"amount\":100000000000000000000}" 'http://127.0.0.1:5050/mint'
    if [ $? -ne 0 ]; then exit_error "Failed to fund account"; fi
}

deploy_accounts_for_e2e_tests() {
    log_info "Deploying signup (ie. registerer) account..."
    SIGNUP_ACCOUNT_ADDRESS=`send_transaction "protostar --profile local deploy ./build/nonce_2d_account.json --inputs 0x175666e92f540a19eb24fa299ce04c23f3b75cb2d2332e3ff2021bf6d615fa5"` || exit_error
    add_funds $SIGNUP_ACCOUNT_ADDRESS || exit_error

    log_info "Deploying marketplace (ie. feeder) account..."
    MARKETPLACE_ACCOUNT_ADDRESS=`send_transaction "protostar --profile local deploy ./build/nonce_2d_account.json --inputs 0x58100ffde2b924de16520921f6bfe13a8bdde9d296a338b9469dd7370ade6cb"` || exit_error
    add_funds $MARKETPLACE_ACCOUNT_ADDRESS || exit_error

    (
        echo "REGISTERER_ACCOUNTS=$SIGNUP_ACCOUNT_ADDRESS"
        echo "FEEDER_ACCOUNTS=$MARKETPLACE_ACCOUNT_ADDRESS"
    ) | tee >&2 $CACHE_FILE
}


NETWORK_OPT=`get_network_opt local`
[ -z "$NETWORK_OPT" ] && exit_error "Unable to determine network option"

build
deploy_accounts_for_e2e_tests
