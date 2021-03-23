delete(_, [], []).
delete(X, [X|L], R) :- delete(X, L, R).
delete(X, [Y|L], [Y|R]) :- delete(X, L, R). 

member(X, [X|_]).
member(X, [_|R]) :- member(X, R).

append([], X, X).
%append(L, [X|R], [X|L]) :- append(

prune([], []).
prune([X|R], L) :- member(X, L), prune(R, L); prune(R, L1), L is [X|L1].


factorial(0, 1).
factorial(1, 1).
factorial(X, R) :- X > 1, X1 is X - 1, factorial(X1, R1), R is X * R1.