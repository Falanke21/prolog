:- use_module(library(plunit)).

get_num_nodes(empty, 0).
get_num_nodes(heap(_, _, LH, RH), Result):-
  get_num_nodes(LH, LNum),
  get_num_nodes(RH, RNum),
  Result = LNum + RNum + 1.

balanced_heap(empty).
balanced_heap(heap(_, _, LH, RH)):-
  get_num_nodes(LH, LNum),
  get_num_nodes(RH, RNum),
  LNum =:= RNum,
  balanced_heap(LH),
  balanced_heap(RH),
  !.
balanced_heap(heap(_, _, LH, RH)):-
  get_num_nodes(LH, LNum),
  get_num_nodes(RH, RNum),
  LNum =:= RNum + 1,
  balanced_heap(LH),
  balanced_heap(RH),
  !.

same_heap(empty, empty).
same_heap(heap(K1, I1, LH1, RH1), heap(K2, I2, LH2, RH2)):-
    K1 =:= K2,
    I1 = I2,
    same_heap(LH1, LH2),
    same_heap(RH1, RH2).

:- begin_tests(heap).
:- include(support).
:- include(heap).

root_only_heap(heap(3, a, empty, empty)).
depth_1_heap_imbalanced(heap(3, a, empty, 
                heap(2, a, empty, empty)
                )).
depth_2_heap(heap(3, a, 
                heap(2, a, empty, empty),
                heap(1, a, empty, empty)
            )).
depth_3_heap(heap(5, a, 
                heap(4, a, 
                    heap(2, a, empty, empty),
                    heap(1, a, empty, empty)
                ), 
                heap(3, a, 
                    heap(2, a, empty, empty), 
                    empty)
            )).
depth_2_heap_wrong_ordering(heap(3, a, 
                                heap(2, a, empty, empty), 
                                heap(6, a, empty, empty)
                            )).
depth_3_heap_wrong_ordering(heap(3, a, 
                                heap(2, a, empty, 
                                    heap(1, a, empty, empty)), 
                                heap(1, a, empty, 
                                    heap(7, a, empty, empty))
                            )).
depth_3_heap_weird_balance(heap(5, a, 
                                heap(3, a, 
                                    heap(2, a, empty, empty),
                                    empty),
                                heap(4, a, 
                                    heap(1, a, empty, empty),
                                    empty)
                                )).
test(is_heap_empty):-
    is_heap(empty).

test(is_heap_root):-
    root_only_heap(H),
    is_heap(H).

test(is_heap_1_right_child):-
    depth_1_heap_imbalanced(H),
    is_heap(H).

test(is_heap_depth_2):-
    depth_2_heap(H),
    is_heap(H).

test(is_heap_depth_3):-
    depth_3_heap(H),
    is_heap(H).

test(is_heap_wrong_ordering, [fail]):-
    depth_2_heap_wrong_ordering(H),
    is_heap(H).

test(is_heap_depth_3_wrong_ordering, [fail]):-
    depth_3_heap_wrong_ordering(H),
    is_heap(H).

test(balanced_heap_yes):-
    depth_3_heap(H),
    balanced_heap(H).

test(balanced_heap_no, [fail]):-
    depth_1_heap_imbalanced(H),
    balanced_heap(H).

test(balanced_heap_weird):-
    depth_3_heap_weird_balance(H),
    balanced_heap(H).

test(add_to_heap_small_NewK_bigger):-
    root_only_heap(H), 
    add_to_heap(5, a, H, NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(5, a, 
                        heap(3, a, empty, empty), 
                        empty)).

test(add_to_heap_small_K_bigger):-
    root_only_heap(H), 
    add_to_heap(1, a, H, NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(3, a, 
                        heap(1, a, empty, empty), 
                        empty)).

test(add_to_heap_depth_3_heap_add_to_root):-
    depth_3_heap(H),
    add_to_heap(10, a, H, NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(10, a, 
                        heap(5, a, 
                            heap(3, a, empty, empty),
                            heap(2, a, empty, empty)
                        ), 
                        heap(4, a, 
                            heap(2, a, empty, empty), 
                            heap(1, a, empty, empty))
                    )).

