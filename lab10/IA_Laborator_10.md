# Inteligenta Artificiala, laborator nr.10.

A elaborat: **Curmanschii Anton, IA1901**.

## Sarcina

Varianta 7.

Fie date trei bidoane – unul de 14 litri, unul de 8 litri şi unul de 5 litri. Iniţial cel de 14 litri este plin, iar celelalte (de 8 litri şi de 5 litri) sunt deşarte. Să se găsească o secvenţă de acţiuni care lasă câte 7 litri de apă în bidoanele de 14 litri şi de 8 litri. Acţiunile posibile care pot modifica starea bidoanelor sunt: apa poate fi turnată dintr-un bidon în altul, până când primul se goleşte sau al doilea se umple.

## Soluționare

Putem formaliza problema propusă prin 3 numere, fiecare număr să reprezente câte litre de apă avem în fiecare bidon. Vom încerca să umplem câte un bidon, după ce vom face recursie pe starea rezultantă. 

Pot prevede o problemă cu așa algoritm: deadlock-uri (recursia infinită). Presupunem că avem 5 litre în bidonul de 8 litre și 0 în bidonul de 5 litre. Atunci o secvență validă de acțiuni după algoritmul dat va fi de a turna 5 litre de la bidonul de 8 litre în bidonul de 5 litre, umplând-ul, după ce a-l goli, turnând acele 5 litre înapoi în bidonul de 8 litre. Vom nota acțiunele cu o astfel de notație: `[5,8]` înseamnă a turna din 5 în 8. Datorită restrângerilor problemei, putem mereu determina câte litre au fost turnate după așa informație, având starea curentă. Deci, situația descrisă mai sus ar fi notată ca `[8,5], [5,8], [8,5], [5,8], ...` până la infinit.

Cea mai simplă soluție la această problemă este de a păstra o listă cu toate stările trecute și de a verifica dacă sistemul deja a fost în starea nouă, înainte de a o fixa.

## Interpretarea programatică

Pentru o stare dată, încercăm toate acțiunile posibile. În programul am folosit tuplurile cu indicii bidoanelor pentru a reprezenta acțiunile. Starea curentă se reprezintă printr-un tuplu cu trei elemente — număr de litre curent în fiecare bidon.

```prolog
% Given a starting state, returns the new state and the performed action.
cans_advance_state(State, Action, New_State) :-

    % Can indices range from 0 to 2 inclusive
    (Can_From = 0; Can_From = 1; Can_From = 2),
    (Can_To   = 0; Can_To   = 1; Can_To   = 2),
    Can_From \== Can_To,

    % An alternative way of doing this:
    % takeout(Can_From, [0, 1, 2], Rest),
    % takeout(Can_To, Rest, _),

    Action = [Can_From, Can_To],
    cans_action_modify_state(Action, State, New_State).
```

Ca să verificăm rezultatul unei acțiuni, facem următorul lucru:

1. Indexăm starea pentru a primi valorile curente ale bidoanelor din care va fi turnată apa (adică `Starea[Primul_Indice]`) și în care ea va fi turnată. Salvăm aceste valori în variabile `From_Amount` și `To_Amount`, respectiv.

2. Calculăm suma lor, adică câtă apă ar fi în bidonul `To` dacă am turna toată apa din bidonul `From` acolo. O salvăm în variabila `Sum`.

3. Luăm valoarea-limită pentru bidonul To, adică capacitatea bidonului (salvăm ca `To_Limit`).

4. Calculăm valoarea de `Overflow`, adică câtă apă nu poate fi turnată în bidonul `To` (ar fi revărsată). `Overflow = max(Sum - To_Limit, 0)`.

5. Calculăm valorile noi pentru `To_Amount`, `To_Final_Amount = Suma - Overflow` și `From_Amount`, `From_Final_Amount = Overflow`.

6. Dacă valorile noi sunt diferite de cele trecute, starea s-a schimbat (este de ajuns de verificat dacă o singură pereche de valori este diferită). Dacă starea nu s-a schimbat, o aruncăm.

