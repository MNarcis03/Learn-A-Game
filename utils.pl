% *********************************
% utility predicates
% *********************************

%database
:- dynamic
	stack/2,
	top/1,
	human/1,
	depth/1,
	board/2.

% invalid_field(X): X is invalid position
invalid_field(X):-
	X =< 10,!.
invalid_field(X):-
	X >= 89,!.
invalid_field(X):-
	0 is X mod 10,!.
invalid_field(X):-
	9 is X mod 10,!.
	
% exist: check if there is a piece of certain half in the field
exist(Field,half_position(X,_,_,_,_,_,_),pawn):-
	member(Field,X).
exist(Field,half_position(_,X,_,_,_,_,_),rook):-
	member(Field,X).
exist(Field,half_position(_,_,X,_,_,_,_),knight):-
	member(Field,X).
exist(Field,half_position(_,_,_,X,_,_,_),bishop):-
	member(Field,X).
exist(Field,half_position(_,_,_,_,X,_,_),queen):-
	member(Field,X).
exist(Field,half_position(_,_,_,_,_,X,_),king):-
	member(Field,X).



% **************************
% Stack Predicated
% **************************

init_stack :-	
	not(top(_)),
	asserta(top(0)).

push(Move,Value) :-
	retract(top(Old)),
	New is Old+1,
	asserta(top(New)),
	asserta(stack(Move,Value,New)),!.
	
pull(Move,Value) :-
	retract(top(Old)),!,	/* Cut appended... debug !!! */
	New is Old-1,
	asserta(top(New)),
	retract(stack(Move,Value,Old)),!.
	
get(Move,Value,Depth) :-
	top(Top),
	Act is Top-Depth,
	stack(Move,Value,Act),!.

get_0(Move,Value) :-
	top(Top),
	stack(Move,Value,Top),!.
	
replace(Move,Value) :-	
	top(Top),
	retract(stack(_,_,Top)),
	asserta(stack(Move,Value,Top)),!.