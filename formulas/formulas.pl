% 97083/70043 Prolog
% Assessed Exercise 1
% formulas.pl

% :- consult(support).

% Write your answers to the exercise here

% Task 1: wff(+F)
% Succeeds when F is a (well-formed) formula.
wff(F) :-
	ground(F),
	proposition(F).

wff(neg(F)) :-
	ground(F),
	wff(F).

wff(and(F, G)) :-
	ground(F),
	ground(G),
	wff(F),
	wff(G).

wff(or(F, G)) :-
	ground(F),
	ground(G),
	wff(F), 
	wff(G).

wff(imp(F, G)) :-
	ground(F),
	ground(G),
	wff(F),
	wff(G).


% Task 2: cls(+F)
% Succeeds when the formula F is a clause; a clause is either a literal or
% a disjunction of literals, and a literal is either a proposition or a negated 
% proposition.
literal(F) :-
	ground(F),
	proposition(F).

literal(neg(F)) :-
	ground(F),
	proposition(F).

cls(F) :-
	ground(F),
	literal(F).

cls(or(F, G)) :-
	ground(F),
	ground(G),
	cls(F),
	cls(G).


% Task 3: props(+F, -Ps)
% Ps is a duplicate-free list (in any order) of the propositions in formula F.
props(F, Ps) :-
	wff(F),
	props(F, [], Tmp),
	sort(Tmp, Ps).

% Props(+F, +Acc, -Ps)
props(neg(F), Acc, Ps) :-
	props(F, Acc, Ps).

props(and(F, G), Acc, Ps) :-
	props(F, Acc, Tmp),
	props(G, Tmp, Ps).

props(or(F, G), Acc, Ps) :-
	props(F, Acc, Tmp),
	props(G, Tmp, Ps).

props(imp(F, G), Acc, Ps) :-
	props(F, Acc, Tmp),
	props(G, Tmp, Ps).

props(F, Acc, [F|Acc]).

% Task 4: t_value(+F, +Val, -V)
% V is the truth value (either t or f) of formula F, given valuation Val.

% tt stands for truth table
neg_tt(t, f).
neg_tt(f, t).

and_tt(t, t, t).
and_tt(t, f, f).
and_tt(f, t, f).
and_tt(f, f, f).

or_tt(t, t, t).
or_tt(t, f, t).
or_tt(f, t, t).
or_tt(f, f, f).

imp_tt(t, t, t).
imp_tt(t, f, f).
imp_tt(f, t, t).
imp_tt(f, f, t).

t_value(neg(F), Val, V) :-
	wff(F),
	t_value(F, Val, Tmp),
	neg_tt(Tmp, V).

t_value(and(F, G), Val, V) :-
	wff(F),
	wff(G),
	t_value(F, Val, Tmp_f),
	t_value(G, Val, Tmp_g),
	and_tt(Tmp_f, Tmp_g, V).

t_value(or(F, G), Val, V) :-
	wff(F),
	wff(G),
	t_value(F, Val, Tmp_f),
	t_value(G, Val, Tmp_g),
	or_tt(Tmp_f, Tmp_g, V).

t_value(imp(F, G), Val, V) :-
	wff(F),
	wff(G),
	t_value(F, Val, Tmp_f),
	t_value(G, Val, Tmp_g),
	imp_tt(Tmp_f, Tmp_g, V).

t_value(F, Val, t) :-
	wff(F), 
	member(F, Val).

t_value(F, Val, f) :-
	wff(F),
	\+ member(F, Val).
	