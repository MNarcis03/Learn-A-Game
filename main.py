import sys
import chess.pgn

GAMES_PGN_FILE_PATH = "games.pgn"

def main():
    try:
        pgn = open(GAMES_PGN_FILE_PATH)

        game = chess.pgn.read_game(pgn)

        while None != game:
            for move in game.mainline_moves():
                print(move, file = sys.stdout)

            game = chess.pgn.read_game(pgn)

    except Exception as e:
        print("Exception @ {0}".format(str(e)), file = sys.stderr)

    return None

if __name__ == "__main__":
    main()
