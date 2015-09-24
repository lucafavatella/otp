%%--------------------------------------------------------------------------
%% Module which contains direct and indirect calls to remote functions
%% which do not exist.  Their treatment should be the same.
%%--------------------------------------------------------------------------
-module(non_existing).
-export([t_call/0, t_fun/0]).
-export([t_fun2/0]).
-export([erlang_apply_2/0,
         erlang_apply_3/0]).
-export([erlang_spawn_1/0, erlang_spawn_1a/0, erlang_spawn_1b/1, erlang_spawn_1c/1,
         erlang_spawn_3/0]).

t_call() ->
  lists:non_existing_call(42).

t_fun() ->
  Fun = fun lists:non_existing_fun/1,
  Fun(42).

t_fun2() ->
  (fun lists:non_existing_fun2/1)(42).

erlang_apply_2() ->
  apply(fun lists:erlang_apply_2/0, []).

erlang_apply_3() ->
  apply(lists, erlang_apply_3, []). %% XXX This line does not count as external call to erlang:apply/3ExtCalls in dialyzer_analysis_callgraph:cleanup_callgraph.

erlang_spawn_1() ->
  spawn(fun lists:erlang_spawn_1/0).

erlang_spawn_1a() ->
  erlang:spawn(fun lists:erlang_spawn_1/0).

erlang_spawn_1b(F) ->
  spawn(F).

erlang_spawn_1c(F) ->
  erlang:spawn(F).

erlang_spawn_3() ->
  spawn(lists, erlang_spawn, [1,2,3]).

%% Calls to erlang:make_fun/3 and erlang:get_module_info/{1,2} count as external funs, calls to erlang:spawn/0 do not.
