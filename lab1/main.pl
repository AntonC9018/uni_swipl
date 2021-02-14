% Curmanschii Anton, IA1901, 27.01.2021
% Inteligenta Artificiala, lab. nr.1

% Stabilim faptele
% Este oare X barbat?
male(ion).
male(victor). 
male(dima).
male(eugen).
male(grigore).
male(ion_1). % pentru punct C.
% Este oare X femeie?
female(dana).
female(diana).
female(nastea).
female(olga).
female(vica).
female(ana). % pentru punct C.
% Este oare X parintele lui Y?
parent(ion, dana). parent(ion, vica). parent(diana, dana). parent(diana, vica).
parent(nastea, olga). parent(dima, olga). parent(nastea, grigore). parent(dima, grigore).
parent(olga, ana).
parent(grigore, eugen).
parent(ion_1, ion_2). % pentru punct C.

% Definim reguli
% X este mama lui Y daca X este parinte lui Y si este femeie.
mother(X, Y) :- parent(X, Y), female(X).
% X este tata lui Y daca X este parinte lui Y si este barbat.
father(X, Y) :- parent(X, Y), male(X).
% Sibling inseamna au un parinte comun.
sibling(X, Y) :- parent(Z, X), parent(Z, Y),  X \== Y.
% X este frate lui Y daca X este barbat si ei ambii au un parinte comun.
brother(X, Y) :- sibling(X, Y), male(X).
% Similar, doar ca X este femeie.
sister(X, Y) :- sibling(X, Y), female(X).
% X este copil lui Y daca Y este parinte lui X.
child(X, Y) :- parent(Y, X).
% X este fiica lui Y daca Y este parinte lui X si X este femeie.
% Sau putem utiliza si regula child() definit mai sus.
daughter(X, Y) :- parent(Y, X), female(X).
% daughter(X, Y) :- child(X, Y), female(X).
% X este fecior lui Y daca Y este parinte lui X si X este barbat.
son(X, Y) :- parent(Y, X), male(X).
% Regula de ajutor care defineste relatii bunele (Stramos).
grand_parent(X, Y) :- parent(Z, Y), parent(X, Z).
% X este bunel lui Y daca exista Z care este parinte lui Y si X este parinte lui Z si este barbat.
grand_father(X, Y) :- grand_parent(X, Y), male(X).
% Analogic cu bunica
grand_mother(X, Y) :- grand_parent(X, Y), female(X).
% Regula de ajutor pentre matusa/unchi. Nu stiu daca acest concept are nume in romana/engleza.
uncle_or_aunt(X, Y) :- parent(Z, Y), sibling(X, Z).
% X este unchi lui Y daca parinte Z lui Y are parinte comun cu X, si X este barbat.
uncle(X, Y) :- uncle_or_aunt(X, Y), male(X).
% Analogic, doar ca e femeie.
aunt(X, Y) :- uncle_or_aunt(X, Y), female(X).
% X este nepot lui Y daca Y este unchi sau matusa si X este barbat.
nephew(X, Y) :- uncle_or_aunt(Y, X), male(X).
% Asemenator, doar ca este fata.
niece(X, Y) :- uncle_or_aunt(Y, X), female(X).
% Urmas inseamna nepot sau nepoata.
descendant(X, Y) :- grand_parent(Y, X).
% Regula de ajutor.
step_sibling(X, Y) :- parent(X, Z), parent(Y, Z1), siblings(Z, Z1).
% X este var lui Y daca X are parinte care este frate sau sora unui alt parinte lui Y si X este barbat.
step_brother(X, Y) :- step_sibling(X, Y), male(X).
% Analogic.
step_sister(X, Y) :- step_sibling(X, Y), female(X).
% X are copii daca el este parinte la cel putin un copil.
has_child(X) :- parent(X, _).
% X este bunel daca exista un Z pentru care X este bunel.
is_grand_father(X) :- grand_father(X, _).
% Analogic.
is_grand_mother(X) :- grand_mother(X, _).
% X are frati daca exista doua Y si Z diferite care sunt copii lui X
has_sons(X) :- son(Y, X), son(Z, X), Y \== Z.
% X are veri daca existe Y care este vara/var lui X.
has_step_sibling(X) :- step_sibling(X, _).

% A)
% Casatoritii. Cuplurile selectate au copii.
married(ion, diana).
married(nastea, dima).
married(ion_2, ana). % pentru punct C.

% Soacra = mama miresei sau a mirelui in raport cu celalalt sot.
% X - soacra potentiala, Y - sotul de referire. 
mother_in_law(X, Y) :- married(Y, Z), mother(X, Z).
% Cumnat = fratele sotului sau al sotiei in raport cu celalalt sot.
% X - cumnatul potential, Y - sotul de referire.
brother_in_law(X, Y) :- married(Y, Z), brother(X, Z).
% Ginere = sotului unei femei, in raport cu parintii acestea.
% X - ginerele potential, Y - parintele de referire.
bridegroom(X, Y) :- married(X, Z), parent(Y, Z).

% B)
% X este barbat daca a fost definit ca barbat.
% is_male(X) :- male(X).
% In sarcina insa, ne cere sa verificam daca nu este femeie.
is_male(X) :- not(female(X)).


% C) Unele reguli.

% Fericire = 2+ copii.
happy(X) :- parent(X, Y), parent(X, Z), Y \== Z.

% Doi copii = X are un copil Y care are un sibling.
has_two_children(X) :- parent(X, Y), sibling(Y, _).