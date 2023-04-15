:- use_module(library(plunit)).

:- include(arguments).
:- include(utilities).
:- include(syllogisms).
same([], []).

same([H1|R1], [H2|R2]):-
    H1 = H2,
    same(R1, R2).
:- begin_tests(prison).

test(opposite1, [nondet]) :-
    opposite([no,robin,is,a,reptile], [some,robin,is,a,reptile]).

test(opposite2, [nondet]) :-
    opposite([every,student,is,busy], [some,student,is,not,busy]).

test(opposite3) :-
    opposite([some,student,is,busy], [no,student,is,busy]).

test(opposite4) :-
    opposite([some,student,is,not,busy], [every,student,is,busy]).

test(syllogism_no_arg) :-
    forall(p(_,S), phrase(syllogism,S)). 

test(syllogism1) :-
    findall(ClauseList, (p(2,S), phrase(syllogism(ClauseList),S)), ClauseLists),
    same(ClauseLists, [[(mammal(_A):-human(_A))],[(warm_blooded(_B):-mammal(_B))]]).

test(syllogism2) :-
    findall(ClauseList, (p(1,S), phrase(syllogism(ClauseList),S)), ClauseLists),
    same(ClauseLists, [[(bird(_A):-robin(_A))],[(false:-bird(_B),reptile(_B))]]).


:- end_tests(prison).
