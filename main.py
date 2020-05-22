import sys
import chess.pgn
from pyswip import Prolog

GAMES_PGN_FILE_PATH = "games.pgn"

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

def initialize_moves():
    moves = dict()
    colors = "wb"
    pieces = "PRNBQK"

    for color in colors:
        for piece in pieces:
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

def parse_move(board, moves, attacks, move):
    _from = move[:2]
    _to = move[2:]

    y = ord(_to[0]) - ord(_from[0])
    x = ord(_to[1]) - ord(_from[1])

    if "" != board[_to]:
        attacks[board[_from]].add((x, y))
    else:
        moves[board[_from]].add((x, y))

    board[_to] = board[_from]
    board[_from] = ""

    return board, moves, attacks

def create_game_rules(moves, attacks):
    prolog = Prolog()
    colors = "wb"
    pieces = "PRNBQK"

    for color in colors:
        for piece in pieces:
            _assert = "{0}{1}(".format(color, piece)

            for move in moves[color + piece]:
                _assert += "X+{0}&Y+{1},".format(move[0], move[1])

            _assert[-1] = ")"
            prolog.assertz(_assert)

    return prolog

def main():

    try:
        pgn = open(GAMES_PGN_FILE_PATH)

        moves = initialize_moves()
        attacks = initialize_attacks()

        board = initialize_board()
        game = chess.pgn.read_game(pgn)

        while None != game:
            try:
                for move in game.mainline_moves():
                    board, moves, attacks = parse_move(board, moves, attacks, move.uci())

                board = initialize_board()
                game = chess.pgn.read_game(pgn)
                game = None
            except Exception as e:
                print("Exception during While: {0}".format(str(e)), file = sys.stderr)

        prolog = create_game_rules(moves, attacks)

    except Exception as e:
        print("Exception @ {0}".format(str(e)), file = sys.stderr)

    return None

if __name__ == "__main__":
    main()
