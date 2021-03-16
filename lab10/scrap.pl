start() :- bidoane(14, 0, 0).
bidoane(7, 7, 0).
bidoane(X, Y, Z) :- 
    (turnam(X, Y, 14, 8, X1, Y1), bidoane(X1, Y1, Z));
    (turnam(Y, X, 8, 14, Y1, X1), bidoane(X1, Y1, Z));

turnam(X, Y, Z, X1, Y, Z1) :- 
    Z \== 5,
    Liber is 5 - Z,
    (
        (X <= Liber, X1 = 0, Z1 is X + Z);
        (X > Liber, X1 is X - Liber, Z1 is 5)
    ).