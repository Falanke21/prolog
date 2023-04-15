/*
    File: sample.pl  -  nr600
*/

check_integer( 0 ).
check_integer( N ) :-
    N > 0,
    N1 is N - 1,
    check_integer( N1 ).
check_integer( N ) :-
    N < 0,
    N1 is N + 1,
    check_integer( N1 ).
