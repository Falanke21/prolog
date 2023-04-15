/*

    File: family.pl - cjh

*/


% child_of(?Child, ?Parent)
%   Child is a child of Parent.
child_of(emmeline, frank). 
child_of(amelia, frank).
child_of(harold, frank).
child_of(chris, amelia).
child_of(chris, john).
child_of(emlyn, chris).
child_of(emlyn, elizabeth).
child_of(brendon, chris).
child_of(brendon, elizabeth). 
child_of(irene, maurice).
child_of(les, maurice).
child_of(elizabeth, irene).
child_of(elizabeth, george).
child_of(margaret, irene).
child_of(margaret, george).
child_of(rebecca, margaret).
child_of(louise, margaret).   
child_of(nick, margaret).
child_of(rebecca, peter).
child_of(louise, peter).
child_of(nick, peter).

male(frank).   
male(harold).
male(chris).
male(john).
male(emlyn).
male(brendon).
male(maurice).
male(les).
male(nick).
male(peter).
male(george).

female(emmeline).
female(amelia).
female(elizabeth).
female(irene).
female(margaret).
female(rebecca).
female(louise).

% end of data
daughter_of(X, Y) :-
    child_of(X, Y),
    female(X).

uncle_of(X, Y) :-
    child_of(X, Z),
    child_of(Y, W),
    child_of(W, Z),
    male(X).
