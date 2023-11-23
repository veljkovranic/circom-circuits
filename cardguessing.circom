pragma circom 2.1.6;
include "circomlib/comparators.circom";

template CardGuessing() {
     signal input cardPub1;
     signal input cardPub2;
     signal input cardPub3;
     signal input cardPub4;
     signal output out;
     
    // 6 bits is enough to store card value
    component gt = GreaterThan(6);
    gt.in[1] <== cardPub1+cardPub2;
    gt.in[0] <== cardPub3+cardPub4;

    //should probably make sure that this is 0 < cardPubX < 2^6
    component lt = LessThan(6);
    lt.in[0] <== cardPub1+cardPub2;
    lt.in[1] <== cardPub3+cardPub4;
    
    out <== 1 * gt.out + 2 * lt.out;
}


component main {public [cardPub1, cardPub2]} = CardGuessing();


/* INPUT = {
    "cardPub1": "5",
    "cardPub2": "3",
    "cardPub3": "5",
    "cardPub4": "7"
} */
