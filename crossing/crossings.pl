%% File: crossings.pl
%% Name: Frank Hua
%% Date: 03/11/2022
%%
%% This program is a solution to Prolog Assessed Exercise 2 'Crossings'
%% The exercise is a version of the classic Farmer-Wolf-Goat-Cabbage Puzzle

%% Step 1 safe(+Bank)
% Goat not in bank, always safe
safe(Bank) :-
    \+ memberchk(g, Bank),
    !.
% Farmer in bank, always safe
safe(Bank) :-
    memberchk(f, Bank),
    !.
% Otherwise, safe if wolf and cabbage are not in bank
safe(Bank) :-
    \+ memberchk(w, Bank),
    \+ memberchk(c, Bank).


%% Step 2 goal(+State)
% North is empty and South contains exactly 5 element 
% and exactly [f,w,g,c,b] in any order
goal([] - South) :-
    length(South, 5),
    memberchk(f, South),
    memberchk(w, South),
    memberchk(g, South),
    memberchk(c, South),
    memberchk(b, South).


% remove(+E, +List, -Result) remove first element of E from List.
% Fail if can't find E in List
remove(E, [E|T], Result):-
    Result = T,
    !.
remove(E, [H|T], [H|Result]):-
    remove(E, T, Result).

% remove_multi(+Items, +List, -Result) remove all element in Items from List.
% Fail if exists a item in Items that can't be found in List
remove_multi([], List, List).
remove_multi([H|T], List, Result):-
    remove(H, List, TempList),
    remove_multi(T, TempList, Result).

% equiv_bank(+Bank1, +Bank2) check if the 2 banks have same number of each item,
% regardless of order
equiv_bank([], []).
equiv_bank(Bank1, Bank2):-
    % check length equal
    length(Bank1, Len1), length(Bank2, Len2),
    Len1 == Len2,
    % get first element from Bank1 and check if it's in Bank2
    [Head|Tail] = Bank1,
    memberchk(Head, Bank2),
    % remove element from Bank2 and recurse
    remove(Head, Bank2, Temp_Bank),
    equiv_bank(Tail, Temp_Bank).
    
    
%% Step 3 equiv(+State1, +State2)
equiv(S1North - S1South, S2North - S2South):-
    equiv_bank(S1North, S2North),
    equiv_bank(S1South, S2South),
    !.


%% Step 4 visited(+State, +Sequence)
visited(State, [Head|_]):- 
    equiv(State, Head),
    !.

visited(State, [_|Sequence]):- 
    visited(State, Sequence).

%% Step 5 choose(-Items, +Bank)
% Empty Bank can choose nothing, fail
% If Bank doesn't have farmer, we can choose nothing, fail
% Question: do we have to do memberchk twice? 
choose([f], Bank):-
    % Check if it's safe for the remaining bank
    remove(f, Bank, BankWithoutFarmer),
    safe(BankWithoutFarmer).
choose([f,Elem], Bank):-
    remove(f, Bank, BankWithoutFarmer),
    member(Elem, BankWithoutFarmer),
    % Check if it's safe for the remaining bank
    remove(Elem, BankWithoutFarmer, BankAfterChoose),
    safe(BankAfterChoose).


%% Step 6 journey(+State1, -State2)
% Given State1, get a possible State2 within 1 step of action.
journey(State1North - State1South, State2North - State2South):-
    choose(Items, State1North),
    remove_multi(Items, State1North, State2North),
    append(Items, State1South, State2South).
journey(State1North - State1South, State2North - State2South):-
    choose(Items, State1South),
    remove_multi(Items, State1South, State2South),
    append(Items, State1North, State2North).

% extend(+Acc, -Sequence), Acc denotes the accumulated sequence
% Note: the latest added element in acc appears first in Acc
extend([], []):-
    !.
% If last state in acc is goal state, return acc as sequence
extend([H|T], [H|T]):-
    goal(H),
    !.
% Else, get one more step which is non-visited, and add it to the sequence
extend(Acc, Sequence):-
    [H|_] = Acc,
    journey(H, NextState),
    \+ visited(NextState, Acc),
    extend([NextState|Acc], Sequence).

% reverse_sequence(+Sequence, -Result, +Acc), just reverse the list
reverse_sequence([], Acc, Acc).
reverse_sequence([H|T], Result, Acc):-
    reverse_sequence(T, Result, [H|Acc]).
%% Step 7 succeeds(-Sequence)
succeeds(Sequence):-
    extend([ [f,w,g,c,b]-[] ], ReversedSequence),
    reverse_sequence(ReversedSequence, Sequence, []).


% fees(-F1, -F2), F1 is farmer travels alone, F2 is otherwise
fees(1, 2). 
%% Step 8 fee(+State1, +State2, -Fee)
fee(State1North - _, State2North - _, Fee):- 
    choose([f], State1North), % [f] is a valid option
    remove(f, State1North, State2North),
    fees(Fee, _),
    !.

fee(_ - State1South, _ - State2South, Fee):- 
    choose([f], State1South), % [f] is a valid option
    remove(f, State1South, State2South),
    fees(Fee, _),
    !.

fee(State1North - _, State2North - _, Fee):- 
    choose([f, Elem], State1North), % [f, _] is a valid option
    remove_multi([f, Elem], State1North, State2North),
    fees(_, Fee),
    !.

fee(_ - State1South, _ - State2South, Fee):- 
    choose([f, Elem], State1South), % [f, _] is a valid option
    remove_multi([f, Elem], State1South, State2South),
    fees(_, Fee),
    !.


% calculate_cost_from_sequence(+Sequence, +Acc, -Cost)
% Acc is the accumulated cost
calculate_cost_from_sequence([], Acc, Acc).
calculate_cost_from_sequence([_], Acc, Acc). % exit if we only have 1 element
calculate_cost_from_sequence([State1|T], Acc, Cost):-
    [State2|_] = T,
    fee(State1, State2, Fee),
    NewAcc is Acc + Fee,
    calculate_cost_from_sequence(T, NewAcc, Cost).

%% Step 9 cost(-Sequence, -Cost)
cost(Sequence, Cost):-
    succeeds(Sequence),
    calculate_cost_from_sequence(Sequence, 0, Cost).
