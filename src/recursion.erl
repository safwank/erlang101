-module(recursion).
-export([factorial/1, len/1, duplicate/2, reverse/1, sublist/2, zip/2, lenient_zip/2, quicksort/1, lc_quicksort/1, tail_factorial/1, tail_len/1, tail_duplicate/2, tail_reverse/1, tail_sublist/2, tail_zip/2, tail_lenient_zip/2]).

factorial(0) -> 1;
factorial(N) when N > 0 -> N*factorial(N-1).

tail_factorial(N) -> tail_factorial(N,1). 
tail_factorial(0,Accumulator) -> Accumulator;
tail_factorial(N,Accumulator) when N > 0 -> tail_factorial(N-1,N*Accumulator).

len([]) -> 0;
len([_|T]) -> 1 + len(T).

tail_len(L) -> tail_len(L,0). 
tail_len([], Accumulator) -> Accumulator;
tail_len([_|T], Accumulator) -> tail_len(T,Accumulator+1).

duplicate(0,_) -> [];
duplicate(N,Term) when N > 0 -> [Term|duplicate(N-1,Term)].

tail_duplicate(N,Term) -> tail_duplicate(N,Term,[]).
tail_duplicate(0,_,Accumulator) -> Accumulator;
tail_duplicate(N,Term,Accumulator) when N > 0 -> tail_duplicate(N-1,Term,[Term|Accumulator]).

reverse([]) -> [];
reverse([H|T]) -> reverse(T)++[H].

tail_reverse(List) ->  tail_reverse(List, []).
tail_reverse([], Accumulator) -> Accumulator;
tail_reverse([H|T], Accumulator) -> tail_reverse(T,[H|Accumulator]).

sublist(_,0) -> [];
sublist([],_) -> [];
sublist([H|T],N) when N > 0 -> [H|sublist(T,N-1)].

tail_sublist(List,N) -> tail_sublist(List,N,[]).
tail_sublist(_,0,Accumulator) -> Accumulator;
tail_sublist([],_,Accumulator) -> Accumulator;
tail_sublist([H|T],N,Accumulator) when N > 0 -> tail_sublist(T,N-1,Accumulator++[H]).

zip([],[]) -> [];
zip([X|Xs],[Y|Ys]) -> [{X,Y}|zip(Xs,Ys)].

tail_zip(X,Y) -> tail_zip(X,Y,[]).
tail_zip([],[],Accumulator) -> Accumulator;
tail_zip([X|Xs],[Y|Ys],Accumulator) -> tail_zip(Xs, Ys, Accumulator++[{X,Y}]).

lenient_zip([],_) -> [];
lenient_zip(_,[]) -> [];
lenient_zip([X|Xs],[Y|Ys]) -> [{X,Y}|lenient_zip(Xs,Ys)].

tail_lenient_zip(X,Y) -> tail_lenient_zip(X,Y,[]).
tail_lenient_zip([],_,Accumulator) -> Accumulator;
tail_lenient_zip(_,[],Accumulator) -> Accumulator;
tail_lenient_zip([X|Xs],[Y|Ys],Accumulator) -> tail_lenient_zip(Xs, Ys, Accumulator++[{X,Y}]).

quicksort([]) -> [];
quicksort([Pivot|Rest]) ->
	{Smaller, Larger} = partition(Pivot,Rest,[],[]),
	quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).

partition(_,[], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [H|T], Smaller, Larger) ->
	if H =< Pivot -> partition(Pivot, T, [H|Smaller], Larger);
	   H >  Pivot -> partition(Pivot, T, Smaller, [H|Larger])
	end.

lc_quicksort([]) -> [];
lc_quicksort([Pivot|Rest]) ->
	lc_quicksort([Smaller || Smaller <- Rest, Smaller =< Pivot])
		++ [Pivot] ++
		lc_quicksort([Larger || Larger <- Rest, Larger > Pivot]).