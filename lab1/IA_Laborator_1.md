
# Inteligenta Artificiala, laborator nr.1.

A elaborat: **Curmanschii Anton, IA1901**.

Remarca: Utilizez swipl din consola.

## Codul sursa fisierului cu reguli si fapte.

```prolog
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
parent(olga, vica).
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
```

## Interogari.

### Parinte.

Este oare ion_1 parinte lui ion_2?
```prolog
?- parent(ion_1, ion_2).
true.
```

Afisarea tuturor copiilor lui ion_1.
```prolog  
?- parent(ion_1, X).
X = ion_2.
```

Afisarea tuturor perechilor parinte - copil.
```prolog
?- parent(X, Y).
X = ion,
Y = dana ;
X = ion,
Y = vica ;
X = diana,
Y = dana ;
X = diana,
Y = vica ;
X = nastea,
Y = olga ;
X = dima,
Y = olga ;
X = nastea,
Y = grigore ;
X = dima,
Y = grigore ;
X = olga,
Y = vica ;
X = grigore,
Y = eugen ;
X = ion_1,
Y = ion_2.
```

Femeie.
Este oare ana femeie?
```prolog
?- female(ana).
true.
```

Afisarea tuturor femeilor.
```prolog
?- female(X).
X = dana ;
X = diana ;
X = nastea ;
X = olga ;
X = vica ;
X = ana.
```

### Barbat.

Oare este ion_1 barbat?
```prolog
?- male(ion_1).
true.
```

Afisarea tuturor barbatilor.
```prolog
?- male(X).
X = ion ;
X = victor ;
X = dima ;
X = eugen ;
X = grigore ;
X = ion_1.
```

Oare ion_1 este barbat?
```prolog
?- is_male(ion_1).
true.
```

