/*

    Prolog
    Exercise No.4  (prison)

*/


% May be helpful for testing

% generate_integer(+Min, +Max, -I)
%   I is an integer in the range Min <= I <= Max

generate_integer(Min,Max,Min):-
  Min =< Max.
generate_integer(Min,Max,I) :-
  Min < Max,
  NewMin is Min + 1,
  generate_integer(NewMin,Max,I).
  
  
% Uncomment this line to use the provided database for Problem 2.
% You MUST recomment or remove it from your submitted solution.
% :- include(prisonDb).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prison_game(+Cells, +Warders, -Escaped)
%   Escaped is a list of cell numbers for prisoners who will escape
%   once all warders have completed their runs.

prison_game(Cells, Warders, Escaped) :-
  integer(Cells), Cells > 0,
  integer(Warders), Warders > 0,
  make_list(Cells, unlocked, Initial),
  run_warders(2, Warders, Initial, Final),
  extract_indices(Final, unlocked, Escaped).
  

% Write your program here.

% Task 1.1 make_list(+N, +Item, -List).
%   Given a (non-negative) integer N and item Item constructs list List of N
%   elements each of which is Item

make_list(0, _, []) :-
  !.
make_list(N, Item, [Item|List]) :-
  NewN is N - 1,
  make_list(NewN, Item, List).


% Task 1.2 extract_indices(+List, +Item, -Indices).
%   Given list List and item Item computes the list Indices of integers N such
%   that Item is the Nth item of the list List

% extract_indices(+List, +Item, +Curr_Index, +Acc, -Indices)
% Curr_Index is the index accumulator, top-level it should be called as 1
% Acc should be called as [] on top-level
% We iterate through all element in the list
extract_indices_helper([], _, _, Acc, Acc).
extract_indices_helper([Item|T], Item, Curr_Index, Acc, Indices):-
  Next_Index is Curr_Index + 1,
  extract_indices_helper(T, Item, Next_Index, [Curr_Index|Acc], Indices),
  !.
extract_indices_helper([_|T], Item, Curr_Index, Acc, Indices):-
  Next_Index is Curr_Index + 1,
  extract_indices_helper(T, Item, Next_Index, Acc, Indices).

extract_indices(List, Item, SortedIndices):-
  % First element is index 1
  extract_indices_helper(List, Item, 1, [], Indices),
  sort(Indices, SortedIndices).

% reverse the list 
reverse(Xs, Ys) :-
  reverse(Xs, [], Ys, Ys).
  
reverse([], Ys, Ys, []).

reverse([X|Xs], Rs, Ys, [_|Bound]) :-
  reverse(Xs, [X|Rs], Ys, Bound).

% run_one_warder(+I, +Mod, +Initial, +Acc, -Final)
% Run just 1 warder with warder I executing his action
% I is always positive, Mod is always positive
run_one_warder(_, _, [], Acc, Final):-
  % we need to reverse Acc since it's constructed in a reverse order
  reverse(Acc, Final).
% When mod is 1, we change the status of current door
% And reset mod to be I
run_one_warder(I, Mod, [locked|T], Acc, Final):-
  Mod =:= 1,
  run_one_warder(I, I, T, [unlocked|Acc], Final),
  !.
run_one_warder(I, Mod, [unlocked|T], Acc, Final):-
  Mod =:= 1,
  run_one_warder(I, I, T, [locked|Acc], Final),
  !.
% When mod is > 1, we don't change door and recurse
run_one_warder(I, Mod, [H|T], Acc, Final):-
  NewMod is Mod - 1,
  run_one_warder(I, NewMod, T, [H|Acc], Final).

% Task 1.3 run_warders(+N, +W, +Initial, -Final). 
%   Given next warder N and total warders W (both positive integers), and 
%   current door states Initial (a list of the constants locked and unlocked) 
%   returns Final, the list of door states after all warders have completed 
%   their runs.
run_warders(W, W, Initial, Final):-
  run_one_warder(W, W, Initial, [], Final),
  !.
  
