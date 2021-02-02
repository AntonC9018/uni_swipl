# Inteligenta Artificiala, laborator nr.3.

A elaborat: **Curmanschii Anton, IA1901**.

Nu pastez aici sarcinile, deoarece ele coincid cu comentariile asupra predicatelor realizate. 

## Codul 

```prolog
% 1.
% A) Se contine oare X in lista L? 
% Conditia de baza member(X, []) :- false se verifica automat, deoarece este falsa.
member(X, [X|_]).
member(X, [_|L]) :- member(X, L). 
% B) Elementul nr. N
% In cazul in care tragem dintr-o lista vida, nu primim nimic.
% Recursia eventual se reduce la acest caz, 
% daca lungimea listei este mai mica decat indicele solicitat.
take([], _, false).
% Aici folosim indexarea unu, nu cea zero (primul element are indice 1).
take([X|_], 1, X).
take([_|L], N, R) :- N > 1, N1 is N - 1, take(L, N1, R).
% C) Dublarea elementelor
double([], []).
double([X|L], [X,X|R]) :- double(L, R).

% 2.
% A) Se afiseaza elementele listei
print_([]).
print_([X|L]) :- write(X), write('  '), print_(L).
print(L) :- write('[  '), print_(L), write(']'), nl.
% B) Afisare in ordinea inversa
print_inv_([]).
print_inv_([X|L]) :- print_inv_(L), write('  '), write(X).
print_inv(L) :- write('['), print_inv_(L), write('  ]'), nl.
% C) = 1.C)

% 3.
% A) Concatenarea doua liste.
append([], [], []).
% La inceput concatenam prima lista.
append([X|L], L2, [X|R]) :- append(L, L2, R).
% Pe urma a doua.
append([], [X|L], [X|R]) :- append([], L, R).
% B) Inversarea unei liste.
reverse([], X, X).
reverse([X|L], Y, R) :- reverse(L, Y, [X|R]).
reverse(X, R) :- reverse(X, R, []).
% C) Daca o lista Y se contine intr-o alta lista X
contains([], _).
contains([Y|L], [X|R]) :- Y == X -> contains(L, R); contains([Y|L], R).

% 4.
% A) Se elimina un element X.
delete(_, [], []).
delete(X, [X|L], R) :- delete(X, L, R).
delete(X, [Y|L], [Y|R]) :- delete(X, L, R), X \== Y. 
% B) Se elimina elementul de pe pozitia N. Aici folosim indexarea zero.
delete_at([_|L], 0, L).
delete_at([], _, []). 
delete_at([X|L], N, [X|R]) :- N > 0, N1 is N - 1, delete_at(L, N1, R).
% C) Se calculeaza lungimea unei liste.
length1([], 0).
length1([_|L], R) :- length1(L, R1), R is R1 + 1.

% 5.
% A) Numarul de aparitii ale unui element X.
count_occurences(_, [], 0).
count_occurences(X, [Y|L], Count) :- 
    count_occurences(X, L, Count1), 
    ( X == Y 
    -> Count is Count1 + 1
    ;  Count is Count1
    ).
% B) Calculeaza suma elementelor.
sum([], 0).
sum([X|L], R) :- sum(L, R1), R is R1 + X.
% C) a fost.

% 6. 
% A) Element maxim.
max([], 0).
max([X|L], R) :- max(L, R1), (R1 > X -> R is R1; R is X).
% B) Pozitia elementului in lista.
index(X, [Y|L], I) :- X == Y -> I is 0; index(X, L, I2), I is I2 + 1.
index(_, [], -1).
% C) a fost.

% 7. 
% A) Produsul.
product([], 1).
product([X|L], R) :- product(L, R1), R is R1 * X.
% B) Se afiseaza elemetele de pe pozitii impare.
print_at_odd_indices([], _).
print_at_odd_indices([X|L], I) :- 
    M is mod(I, 2),
    ( M == 1 -> write(X), write(', '); true ),
    I1 is I + 1,
    print_at_odd_indices(L, I1).
% C) a fost.
print_at_odd_indices(L) :- print_at_odd_indices(L, 1).
```

## Executarea.

```prolog
% 1
?- member(1, [3, 1, 2]).
true ;
false.

?- member(5, [1, 2, 3]).
false.


?- take([1, 2, 3, 5], 4, R).
R = 5 ;
false.

?- take([1, 2, 3, 5], 0, R).
false.

?- take([1, 2, 3, 5], 1, R).
R = 1 ;
false.


?- double([1, 2, 3], R).
R = [1, 1, 2, 2, 3, 3].

?- double([], R).
R = [].


% 2.
?- print([1, 2, 3]).
[  1  2  3  ]
true.

?- print_inv([1, 2, 3]).
[  3  2  1  ]
true.

% 3.
?- append([1, 2], [1, 2, 3], R).
R = [1, 2, 1, 2, 3] ;
false.

?- append([1, 2], [], R).
R = [1, 2] ;
false.

?- append([], [1, 2], R).
R = [1, 2] ;
false.


?- reverse([1, 2, 3], R).
R = [3, 2, 1].

?- reverse([], R).
R = [].


?- contains([1, 2, 3], [1, 2, 4]).
false.

?- contains([1, 2, 3], [1, 2, 3]).
true.

?- contains([1, 2, 3], [1, 2, 3, 6]).
true.

?- contains([1, 2, 3], [2, 1, 1, 2, 3, 6]).
true.

% 4.
?- delete(9, [1, 2, 9], R).
R = [1, 2] ;
false.

?- delete(9, [], R).
R = [] ;
false.

?- delete(9, [1, 2, 3], R).
R = [1, 2, 3] ;
false.


?- delete_at([1, 2, 3], 0, R).
R = [2, 3] ;
false.

?- delete_at([], 0, R).
R = [].

?- delete_at([1, 2, 3], 2, R).
R = [1, 2] ;
false.


?- length1([], R).
R = 0.

?- length1([1, 2, 3], R).
R = 3.

% 5.
?- count_occurences(1, [1, 2, 3], R).
R = 1 ;
false.

?- count_occurences(1, [1, 2, 3, 1, 1, 2, 1], R).
R = 4 ;
false.


?- sum([1, 2, 3], R).
R = 6.

?- sum([], R).
R = 0.


% 6.
?- max([1, 2, 3, 4, 0], R).
R = 4.


?- index(1, [1, 2, 3], R).
R = 0 ;
false.

?- index(1, [0, 2, 3, 1], R).
R = 3 ;
false.


% 7.
?- product([1, 2, 3], R).
R = 6.

?- product([0, 1, 2], R).
R = 0.

?- product([], R).
R = 1.


?- print_at_odd_indices([1, 2, 3, 4, 0]).
1, 3, 0,
true.
```