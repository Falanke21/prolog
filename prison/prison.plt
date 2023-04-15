:- use_module(library(plunit)).

:- begin_tests(prison).
:- include(prisonDb).
:- include(prison).

test(make_list_single) :-
	make_list(1, 1, [1]).

test(make_list_multiple) :-
	make_list(3, a, [a,a,a]).

test(extract_indices_single) :-
	extract_indices([a,b,c], b, [2]).

test(extract_indices_multiple) :-
	extract_indices([a,b,c,a,b,c], a, [1,4]).

test(extract_indices_none) :-
	extract_indices([a,b,c], d, []).

test(extract_indices_empty) :-
	extract_indices([], a, []).

test(extract_indices_all) :-
	extract_indices([a,a,a], a, [1,2,3]).

test(extract_indices_example) :-
	extract_indices([m,a,n,d,e,l,a], a, [2,7]).

test(run_warders_N_greater_than_W, [fail]) :-
	run_warders(2, 1, [unlocked,unlocked], _).

test(run_warders_N_equal_W) :-
	run_warders(2,2,[unlocked,unlocked],[unlocked,locked]).

test(run_warders_W_equal_3) :-
	run_warders(2,3,[locked,locked,locked],[locked,unlocked,unlocked]).

test(run_warders_W_equal_4) :-
	run_warders(2,4,[unlocked,unlocked,unlocked,unlocked],[unlocked,locked,locked,unlocked]).

test(run_warders_N_equal_1) :-
	run_warders(1,2,[locked, locked],[unlocked, locked]).

test(run_warders_N_equal_1_W_equal_3) :-
	run_warders(1,3,[locked, locked, locked],[unlocked, locked, locked]).

test(cell_status_N_0):-
	cell_status(2, 0, locked).

test(cell_status_N_0_unlocked_should_fail, [fail]):-
	cell_status(59,0,unlocked).

test(cell_status_N_1):-
	cell_status(2, 1, unlocked).

test(cell_status_N_2):-
	cell_status(2, 2, locked).

test(cell_status_N_3):-
	cell_status(2, 5, locked).

test(cell_status_simple):-
	cell_status(1, 1, unlocked).

test(cell_status_simple_fail, [fail]):-
	cell_status(1, 1, locked).

test(cell_status_Status_variable1) :-
	cell_status(1, 1, Status),
	Status == unlocked.

test(cell_status_Status_variable2) :-
	cell_status(2, 2, Status),
	Status == locked.

test(cell_status_Cell4) :-
	cell_status(4, 4, unlocked).

test(cell_status_psychopath) :-
	cell_status(59, 1, locked).

test(cell_status_psychopath2) :-
	cell_status(59, 100, locked).

test(cell_status_psychopath_cell61) :-
	cell_status(61, 100, locked).

test(escaped_cell_1) :-
	escaped('Gardner', 'Ian').

test(escaped_cell_multiple) :-
	% All in cell 9
	escaped('McCann', 'Cristiano'),
	escaped('Wolf', 'Sebastian'),
	escaped('Uchitel', 'Tony').

test(escaped_psycho, [fail]) :-
	escaped('Kelly', 'Antonio').

test(escaped_neighbor_of_psycho, [fail]) :-
	escaped('McCann', 'Dalal').

:- end_tests(prison).
