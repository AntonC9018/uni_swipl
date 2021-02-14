% remove_second(X, L, Ignore, R) :- 

% 1.
% Să se scrie programul pentru sortarea unei liste numerice 
% în ordine crescătoare, prin metoda „naivă”: se generează 
% permutări ale listei până când se obţine o permutare sortată.

% Generam permutarile
takeout(X, [X|R], R).
takeout(X, [H|T], [H|R]) :- takeout(X, T, R).

% takeout(X, R, L) aici genereaza toate variante posibile in care
% elementul X poate fi scos din R pentru a produce L.
% Necunoscutul in acest caz este lista din care se scoate X-ul, R. 
perm([X|Y], R) :- perm(Y, L), takeout(X, R, L).   
perm([], []).

is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|R]) :- X =< Y, is_sorted([Y|R]).

dumb_sort(L, R) :- perm(L, R), is_sorted(R).


% 2.
% Să se scrie programul pentru sortarea unei liste numerice în ordine crescătoare, 
% prin metoda inserţiei: capul listei se elimină, se sortează coada, apoi capul 
% se inserează în coada sortată pe poziţia corespunzătoare.

% Inseram elementul X in lista sortata L, conservand proprietatea ca L este sortata 
keep_sorted_put(X, [], [X]).
keep_sorted_put(X, [Y|L], R) :- X =< Y -> R = [X,Y|L] ; keep_sorted_put(X, L, R1), R = [Y|R1].

insertion_sort([], []).
insertion_sort([X|L], R) :- insertion_sort(L, L1), keep_sorted_put(X, L1, R).


% 3. Să se scrie programul pentru sortarea unei liste numerice în ordine crescătoare, prin metoda bulelor.
bubble_sort([], L, L).

% 7. Să se scrie programul care pentru o listă (ce reprezintă o mulţime de numere) 
% şi un număr dat găseşte o submulţime de elemente, suma cărora este egală 
% cu numărul dat (dacă există o astfel de submulţime).

% O submultime a unei multime este toate combinatiile elementelor acestora cu primul element 
% in conjuctia cu toate combinatiile elementelor acestora fara primul element.
subset([], []).
subset([X|L], R) :- subset(L, R1), (R = R1 ; R = [X|R1]).

% Insasi functie
% sum_list este functia standarta, ce sumeaza toate elementele dintr-o lista.
subset_where_sum_is(L, Sum, R) :- subset(L, Subset), sum_list(Subset, Sum), R = Subset.