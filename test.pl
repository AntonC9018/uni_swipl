delete(_, [], []).
delete(X, [X|L], R) :- delete(X, L, R).
delete(X, [Y|L], [Y|R]) :- delete(X, L, R). 

member(X, [X|_]).
member(X, [_|R]) :- member(X, R).

append([], X, X).
%append(L, [X|R], [X|L]) :- append(

prune([], []).
prune([X|R], L) :- member(X, L), prune(R, L); prune(R, L1), L is [X|L1].
