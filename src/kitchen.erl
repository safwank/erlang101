-module(kitchen).
-compile(export_all).

stateless_fridge() ->
	receive
		{From, {store, _Food}} ->
			From ! {self(), ok},
			stateless_fridge();
		{From, {take, _Food}} ->
			From ! {self(), not_found},
			stateless_fridge();
		terminate ->
			ok
	end.

stateful_fridge(FoodList) ->
	receive
		{From, {store, Food}} ->
			From ! {self(), ok},
			stateful_fridge([Food|FoodList]);
		{From, {take, Food}} ->
			case lists:member(Food, FoodList) of
				true ->
					From ! {self(), {ok, Food}},
					stateful_fridge(lists:delete(Food, FoodList));
				false ->
					From ! {self(), not_found},
					stateful_fridge(FoodList)
			end;
		{From, peek} ->
			From ! {self(), FoodList},
			stateful_fridge(FoodList);
		terminate ->
			ok
	end.

start(FoodList) ->
	spawn(?MODULE, stateful_fridge, [FoodList]).

store(Pid, Food) ->
	Pid ! {self(), {store, Food}},
	receive
		{Pid, Msg} -> Msg
	end.

take(Pid, Food) ->
	Pid ! {self(), {take, Food}},
	receive
		{Pid, Msg} -> Msg
	end.

peek(Pid) ->
	Pid ! {self(), peek},
	receive
		{Pid, Msg} -> Msg
	end.

store2(Pid, Food) ->
	Pid ! {self(), {store, Food}},
	receive
		{Pid, Msg} -> Msg
		after 3000 ->
			timeout
	end.

take2(Pid, Food) ->
	Pid ! {self(), {take, Food}},
	receive
		{Pid, Msg} -> Msg
		after 3000 ->
			timeout
	end.