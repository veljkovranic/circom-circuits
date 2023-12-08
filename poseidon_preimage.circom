pragma circom  2.1.6;

include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/poseidon.circom";


template Preimage(){
    signal input hash;
    signal input value;
    signal output out;

    component poseidon = Poseidon(1);
    poseidon.inputs[0] <== value;

    log(poseidon.out);
    // hash === poseidon.out;

    component isEqual = IsEqual();
    isEqual.in[0] <== hash;
    isEqual.in[1] <== poseidon.out;
    isEqual.out === 1;
    out <== isEqual.out;
}

component main {public [hash]} = Preimage();
/* INPUT = {
    "hash": "13627037666469972566872400532114169710563143949452402347985180265144279199946",
    "value": "098121098108111115057052064103109097105108046099111109"
}*/