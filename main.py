import sys
import chess.pgn

GAMES_PGN_FILE_PATH = "games.pgn"
CHESS_RULES_FILE_PATH = "chess_rules.pl"

def initialize_board():
    board = dict()
    lines = "12345678"
    columns = "abcdefgh"

    for column in columns:
        for line in lines:
            if "2" == line:
                board[column + line] = "wP"
            elif "7" == line:
                board[column + line] = "bP"
            elif ("1" == line) and (("a" == column) or ("h" == column)):
                board[column + line] = "wR"
            elif ("8" == line) and (("a" == column) or ("h" == column)):
                board[column + line] = "bR"
            elif ("1" == line) and (("b" == column) or ("g" == column)):
                board[column + line] = "wN"
            elif ("8" == line) and (("b" == column) or ("g" == column)):
                board[column + line] = "bN"
            elif ("1" == line) and (("c" == column) or ("f" == column)):
                board[column + line] = "wB"
            elif ("8" == line) and (("c" == column) or ("f" == column)):
                board[column + line] = "bB"
            elif ("1" == line) and ("d" == column):
                board[column + line] = "wQ"
            elif ("8" == line) and ("d" == column):
                board[column + line] = "bQ"
            elif ("1" == line) and ("e" == column):
                board[column + line] = "wK"
            elif ("8" == line) and ("e" == column):
                board[column + line] = "bK"
            else:
                board[column + line] = ""

    return board

def initialize_conversion_board():
    conversion_board = dict()
    lines = "12345678"
    columns = "abcdefgh"
    value = 11

    for column in columns:
        for line in lines:
            conversion_board[column + line] = value

            if ((18 == value) or (28 == value) or (38 == value) or (48 == value) or
                (58 == value) or (68 == value) or (78 == value) or (88 == value)):
                value += 3
            else:
                value += 1

    return conversion_board

def initialize_moves():
    moves = dict()
    colors = "wb"
    pieces = "PRNBQK"

    for piece in pieces:
        for color in colors:
            moves[color + piece] = set()

    return moves

def initialize_attacks():
    attacks = dict()
    colors = "wb"
    pieces = "PRNBQK"

    for color in colors:
        for piece in pieces:
            attacks[color + piece] = set()

    return attacks

def parse_move(board, conversion_board, moves, attacks, move):
    _from = move[:2]
    _to = move[2:]
    value = 0

    value = conversion_board[_to] - conversion_board[_from]

    if "R" == board[_from][1]:
        if 0 == value % 10:
            value = 10 * (value // abs(value))
        else:
            value = 1 * (value // abs(value))
    elif "B" == board[_from][1]:
        if 0 == value % 11:
            value = 11 * (value // abs(value))
        else:
            value = 9 * (value // abs(value))
    elif ("Q" == board[_from][1]) or ("K" == board[_from][1]):
        if 0 == value % 10:
            value = 10 * (value // abs(value))
        elif -7 <= value <= 7:
            value = 1 * (value // abs(value))
        elif 0 == value % 11:
            value = 11 * (value // abs(value))
        else:
            value = 9 * (value // abs(value))
    elif "P" == board[_from][1]:
        if -2 <= value <= 2:
            value *= 10 * (value // abs(value))

    moves[board[_from]].add(value)

    board[_to] = board[_from]
    board[_from] = ""

    return board, moves, attacks

def create_chess_rules(moves, attacks):
    with open(CHESS_RULES_FILE_PATH, "w+") as fd:
        for piece, _moves in moves.items():
            if "wR" == piece:
                moves["wR"].union(moves["bR"])
                
                for move in _moves:
                    _format = "poss_move(rook, {0}).\n".format(move)
                    fd.writelines(_format)
            elif "wB" == piece:
                moves["wB"].union(moves["bB"])

                for move in _moves:
                    _format = "poss_move(bishop, {0}).\n".format(move)
                    fd.writelines(_format)
            elif "wN" == piece:
                moves["wN"].union(moves["bN"])

                for move in _moves:
                    _format = "poss_move(knight, {0}).\n".format(move)
                    fd.writelines(_format)
            elif "wQ" == piece:
                moves["wQ"].union(moves["bQ"])

                for move in _moves:
                    _format = "poss_move(queen, {0}).\n".format(move)
                    fd.writelines(_format)
            elif "wK" == piece:
                moves["wK"].union(moves["bK"])

                for move in _moves:
                    _format = "poss_move(king, {0}).\n".format(move)
                    fd.writelines(_format)
            elif "wP" == piece:
                moves["wP"].union(moves["bP"])

                for move in _moves:
                    _format = "poss_move(pawn, {0}).\n".format(move)
                    fd.writelines(_format)

    return None

def main():
    pgn = open(GAMES_PGN_FILE_PATH)

    conversion_board = initialize_conversion_board()

    moves = initialize_moves()
    attacks = initialize_attacks()

    board = initialize_board()
    game = chess.pgn.read_game(pgn)

    while None != game:
        try:
            for move in game.mainline_moves():
                board, moves, attacks = parse_move(board, conversion_board, moves, attacks, move.uci())
        except Exception as e:
            pass

        board = initialize_board()
        game = chess.pgn.read_game(pgn)

    create_chess_rules(moves, attacks)

    return None

if __name__ == "__main__":
    main()
