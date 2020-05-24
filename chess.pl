
:- [utils].	
<<<<<<< HEAD
:- [piece_rule].	
=======
:- [piece_rule].

>>>>>>> 2d339436388d4019969597424504f7941ee349a4

%****************************************************************
%	Game Control Predicates
%****************************************************************

% enter: given Position and Color, return a move
enter(Position,Color,Move) :-
	repeat,
	read_move(Move,Color),
	(	
		check_legal(Move,Color,Position),
		nl,!
	;
		write('Illegal Move!'),
		nl,fail
	).
<<<<<<< HEAD
enter(Position,Color,Move) :-
	write_move(Move,Color),!.
=======
>>>>>>> 2d339436388d4019969597424504f7941ee349a4
	
% play: chess main loop, Start and Opposite take turns
play(BasicPosition,Start) :-
	asserta(board(BasicPosition,Start)),    % execute only once
	nl,
	draw_board(BasicPosition),
	write('Enter moves like <d2d4.>'),nl,
	write('Enter <exit.> to quit'),nl,
	nl,
	repeat,
	retract(board(Position,Color)),         % read last Position status and color in action
	( 
		are_kings_alive(Position) ->
<<<<<<< HEAD
		enter(Position,Color,Move),
		make_move(Color,Position,Move,New,_),
		draw_board(New),
		invert(Color,Op),
		asserta(board(New,Op)),               % store current Position status and opposite color
		fail
	;
		write_winner(Position),
		!, fail
=======
		write_move(Move,Color),
		;
		!, fail % punem aici functia care face afisarea

>>>>>>> 2d339436388d4019969597424504f7941ee349a4
	).
play(_,_).

king_alive(half_position(_,_,_,_,_,K,_)) :-
	length(K,1).

write_winner(Position) :-
	write('GAME ENDED'), nl,
	winner(Position,Winner),
	write(Winner), write(' wins'), nl.

are_kings_alive(position(W,B,_)) :-
	king_alive(W),
	king_alive(B).

winner(position(W,_,_), white) :- king_alive(W).
winner(position(_,B,_), black) :- king_alive(B).
	
%****************************************************************
%	Board Predicates
%****************************************************************

% true if a piece is in From and moves to To
change(Old,Color,From,To,New):-
	get_half(Old,Half,Color),
	exist(From,Half,Type),
<<<<<<< HEAD
	remove(From,List,Templist),
	update_half(Old,Newhalf,Color,New).
=======
>>>>>>> 2d339436388d4019969597424504f7941ee349a4

% true if there is a piece in the Field and kill it
kill(Old,Color,Field,New):- 
	get_half(Old,Half,Color),
	exist(Field,Half,Type),
<<<<<<< HEAD
	remove(Field,List,Newlist),
	update_half(Old,Newhalf,Color,New).
	
	
=======

>>>>>>> 2d339436388d4019969597424504f7941ee349a4
%****************************************************************
%	Move Predicates
%****************************************************************

% castling
check_00(Old,white,15,17,New) :-
	Old=position(half_position(_,_,_,_,_,[15],_),_,_),
	change(Old,white,18,16,New),!.
check_00(Old,white,15,13,New) :-
	Old=position(half_position(_,_,_,_,_,[15],_),_,_),
	change(Old,white,11,14,New),!.
check_00(Old,black,85,87,New) :-
	Old=position(_,half_position(_,_,_,_,_,[85],_),_),
	change(Old,black,88,86,New),!.
check_00(Old,black,85,83,New) :-
	Old=position(_,half_position(_,_,_,_,_,[85],_),_),
	change(Old,black,81,84,New),!.
check_00(Old,_,_,_,Old).

% check_legal : check if Move is legal, Move e.g. from(Pos1,Pos2)
check_legal(Move,Color,Position):-
	generate(PosMove,Color,Position,_,_),
	Move = PosMove,!.

% generate: move(From,To), Old: old position, Hit:
generate(Move,Color,Old,New,Hit):-
	all_moves(Color,Old,Move),


%****************************************************************
%	UI Predicates
%****************************************************************

% read_move: read input from user
read_move(move(From,To),Color):-
	repeat,
	% write("Your move: <"),write(Color),write("> "),
	write("Your move: "),
	read(Input),
	(
	  	Input = 'exit',
	  	halt
	;
	    name(Input,[A,B,C,D]),	% name("d2d4",[100, 50, 100, 52]) ascii:50-2,52-4,100-d
	  	str_pos([A,B],From),
	  	str_pos([C,D],To),!
	;
	  	write('Wrong format ( enter like <a1b2.> '),nl,
	  	fail
	).

% pos e.g. 42 to str ["d","2"]
str_pos([L,C],Pos):-
	nonvar(Pos),	% Pos known
	pos_no(Row,Col,Pos),
	L is Col + 96,	% int to char
	C is Row + 48,!.
str_pos([L,C],Pos):-
	Col is L - 96,	% char to int
	Row is C - 48,
	pos_no(Row,Col,Pos),!.

% pos e.g. (2,2) to no 22
pos_no(Row,Col,N):-
	nonvar(N),!,
	Row is N // 10,
	Col is N mod 10.
pos_no(R,C,N):-
	N  is  R*10 + C.

% write_move : print move to screen.
write_move(move(From,To),Color):-
	str_pos([A,B],From),
	str_pos([C,D],To),
	name(Move,[A,B,C,D]),
	% write("My move: <"),write(Color),write("> "),
	write("My move: "),
	write(Move),nl,nl,!.
	
% draw_board: show current position
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
	write("  a  b  c  d  e  f  g  h"),nl,nl.
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
				
%****************************************************************
%	Main Predicates
%****************************************************************

initial_pos(position(H1,H2,0)):-
	PawnWhite = [21,22,23,24,25,26,27,28],
	H1 = half_position(PawnWhite,[11,18],[12,17],[13,16],[14],[15],notmoved),
	PawnBlack = [71,72,73,74,75,76,77,78],
	H2 = half_position(PawnBlack,[81,88],[82,87],[83,86],[84],[85],notmoved).

run:-
	retractall(stack(_,_,_)),
	retractall(top(_)),
	retractall(human(_)),
	retractall(depth(_)),
	retractall(board(_,_)),

	initial_pos(Position),
	asserta(depth(2)),
	init_stack,
	play(Position,white),	% main circulation
	closechess.	
			
