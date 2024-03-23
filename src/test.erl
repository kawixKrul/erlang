%%%-------------------------------------------------------------------
%%% @author michalkawa
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. mar 2024 12:32
%%%-------------------------------------------------------------------
-module(test).
-author("michalkawa").

%% API
-export([f/0, power/2, duplicateElements/1, contains/2, sumFloats/1]).


f()->3.

power(X,1) ->
  X;
power(X, N) ->
  X*power(X,N-1).

contains([],V) -> false;
contains([H|T], V) -> H == V orelse contains(T, V).


duplicateElements([]) -> [];
duplicateElements([H|T]) ->
  [H, H] ++ duplicateElements(T).

sumFloats([]) -> 0;
sumFloats([H|T]) ->
  if is_float(H) -> H + sumFloats(T);
    _ -> sumFloats(T)
  end.

