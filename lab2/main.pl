% Sumarea a doua numerelor naturale. Pentru a suporta si functia de adunare a numerelor negative, 
% avem nevoie sa mai adaugam unele reguli, de exemplu daca Y este negativ, deplasam in alta deirectie.
% Pentru a suporta adaugarea numerelor cu partea fractionara.
% X + 0 este X.
sum(X, 0, X).
% X + Y = X + 1 + (Y - 1).
sum(X, Y, R) :- Y > 0, Y1 is Y - 1, X1 is X + 1, sum(X1, Y1, R).

% Iarasi, suportam numai numere naturale, cum se cere in conditie. 
% Modificarile pentru a suporta acestea ar fi asemenatoare la cele la suma.
% X - 0 este X.
diff(X, 0, X).
% X - Y = X - 1 - (Y - 1).
diff(X, Y, R) :- Y > 0, X1 is X - 1, Y1 is Y - 1, diff(X1, Y1, R).

% 
% X * 0 este 0.
product(_, 0, 0).
product(0, _, 0).
% X * Y = X + X * (Y - 1).
product(X, Y, R) :- Y > 0, Y1 is Y - 1, product(X, Y1, R1), R is X + R1.

% Gaseste cel mai mare denumitor comun lui X in raport la Y, folosind algoritmul lui Euclid.
gcd(X, Y, R) :- X > Y, X1 is X - Y, gcd(X1, Y, R);
                X < Y, X1 is Y - X, gcd(X1, X, R).
gcd(X, X, X).

% Calculeaza X^N.
% X ^ 0 = 1.
power(_, 0, 1). 
% 0 ^ X = 0.
power(0, _, 0).
% X ^ N = X * X ^ (N - 1).
power(X, N, R) :- N > 0, X > 0, N1 is N - 1, power(X, N1, R1), R is X * R1.

% X % X = 0.
mod1(X, X, 0).
                 % X % Y = (X - Y) % Y.
mod1(X, Y, R) :- X > Y -> X1 is X - Y, mod1(X1, Y, R);
                 % Insa daca X < Y, X este rezultatul.
                 X < Y, R = X.

% X este succ lui Y daca X = Y + 1.
% 1 = 0 + 1.
succ1(0, 1).
% Daca X = Y + 1, atunci X - 1 = (Y - 1) + 1.
succ1(X, Y) :- X > 0, X1 is X - 1, succ1(X1, Y1), Y is Y1 + 1.

% Analogic.
predecessor(1, 0).
predecessor(X, Y) :- X > 1, X1 is X - 1, predecessor(X1, Y1), Y is Y1 + 1.

% X / X = 1.
div1(X, X, 1).
                 % X / Y = (X - Y) / Y.
div1(X, Y, R) :- X > Y -> X1 is X - Y, div1(X1, Y, R1), R is R1 + 1;
                 % Insa daca X < Y, X / Y = 0.
                 X < Y, R is 0.

% Incepem de la 0.
sum_to(0, 0).
% Suma(de la i la N) = N + Suma(de la i la N - 1).
sum_to(N, X) :- N > 0, N1 is N - 1, sum_to(N1, X1), X is X1 + N.

fib(0, 0).
fib(1, 1).
fib(N, X) :- N > 1,
             N1 is N - 1, fib(N1, X1), 
             N2 is N - 2, fib(N2, X2), 
             X is X1 + X2.

% Ackerman
ackerman(0, X, R) :- R is X + 1.
ackerman(N, 0, R) :- N > 0, N1 is N - 1, ackerman(N1, 1, R).
ackerman(N, M, R) :- N > 0, M > 0, 
                     M1 is M - 1, 
                     ackerman(N, M1, R1), 
                     N1 is N - 1, 
                     ackerman(N1, R1, R).

% Numar de cifre in baza B
num_digits(0, _, 0).
num_digits(X, B, R) :- X > 0, X1 is div(X, B), num_digits(X1, B, R1), R is R1 + 1.

% Suma divizorilor
% R este K daca X mod K este 0, 0 in alt caz.
k_if_divides(X, K, R) :- M is mod(X, K), (M == 0 -> R is K; R is 0).
sum_of_divisors(_, 1, 1).
sum_of_divisors(X, K, R) :- K > 1, 
                            k_if_divides(X, K, M), 
                            K1 is K - 1, 
                            sum_of_divisors(X, K1, R1), 
                            R is R1 + M.
sum_of_divisors(0, 0).
sum_of_divisors(X, R) :- X > 0, sum_of_divisors(X, X, R).

% Suma numelor impare pana la N
sum_of_odd_upto_n(0, 0).
sum_of_odd_upto_n(N, R) :- N > 0,
                           M is mod(N, 2), 
                           N1 is N - 1, 
                           sum_of_odd_upto_n(N1, R1),
                           R is M * N + R1.

% Verifica daca X este prim. X este prim, daca suma factorilor lui X este X + 1.
is_prime(0) :- false.
is_prime(1) :- false.
is_prime(X) :- X > 1, sum_of_divisors(X, R), R is X + 1.

% Verifica daca suma divizorilor (in afara lui X) este egala cu X.
is_perfect(0).
is_perfect(1).
is_perfect(X) :- X > 2, K is div(X, 2), sum_of_divisors(X, K, R), R == X.

% Suma primelor N multiple
sum_of_multiples(_, 0, 0).
sum_of_multiples(X, N, R) :- N > 0,
                             N1 is N - 1,
                             sum_of_multiples(X, N1, R1),
                             R is R1 + X * N.

% Suma a trei numere naturale
sum_of_three(X, Y, Z, R) :- sum(X, Y, R1), sum(R1, Z, R).

% Reducere a doua numere (reciproc prime)
make_coprime(1, Y, 1, Y).
make_coprime(X, 1, X, 1).
make_coprime(0, Y, 0, Y).
make_coprime(X, 0, X, 0).
make_coprime(X, Y, XR, YR) :- 
        % Se gaseste divizorul comun.
        gcd(X, Y, Gcd), 
        % Daca el face rezultat mai mic, atunci X si Y se divizeaza.
        ( 
            Gcd > 1 -> 
                X1 is X / Gcd, Y1 is Y / Gcd, 
                make_coprime(X1, Y1, XR, YR)
            % Daca nu, returnam X si Y
            ; XR is X, YR is Y 
        ).

func(0, 22).
func(1, 17).
func(N, R) :- N > 1, 
              N1 is N - 1, func(N1, R1),
              N2 is N - 2, func(N2, R2),
              R is 2 * R1 + R2.

% Suma(i de la 1 la N lui 1/i).
sum_of_reciprocals(0, 0).
sum_of_reciprocals(N, R) :- N > 0, 
                            N1 is N - 1, sum_of_reciprocals(N1, R1), 
                            R is R1 + 1 / N.

% Se verifica daca K este divizor lui X.
divides(_, 0) :- false.
divides(X, K) :- K \== 0, R is mod(X, K), R == 0.