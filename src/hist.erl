%%%-------------------------------------------------------------------
%%% @author Amir
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. sep 2016 15:49
%%%-------------------------------------------------------------------
-module(hist).
-author("Amir").

%% API
-compile([export_all]).

new(Name)->
  [{Name,0}].

%%update(Node, N, [])->
%%  {new, [{Node,N}]};
update(Node,N,History)->
  case lists:keyfind(Node,1,History) of
    {Node,MessageNumber} -> if
                              MessageNumber < N -> {new, lists:keyreplace(Node,1,History,{Node,N})};
                              true -> old %ska det inte vara {old, History}?
                            end;
  false -> {new, History ++ [{Node,N}]}
end.

