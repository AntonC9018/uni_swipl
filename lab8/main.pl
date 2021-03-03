matches_think(X, Action, Outcome) :- X1 is X - 1, Mod is X1 mod 4,
    % Winning position. To keep winning, get it into the losing range
    (Mod > 0) -> Action = Mod, Outcome = win
    % If in a losing position, stalling probably makes most sense
    ; Action = 1, Outcome = lose.

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