%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. sep 2016 13:28
%%%-------------------------------------------------------------------
-module(map).
-author("admin").

%% API
-compile(export_all).

new()->
  [].

%update(Node, Links, [])->
%  [{Node,Links}];
update(Node, Links, Map)->
  case lists:keyfind(Node, 1, Map) of
    {Node,_}  -> lists:keyreplace(Node, 1, Map, {Node,Links});
    false -> Map ++ [{Node,Links}]
end.

reachable(_,[])->
  [];
reachable(Node,Map)->
  [H|T] = Map,
  {City, Links} = H,
  if
  City == Node -> Links;
  true->
    reachable(Node,T)
  end.


all_nodes([])->
  [];
all_nodes([{Node, ConnectedNodes}|T])->
    FirstNode = [Node] ++ ConnectedNodes,
    FinalList = FirstNode ++ all_nodes(T),
    lists:usort(FinalList).

