# Inteligenta Artificiala, laborator nr.8.

A elaborat: **Curmanschii Anton, IA1901**.

## Sarcina.

Jocul **Chibriturile**.

Să se realizeze în Prolog jocul **Chibriturile**. Pe masă sunt aşezate 23 chibrituri. Sunt doi jucători şi fiecare din ei pe rând trebuie să ia de pe masă câteva chibrituri. Fiecare jucător are dreptul să ia 1, 2, sau 3 chibrituri. Jucătorul care va lua *ultimul* chibrit va pierde jocul. Să se scrie programul care utilizează strategia optimală de joc.

## Soluționare.

### Soluția matematică

Vom incerca sa intelegem joaca un pic mai bine. Deci, este evident, că la orice stare a jocului, cu strategia optimă, unul din jucătorilor mereu câștigă, iar altul mereu pierde.

De exemplu, dacă a rămas numai o chibrită (x = 1), și este rândul jucătorului 1, el a pierdut, fiindcă este nevoit să ia ultima chibrită. Pentru x = 2, jucătorul poate lua 1, astfel câștigând. Asemănător pentru x = 3 și x = 4. Însă, dacă x = 5, jucătorul pierde, deoarece atunci celălalt jucător nimerește în poziția numai ce explicată. Vom face un tabel cu rezultatele pentru fiecare din poziții. (W = Win, L = Lose).

|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|
|-|-|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
|L|W|W|W|L|W|W|W|L| W| W| W| L| W| W| W| L| W| W| W| L| W| W|

Din acest tabel se observă formula generală: jucătorul curent va câștiga, dacă $(x - 1) \mod 4 > 0$. Deci, strategia optimă va lucra prin aducerea valorii lui x în afară acestui interval (fiindcă atunci oponentul va nimeri în poziția L).

```prolog
matches_think(X, Action, Outcome) :- X1 is X - 1, Mod is X1 mod 4,
    % Winning position. To keep winning, get it into the losing range
    (Mod > 0) -> Action = Mod, Outcome = win
    % If in a losing position, stalling probably makes most sense
    ; Action = 1, Outcome = lose.
```

### Soluția recursivă

O altă soluție ar fi una recursivă. Pentru numărul de chibrituri curent, `X`, Același AI este cerut de găsit o mișcare optimă pentru fiecare mișcare curent posibilă. În sfârșit, recursia ne aduce la cazul de bază. Mișcarea corectă va fi acea mișcare care aduce oponentul la pierdere, adică rezultatul prevăzut pentru care este `lose`.

```prolog
matches_think_recursive(1, 1, lose). 
matches_think_recursive(2, 1, win). 
matches_think_recursive(3, 2, win). 
matches_think_recursive(X, Action, Outcome) :- X > 3,
    (
        % if the opponent loses no matter what, do this move.
        X1 is X - 1, matches_think_recursive(X1, _, lose) -> Action = 1, Outcome = win;
        X1 is X - 2, matches_think_recursive(X1, _, lose) -> Action = 2, Outcome = win;
        X1 is X - 3, matches_think_recursive(X1, _, lose) -> Action = 3, Outcome = win;
        % otherwise, stall.
        Action = 1, Outcome = lose
    ).
```

### Joaca

Am programat și însăși joaca. Iată un exemplu de execuție:

