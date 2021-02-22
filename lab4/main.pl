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
% Vom folosi aceasta functie din lab3.
member(X, [X|_]).
member(X, [_|L]) :- member(X, L). 

% Aceasta functie sterge toate elementele in afara primei.
% Tinem cont de o lista de elemente care sa ignoram.
% Cand intalnim un careva element, il punem in acea lista.
remove_all_but_first_repetitions(_, [], []).
remove_all_but_first_repetitions(Ignore, [Y|L], R) :- 
    member(Y, Ignore) -> remove_all_but_first_repetitions(Ignore, L, R);
                        (remove_all_but_first_repetitions([Y|Ignore], L, R1), R = [Y|R1]).  

% Pentru inversul, inversam lista de doua ori.
remove_all_but_last_repetitions(L, R) :- 
    reverse(L, R1), 
    remove_all_but_first_repetitions([], R1, R2),
    reverse(R2, R).


% 5. Să se scrie predicatul care verifică dacă un element dat  
%    se întâlneşte într-o listă dată exact de două ori.

% Vom folosi predicatul count_occurences din lab3
count_occurences(_, [], 0).
count_occurences(X, [Y|L], Count) :- 
    count_occurences(X, L, Count1), 
    ( X == Y 
    -> Count is Count1 + 1
    ;  Count is Count1
    ).

occurs_twice(X, L) :- count_occurences(X, L, 2).


% 6. Să se scrie predicatul care elimină dintr-o listă arbitrară primele N elemente
skip(L, 0, L).
skip([], _, []).
skip([_|L], N, R) :- N > 0, N1 is N - 1, skip(L, N1, R).


% 7. Să se scrie predicatul care verifică dacă o listă este prefixul altei liste.
prefix([], _).
prefix([X|Prefix], [Y|L]) :- X == Y, prefix(Prefix, L).


% 8. Să se scrie predicatul care verifică dacă un element 
%    dat se întâlneşte într-o listă o singură dată. 
does_not_occur(_, []).
does_not_occur(X, [Y|R]) :- X \== Y, does_not_occur(X, R).

occurs_once(X, [X|R]) :- does_not_occur(X, R).
occurs_once(X, [Y|R]) :- X \== Y, occurs_once(X, R).


% 9. Să se scrie predicatul care pentru o listă numerică calculează  
%    suma ultimelor două elemente ale acestei liste. 
add_last_two([], 0).
add_last_two([X], X).
add_last_two([X,Y|L], R) :- L == []  -> R is X + Y
                         ;  L = [X1] -> R is X1 + Y
                         ;  add_last_two(L, R).


% 10. Să se scrie predicatul care calculează numărul de apariţii 
%     ale unui element dat într-o listă.
% Deja l-am realizat in lab3.


% 11. Să se scrie predicatul care elimină toate apariţiile 
%     unui element dat de pe poziţiile impare dintr-o listă. 
%     Se consideră că poziţia primului element al listei este 1.
/*
remove_element_odd(_, _, [], []) :- 
remove_element_odd(X, 0, [_|R], L) :- remove_element_odd(X, 1, R, L). 
remove_element_odd(X, 1, [Y|R], L) :- 
    X \== Y -> remove_element_odd(X, 0, R, L1), L = [X|L1]
            ;  remove_element_odd(X, 0, R, L).
*/
remove_element_odd(_, [], []).
remove_element_odd(X, [X], []).
remove_element_odd(X, [Y], [Y]) :- X \== Y. 
remove_element_odd(X, [X,Y|L], [Y|R]) :- remove_element_odd(X, L, R).  
remove_element_odd(X, [Y,Z|L], [Y,Z|R]) :- Y \== X, remove_element_odd(X, L, R).  