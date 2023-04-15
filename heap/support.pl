/*
 * Support file for Prolog Heap lab exercise.
 * Author: Tim Kimber (tk106)
 */

:- use_module(library(queues)).

% This predicate will print a representation of a heap to standard output.

portray_heap(H):-
  measure(H, Height, KeyWidth),
  list_queue([H, break], Q),
  nl,
  portray_heap(Q, Height, KeyWidth).
  
portray_heap(Q, _, _):-
  queue_length(Q, 1),
  !,
  nl.
portray_heap(Q, Height, KW):-
  queue_cons(break, Tail, Q),
  !,
  nl,
  queue_last(Tail, break, NewQ),
  Smaller is Height - 1,
  portray_heap(NewQ, Smaller, KW).
portray_heap(Q, Height, KW):-
  queue_cons(empty, Tail, Q),
  !,
  portray_node(' ', Height, KW),
  add_children_of_empty(Tail, Height, NewQ),
  portray_heap(NewQ, Height, KW).
portray_heap(Q, Height, KW):-
  queue_cons(heap(K, _, LH, RH), Tail, Q),
  portray_node(K, Height, KW),
  queue_append(Tail, [LH, RH], NewQ),
  portray_heap(NewQ, Height, KW).
  

portray_node(N, Height, KeyWidth):-
  Col is integer(2 ** (Height - 1)) * (KeyWidth + 1),
  format('~|~t~p~t~*+', [N, Col]).
 

add_children_of_empty(Q, Height, NewQ):-
  Height > 0,
  !,
  queue_append(Q, [empty, empty], NewQ).

add_children_of_empty(Q, _, Q).


measure(H, Hi, KW):-
  measure(H, 0, 0, Hi, 1, KW).
measure(empty, HThis, Longest, HThis, KW, KW):-
  HThis > Longest,
  !.
measure(empty, _, Hi, Hi, KW, KW).
measure(heap(K, _, LH, RH), M, Longest, Hi, Wacc, KW):-
  N is M + 1,
  number_codes(K, Codes),
  length(Codes, WK),
  max(Wacc, WK, WMax),
  measure(LH, N, Longest, HL, WMax, WL),
  measure(RH, N, HL, Hi, WL, KW).

max(X, Y, Z):-
  X > Y,
  !,
  Z = X.
max(_, Y, Y).
