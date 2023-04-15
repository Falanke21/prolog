%% File: syllogisms.pl
%% Name: Frank Hua
%% Date: 24/11/2022
%%
%% This program is a solution to Prolog Assessed Exercise 5 'Syllogisms'
%% The exercise is to develop a parser and meta-interpreter for syllogistic
%% sentences, and use these to build a tool to determine the validity of a
%% syllogistic argument.

%% ---------------------------- Step 1 ---------------------------------------%%

article --> [a].
article --> [every].
optional_article --> [].
optional_article --> [a].
%% opposite(+L, -Opp)
opposite([no|T], [some|T]).
opposite([H|T], Opp) :-
    article([H], _),
    % Get the subject of L
    T = [B, is|C],
    Opp = [some, B, is, not|C].
% Case existential qualifier
opposite([some|T], Opp) :-
    T = [B, is|Rest],
    Rest = [not|C],
    !,
    Opp = [every, B, is|C].
opposite([some|T], Opp) :-
    T = [B, is|C],
    Opp = [no, B, is|C].

%% ---------------------------- Step 2 ---------------------------------------%%

%% Stage 2.1 - This is the suggested way to develop the solution.
%% Once Stage 2.2 is complete you can delete or comment out this code.
%% syllogism/0
% every B is C
syllogism --> 
    article,
    [_],
    [is],
    optional_article,
    [_].
% no B is C
syllogism -->
    [no],
    [_],
    [is],
    optional_article,
    [_].
% some B is not C
syllogism -->
    [some],
    [_],
    [is],
    [not],
    optional_article,
    [_].
% some B is C
syllogism -->
    [some],
    [_],
    [is],
    optional_article,
    [_].

%% Stage 2.2 
%% syllogism(-Clauses)

% every B is C
syllogism([Clause]) -->
    article,
    [B],
    [is],
    optional_article,
    [C],
    {
        Subject =.. [B, X],
        Object =.. [C, X],
        Clause =.. [:-, Object, Subject]
    }.
% no B is C
syllogism([Clause]) -->
    [no],
    [B],
    [is],
    optional_article,
    [C],
    {
        Subject =.. [B, X],
        Object =.. [C, X],
        Clause =.. [:-, false, (Subject, Object)]
    }.
% some B is not C
syllogism([First, Second]) -->
    [some],
    [B],
    [is],
    [not],
    optional_article,
    [C],
    {
        NotC =.. [not, C],
        Inner =.. [some, B, NotC],
        FirstLeft =.. [B, Inner],
        First =.. [:-, FirstLeft, true],
        SecondRight =.. [C, Inner],
        Second =.. [:-, false, SecondRight]
    }.
% some B is C
syllogism([First, Second]) -->
    [some],
    [B],
    [is],
    optional_article,
    [C],
    {
        Inner =.. [some, B, C],
        FirstLeft =.. [B, Inner],
        SecondLeft =.. [C, Inner],
        First =.. [:-, FirstLeft, true],
        Second =.. [:-, SecondLeft, true]
    }.

%% ---------------------------- Step 3 ---------------------------------------%%

%% translate(+N)

translate(N) :-
    % First do asserts for p
    findall(S, p(N, S), Ss),
    % Ss is guarantee to have only 2 items in list
    Ss = [FirstS|T],
    T = [SecondS|_],
    % Get the list of available Clauses, for premise S
    syllogism(ClauseList1, FirstS, []),
    assertall(N, ClauseList1),
    syllogism(ClauseList2, SecondS, []),
    assertall(N, ClauseList2),

    % Now do asserts for c
    c(N, S),
    opposite(S, OppositeS),
    syllogism(ClauseList3, OppositeS, []),
    assertall(N, ClauseList3).


%% ---------------------------- Step 4 ---------------------------------------%%

%% eval(+N, +Calls)
eval(_, true).
% Case where we have a tuple
eval(N, (Call1, Call2)) :-
    !,
    cl(N, Call1, Body1),
    eval(N, Body1),
    eval(N, Call2).
% Case where we only have 1 call, including "false" call
eval(N, Call) :-
    cl(N, Call, Body),
    eval(N, Body).
    

%% valid(?N)

valid(N) :-
    eval(N, false).


%% invalid(?N)

invalid(N) :-
    \+ valid(N).

%% ---------------------------- Step 5 ---------------------------------------%%

%% test(+N)

show_syllogism(N) :-
    format('syllogism ~d:', [N]), nl,
    findall(S, p(N, S), Ss),
    Ss = [S1, S2],
    write('   '),
    writeL(S1), nl,
    write('   '),
    writeL(S2), nl,
    write('   =>'), nl,
    c(N, SC), 
    write('   '),
    writeL(SC), nl.
test(N) :-
    valid(N),
    !,
    show_syllogism(N), nl,
    write('Premises and opposite of conclusion converted to clauses:'), nl,
    show_clauses(N), nl,
    format('false can be derived, syllogism ~d is valid.', [N]).
test(N) :-
    show_syllogism(N), nl,
    write('Premises and opposite of conclusion converted to clauses:'), nl,
    show_clauses(N),
    format('false cannot be derived, syllogism ~d is invalid.', [N]).
