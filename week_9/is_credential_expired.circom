pragma circom  2.1.6;

include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/poseidon.circom";

template IsExpired(){
    signal input credential_commitment;
    signal input current_timestamp;
    signal input expiry_timestamp;
    signal input my_id;

    signal output out;

    component poseidon = Poseidon(2);
    poseidon.inputs[0] <== expiry_timestamp;
    poseidon.inputs[1] <== my_id;

    log(poseidon.out);
    credential_commitment === poseidon.out;

    component isGreaterThan = GreaterThan(252);
    isGreaterThan.in[0] <== expiry_timestamp;
    isGreaterThan.in[1] <== current_timestamp;
    
    isGreaterThan.out === 0;
    out <== isGreaterThan.out;
}

component main {public [current_timestamp, credential_commitment]} = IsExpired();
/* INPUT = {
    "credential_commitment": "19394113533865759505160282846860138141358212006067908494061718933108835507317",
    "current_timestamp": "1702063573",
    "expiry_timestamp": "1702043363",
    "my_id": "098121098108111115057052064103109097105108046099111109"
}*/
