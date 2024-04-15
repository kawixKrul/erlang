%%%-------------------------------------------------------------------
%%% @author michalkawa
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. kwi 2024 12:24
%%%-------------------------------------------------------------------
-module(localizator).
-author("michalkawa").

%% API
-export([generate_data/1, find_closest/2, find_closest_pararell/2, compare_speeds/4]).

generate_data(N) -> [{rand:uniform(10000), rand:uniform(10000)} || _ <- lists:seq(1, N)].

dist({X1, Y1}, {X2, Y2}) -> math:sqrt(math:pow(X2-X1, 2) + math:pow(Y2-Y1, 2)).

find_for_person(PersonLocation, SensorsLocation) ->
  lists:min([{dist(PersonLocation, S), {PersonLocation, S}} || S <- SensorsLocation]).
find_for_person(PersonLocation, SensorsLocation, ParentPID) ->
  Result = lists:min([{dist(PersonLocation, S), {PersonLocation, S}} || S <- SensorsLocation]),
  ParentPID ! Result.

find_closest(PeopleLocations, SensorsLocation) ->
  lists:min([find_for_person(P, SensorsLocation)|| P <- PeopleLocations]).

find_closest_pararell(PeopleLocations, SensorsLocation) ->
  PID = self(),
  [spawn(fun() -> PID ! find_for_person(P, SensorsLocation) end) || P <- PeopleLocations],

  Dists = [receive R -> R end || _ <- PeopleLocations],
  lists:min(Dists).

compare_speeds(P, S, Fun1, Fun2) ->
  {Timer1, _} = timer:tc(fun() -> Fun1(P, S) end),
  {Timer2, _} = timer:tc(fun() -> Fun2(P, S) end),
  io:format("F1: ~ws, F2: ~ws~n", [Timer1/math:pow(10,6), Timer2/math:pow(10,6)]).