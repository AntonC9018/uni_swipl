% 2) Fiind data o harta cu n tari, se cer toate solutiile de colorare a hartii,
% utilizand maxim 4 culori, astfel incat 2 tari cu frontiera comuna sa fie
% colorate diferit. Se stie ca sunt suficiente numai 4 culori astfel incat orice
% harta planara sa poata fi colorata.
takeout(X, [X|R], R).
takeout(X, [H|T], [H|R]) :- takeout(X, T, R).

replace([], _, _, []). 
replace([H|T], Element, By, [RH|RT]) :- 
    (H == Element -> RH = By ; RH = H),
    replace(T, Element, By, RT).

replace_nested([], _, _, []).
replace_nested([H|T], Element, By, [RH|RT]) :- 
    replace(H, Element, By, RH), 
    replace_nested(T, Element, By, RT).

has_duplicate_pairs([H|T]) :- [X,Y] = H, X == Y ; has_duplicate_pairs(T).


color(1). color(2). color(3). color(4).

do_coloring([], _, []).
do_coloring([Country|T], Borders, Coloring) :-
    color(Color), 
    replace_nested(Borders, Country, Color, New_Borders),
    not(has_duplicate_pairs(New_Borders)),
    do_coloring(T, New_Borders, Coloring1),
    Coloring = [[Country, Color]|Coloring1].

test(Coloring) :- do_coloring([america, austria, moldova, romania, kiev], [[moldova, kiev], [austria, america], [america, moldova], [romania, moldova], [moldova, austria]], Coloring).

test2(Coloring) :- do_coloring([america, austria], [[austria, america]], Coloring).
