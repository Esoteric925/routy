%%%-------------------------------------------------------------------
%%% @author Amir
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. sep 2016 15:01
%%%-------------------------------------------------------------------
-module(intf).
-author("Amir").

%% API
-compile([export_all]).

new()->
  [].

add(Name,Ref,Pid,Intf)->
  [{Name,Ref,Pid}] ++ Intf.

remove(Name,Intf)->
  lists:keydelete(Name,1,Intf).

lookup(Name,Intf)->
  case lists:keyfind(Name,1,Intf) of
    {Name,_,Pid}  -> {ok,Pid};
    false -> notfound
end.

ref(Name,Intf)->
  case lists:keyfind(Name,1,Intf) of
    {Name,Ref,_} -> {ok,Ref};
    false -> notfound
end.

name(Ref, Intf)->
  case lists:keyfind(Ref,2,Intf) of
    {Name,Ref,_} -> {ok,Name};
    false -> notfound
  end.

list([])->
  [];
list([{Name,_,_}|T])->
  [Name|list(T)].

broadcast(Message, [])->
  Message;
broadcast(Message, [{_,_,Pid}|T]) ->
  Pid ! Message,
  broadcast(Message,T).

