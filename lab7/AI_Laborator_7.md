# Inteligenta Artificiala, laborator nr.7.

A elaborat: **Curmanschii Anton, IA1901**.

## Sarcina.

Varianta 7.

**Copiii familiei Bright.** 
În familia Bright sunt cinci copii. La vârstele de *4, 5, 6, 7* şi *8* ani `Rose` şi fraţii săi şi-au demonstrat talentele în domenii diferite. Unul din ei cântă bine la `pian`. Să se determine vârsta şi talentul fiecărui copil, ţinând cont că:
1. `Becca` are `4` ani şi nu străluceşte în `matematici`. 
2. Un `magician al calculatorului` e cu un an mai mare decât `Stu`. 
3. `Violonistul` are 7 ani. 
4. `Iona` nu are 8 ani. 
5. La 5 ani ai săi `Robe` un copil mai mic decât cel ce străluceşte în `litere`.

## Realizare

Traducem într-un limbaj mai apropiat de prolog.

Având trei liste: lista de nume `[rose, becca, stu, iona, robe]`, lista de vârste `[4, 5, 6, 7, 8]`, lista de ocupatii (domenii) `[piano, math, violin, computer_magician, grammar]`, de găsit toate **combinațiile** acestora (adică toate seturi de tupluri `(nume, varsta, domeniu)`, unde acestea sunt luate din liste de mai sus și valorile individuale nu se repetă), unde printre ele există tuplurile, pentru care:
1. `(becca, 4, X)`, unde `X` este o altă valoare, diferită de math;
2. `(_, X, computer_magician)` și `(stu, X + 1, _)`;
3. `(_, 7, violin)`;
4. `(iona, not 8, _)`;
5. `(robe, 5, _)`;
6. `(_, X, grammar)`, unde `X` > 5.

Problema, descrisă astfel, este de fapt rezolvată. Mai jos vedeți predicatul care soluționează problema propusă. El returnează o listă cu rezultat.

```prolog
% returns a list of pairs [ [Name, Age, Occupation], ... ]
brights(R) :-
    
    % Generate all possible combinations of tuples of data
    tuple_combinations(
        [
            [becca, rose, stu, iona, robe], 
            [4, 5, 6, 7, 8],
            [math, piano, computer_magician, violin, grammar]
        ], 
        R
    ),

    % Becca is 4 and is not good at math
    member([becca, 4, D_Becca], R), D_Becca \= math, 
    
    % computer_magician is older than Stu by 1 year.
    member([_, Age_Magician, computer_magician], R),
    member([stu, Age_Stu, _], R),
    Age_Magician is Age_Stu + 1,

    % Iona is not 8
    member([iona, A_Iona, _], R), A_Iona \= 8, 

    % Robe is 5 and is younger than the grammar guy
    member([robe, 5, _], R),
    member([_, Age_Grammar, grammar], R), Age_Grammar > 5,

    % Somebody plays violin at 7
    member([_, 7, violin], R).
```

Mai compicată este funcția care generează toate combinațiile între tupluri `tuple_combinations/2`. Pentru fiecare sublista din parametrul 1 de intrare, ea generează toate combinațiile posibile pentru fiecare element din ea cu toate alte elemente din celelalte subliste. 

```prolog
% Now, generate combinations and return unique combinations
tuple_combinations([[]|_], []).
tuple_combinations(L, R) :- 
    tuple_combination(L, Tuple, Rest), 
    tuple_combinations(Rest, R1), 
    R = [Tuple|R1].
```

Deci, la început este găsită o combinație posibilă pentru un element din fiecare sublistă din lista de intrare L, ca un tuplu, pe urmă este generată o combinație a celorlaltor elemente, și, în sfârșit, acel prim tuplu este concatenat cu restul tuplurilor.

Funcția `tuple_combination/3` returnează un tuplu selectat, și sublistele modificate (fără elementele strânse). Folosim recursia. Dacă a rămas doar o sublistă, luăm doar primul element, ca să evităm repetări.

```prolog
% Helper functions, explained previously
takeout(X, [X|R], R).
takeout(X, [H|T], [H|R]) :- takeout(X, T, R).

% With one list remaining, just take the last element.
tuple_combination([[X|Rest]], [X], [Rest]). 
% If head is a list, return combinations of it with the other lists
tuple_combination([H|T], R, [HRest|TRest]) :- 
        T \= [],
        is_list(H), 
        combination(T, R1, TRest), 
        takeout(X, H, HRest), 
        R = [X|R1].
```

## Întregul cod

