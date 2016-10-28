%%%-------------------------------------------------------------------
%%% @author Amir
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. sep 2016 13:38
%%%-------------------------------------------------------------------
-module(dijkstra).
-author("Amir").

%% API
-compile(export_all).

entry(_, [])->
  0;
entry(Node,[{To,Hop,_}|T])->

  case Node of
     To -> Hop;
     _ -> entry(Node,T)
  end.

replace(Node, N, NewGateway, Sorted) ->

  lists:keysort(2,lists:keyreplace(Node,1,Sorted,{Node,N,NewGateway})).

update(Node,N,Gateway,Sorted)->
  case N < entry(Node,Sorted) of
    true -> replace(Node,N,Gateway,Sorted) ;
    false -> Sorted
  end.

iterate([{_,inf,_}|_],_,Table)->
  %erlang:display("jag ar i iterate basfallet"),
 % erlang:display("min table är "),
  %erlang:display(Table),
  Table;
iterate([], _, Table)->
 % erlang:display("jag ar i iterate och min sortedlista ar tom"),
 % erlang:display("min table ser ut so har"),
  %erlang:display(Table),
  Table;
iterate([{Dest, Hop, Gateway}|T], Map, Table)->

  Links = map:reachable(Dest,Map),

  UpdatedSortedList = helpToIterate(Links,Gateway,T,Hop),

   iterate(UpdatedSortedList,Map,[{Dest,Gateway}|Table]).

helpToIterate([],_,Sorted,_)->
  Sorted;
helpToIterate([H|T], Dest, Sorted, Hop)->
  New = update(H,Hop+1,Dest,Sorted),
  helpToIterate(T,Dest,New,Hop).

table([],[])->
  [];
table([H|T], [])->
  [{H,H}|table(T,[])];
table(Gateways, Map)->
  AllNodes = map:all_nodes(Map),
%  erlang:display(allmaps), erlang:display(AllNodes),
  UpdatedList = dijkstra:setInfUnknown(AllNodes),
 % erlang:display(updatedlist), erlang:display(UpdatedList),
  FinalizedList = fixedList(Gateways,UpdatedList),
  %erlang:display(finalizedlist),erlang:display(FinalizedList),
  iterate(FinalizedList,Map,[]).

fixedList([],List)->
  List;
fixedList([H|T], List)->
  case lists:keyfind(H,1,List) of
    {H,_,_} -> TempList = update(H,0,H,List);
    false -> TempList = List
  end,
  fixedList(T,TempList).

setInfUnknown([])->
  [];
setInfUnknown([H|T])->
  [{H,inf,unknown}|setInfUnknown(T)].

route(Node,Table)->
  case lists:keyfind(Node,1,Table) of
    {Node,Gateway} -> {ok,Gateway};
    false -> notfound
end.
