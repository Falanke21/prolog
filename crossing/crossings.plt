:- use_module(library(plunit)).

:- begin_tests(crossings).
:- include(crossings).

test(safe1) :-
    safe([]).

test(safe2) :-
    safe([f, g, w]).

test(safe3, [fail]):-
    safe([g, c]).

test(safe4, [fail]):-
    safe([w, g, b]).

test(goal1):-
    goal([]-[c,w,g,b,f]).

test(goal2, [fail]):-
    goal([f]-[c,w,g,b,f]).

test(goal3, [fail]):-
    goal([]-[c,w,b,f]).

test(goal4):-
    goal([]-[c,f,g,b,w]).

test(goal5, [fail]):-
    goal([]-[]).

test(remove1):-
    remove(a, [a], []).

test(remove2, [fail]):-
    remove(a, [], _).

test(remove3, [fail]):-
    remove(a, [b, c], _).

test(remove4):-
    remove(a, [b, c, a], [b, c]).

test(remove_multi1):-
    remove_multi([a, b], [b, c, a], [c]).

test(remove_multi2):-
    remove_multi([a], [a, b, c], [b, c]).

test(equiv1):-
    equiv([b,c]-[f,w,g], [c,b]-[g,f,w]).

test(equiv2, [fail]):-
    equiv([b]-[f,w,c,g], [c,b]-[g,f,w]).

test(equiv3):-
    equiv([adam, bob]-[zedd, venus], [bob, adam]-[venus, zedd]).

test(equiv4, [fail]):-
    equiv([w,w,f]-[], [f,f,w]-[]).

test(visited1) :-
    visited([b,c]-[f,w,g], [[c,b]-[g,f,w], [c,b,f,w]-[g]]).

test(visited2, [fail]) :-
    visited([b]-[f,c,w,g], [[c,b]-[g,f,w], [c,b,f,w]-[g]]).

test(visited3, [fail]):-
    visited([]-[], []).

test(visited4, [fail]):-
    visited([g]-[f,c,w,b], []).

% choose should fail if no options available
test(choose1, [fail]):-
    choose(_, []).
% choose should fail if no farmer
test(choose2, [fail]):-
    choose(_, [w, b]).

test(choose3, all(Items == [[f], [f,w]])):-
    choose(Items, [f, w]).

test(choose4, all(Items == [[f,g], [f,w]])):-
    choose(Items, [f, g, w]).

test(choose5, all(Items == [[f,g]])):-
    choose(Items, [f, g, c, w]).

test(choose6, all(Items == [[f], [f,g], [f,b]])):-
    choose(Items, [g,f,b]).

test(journey_not_safe, [fail]):-
    journey([b,c]-[f,w,g], [f,b,c]-[w,g]).

test(journey_move_without_farmer, [fail]):-
    journey([b,c]-[f,w,g], [w,b,c]-[f,g]).

test(journey_move_f_and_g):-
    journey([b,c]-[f,w,g], [f,g,b,c]-[w]).

test(journey_north_to_south, [nondet]):-
    journey([f,g]-[w,c,b], [g]-[f,w,c,b]).

test(journey_move_f_and_w, [nondet]):-
    journey([b,c]-[f,w,g], [f,w,b,c]-[g]).

test(fee_farmer_with_goat):-
    fee([f,w,g,c,b]-[], [w,c,b]-[f,g], 2).

test(fee_only_farmer):-
    fee([w,c,b]-[f,g], [w,f,c,b]-[g], 1).

test(fee_order_does_not_matter_in_state):-
    fee([c,w,b]-[g,f], [c,f,b,w]-[g], 1).

test(calculate_cost_from_sequence1, [nondet]):-
    calculate_cost_from_sequence([[f,w,g,c,b]-[],[w,c,b]-[f,g],[f,w,c,b]-[g],
        [c,b]-[f,w,g],[f,g,c,b]-[w],[g,b]-[f,c,w],[f,g,b]-[c,w],[g]-[f,b,c,w],
        [f,g]-[b,c,w],[]-[f,g,b,c,w]], 0, 15).


:- end_tests(crossings).
