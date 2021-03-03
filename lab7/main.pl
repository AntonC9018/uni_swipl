% Helper functions, explained previously
takeout(X, [X|R], R).
takeout(X, [H|T], [H|R]) :- takeout(X, T, R).

% With one list remaining, just take the last element.
tuple_combination([[X|Rest]], [X], [Rest]). 
% If head is a list, return combinations of it with the other lists
tuple_combination([H|T], R, [HRest|TRest]) :- 
        T \== [],
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
    member([becca, 4, D_Becca], R), D_Becca \== math, 
    
    % computer_magician is older than Stu by 1 year.
    member([_, Age_Magician, computer_magician], R),
    member([stu, Age_Stu, _], R),
    Age_Magician is Age_Stu + 1,

    % Iona is not 8
    member([iona, A_Iona, _], R), A_Iona \== 8, 

    % Robe is 5 and is younger than the grammar guy
    member([robe, 5, _], R),
    member([_, Age_Grammar, grammar], R), Age_Grammar > 5,

    % Somebody plays violin at 7
    member([_, 7, violin], R).


/*
perms([], [], [], []).
perms(L1, L2, L3, R) :- takeout(E1, L1, New_L1), 
                        takeout(E2, L2, New_L2), 
                        takeout(E3, L3, New_L3),
                        perms(New_L1, New_L2, New_L3, R1),
                        R = [[E1, E2, E3]|R1].*/