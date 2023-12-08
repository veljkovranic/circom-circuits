pragma circom  2.1.6;

include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/poseidon.circom";

template IsOver18(){
    signal input age;
    signal input age_commitment;
    signal input entropy;

    signal output out;

    component poseidon = Poseidon(2);
    poseidon.inputs[0] <== age;
    poseidon.inputs[1] <== entropy;

    log(poseidon.out);
    age_commitment === poseidon.out;

    component isGreaterThan = GreaterThan(252);
    isGreaterThan.in[0] <== age;
    isGreaterThan.in[1] <== 18;

    // assert isGreaterThan === 1
    out <== isGreaterThan.out;
}

component main {public [age_commitment]} = IsOver18();
/* INPUT = {
    "age_commitment": "17570147397920501245480269924493074214037241411372266630866574325596282242963",
    "entropy": "31241241",
    "age": "17"
}*/
