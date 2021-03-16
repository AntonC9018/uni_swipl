# Inteligenta Artificiala, laborator nr.11.

A elaborat: **Curmanschii Anton, IA1901**.

## Sarcina

Varianta 7.

Fie dată gramatica 
$
G = (V_N, V_T, P, S); V_N={S}, V_T={a}, 
P =
\\begin{cases}
S \\rightarrow aaS \\\\
S \\rightarrow a
\\end{cases}
$

Limbajul generat de această gramatică este: 
$L(G)=\\\{a^{2i-1},i \\geq 1\\\}$. 
Să se scrie un program Prolog ce ar recunoaşte astfel de cuvinte.


## Introducere

Elementele gramaticii pot fi interpretate în contextul Prologului în felul următor:
- $V_N$ este o mulțime ce conține numele predicatelor, utilizate la recunoașterea secvențelor valide de caractere.
- $V_T$ este o mulțime de simboluri care pot fi utilizate în cuvinte.
- $P$ este mulțimea corpurilor acelor simboluri.
- $S$ este mulțimea predicatelor formate din predicate din $V_N$ care definesc structura șirurilor valide.


## Rezolvare

În cazul problemei aceste particulare:
- $V_N = \\{ Sequence \\}$
- $V_T = \\{ a \\}$
- $P = \\{ Sequence \\rightarrow a; Sequence \\rightarrow a, a, Sequence \\}$
- $S = \\{ Sequence \\}$

Rezolvarea utilizând sintaxa DCG este trivială:
```prolog
sequence --> [a]
sequence --> [a, a], sequence.
```

Pornim. Cum a fost menționat în lucrarea 6, prin al două parametru se transmite lista fără elementele potrivite:
```
1 ?- sequence([], R).            
false.                           
                                 
2 ?- sequence([a], R).           
R = [] ;                         
false.                           
                                 
3 ?- sequence([a, a, a, a], R).  
R = [a, a, a] ;                  
R = [a] ;                        
false.                           
                                 
4 ?- sequence([a, a, a], R).     
R = [a, a] ;                     
R = [] ;                         
false.                           
                                 
5 ?- sequence([a, a, a, b], R).  
R = [a, a, b] ;                  
R = [b] ;                        
false.                           
                                 
6 ?- sequence([b, a], R).        
false.
```

## Un caz mai complicat

Să spunem că avem un caz ceva mai complicat (varianta 4):
- $V_N = \\{ Sequence, A, B \\}$
- $V_T = \\{ a, b, c \\}$
- $P = \\left\\{
\\begin{array}{c}
    & Sequence \\rightarrow A, B \\\\
    & A \\rightarrow a, A, b \\\\
    & A \\rightarrow a, b \\\\
    & B \\rightarrow c, B \\\\
    & B \\rightarrow c
\\end{array} \\right\\}$
- $S = \\{ sequence \\}$

Rezolvarea utilizând sintaxa DCG:
```prolog
sequence --> a_, b_.

a_ --> [a], a_, [b].
a_ --> [a, b].

b_ --> [c], b_.
b_ --> [c].
```

Verificăm. Cel mai scurt cuvânt ar fi cuvântul "abc":
```
1 ?- sequence([a, b, c], R).
R = [].
```

Secvențele "ab" (imbricate) și "c" pot să se repete de mai multe ori:
```
2 ?- sequence([a, a, a, b, b, b, c, c, c], R).
R = [] ;
R = [c] ;
R = [c, c] ;
false.
```

Și o secvență nevalidă:
```
3 ?- sequence([c, a, b], R).
false.
```