test(add_to_heap_depth_3_heap_add_to_middle):-
    depth_3_heap(H),
    add_to_heap(10, a, H, NewH),
    add_to_heap(6, a, NewH, NewNewH),
    balanced_heap(NewNewH),
    same_heap(NewNewH, heap(10, a, 
                        heap(6, a, 
                            heap(4, a, 
                                heap(1, a, empty, empty), 
                                empty),
                            heap(2, a, empty, empty)
                        ), 
                        heap(5, a, 
                            heap(3, a, empty, empty), 
                            heap(2, a, empty, empty))
                    )).

test(add_to_heap_weird_heap):-
    depth_3_heap_weird_balance(H), 
    depth_3_heap(H2),
    add_to_heap(2, a, H, NewH),
    same_heap(NewH, H2).

test(remove_max_depth2_heap):-
    depth_2_heap(H),
    remove_max(H, K, I, NewH),
    K =:= 3,
    I == a,
    same_heap(NewH, heap(2, a, heap(1, a, empty, empty), empty)).

test(remove_max_depth3_heap):-
    depth_3_heap(H),
    remove_max(H, K, I, NewH),
    K =:= 5,
    I == a,
    is_heap(NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(4, a, 
                        heap(3, a, 
                            heap(2, a, empty, empty),
                            empty),
                        heap(2, a, 
                            heap(1, a, empty, empty),
                            empty)
                        )).
    
test(remove_max_weird_heap):-
    depth_3_heap_weird_balance(H),
    remove_max(H, K, I, NewH),
    K =:= 5,
    I == a,
    is_heap(NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(4, a, 
                        heap(2, a, 
                            heap(1, a, empty, empty),
                            empty),
                        heap(3, a, empty, empty)
                    )).

test(heap_sort_asc1):-
    heap_sort_asc([], []),
    X = [(3,a),(5,b),(2,c),(6,d),(8,e),(10,f),(9,g),(14,h),(0,i),(-5,j)],
    heap_sort_asc(X, [(-5,j),(0,i),(2,c),(3,a),(5,b),(6,d),(8,e),(9,g),(10,f),(14,h)]).

test(delete_from_heap_root):-
    root_only_heap(H),
    delete_from_heap(a, H, NewH),
    same_heap(NewH, empty).

test(delete_from_heap_2_nodes_delete_root):-
    H = heap(5, a, 
            heap(2, b, empty, empty),
            empty),
    delete_from_heap(a, H, NewH),
    same_heap(NewH, heap(2, b, empty, empty)).

test(delete_from_heap_2_nodes_delete_leaf):-
    H = heap(5, a, 
            heap(2, b, empty, empty),
            empty),
    delete_from_heap(b, H, NewH),
    same_heap(NewH, heap(5, a, empty, empty)).

depth_3_heap_for_delete(heap(5, a, 
                            heap(4, b, 
                                heap(2, c, empty, empty),
                                heap(1, d, empty, empty)
                            ), 
                            heap(3, e, 
                                heap(2, h, empty, empty), 
                                empty)
                        )).
test(delete_from_heap_depth3_delete_root):-
    depth_3_heap_for_delete(H),
    delete_from_heap(a, H, NewH),
    is_heap(NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(4, b, 
                        heap(3, e, 
                            heap(2, h, empty, empty),
                            empty),
                        heap(2, c, 
                            heap(1, d, empty, empty),
                            empty)
                    )).

test(delete_from_heap_depth3_delete_left):-
    depth_3_heap_for_delete(H),
    delete_from_heap(b, H, NewH),
    is_heap(NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(5, a, 
                        heap(3, e, 
                            heap(2, h, empty, empty),
                            empty),
                        heap(2, c, 
                            heap(1, d, empty, empty),
                            empty)
                        )).

test(delete_from_heap_depth3_delete_right_leaf):-
    depth_3_heap_for_delete(H),
    delete_from_heap(h, H, NewH),
    is_heap(NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(5, a, 
                        heap(3, e, 
                            heap(2, c, empty, empty),
                            empty),
                        heap(4, b, 
                            heap(1, d, empty, empty),
                            empty)
                        )).

test(delete_from_heap_depth3_delete_right_middle):-
    depth_3_heap_for_delete(H),
    delete_from_heap(e, H, NewH),
    is_heap(NewH),
    balanced_heap(NewH),
    same_heap(NewH, heap(5, a, 
                        heap(2, h,
                            heap(2, c, empty, empty),
                            empty),
                        heap(4, b,
                            heap(1, d, empty, empty),
                            empty)
                        )).

:- end_tests(heap).