```prolog
% Helper functions, explained previously
takeout(X, [X|R], R).
takeout(X, [H|T], [H|R]) :- takeout(X, T, R).

% With one list remaining, just take the last element.
tuple_combination([[X|Rest]], [X], [Rest]). 
% If head is a list, return combinations of it with the other lists
tuple_combination([H|T], R, [HRest|TRest]) :- 
        T \= [],
        is_list(H), 
        tuple_combination(T, R1, TRest), 
        takeout(X, H, HRest), 
        R = [X|R1].

% Now, generate combinations and return unique combinations
tuple_combinations([[]|_], []).
tuple_combinations(L, R) :- 
    tuple_combination(L, Tuple, Rest), 
    tuple_combinations(Rest, R1), 
    R = [Tuple|R1].

% returns a list of pairs [ [Name, Age, Occupation], ... ]
brights(R) :-
    
    % Generate all possible combinations of data
    tuple_combinations(
        [
            [becca, rose, stu, iona, robe], 
            [4, 5, 6, 7, 8],
            [math, piano, computer_magician, violin, grammar]
        ], 
        R
    ),

    % Becca is 4 and is not good at math
    member([becca, 4, D_Becca], R), D_Becca \= math, 
    
    % computer_magician is older than Stu by 1 year.
    member([_, Age_Magician, computer_magician], R),
    member([stu, Age_Stu, _], R),
    Age_Magician is Age_Stu + 1,

    % Iona is not 8
    member([iona, A_Iona, _], R), A_Iona \= 8, 

    % Robe is 5 and is younger than the grammar guy
    member([robe, 5, _], R),
    member([_, Age_Grammar, grammar], R), Age_Grammar > 5,

    % Somebody plays violin at 7
    member([_, 7, violin], R).
```

## Executare

Aparent, soluția este unică.

```
1 ?- brights(R).
R = [[robe, 5, math], [becca, 4, piano], [rose, 8, computer_magician], [stu, 7, violin], [iona, 6, grammar]] ;
false.
```

Dacă eliminăm, de exemplu, condiția cu violinul, vom avea mai multe răspunsuri.

```
1 ?- brights(R).
R = [[robe, 5, math], [becca, 4, piano], [iona, 7, computer_magician], [stu, 6, violin], [rose, 8, grammar]] ;
R = [[robe, 5, math], [becca, 4, piano], [iona, 7, computer_magician], [rose, 8, violin], [stu, 6, grammar]] ;
R = [[robe, 5, math], [becca, 4, piano], [rose, 8, computer_magician], [iona, 6, violin], [stu, 7, grammar]] ;
R = [[robe, 5, math], [becca, 4, piano], [rose, 8, computer_magician], [stu, 7, violin], [iona, 6, grammar]] ;
R = [[robe, 5, math], [stu, 6, piano], [iona, 7, computer_magician], [becca, 4, violin], [rose, 8, grammar]] ;
R = [[robe, 5, math], [iona, 6, piano], [rose, 8, computer_magician], [becca, 4, violin], [stu, 7, grammar]] ;
R = [[robe, 5, math], [stu, 7, piano], [rose, 8, computer_magician], [becca, 4, violin], [iona, 6, grammar]] ;
R = [[robe, 5, math], [rose, 8, piano], [iona, 7, computer_magician], [becca, 4, violin], [stu, 6, grammar]] ;
R = [[stu, 6, math], [becca, 4, piano], [iona, 7, computer_magician], [robe, 5, violin], [rose, 8, grammar]] ;
R = [[stu, 6, math], [robe, 5, piano], [iona, 7, computer_magician], [becca, 4, violin], [rose, 8, grammar]] ;
R = [[iona, 6, math], [becca, 4, piano], [rose, 8, computer_magician], [robe, 5, violin], [stu, 7, grammar]] ;
R = [[iona, 6, math], [robe, 5, piano], [rose, 8, computer_magician], [becca, 4, violin], [stu, 7, grammar]] ;
R = [[stu, 7, math], [becca, 4, piano], [rose, 8, computer_magician], [robe, 5, violin], [iona, 6, grammar]] ;
R = [[stu, 7, math], [robe, 5, piano], [rose, 8, computer_magician], [becca, 4, violin], [iona, 6, grammar]] ;
R = [[rose, 8, math], [becca, 4, piano], [iona, 7, computer_magician], [robe, 5, violin], [stu, 6, grammar]] ;
R = [[rose, 8, math], [robe, 5, piano], [iona, 7, computer_magician], [becca, 4, violin], [stu, 6, grammar]] ;
false.
```