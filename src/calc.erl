%% Author: safwan
%% Created: Dec 3, 2011
%% Description: TODO: Add description to calc
-module(calc).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([rpn/1, rpn_test/0]).

%%
%% API Functions (Reverse Polish Notation calculator)
%%
rpn(L) when is_list(L) ->
	[Res] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
	Res.

rpn_test() ->
	5 = rpn("2 3 +"),
	87 = rpn("90 3 -"),
	-4 = rpn("10 4 3 + 2 * -"),
	-2.0 = rpn("10 4 3 + 2 * - 2 /"),
	ok = try
			 rpn("90 34 12 33 55 66 + * - +")
		 catch
			 error:{badmatch,[_|_]} -> ok
		 end,
	4037 = rpn("90 34 12 33 55 66 + * - + -"),
	8.0 = rpn("2 3 ^"),
	true = math:sqrt(2) == rpn("2 0.5 ^"),
	true = math:log(2.7) == rpn("2.7 ln"),
	true = math:log10(2.7) == rpn("2.7 log10"),
	50 = rpn("10 10 10 20 sum"),
	10.0 = rpn("10 10 10 20 sum 5 /"),
	1000.0 = rpn("10 10 20 0.5 prod"),
	ok.

%%
%% Local Functions
%%
rpn("+", [N1,N2|Stack]) -> [N2 + N1|Stack];
rpn("-", [N1,N2|Stack]) -> [N2 - N1|Stack];
rpn("*", [N1,N2|Stack]) -> [N2 * N1|Stack];
rpn("/", [N1,N2|Stack]) -> [N2 / N1|Stack];
rpn("^", [N1,N2|Stack]) -> [math:pow(N2,N1)|Stack];
rpn("ln", [N|Stack]) -> [math:log(N)|Stack];
rpn("log10", [N|Stack]) -> [math:log10(N)|Stack];
rpn("sum", Stack) -> [lists:sum(Stack)];
%% rpn("prod", [N1,N2|Stack]) -> rpn("prod", [N2 * N1|Stack]);
%% rpn("prod", Stack) -> Stack;
rpn("prod", Stack)  -> [lists:foldl(fun erlang:'*'/2, 1, Stack)];
rpn(X, Stack) -> [read(X)|Stack].

read(N) ->
	case string:to_float(N) of
		{error,no_float} -> list_to_integer(N);
		{F,_} -> F
	end.