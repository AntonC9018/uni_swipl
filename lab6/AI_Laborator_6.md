# Inteligenta Artificiala, laborator nr.6.

A elaborat: **Curmanschii Anton, IA1901**.

## Sarcina.

Varianta 7.

Să se scrie un program Prolog care realizează automatul finit ce recunoaşte cuvintele de forma $a(abc)^{n}(ab)^{m}, n \geq 0, m \geq 0, n + m \geq 1$

## Soluționare și explicații.

Pentru informație referitor la parsing în Prolog, am accesat [această pagină](https://www.cpp.edu/~jrfisher/www/prolog_tutorial/7_1.html). În scurt, Prolog-ul recunoaște o sintaxă specială, numită DCG, care permite să implementăm parser-uri sau chiar și generatori de text (sau de liste). 

Trecem la soluția exemplului meu. Ca să nu mă încurce, am hotărât să numesc predicatele cu `_` la sfârșit, dacă poate să conțină repetări, și calculează numărul de elemente. Deci, predicatul care consumă pattern-ul `abc` de 0+ ori ar fi numit `abc_`.

Deci, definim prima regulă, sequence. Ea potrivește condiției din problemă: se potrivește o dată simbolul `a` prin sintaxa `[a]`, pe urmă de `N` ori (adică salvăm numărul de apariții în `N`) abc prin sintaxa `abc_(N)`, pe urmă de `M` ori secvența de prin regula `de_(M)`. După ce avem o expresie prolog încorporată, care verifică dacă `N + M` este mai mare sau egal ca 1. Expresiile prolog sunt încorporate, folosind paranteze acolade.
```
sequence --> [a], abc_(N), de_(M), 
             { S is N + M, S >= 1 }.
```

Pe urmă definim regulile pentru secvențele `abc` și `de`. Aici nu e nimic complicat. Prin `[a,b,c]` înregistrăm potrivirea următoare, după ce incrementăm contorul. Folosim recursia pentru a avea mai multe potriviri.
```
abc_(0) --> [].
abc_(N) --> [a,b,c], abc_(N1), { N is N1 + 1 }.
```

## Intregul cod.
```
sequence --> [a], abc_(N), de_(M), 
             { S is N + M, S >= 1 }.

abc_(0) --> [].
abc_(N) --> [a,b,c], abc_(N1), { N is N1 + 1 }.

de_(0)  --> [].
de_(M)  --> [d,e], de_(M1), { M is M1 + 1 }.
```


## Executare

În primul rând, putem utiliza comanda predicatul `listing/0` pentru a găsi cum au fost transformate expresiile descrise alterior. Găsim prin output-ul funcțiile noastre. Funcțiile date sunt clare după lucrări 1-5.
```prolog
abc_(0, A, A).                   
abc_(N, [a, b, c|A], B) :-       
    abc_(N1, A, C),              
    N is N1+1,                   
    B=C.                         
                                 
de_(0, A, A).                    
de_(M, [d, e|A], B) :-           
    de_(M1, A, C),               
    M is M1+1,                   
    B=C.                         
                                   
sequence([a|A], B) :-            
    abc_(N, A, C),               
    de_(M, C, D),                
    S is N+M,                    
    S>=1,                        
    B=D.                         
```

De menționat un lucru. Predicatul creat ia doua parametre: lista, după care se recunoaște pattern-ul, și o listă care conține restul primei liste, după eliminarea elementelor potrivite. Deci la executare vom vedea mai multe variante posibile de acea listă, fiidncă putem avea mai multe combinații de numărul de grupuri de `abc` și de `de` potrivite.

```
1 ?- sequence([a,a,b,c,d,e],[]).       
true ;                                 
false.                                 
                                       
2 ?- sequence([a,a,b,c],[]).           
true ;                                 
false.                                 
                                       
3 ?- sequence([a,a,b,c,a,b,c,d,e],X).  
X = [a, b, c, d, e] ;                  
X = [d, e] ;                           
X = [] ;                               
false.                                 
                                       
4 ?- sequence([a,a,b,c,a,b,c,d,d,e],X).
X = [a, b, c, d, d, e] ;               
X = [d, d, e] ;                        
false.                                 
                                       
5 ?- sequence([a,d,e],X).              
X = [] ;                               
false.                                 
                                       
6 ?- sequence([a,d,d,e],X).            
false.                                 
```

## Concluzie

În laboratorul 6 am prezentat sintaxa lui DGC în prolog și am realizat un exemplu.