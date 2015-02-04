TRANS=[0.7 0.3;0.4 0.6];
EMIS=[0.1 0.4 0.5;0.6 0.3 0.1];
[seq, states] = hmmgenerate(1000, TRANS, EMIS);

likelystates = hmmviterbi(seq, TRANS, EMIS);

sum(states==likelystates)/1000




