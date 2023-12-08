pragma circom 2.1.6;
include "circomlib/comparators.circom";

template primify() {
    var primes[6] = [2, 3, 5, 7, 11, 13];
    signal input x[4];
    signal output y[4];
    var tmp[4];
    
    for (var i=0; i < 4; i++) {
        tmp[i] = 0;
        for (var j=0; j<6; j++) {
            tmp[i] +=(j+1 == x[i]) * primes[j];
        }
    }
    y <-- tmp;
    for (var i = 0; i < 4; i++) {
        log("x[i], y[i] = ", x[i], ",", y[i]);
    }
}

template Mastermind(n) {
    signal input secret[4];
    signal input guess[4];
    signal output outCorrect;
    signal output outAlmost;

    var tmp = 0;
    for (var i = 0; i < 4; i++) {
        tmp += guess[i]==secret[i];
    }
   
    component divCheck = divisionCheck();
    divCheck.guess <== guess;
    divCheck.secret <== secret;

    outCorrect <-- tmp;
    outAlmost <== divCheck.out - outCorrect;
}


template divisionCheck(){
    signal input guess[4];
    signal input secret[4];
    signal output out;

    component primG = primify();
    primG.x <== guess;

    component primS = primify();
    primS.x <== secret;

    var product = 1;
    for (var i=0; i < 4; i++) {
        product *= primS.y[i];
    }

    var sumAlmost = 0;
    for (var i = 0; i<4; i++) {
        if (product % primG.y[i] == 0) {
            sumAlmost += 1;
            product /= primG.y[i];
        }
    }
    out <-- sumAlmost;
}

component main {public [guess]} = Mastermind(4);


/* INPUT = {
    "secret": ["2", "3", "3", "1"],
    "guess": ["2", "1", "2", "5"]
} */
