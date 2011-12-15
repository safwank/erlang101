-module(event_sup).
-export([start/2, start_link/2, init/1, loop/1]).

start(Mod,Args) ->
	spawn(?MODULE, init, [{Mod, Args}]).

start_link(Mod,Args) ->
	spawn_link(?MODULE, init, [{Mod, Args}]).

init({Mod,Args}) ->
	process_flag(trap_exit, true),
	loop({Mod,start_link,Args}).

loop({Mod,Fn,Args}) ->
	Pid = apply(Mod,Fn,Args),
	receive
		{'EXIT', Pid, Reason} ->
			io:format("Process ~p exited for reason ~p~n",[Pid,Reason]),
			loop({Mod,Fn,Args});
		{'EXIT', _From, shutdown} ->
			exit(shutdown) % will kill the child too
	end.
