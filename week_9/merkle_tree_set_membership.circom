pragma circom  2.1.6;

include "circomlib/comparators.circom";
include "circomlib/mux1.circom";
include "circomlib/poseidon.circom";

template MembershipProof(N){
    signal input my_id;
    signal input root;
    signal input path[N];
    signal input siblings[N];

    signal output out;

    component initial_hash_function = Poseidon(1);
    initial_hash_function.inputs[0] <== my_id;

    component hash_functions[N][2];
    var M = N + 1;
    component chooser[M];
    chooser[0] = Mux1();
    chooser[0].c[0] <== my_id;
    chooser[0].c[1] <== my_id;
    chooser[0].s <== 0;

    // Optimization suggestion, use two mux and one Poseidon
    for (var i = 0; i < N; i++) {
        hash_functions[i][0] = Poseidon(2);
        hash_functions[i][0].inputs[0] <== chooser[i].out;
        hash_functions[i][0].inputs[1] <== siblings[i];

        hash_functions[i][1] = Poseidon(2);
        hash_functions[i][1].inputs[0] <== siblings[i];
        hash_functions[i][1].inputs[1] <== chooser[i].out;

        chooser[i+1] = Mux1();
        chooser[i+1].c[0] <== hash_functions[i][0].out;
        chooser[i+1].c[1] <== hash_functions[i][1].out;
        chooser[i+1].s <== path[i];
    }
    out <== chooser[N].out;
    root === chooser[N].out;
}

component main {public [root]} = MembershipProof(3);

/* INPUT = {
    "root": "16805777841726953034830097708390483748045275663839214721411960714648433185485",
    "my_id": "42314214",
    "siblings" : ["230", "321", "3213"],
    "path" : ["0", "1", "0"]
}
*/