/************************************************************
*                     2. Project to FLP                     *
*                   Logic - Rubick's cube                   *
*                  Marek Hlávka - xhlavk09                  *
*************************************************************
*
*                          input2.pl
* Predicates for reading inpur are from FLP computer classes
*           autor: Martin Hyrs, ihyrs@fit.vutbr.cz
*
Cube = [
    [[5,5,3],   
     [5,5,3],   A
     [5,4,4]],
    [[2,2,5],
     [3,2,2],   B       
     [6,4,4]],          
    [[6,4,4],           
     [4,4,4],   C               A
     [4,4,4]],          CUBE:   B C D E
    [[2,2,5],                   F
     [2,2,5],   D
     [6,6,2]],
    [[1,1,5],
     [3,2,2],   E
     [6,3,3]],
    [[1,1,5],
     [3,2,2],   F
     [6,3,3]]].
***************************************************************/

% Main predicate for program
% Separate predicates for arguments options
% '-h' print help text
% '-d' printing extra information while program running

% Printing help text
main :-
    current_prolog_flag(argv, Args),
    parse_help(Args),
    write('Solver for rubicks cube in PROLOG by Marek Hlavka.
        Usage:   ./flp22-log [-d] [-h]
            -d  Flag to printing more info with running program
            -h  Print this text'),nl,halt.

% Printing debug information along with running program
main :-
    current_prolog_flag(argv, Args),
    parse_debug(Args),
    read_cube(Cube),
    write('------------------ INPUT ------------------'),
    nl,write_cube(Cube),
    write('-------------------------------------------'),nl,!,
    solve(Cube, 1, SOLUTION),
    write('----------------- SOLUTION ----------------'),nl,
    write_solution(SOLUTION),halt.

% Program with standart output - just the solution
main :- 
    read_cube(Cube),
    !,solve(Cube, 0, SOLUTION),
    write_solution(SOLUTION),halt.


%%%%%%%%%%%%%%%%%%%%%%%%%%% Parsing arguments %%%%%%%%%%%%%%%%
parse_debug([H|_]) :- H = '-d'.
parse_debug([_|T]) :- parse_debug(T).

parse_help([H|_]) :- H = '-h'.
parse_help([_|T]) :- parse_help(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READING IN CUBE %%%%%%%%%%%%%%%%
% Reading cube with different lengths of lines
% read_cube(-CUBE)
read_cube(CUBE) :-
    start2(3, UP),
    create_1(UP, OUT_1),
    create_4(3, OUT_2, OUT_3, OUT_4, OUT_5),
    start2(3, DOWN),
    create_1(DOWN, OUT_6),
    merge_6_to_cube(OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, CUBE).

% Read one separate face
% create_1(+[], -[])
create_1([[X]|[]], [X]).
create_1([[X]|XS], [X|RET]) :-
    create_1(XS, RET).

% Read input of three faces in same line
% create_4(+CNT, -[], -[], -[], -[])
create_4(CNT, [], [], [], []) :- CNT==0.
create_4(CNT, [A|OUT2], [B|OUT3], [C|OUT4], [D|OUT5]):-
    read_lines2(LL, 1),
    split_lines2(LL, [OUT]),
    split_to_4(OUT, A, B, C, D),
    CNT1 is CNT - 1,
    create_4(CNT1, OUT2, OUT3, OUT4, OUT5).

% Split list of 4 to 4 parts
% split_to_4(+[], -O1, -O2, -O3, -O4)    
split_to_4([O1,O2,O3,O4], O1, O2, O3, O4).

% Create CUBE structure (6x3x3 list) to store cube information
% merge_6_to_cube( +Side1, +Side2, +Side3, +Side4, +Side5, +Side6, -Cube):-
merge_6_to_cube(Side1,Side2,Side3,Side4,Side5,Side6, Cube):-
    append([[Side1], [Side2], [Side3], [Side4], [Side5], [Side6]], Cube).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WRITING OUT CUBE %%%%%%%%%%%%%%%%

% write_cube(+Cube)
write_cube(Cube) :- write_cube(6, Cube).

% Predicate to cycle through list of faces and prints them in coresponding format
% write_cube(+CNT, +[SIDE|SIDES])
write_cube(_,[]).
write_cube(CNT, _) :- CNT =< 0.
write_cube(CNT, [SIDE|SIDES]) :-    % Write First and Last side (Top and bottom side)
    (CNT == 1; CNT == 6),!,
    write_side(SIDE),
    CNT1 is CNT - 1,
    write_cube(CNT1, SIDES).

write_cube(CNT, SIDES) :-     % Write rest of sides (all apart top and bottom)
    take(4, SIDES, SIDES_4, RET_SIDES),
    write_4_sides(SIDES_4),
    CNT1 is CNT - 4,
    write_cube(CNT1, RET_SIDES).


% Write Side line by line
write_side([]).
write_side([LINE|LINES]) :-
    write_row(LINE),nl,
    write_side(LINES).

% Write 4 Sides on same 3 rows
write_4_sides(SIDES) :-
    write_rows(0, SIDES),nl,
    write_rows(1, SIDES),nl,
    write_rows(2, SIDES),nl.

% Write Nth row for all input faces
write_rows(_, []).
write_rows(CNT, [SIDE|SIDES]) :-
    write_X_row(CNT, SIDE),
    write(' '),
    write_rows(CNT, SIDES).

% Write Nth row of foce
write_X_row(_, []).
write_X_row(CNT, [ROW|ROWS]) :-
    (CNT == 0) ->
    write_row(ROW)
    ;(
        CNT1 is CNT - 1,
        write_X_row(CNT1, ROWS)
    ).

write_row([]).
write_row([X|XS]) :-
    write(X),
    write_row(XS).

% Take firs CNT items from list
take(CNT, RET_SIDES, [], RET_SIDES) :- CNT == 0,!.
take(CNT, [L|LIST], RET, RET_SIDES) :-
    CNT1 is CNT - 1,
    take(CNT1, LIST, RET1, RET_SIDES),
    append([L], RET1, RET).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% FUNCTIONS WITH SIDES %%%%%%%%%%%%%%%%%%%%%%
/*
%%%%%%%%%%%%%%% SIDE
rotate_side_left([[A,B,C],[D,E,F],[G,H,I]], [[C, F, I],[B, E, H],[A, D, G]]).
rotate_side_right([[A,B,C],[D,E,F],[G,H,I]], [[G, D, A],[H, E, B],[I, F, C]]).

%%%%%%%%%%%%%%% ROW & LIST
%% SET
set_nth(N, List, NewElem, NewList) :-
    nth0(N, List, _, RestList), % get the nth element and the rest of the list
    nth0(N, NewList, NewElem, RestList). % create the new list with the new element

%% GET & SET
replace_nth(N, List, NewElem, OldElem, NewList) :-
    nth0(N, List, OldElem, RestList), % get the nth element and the rest of the list
    nth0(N, NewList, NewElem, RestList). % create the new list with the new element

%%%%%%%%%%%%%% COLUMN
%% GET
get_col(_, [], []).
get_col(N, [ROW|ROWS], [R|RET]) :-
    nth0(N, ROW, R),
    get_col(N, ROWS, RET).

%% SET
set_col(_, [], _, []).
set_col(N, [ROW|ROWS], [SRC|SRCS], [R|RET]) :-
    set_nth(N, ROW, SRC, R),
    set_col(N, ROWS, SRCS, RET).

%% GET & SET
replace_col(N, [ROW|ROWS], [SRC|SRCS], [RET|RETS], [RET_SIDE|RET_SIDES]) :-
    %write("here1"),nl,
    replace_nth(N, ROW, SRC, RET, RET_SIDE),
    %write("here3"),nl,
    replace_col(N, ROWS, SRCS, RETS, RET_SIDES).
replace_col(_, [], _, [], []).
*/