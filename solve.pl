/************************************************************
*                     2. Project to FLP                     *
*                   Logic - Rubick's cube                   *
*                  Marek Hlávka - xhlavk09                  *
*************************************************************/

% Predicate to chesk if Rubicks cube is solved
valid_cube(
  [[[A, A, A],[A, A, A],[A, A, A]], % Output
   [[B, B, B],[B, B, B],[B, B, B]],
   [[C, C, C],[C, C, C],[C, C, C]],
   [[D, D, D],[D, D, D],[D, D, D]],
   [[E, E, E],[E, E, E],[E, E, E]],
   [[F, F, F],[F, F, F],[F, F, F]]]
).

% Creates CUBE structure for correct solved cube
% as second start point for Bidirectional search
set_goal(
  [[_,[_, A, _],_], % Output
   [_,[_, B, _],_],
   [_,[_, C, _],_],
   [_,[_, D, _],_],
   [_,[_, E, _],_],
   [_,[_, F, _],_]]
   ,
  [[[A, A, A],[A, A, A],[A, A, A]], % Output
   [[B, B, B],[B, B, B],[B, B, B]],
   [[C, C, C],[C, C, C],[C, C, C]],
   [[D, D, D],[D, D, D],[D, D, D]],
   [[E, E, E],[E, E, E],[E, E, E]],
   [[F, F, F],[F, F, F],[F, F, F]]]
).

% Predicate to print state at each searching length
write_state(MaxLength, StartTime) :-
    statistics(runtime,[Stop|_]),
    Runtime is Stop - StartTime,
    write('Start searching for solution of length '),
    write(MaxLength),
    write(' at '),
    write(Runtime),
    write(' ms'),nl.

% Prints runtime of program
write_state(StartTime) :-
    statistics(runtime,[Stop|_]),
    Runtime is Stop - StartTime,
    write('Found solution at '),
    write(Runtime),
    write(' ms'),nl.

% Get list head
head([H|_], H).

% Copy list from one to another
copy_list(X, X).

% Predicate to cycle through list and print solution to solve a rubicks cube
write_solution([]).
write_solution([CUBE|CUBES]) :-
    write_cube(CUBE),nl,
    write_solution(CUBES).


% Check if path from scrambled cube and from solved cubes have crosed
%   and that means solution is found
% step_bidirectional(+CUBE, +REV_CUBE, +Len, +L, +REV_L, -R)
step_bidirectional(CUBE, CUBE, _, L, REV_L, R) :-
    reverse([CUBE|REV_L], REST),
    append(REST, L, REV_R),
    head(REV_R, X),
    (valid_cube(X)->(
        reverse(REV_R, R)
    );(
        copy_list(REV_R, R)
    )).

% Predicate to check 18 new movess from input cube
step_bidirectional(CUBE, REV_CUBE, Len, L, REV_L, R) :-
    cube_move(CUBE, NCUBE),
    \+ memberchk(NCUBE, L),
    length(L, X),
    length(REV_L, Y),
    XY is X + Y,
    XY < Len,
    step_bidirectional(REV_CUBE, NCUBE, Len, [CUBE|REV_L], L, R).

% Starting predicate do solve algorithm
% solve(+CUBE, +MODE, -RET_PATH)
%
% Solve with writing out info
solve(CUBE, 1, RET_PATH) :-
    write('------ Bidirectional Iterational DFS ------'),nl,
    set_goal(CUBE, GOAL),
    statistics(runtime, [Start|_]),
    between(0,30,X),
    write_state(X, Start),
    step_bidirectional(CUBE, GOAL, X, [], [], RET_PATH),
    write_state(Start).

% Solve with standart output - just solution
solve(CUBE, 0, RET_PATH) :-
    set_goal(CUBE, GOAL),
    between(0,20,X),
    step_bidirectional(CUBE, GOAL, X, [], [], RET_PATH).


solve(_, _) :- write('Failed to find solution'),nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Algorithm simple IDS without bidirection %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
step_one(CUBE, Len, L, Res) :-
    valid_cube(CUBE),
    reverse([CUBE|L], Res).

step_one(CUBE, Len, L, R) :-
    cube_move(CUBE, NCUBE),
    \+ memberchk(NCUBE, L),
    length(L, X),
    X < Len,
    step_one(NCUBE,Len,[CUBE|L], R).

solve(CUBE, 1, RET_PATH) :-
    statistics(runtime,[Start|_]),
    !,between(0,0,X),
    write_state(X, Start),
    step_one(CUBE, X, [], RET_PATH).

solve(CUBE, 0, RET_PATH) :-
    between(0,30,X),
    step_one(CUBE, X, [], RET_PATH).
*/