```
1 ?- matches_game_start().
There are 23 matches on the table. You and your opponent will select any amount from 1 to 3 matches, in turns. Whoever draws the last one is the loser.
Type 1. to play with AI, 2. to play with your friend, 3. to exit: 1.
Game against ai started. There are 23 matches. player, your turn.
How many matches do you take? |: 1.
22 matches remain.
It is ai's turn.
21 matches remain.
It is player's turn.
Ai predicted a win
How many matches do you take? |: 2.
19 matches remain.
It is ai's turn.
17 matches remain.
It is player's turn.
Ai predicted a win
How many matches do you take? |: 3.
14 matches remain.
It is ai's turn.
13 matches remain.
It is player's turn.
Ai predicted a win
How many matches do you take? |: 3.
10 matches remain.
It is ai's turn.
9 matches remain.
It is player's turn.
Ai predicted a win
How many matches do you take? |: 3.
6 matches remain.
It is ai's turn.
5 matches remain.
It is player's turn.
Ai predicted a win
How many matches do you take? |: 3.
2 matches remain.
It is ai's turn.
1 matches remain.
It is player's turn.
Ai predicted a win
How many matches do you take? |: 1.
ai won.
Type 1. to play with AI, 2. to play with your friend, 3. to exit: |: 2.
Game with 2 players started. There are 23 matches. player1, your turn.
How many matches do you take? |: 3.
20 matches remain.
It is player2's turn.
How many matches do you take? |: 3.
17 matches remain.
It is player1's turn.
How many matches do you take? |: 3.
14 matches remain.
It is player2's turn.
How many matches do you take? |: 3.
11 matches remain.
It is player1's turn.
How many matches do you take? |: 3.
8 matches remain.
It is player2's turn.
How many matches do you take? |: 3.
5 matches remain.
It is player1's turn.
How many matches do you take? |: 3.
2 matches remain.
It is player2's turn.
How many matches do you take? |: 1.
1 matches remain.
It is player1's turn.
How many matches do you take? |: 1.
player2 won.
Type 1. to play with AI, 2. to play with your friend, 3. to exit: |: 3.

true .
```

Și iată codul:
```prolog
matches_game_print_state(X, Player) :-
    write(X), write(" matches remain.\nIt is "), write(Player), write("\'s turn.\n").

matches_game_player_take_turn(X, R) :- 
    (
        write("How many matches do you take? "), 
        read(Value), Value > 0, Value < 4, Value =< X 
    ) -> R is X - Value;
    matches_game_player_take_turn(X, R).

matches_game_ai_take_turn(X, R, Prediction) :-
    matches_think_recursive(X, Action, Prediction),
    % uncomment, if you want the particular solution.
    % matches_think(X, Action, Prediction),
    R is X - Action.

matches_game_lost(0).


matches_game_ai_loop(X, Winner) :- 
    % Player goes first
    matches_game_player_take_turn(X, X1),
    (
        matches_game_lost(X1) -> Winner = ai, !;
    
        % Print the new number of matches remaining, whose turn it is
        matches_game_print_state(X1, ai), 

        % AI's turn
        matches_game_ai_take_turn(X1, X2, Prediction),
    (
        matches_game_lost(X2) -> Winner = player, !;

        matches_game_print_state(X2, player), 
        write("Ai predicted a "), write(Prediction), write("\n"),
        matches_game_ai_loop(X2, Winner)
    )).
    

matches_game_ai_start(X) :-
    write("Game against ai started. There are "), 
    write(X),
    write(" matches. player, your turn.\n"),
    matches_game_ai_loop(X, Winner),
    write(Winner), write(" won.\n").


matches_game_two_players(X, Winner) :- 
    matches_game_player_take_turn(X, X1),
    ( 
        matches_game_lost(X1) -> Winner = player2, !;
        matches_game_print_state(X1, player2), 
        matches_game_player_take_turn(X1, X2),
    (
        matches_game_lost(X2) -> Winner = player1, !;
        matches_game_print_state(X2, player1), 
        matches_game_two_players(X2, Winner)
    )).

matches_game_two_players_start(X) :-
    write("Game with 2 players started. There are "), 
    write(X), write(" matches. player1, your turn.\n"),
    matches_game_two_players(X, Winner),
    write(Winner), write(" won.\n").


matches_game_rules(X) :- write("There are "), write(X), write(" matches on the table. You and your opponent will select any amount from 1 to 3 matches, in turns. Whoever draws the last one is the loser.\n").


matches_game_play_menu(X) :- 
    write("Type 1. to play with AI, 2. to play with your friend, 3. to exit: "), 
    read(Input), 
    (
        Input == 1 -> (matches_game_ai_start(X), matches_game_play_menu(X));
        Input == 2 -> (matches_game_two_players_start(X), matches_game_play_menu(X));
        Input == 3 -> !;
        matches_game_play_menu(X)
    ).


matches_game_start() :-
    matches_game_rules(23),
    matches_game_play_menu(23).
```