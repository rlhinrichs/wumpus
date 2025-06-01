:- use_module(library(http/json)).

% Simulate reading a JSON file
read_json_file(FileName, JSON) :-
    open(FileName, read, Stream),
    json_read(Stream, JSON),
    close(Stream).

% Simulate writing to a JSON file
write_json_file(FileName, JSON) :-
    open(FileName, write, Stream),
    json_write(Stream, JSON),
    close(Stream).

% Example of updating percepts based on some game logic
update_percepts :-
    FileName = 'game_state.json',
    read_json_file(FileName, JSON),
    update_all_percepts(JSON, UpdatedJSON),
    write_json_file(FileName, UpdatedJSON).

% Update all percepts based on adjacent and current cell features
update_all_percepts(JSON, UpdatedJSON) :-
    maplist(update_cell_percepts(JSON), JSON, UpdatedJSON).

% Update the percepts of a single cell
update_cell_percepts(JSON, Cell, UpdatedCell) :-
    update_stenchy(JSON, Cell, CellWithStench),
    update_windy(JSON, CellWithStench, CellWithWind),
    update_glitter(CellWithWind, UpdatedCell).

% Update 'stenchy' percept based on adjacent Wumpus
update_stenchy(JSON, Cell, UpdatedCell) :-
    (   adjacent_has_feature(JSON, Cell, wumpus)
    ->  put_dict(_{percepts: Cell.percepts.put(stenchy, true)}, Cell, UpdatedCell)
    ;   UpdatedCell = Cell).

% Update 'windy' percept based on adjacent pits
update_windy(JSON, Cell, UpdatedCell) :-
    (   adjacent_has_feature(JSON, Cell, pit)
    ->  put_dict(_{percepts: Cell.percepts.put(windy, true)}, Cell, UpdatedCell)
    ;   UpdatedCell = Cell).

% Update 'glitter' percept based on gold in the same cell
update_glitter(Cell, UpdatedCell) :-
    (   cell_has_feature(Cell, gold)
    ->  put_dict(_{percepts: Cell.percepts.put(glitter, true)}, Cell, UpdatedCell)
    ;   UpdatedCell = Cell).

% Check if any adjacent cell has a specific feature (Wumpus or pit)
adjacent_has_feature(JSON, Cell, Feature) :-
    member(AdjCell, JSON),
    is_adjacent(Cell, AdjCell),
    get_dict(Feature, AdjCell.probabilities, Prob),
    Prob > 0.05.

% Check if the current cell has a specific feature (gold)
cell_has_feature(Cell, Feature) :-
    get_dict(Feature, Cell.probabilities, Prob),
    Prob > 0.05.

% Check adjacency based on coordinates
is_adjacent(Cell1, Cell2) :-
    X1 = Cell1.location.x, Y1 = Cell1.location.y,
    X2 = Cell2.location.x, Y2 = Cell2.location.y,
    (   X1 == X2, abs(Y1 - Y2) == 1
    ;   Y1 == Y2, abs(X1 - X2) == 1).

% Run the percept update process
:- update_percepts.
