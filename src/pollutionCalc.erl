%%%-------------------------------------------------------------------
%%% @author michalkawa
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. mar 2024 23:13
%%%-------------------------------------------------------------------
-module(pollutionCalc).
-author("michalkawa").

%% API
-export([number_of_readings/2, calculate_mean/2, calculate_max/2]).


number_of_readings([], _) -> 0;
number_of_readings([{_,{Data,_},_}|T], Date) ->
  case Data == Date of
      true -> 1 + number_of_readings(T, Date);
      false -> number_of_readings(T, Date)
  end.


calculate_max([{_,_,Pollution}|T], Type) ->
  MaxVal = lists:max([Value || {Type2, Value} <- Pollution, Type =:= Type2]),
  calculate_max_value(T, Type, MaxVal).
calculate_max_value([], _, Val) ->
  case Val of
    none -> -1;
    _ -> Val
  end;
calculate_max_value([{_, _, Pollution}|T], Type, Val) ->
  MaxVal2 = lists:max([Value || {Type2, Value} <- Pollution, Type =:= Type2]),
  NewMaxValue = case MaxVal2 > Val of
                  true -> MaxVal2;
                  false -> Val
                end,
  calculate_max_value(T, Type, NewMaxValue).


calculate_mean(Readings, Type) ->
  {Sum, Count} = calculate_mean_value(Readings, Type, {0 , 0}),
  case Count of
     0 -> -1;
     _ -> Sum/Count
  end.
calculate_mean_value([], _, {Sum, Count}) -> {Sum , Count};
calculate_mean_value([{_, _, Pollution}|T], Type, {SumCur, CountCur}) ->
  {Sum, Count} = lists:foldl(
    fun({Type2, Value}, {SumCur2, CountCur2}) ->
      case Type =:= Type2 of
        true -> {SumCur2 + Value, CountCur2 + 1};
        false -> {SumCur2, CountCur2}
      end
    end,
    {SumCur, CountCur},
    Pollution),
  calculate_mean_value(T, Type, {Sum, Count}).
