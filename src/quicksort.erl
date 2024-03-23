%%%-------------------------------------------------------------------
%%% @author michalkawa
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. mar 2024 11:42
%%%-------------------------------------------------------------------
-module(quicksort).
-author("michalkawa").

%% API
-export([qs/1, random_elems/3, compare_speeds/3]).

less_than(List, Arg) -> lists:filter(fun(X) -> X < Arg end, List).
grt_eq_than(List, Arg) -> lists:filter(fun(X) -> X >= Arg end, List).

qs([]) -> [];
qs([Pivot|Tail]) -> qs( less_than(Tail,Pivot) ) ++ [Pivot] ++ qs( grt_eq_than(Tail,Pivot) ).

random_elems(N,Min,Max) -> [rand:uniform(Max-Min+1)+Min-1 || _ <- lists:seq(1,N)].

compare_speeds(List, Fun1, Fun2) ->
  {Timer1, _} = timer:tc(fun() -> Fun1(List) end),
  {Timer2, _} = timer:tc(fun() -> Fun2(List) end),
  io:format("F1: ~p, F2: ~p~n", [Timer1, Timer2]).
