% 1. Se gaseste elementrul maxim dintr-o lista. 
%    Deja am scris acest predicat, dar atases inca o data.
max([], 0).
max([X|L], R) :- max(L, R1), (R1 > X -> R is R1; R is X).

% 2. Sa se scrie predicatul care alipeste doua liste, inversand-o pe prima lista.
%    Voi folosi predicatele de ajutor pe care le-am scris in lucrarea precedenta.
% Pun acele predicate din tema trecuta si aici.
append([], [], []).
% La inceput concatenam prima lista.
append([X|L], L2, [X|R]) :- append(L, L2, R).
% Pe urma a doua.
append([], [X|L], [X|R]) :- append([], L, R).
% B) Inversarea unei liste.
reverse([], X, X).
reverse([X|L], Y, R) :- reverse(L, Y, [X|R]).
reverse(X, R) :- reverse(X, R, []).

append_reverse(X, Y, R) :- reverse(X, R1), append(R1, Y, R).

% 3. Schimbam elementele pe pozitiile impare cu cele pe pozitiile pare.
%    Daca numarul de elemente este impar, ultimul element ramane neschimbat.
odd_to_even([], []).
odd_to_even([X], [X]).
odd_to_even([X,Y|L], [Y,X|R]) :- odd_to_even(L, R).

% 4. Se elimina toate elementele repetate, in afara ultimei repetari.
remove_all_but_last_repetitions(_, [], []).
remove_all_but_last_repetitions(_, [Y], [Y]).
remove_all_but_last_repetitions(X, [Y|L], R) :- 