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