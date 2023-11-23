pragma circom 2.1.6;
include "circomlib/comparators.circom";

//missing range check everywhere :) 

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
  //this is sketchy
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

    component isEq1 = IsEqual();
    isEq1.in[0] <== secret[0];
    isEq1.in[1] <== guess[0];

    component isEq2 = IsEqual();
    isEq2.in[0] <== secret[1];
    isEq2.in[1] <== guess[1];

    component isEq3 = IsEqual();
    isEq3.in[0] <== secret[2];
    isEq3.in[1] <== guess[2];

    component isEq4 = IsEqual();
    isEq4.in[0] <== secret[3];
    isEq4.in[1] <== guess[3];
   
    component divCheck = divisionCheck();
    divCheck.guess <== guess;
    divCheck.secret <== secret;

    outCorrect <== isEq1.out + isEq2.out + isEq3.out + isEq4.out;
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
  //this is a bit sketchy, 
    out <-- sumAlmost;
}

component main {public [guess]} = Mastermind(4);


/* INPUT = {
    "secret": ["2", "3", "3", "1"],
    "guess": ["4", "1", "2", "5"]
} */
