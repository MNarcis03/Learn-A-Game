% *********************************
% utility predicates
% *********************************

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

% invert: between black and white
invert(F1,F2):-
	F1 = black,
	F2 = white.

invert(F1,F2):-
	F1 = white,
	F2 = black.

% *******************************************
% predecates for generating new moves
% *******************************************

% one_step: from Field to Next through one step
one_step(Field,Direction,Next,Color,Position):-
	Next is Field + Direction,
	not(invalid_field(Next)),
	not(occupied(Next,Color,Position)).

% multiple_steps: from Field to Next through one or multiple steps
multiple_steps(Field,Direction,Next,Color,Position):-
	one_step(Field,Direction,Next,Color,Position).

multiple_steps(Field,Direction,Next,Color,Position):-
	one_step(Field,Direction,FieldNew,Color,Position),
	invert(Color,Oppo),
	get_half(Position,HalfOppo,Oppo),
	not(exist(FieldNew,HalfOppo,_)),
	multiple_steps(FieldNew,Direction,Next,Color,Position).

% get_half: get half position for one side
get_half(position(Half,_,_),Half,white).
get_half(position(_,Half,_),Half,black).

% occupied: true if there is a piece in the Field
occupied(Field,white,position(Stones,_,_)):- exist(Field,Stones,_).
occupied(Field,black,position(_,Stones,_)):- exist(Field,Stones,_).

% unoccupied: true if the position is valid and not occupied by any piece
unoccupied(Field,Position):-
	not(occupied(Field,white,Position)),
	not(occupied(Field,black,Position)),
	not(invalid_field(Field)).

% poss_move: (piece, move value)
poss_move(rook,10).
poss_move(rook,-10).
poss_move(rook,1).
poss_move(rook,-1).
poss_move(bishop,9).
poss_move(bishop,11).
poss_move(bishop,-9).
poss_move(bishop,-11).
poss_move(knight,19).
poss_move(knight,21).
poss_move(knight,8).
poss_move(knight,12).
poss_move(knight,-8).
poss_move(knight,-12).
poss_move(knight,-19).
poss_move(knight,-21).

poss_move(queen,X):-
	poss_move(rook,X).

poss_move(queen,X):-
	poss_move(bishop,X).

poss_move(king,X):-
	poss_move(queen,X).

% pawn_move: rules of pawns possible move
pawn_move(From,white,Position,To):-
	To  is  From + 9,
	occupied(To,black,Position).

pawn_move(From,white,Position,To):-
	To  is  From + 10,
	unoccupied(To,Position).

pawn_move(From,white,Position,To):-
	To  is  From + 11,
	occupied(To,black,Position).

pawn_move(From,white,Position,To):-
	To  is  From + 20,
	Over  is  From + 10,
	unoccupied(To,Position),
	unoccupied(Over,Position),
	Row  is  From // 10,
	Row = 2.

pawn_move(From,black,Position,To):-
	To  is  From - 9,
	occupied(To,white,Position).

pawn_move(From,black,Position,To):-
	To  is  From - 10,
	unoccupied(To,Position).

pawn_move(From,black,Position,To):-
	To  is  From - 11,
	occupied(To,white,Position).

pawn_move(From,black,Position,To):-
	To  is  From - 20,
	Over  is  From - 10,
	unoccupied(To,Position),
	unoccupied(Over,Position),
	Row  is  From // 10,
	Row = 7.

% short castling
castling_move(Color,Position,King,To):-
	(
		Color=white,
		King=15
		;
		Color=black,
		King=85
	),
	RookNew is King+1,
	To is King+2,
	Rook is King+3,
	get_half(Position,half_position(_,Rookies,_,_,_,_,_),Color),
	member(Rook,Rookies),
	unoccupied(RookNew,Position),
	unoccupied(To,Position).

% long castling
castling_move(Color,Position,King,To):-
	(
		Color=white,
		King=15
		;
		Color=black,
		King=85
	),
	RookNew is King-1,
	To is King-2,
	Blank is King-3,
	Rook is King-5,
	get_half(Position,half_position(_,Rookies,_,_,_,_,_),Color),
	member(Rook,Rookies),
	unoccupied(RookNew,Position),
	unoccupied(To,Position),
	unoccupied(Blank,Position).

% long_move: move for long distance
long_move(From,Color,Typ,Position,To):-
	poss_move(Typ,Direction),
	multiple_steps(From,Direction,To,Color,Position).

% short_move: move for one step
short_move(From,Color,Typ,Position,To):-
	poss_move(Typ,Direction),
	one_step(From,Direction,To,Color,Position).

% all_moves: generate all possible moves
all_moves(Color,Position,move(From,To)):-
	get_half(Position,half_position(Pawn,_,_,_,_,_,_),Color),
	member(From,Pawn),		% From is Pawn
	nl,
	write('Pawn from '),
	write(From),
	write(' can be moved to '),
	pawn_move(From,Color,Position,To),
	write(To),
	write(', ').

all_moves(Color,Position,move(From,To)):-
	get_half(Position,half_position(_,Rookies,_,_,_,_,_),Color),
	member(From,Rookies), 	% From is Rook
	nl,
	write('Rook from '),
	write(From),
	write(' can be moved to '),
	long_move(From,Color,rook,Position,To),
	write(To),
	write(', ').