```prolog
% 14, 8, 5 liters
cans_limit(0, 14).
cans_limit(1, 8).
cans_limit(2, 5).

% Given a starting state and an action, returns the new state, after that action.
% Actions are represented using 0 based indices, [can_from, can_to].
cans_action_modify_state([Can_From, Can_To], State, New_State) :-
    nth0(Can_From, State, Amount_From),
    nth0(Can_To, State, Amount_To),
    
    % Add all water from From to To.
    To_New is Amount_To + Amount_From,
    % Get the limit of that can.
    cans_limit(Can_To, To_Limit),
    % Calculate the overflown amount.
    Potential_Overflow is To_New - To_Limit,
    % Keep it positive
    Overflow is max(Potential_Overflow, 0),
    % Subtract the overflow from the final new amount.
    To_Final_Amount is To_New - Overflow,
    % Add the overflown amount back to the initial can.
    From_Final_Amount is Overflow,
    % Make sure a value changed
    Amount_From \== From_Final_Amount, 

    % Fill in the resultant state
    replace_at(Can_From, From_Final_Amount, State, New_State1),
    replace_at(Can_To, To_Final_Amount, New_State1, New_State).
```

Cu această funcție, putem folosi recursia pentru a genera o listă de acțiuni consecutive care aduc la starea finală. Ținem cont și de problema apariției repetate ale stărilor ce rezultă în recursia infinită.

```prolog
% Gets an initial state and the states that the system has
% already been in, returns a sequence of steps to get to the end.

% Base case:
cans_([7, 7, 0], _, []) :- !.

cans_(State, Previous_States, Actions) :-
    % Generate the next state.
    cans_advance_state(State, Action, New_State),
    % The generated state has not been registered before.
    not(contains_sublist_as_element(Previous_States, New_State)),
    % Recurse, having added the new state into the list of the previous states.
    cans_(New_State, [New_State|Previous_States], Actions1),
    % Return the list of actions.
    Actions = [Action|Actions1].

% Initial state: 14, 0, 0
cans(Actions) :- cans_([14, 0, 0], [[14, 0, 0]], Actions).
```

### Executare
```
1 ?- cans(Steps).
Steps = [[0, 1], [0, 2], [1, 0], [2, 1], [0, 2], [2, 1], [1, 0], [2|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [0, 1], [1, 0], [2, 1], [0, 2], [2, 1], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [1, 0], [2, 1], [0, 2], [2, 1], [1, 0], [2|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [0, 2], [1, 0], [2|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [0, 1], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [1, 0], [2|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 1], [1, 2], [2, 0], [1, 2], [0, 2], [2, 1], [0, 2], [2|...], [...|...]|...] ;
Steps = [[0, 2], [0, 1], [2, 0], [1, 2], [2, 0], [1, 2], [0, 1], [1|...], [...|...]|...] ;
Steps = [[0, 2], [2, 1], [0, 1], [1, 2], [2, 0], [1, 2], [0, 1], [1|...], [...|...]|...] ;
Steps = [[0, 2], [2, 1], [0, 2], [0, 1], [2, 0], [1, 2], [2, 0], [1|...], [...|...]|...] ;
Steps = [[0, 2], [2, 1], [0, 2], [2, 1], [0, 2], [2, 0], [1, 2], [2|...], [...|...]|...] ;
Steps = [[0, 2], [2, 1], [0, 2], [2, 1], [1, 0], [2, 1], [0, 1], [1|...], [...|...]|...] ;
Steps = [[0, 2], [2, 1], [0, 2], [2, 1], [1, 0], [2, 1], [0, 2], [0|...], [...|...]|...] ;
Steps = [[0, 2], [2, 1], [0, 2], [2, 1], [1, 0], [2, 1], [0, 2], [2|...]] ;
Steps = [[0, 2], [2, 1], [0, 2], [2, 1], [2, 0], [1, 2], [2, 0], [1|...], [...|...]|...] ;
```

### Întregul cod

Nu plasez întregul cod aici, fiindcă este destul de lung.

Nu au fost menționate aici numai funcțiile ajutătoare pe care le-am folosit.

```prolog
% Helper functions, explained previously
takeout(X, [X|R], R).
takeout(X, [H|T], [H|R]) :- takeout(X, T, R).

replace_at(0, Value, [_|L], [Value|L]).
replace_at(Index, Value, [X|Rest], Result) :- 
    Index > 0, 
    Index1 is Index - 1, 
    replace_at(Index1, Value, Rest, R1),
    Result = [X|R1].

list_equal([], []).
list_equal([H|R1], [H|R2]):- list_equal(R1, R2).

% Returns true if a list is contained as an element in the given list of lists
contains_sublist_as_element([X|Rest], List) :-
    list_equal(X, List), !;
    contains_sublist_as_element(Rest, List).
```