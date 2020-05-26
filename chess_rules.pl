pawn_move(From,white,Position,To):-
	To is From + 10,
	unoccupied(To, Position).
pawn_move(From,white,Position,To):-
	To is From + 11,
	occupied(To, black, Position).
pawn_move(From,white,Position,To):-
	To is From + 20,
	Over is From + 10,
	unoccupied(To, Position),                                    
	unoccupied(Over, Position),
	Row is From // 10,
	Row = 2.
pawn_move(From,white,Position,To):-
	To is From + 9,
	occupied(To, black, Position).
pawn_move(From,black,Position,To):-
	To is From - 9,
	occupied(To, white, Position).
pawn_move(From,black,Position,To):-
	To is From - 10,
	unoccupied(To, Position).
pawn_move(From,black,Position,To):-
	To is From - 20,
	Over is From - 10,
	unoccupied(To, Position),                                    
	unoccupied(Over, Position),
	Row is From // 10,
	Row = 2.
pawn_move(From,black,Position,To):-
	To is From - 11,
	occupied(To, white, Position).
poss_move(rook, 1).
poss_move(rook, 10).
poss_move(rook, -1).
poss_move(rook, -10).
poss_move(knight, 8).
poss_move(knight, -21).
poss_move(knight, 12).
poss_move(knight, -19).
poss_move(knight, 19).
poss_move(knight, -12).
poss_move(knight, 21).
poss_move(knight, -8).
poss_move(bishop, 9).
poss_move(bishop, 11).
poss_move(bishop, -11).
poss_move(bishop, -9).
poss_move(queen, 1).
poss_move(queen, 9).
poss_move(queen, 10).
poss_move(queen, 11).
poss_move(queen, -11).
poss_move(queen, -10).
poss_move(queen, -9).
poss_move(queen, -1).
poss_move(king, 1).
poss_move(king, 9).
poss_move(king, 10).
poss_move(king, -11).
poss_move(king, -10).
poss_move(king, -9).