all_moves(Color,Position,move(From,To)):-
	get_half(Position,half_position(_,_,Knights,_,_,_,_),Color),
	member(From,Knights),	% From is Knight
	nl,
	write('Knight from '),
	write(From),
	write(' can be moved to '),
	short_move(From,Color,knight,Position,To),
	write(To),
	write(', ').

all_moves(Color,Position,move(From,To)):-
	get_half(Position,half_position(_,_,_,Bishies,_,_,_),Color),
	member(From,Bishies),	% From is Bish
	nl,
	write('Bishop from '),
	write(From),
	write(' can be moved to '),
	long_move(From,Color,bishop,Position,To),
	write(To),
	write(', ').

all_moves(Color,Position,move(From,To)):-
	get_half(Position,half_position(_,_,_,_,Queenies,_,_),Color),
	member(From,Queenies),	% From is Queen
	nl,
	write('Queen from '),
	write(From),
	write(' can be moved to '),
	long_move(From,Color,queen,Position,To),
	write(To),
	write(', ').

all_moves(Color,Position,move(King,To)):-
	get_half(Position,half_position(_,_,_,_,_,[King],_),Color),
	nl,
	write('King from '),
	write(From),
	write(' can be moved to '),
	short_move(King,Color,king,Position,To),
	write(To),
	write(', ').

all_moves(Color,Position,move(King,To)):-
	get_half(Position,half_position(_,_,_,_,_,[King],_),Color),
	nl,
	write('King from '),
	write(From),
	write(' can be moved to '),
	castling_move(Color,Position,King,To),
	write(To),
	write(', ').

pos_no(Row,Col,N):-
	nonvar(N),!,
	Row is N // 10,
	Col is N mod 10.
pos_no(R,C,N):-
	N  is  R*10 + C.

draw_board(Position):-
	Position = position(H1,H2,_),
	generate_board(Board),
	place_pieces(white,H1,Board,Board1),
	place_pieces(black,H2,Board1,BoardNew),
	write_board(BoardNew).

write_board([R1,R2,R3,R4,R5,R6,R7,R8]):-
	write("8"),write(R8),nl,
	write("7"),write(R7),nl,
	write("6"),write(R6),nl,
	write("5"),write(R5),nl,
	write("4"),write(R4),nl,
	write("3"),write(R3),nl,
	write("2"),write(R2),nl,
	write("1"),write(R1),nl,
	write("   1  2  3  4  5  6  7  8"),nl,nl.

% generate_board: generate blank board
generate_board([['  ','  ','  ','  ','  ','  ','  ','  '],
				['  ','  ','  ','  ','  ','  ','  ','  '],
				['  ','  ','  ','  ','  ','  ','  ','  '],
				['  ','  ','  ','  ','  ','  ','  ','  '],
				['  ','  ','  ','  ','  ','  ','  ','  '],
				['  ','  ','  ','  ','  ','  ','  ','  '],
				['  ','  ','  ','  ','  ','  ','  ','  '],
				['  ','  ','  ','  ','  ','  ','  ','  ']]).

% place_pieces: place pieces of half side on board
place_pieces(white,Half,Board,BoardNew):-
	Half = half_position(Pawn,Rook,Knight,Bishop,Queen,King,_),
	place_piece('wP',Pawn,Board,Board1),
	place_piece('wR',Rook,Board1,Board2),
	place_piece('wN',Knight,Board2,Board3),
	place_piece('wB',Bishop,Board3,Board4),
	place_piece('wQ',Queen,Board4,Board5),
	place_piece('wK',King,Board5,BoardNew),
	!.

place_pieces(black,Half,Board,BoardNew):-
	Half = half_position(Pawn,Rook,Knight,Bishop,Queen,King,_),
	place_piece('bP',Pawn,Board,Board1),
	place_piece('bR',Rook,Board1,Board2),
	place_piece('bN',Knight,Board2,Board3),
	place_piece('bB',Bishop,Board3,Board4),
	place_piece('bQ',Queen,Board4,Board5),
	place_piece('bK',King,Board5,BoardNew),
	!.

% place_piece: place all pieces of certain type
place_piece(_,[],Board,Board).

place_piece(Str,[Field|Fs],Board,BoardNew):-
	pos_no(Row,Col,Field),
	nth1(Row, Board, List),
	replace(List,Col,Str,ListNew),
	replace(Board,Row,ListNew,Board1),
	place_piece(Str,Fs,Board1,BoardNew).

% replace(ListOld, Index, ReplacedBy, ListNew)
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > 1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

run:-
	PawnWhite = [21,22,23,24,25,26,27,28],
	PawnBlack = [71,72,73,74,75,76,77,78],
	H1 = half_position(PawnWhite,[11,18],[12,17],[13,16],[14],[15],notmoved),
	H2 = half_position(PawnBlack,[81,88],[82,87],[83,86],[84],[85],notmoved),
	Position = position(H1,H2,0),
	draw_board(Position),
	write('Enter player color:(white/black)'),
	read(X),
	write('Possible Moves for WHITE player'),nl,
	all_moves(X,Position,Move),
	fail.