Tot afiseaza toti barbatii? Este afisat false, deoarece ???
```prolog
?- is_male(X).
false.
```
Ne uitam in `trace`.
```prolog
[trace] ?- is_male(X).
   Call: (10) is_male(_1980) ? creep
^  Call: (11) not(female(_1980)) ? creep
   Call: (12) female(_1980) ? creep
   Exit: (12) female(dana) ? creep
^  Fail: (11) not(user:female(_1980)) ? creep
   Fail: (10) is_male(_1980) ? creep
false.
```
Deci este incercata o valoare, `dana`, care nu a fost intorsa la predicatul `is_male/1`. Pe urma am primit `Fail`. `is_male/1` considera ca nu exista o alta valoare care ar putea fi atribuita lui `X`. Nu stiu de ce este asa.
UPDATE: am citit informatia de pe aici [Negation as failure](https://www.cpp.edu/~jrfisher/www/prolog_tutorial/2_5.html).
> But consider that the goal ?-not(married(Who)) fails because for the variable binding Who=tom, married(Who) succeeds, and so the negative goal fails. Thus, negative goals ?-not(g) with variables cannot be expected to produce bindings of the variables for which the goal g fails.

Deci, `X` in scopul `female(X)` nici nu poate primi valori care nu sunt femei, astfel mereu produce `true`. Deci `not(female(X))` mereu produce `false`.

Familiile fara copii. Prin familie, intelegem pereche de parinti casatoriti.
Sa spunem ca ion_2 si ana sunt casatoriti.
```prolog
?- married(ion_2, ana).
true.
```

Daca X si Y sunt casatoriti, si nici X, nici Y nu au copii, le afisam.
```prolog
?- married(X, Y), \+ parent(X, _), \+ parent(Y, _).
X = ion_2,
Y = ana.
```

Toate mamele. Apar de mai multe ori, deoarece predicatul este apelat pentru fiecare copil.
```prolog
?- mother(X, _).
X = diana ;
X = diana ;
X = nastea ;
X = nastea ;
X = olga ;
false.
```

Nepotii (fete) lui grigore. Vica apare de doua ori
```prolog
?- niece(X, grigore).
X = vica ;
X = vica ;
false.
```

Persoanele fericite (2+ copii).
```prolog
?- happy(X).
X = ion ;
X = ion ;
X = diana ;
X = diana ;
X = nastea ;
X = dima ;
X = nastea ;
X = dima ;
false.
```

Are 2+ copii.
```prolog
?- has_two_children(X).             
X = ion ;                             
X = ion ;                             
X = ion ;                             
X = ion ;                             
X = ion ;                             
X = ion ;                             
X = ion ;                             
X = ion ;                             
X = ion ;                             
X = diana ;                           
X = diana ;                           
X = diana ;                           
X = diana ;                           
X = diana ;                           
X = diana ;                           
X = diana ;                           
X = diana ;                           
X = diana ;                           
X = nastea ;                          
X = nastea ;                          
X = nastea ;                          
X = nastea ;                          
X = dima ;                            
X = dima ;                            
X = dima ;                            
X = dima ;                            
X = nastea ;                          
X = nastea ;                          
X = nastea ;                          
X = nastea ;                          
X = dima ;                            
X = dima ;                            
X = dima ;                            
X = dima ;                            
X = olga ;                            
X = olga ;                            
X = olga ;                            
X = olga ;                            
X = olga ;                            
X = grigore ;                         
X = ion_1.                            
```
De ce aceasta se intampla? Daca ne uitam prin trace, observam asa ceva:
```prolog
[trace] ?- has_two_children(X).             
    Call: (10) has_two_children(_3130) ? creep 
    Call: (11) parent(_3130, _3554) ? creep    
    Exit: (11) parent(ion, dana) ? creep       
    Call: (11) sibling(dana, _3708) ? creep    
    Call: (12) dana\==_3694 ? creep            
    Exit: (12) dana\==_3694 ? creep            
    Call: (12) parent(_3788, dana) ? creep     
    Exit: (12) parent(ion, dana) ? creep       
    Call: (12) parent(ion, _3694) ? creep      
    Exit: (12) parent(ion, dana) ? creep       
    Exit: (11) sibling(dana, dana) ? creep     
    Exit: (10) has_two_children(ion) ? creep   
X = ion ;                                     
    Redo: (12) parent(ion, _3694) ? creep      
    Exit: (12) parent(ion, vica) ? creep       
    Exit: (11) sibling(dana, vica) ? creep     
    Exit: (10) has_two_children(ion) ? creep   
X = ion ;                                     
    ...
```
`sibling(dana, dana) = True`, adica dana a fost determinata ca sora/frate lui dana.
Ne uitam in codul sursa: 
```prolog
    sibling(X, Y) :- X \== Y, parent(Z, X), parent(Z, Y).
```
Este verificat daca X nu este Y la inceputul functiei, dar Y la acel momel nu se cunoaste.
Daca punem la sfarsit, trebuie sa lucreze (in codul sursa este specificata versiunea corecta).
```prolog
?- has_two_children(X).   
X = ion ;                   
X = ion ;                   
X = ion ;                   
X = ion ;                   
X = diana ;                 
X = diana ;                 
X = diana ;                 
X = diana ;                 
X = nastea ;                
X = nastea ;                
X = dima ;                  
X = dima ;                  
X = nastea ;                
X = nastea ;                
X = dima ;                  
X = dima ;                  
X = olga ;                  
X = olga ;                  
```
Acum ion apare de 4 ori, ce e logic. Perechile de surori/frati sunt:
*dana -- dana, dana -- vica, vica -- vica, vica -- dana*. Numai doua combinatii produc rezultatul adevar: *dana -- vica, vica -- dana*. Insa aceste perechi sunt implicate de 2 ori fiecare: o ora pentru fiecare parinte. Deci, o data dana este sora lui vica prin intermediul lui ion, si iarasi o data prin sotia lui. Deoarece ele sunt ambele copiii ambelor parintii sai, predicatul sibling/2 produce adevar pentru ambele parinti. Astfel, ion este considerat avand doua copii de 4 ori.