run_warders(N, W, Initial, Final):-
  N < W,
  run_one_warder(N, N, Initial, [], Temp),
  NewN is N + 1,
  run_warders(NewN, W, Temp, Final).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Write your program here.
% get_factor_helper(+Num, +Threshold, +NumAcc, +ListAcc, -Result)
% Loop from Num until 0
% Assumption: Num >= NumAcc >= 0
get_factor_helper(_, _, 0, ListAcc, ListAcc):-
  !.
get_factor_helper(Num, Threshold, NumAcc, ListAcc, Result):-
  NumAcc =< Threshold,
  Num mod NumAcc =:= 0,
  !,
  NewNumAcc is NumAcc - 1,
  get_factor_helper(Num, Threshold, NewNumAcc, [NumAcc|ListAcc], Result).
% NumAcc not a factor
get_factor_helper(Num, Threshold, NumAcc, ListAcc, Result):-
  NewNumAcc is NumAcc - 1,
  get_factor_helper(Num, Threshold, NewNumAcc, ListAcc, Result).

% get_factors_under_threshold(+Num, +Threshold, -Result)
% Return a list of all the factors (divisors) that's <= threshold
% Threshold can be larger than Num
% Assumptions: Num >= 0, Threshold > 0
% Example: get_factors_under_threshold(80, 20, [1, 2, 4, 5, 8, 10, 16, 20])
get_factors_under_threshold(Num, Threshold, Result) :-
  get_factor_helper(Num, Threshold, Num, [], Result).

% should_change_lock_status(+Factors, -Should)
% Should is yes or no
should_change_lock_status(Factors, yes):-
  length(Factors, Len),
  % Odd number means we should change
  Len mod 2 =:= 1.
should_change_lock_status(Factors, no):-
  length(Factors, Len),
  % Even number means no change on status
  Len mod 2 =:= 0.

% Task 2.1 cell_status(+Cell, +N, ?Status)
%   Succeeds if the status of cell Cell is Status after N warders have made 
%   their runs. If Status is a variable, then the correct value should be 
%   returned.
% Initially all locked
cell_status(_, 0, locked) :-
  !.
% If there's psychopath in this cell we always lock
cell_status(Cell, _, locked) :-
  prisoner(Surname, FirstName, Cell, _, _, _),
  psychopath(Surname, FirstName),
  !.
% Filter out psychopath, otherwise it will get matched to the next clause
cell_status(Cell, _, unlocked) :-
  prisoner(Surname, FirstName, Cell, _, _, _),
  psychopath(Surname, FirstName),
  !,
  fail.
% Now, if a warder's num is a factor of Cell num, we would need to change
% the status of that cell door. 
% Thus we get all factors of Cell num (that's smaller than N),
% and see how many status changes we have. 
% If we have even changes, we stay locked.
% If we have odd changes, we can unlock. 
cell_status(Cell, N, unlocked) :-
  get_factors_under_threshold(Cell, N, Factors),
  should_change_lock_status(Factors, yes),
  !.
cell_status(Cell, N, locked) :-
  get_factors_under_threshold(Cell, N, Factors),
  should_change_lock_status(Factors, no).

% Task 2.2 

% escaped(?Surname, ?FirstName)
%   holds when the prisoner with that name escapes (i.e., occupies a cell which 
%   is unlocked after the last warder has made his run, but bearing in mind that
%   prisoners with a year or less left to serve will not escape).

escaped(Surname, FirstName) :-
  prisoner(Surname, FirstName, Cell, _, _, ToServe),
  % 1 year serve would not run
  ToServe > 1,
  warders(NumWarders),
  cell_status(Cell, NumWarders, unlocked).


% escapers(-List)
%   List is the list of escaped prisoners. List is a list of terms of the form 
%   (Surname, FirstName), sorted in ascending alphabetical order according to 
%   Surname.

escapers(List) :-
  setof((Surname, FirstName), escaped(Surname, FirstName), List).
