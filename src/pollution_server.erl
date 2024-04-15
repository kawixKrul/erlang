%%%-------------------------------------------------------------------
%%% @author michalkawa
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. kwi 2024 13:00
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("michalkawa").

%% API
-export([stop/0, start/0, create_monitor/0, add_station/2, add_value/4, remove_value/3, get_one_value/3, get_station_mean/2, get_daily_mean/2, get_daily_deviation/2]).

start() -> register(server, spawn(fun() -> server_loop(none) end)).

stop() -> server ! kill.

create_monitor() -> server ! create.

add_station(Name, Cords) -> server ! {add_station, {Name, Cords}}.

add_value(Key, Date, Type, Value) -> server ! {add_value, {Key, Date, Type, Value}}.

remove_value(Key, Date, Type) -> server ! {remove_value, {Key, Date, Type}}.

get_one_value(Key, Date, Type) -> server ! {get_one_value, {Key, Date, Type}, self()}, receive R -> R end.

get_station_mean(Key, Type) -> server ! {get_station_mean, {Key, Type}, self()}, receive R -> R end.

get_daily_mean(Type, Day) -> server ! {get_daily_mean, {Type, Day}, self()}, receive R -> R end.

get_daily_deviation(Type, Day) -> server ! {get_daily_deviation, {Type, Day}, self()}, receive R -> R end.

print_error(Message) -> io:format("Error: ~s~n", [Message]).

server_loop(Monitor) ->
  receive
    create -> case Monitor of
                none -> M = pollution:create_monitor(), server_loop(M);
                _ -> print_error("Already initialized"), server_loop(Monitor)
              end;

    kill -> ok;

    {add_station, {N, C}} ->
      M = pollution:add_station(N, C, Monitor),
      case M of
        {error, Msg} -> print_error(Msg), server_loop(Monitor);
        _ -> server_loop(M)
      end;

    {add_value, {K, D, T, V}} ->
      M = pollution:add_value(K, D, T, V, Monitor),
      case M of
        {error, Msg} -> print_error(Msg), server_loop(Monitor);
        _ -> server_loop(M)
      end;

    {remove_value, {K, D, T}} ->
      M = pollution:remove_value(K, D, T, Monitor),
      case M of
        {error, Msg} -> print_error(Msg), server_loop(Monitor);
        _ -> server_loop(M)
      end;

    {get_one_value, {K, D, T}, PID} ->
      V = pollution:get_one_value(K, D, T, Monitor),
      case V of
        {error, Msg} -> print_error(Msg), server_loop(Monitor);
        _ -> PID ! V, server_loop(Monitor)
      end;

    {get_station_mean, {K, T}, PID} ->
      V = pollution:get_station_mean(K, T, Monitor),
      case V of
        {error, Msg} -> print_error(Msg), server_loop(Monitor);
        _ -> PID ! V, server_loop(Monitor)
      end;

    {get_daily_mean, {T, D}, PID} ->
      V = pollution:get_daily_mean(T, D, Monitor),
      case V of
        {error, Msg} -> print_error(Msg), server_loop(Monitor);
        _ -> PID ! V, server_loop(Monitor)
      end;

    {get_daily_deviation, {T, D}, PID} ->
      V = pollution:get_daily_deviation(T, D, Monitor),
      case V of
        {error, Msg} -> print_error(Msg), server_loop(Monitor);
        _ -> PID ! V, server_loop(Monitor)
      end;

    _ -> server_loop(Monitor)

  end.