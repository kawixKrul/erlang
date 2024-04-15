%%%-------------------------------------------------------------------
%%% @author michalkawa
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. kwi 2024 11:39
%%%-------------------------------------------------------------------
-module(pingpong).
-author("michalkawa").

%% API
-export([start/0, stop/0, play/1, ping/0, pong/0]).


ping() ->
  receive
    0 -> io:format("PING got 0"), ping();
    N -> timer:sleep(100), io:format("PING got ~w, sending ~w~n", [N, N-1]), pong ! N-1, ping()
  end.

pong() ->
  receive
    0 -> io:format("PONG got 0"), pong();
    N -> timer:sleep(100), io:format("PONG got ~w, sending ~w~n", [N, N-1]), ping ! N-1, pong()
  end.

start() ->
  register(ping, spawn(?MODULE, ping, [])),
  register(pong, spawn(?MODULE, pong, [])).


play(N) -> ping ! N.

stop() -> exit(ping), exit(pong).