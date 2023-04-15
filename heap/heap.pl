% Prolog Assessed Exercise 3
% heap.pl


% Write your answers to the exercise here


% Task 1. is_heap(+H). Succeeds if H is a binary heap.
is_heap(empty).
is_heap(heap(K, _, empty, empty)):-
  integer(K),
  !.
is_heap(heap(K, _, LH, empty)):-
  integer(K),
  is_heap(LH),
  LH = heap(LK, _, _, _),
  K >= LK,
  !.
is_heap(heap(K, _, empty, RH)):-
  integer(K),
  is_heap(RH),
  RH = heap(RK, _, _, _),
  K >= RK,
  !.
is_heap(heap(K, _, LH, RH)):-
  integer(K),
  is_heap(LH),
  is_heap(RH),
  LH = heap(LK, _, _, _),
  RH = heap(RK, _, _, _),
  K >= LK,
  K >= RK,
  !.

% Task 2. add_to_heap(+K, +I, +H, -NewH)
add_to_heap(K, I, empty, heap(K, I, empty, empty)).
add_to_heap(NewK, NewI, heap(K, I, LH, RH), NewH):-
  NewK =< K,
  % First add to right heap
  add_to_heap(NewK, NewI, RH, RH_added),
  % Then swap left and right
  NewH = heap(K, I, RH_added, LH),
  !.
add_to_heap(NewK, NewI, heap(K, I, LH, RH), NewH):-
  NewK > K,
  % First add to right heap
  add_to_heap(K, I, RH, RH_added),
  % Then swap left and right
  NewH = heap(NewK, NewI, RH_added, LH),
  !.

% heapify(+H, -NewH) given a heap with only root violating ordering constraint
% push down the root until ordering is preserved
heapify(empty, empty).
heapify(heap(K, I, empty, empty), heap(K, I, empty, empty)):-
  !.
heapify(heap(K, I, LH, empty), heap(K, I, LH, empty)):-
  LH = heap(LHK, _, empty, empty),
  K >= LHK,
  !.
heapify(heap(K, I, LH, empty), NewH):-
  LH = heap(LHK, LHI, empty, empty),
  K < LHK,
  NewH = heap(LHK, LHI, heap(K, I, empty, empty), empty),
  !.
heapify(heap(K, I, LH, RH), heap(K, I, LH, RH)):-
  LH = heap(LHK, _, _, _),
  RH = heap(RHK, _, _, _),
  K >= LHK,
  K >= RHK,
  !.
heapify(heap(K, I, LH, RH), NewH):-
  LH = heap(LHK, LHI, LLH, LRH),
  RH = heap(RHK, _, _, _),
  LHK >= RHK,
  heapify(heap(K, I, LLH, LRH), TempH),
  NewH = heap(LHK, LHI, TempH, RH),
  !.
heapify(heap(K, I, LH, RH), NewH):-
  LH = heap(LHK, _, _, _),
  RH = heap(RHK, RHI, RLH, RRH),
  LHK < RHK,
  heapify(heap(K, I, RLH, RRH), TempH),
  NewH = heap(RHK, RHI, LH, TempH),
  !.

% remove_left_most(+H, -K, -I, -NewH) 
% remove the left most node in the heap. Swap to make sure balance is preserved
remove_left_most(heap(K, I, empty, empty), K, I, empty):-
  !.
% If LH is not empty and RH is empty, LH must consist of only 1 node
remove_left_most(heap(K, I, LH, empty), LeftMostK, LeftMostI, NewH):-
  LH = heap(LeftMostK, LeftMostI, empty, empty),
  NewH = heap(K, I, empty, empty),
  !.
remove_left_most(heap(K, I, LH, RH), LeftMostK, LeftMostI, NewH):-
  remove_left_most(LH, LeftMostK, LeftMostI, NewLH),
  % Swap
  NewH = heap(K, I, RH, NewLH),
  !.
% Task 3. remove_max(+H, -K, -I, -NewH)
remove_max(heap(K, I, empty, empty), K, I, empty):-
  !.
remove_max(H, K, I, NewH):-
  % Remove the left most node
  remove_left_most(H, LeftMostK, LeftMostI, RemovedLeftH),
  RemovedLeftH = heap(K, I, RemovedLeftLH, RemovedLeftRH),
  % Put the left most node on root, and heapify
  WrongRootH = heap(LeftMostK, LeftMostI, RemovedLeftLH, RemovedLeftRH),
  heapify(WrongRootH, NewH),
  !.

% heap_sort_construct_heap(+L, +Acc, -H), 
% at top level, Acc should be called with empty
heap_sort_construct_heap([], Acc, Acc).
heap_sort_construct_heap([Item|T], Acc, Result):-
  Item = (K, I),
  add_to_heap(K, I, Acc, NewAcc),
  heap_sort_construct_heap(T, NewAcc, Result).

% heap_sort_dismantle_heap(+H, +Acc, -S)
heap_sort_dismantle_heap(empty, Acc, Acc):-
  !.
heap_sort_dismantle_heap(H, Acc, Result):-
  remove_max(H, K, I, NewH),
  NewAcc = [(K, I)|Acc],
  heap_sort_dismantle_heap(NewH, NewAcc, Result).
% Task 4. heap_sort_asc(+L, -S)
heap_sort_asc(L, Result):-
  heap_sort_construct_heap(L, empty, H),
  heap_sort_dismantle_heap(H, [], Result).

% Task 5. delete_from_heap(+I, +H, -NewH)
% Case I is root
delete_from_heap(I, H, NewH) :-
  H = heap(_, I, _, _),
  remove_max(H, _, I, NewH),
  !.
% Case I in the left
delete_from_heap(I, heap(HK, HI, LH, RH), Result):-
  % Find I, delete and swap
  delete_from_heap(I, LH, NewLH),
  Result = heap(HK, HI, RH, NewLH),
  !.
% Case I in the right
delete_from_heap(I, heap(HK, HI, LH, RH), Result):-
  % Find I, delete, and do a remove_left_most on LH, finally add that node back
  delete_from_heap(I, RH, NewRH),
  remove_left_most(LH, LeftMostK, LeftMostI, NewLH),
  CombinedH = heap(HK, HI, NewLH, NewRH),
  add_to_heap(LeftMostK, LeftMostI, CombinedH, Result),
  !.
