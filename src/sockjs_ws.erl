-module(sockjs_ws).

-behaviour(sockjs_sender).

-export([send/2, close/3]).

%% TODO this has little in common with the other transports
%% Where should framing happen? (Do we care?)

send(Data, {?MODULE, Ws, cowboy, _}) ->
    Ws ! {send, ["a[", sockjs_util:encode(Data), "]"]};

send(Data, {?MODULE, Ws, misultin, _}) ->
    Ws:send(["a[", sockjs_util:encode(Data), "]"]).

close(Code, Reason, {?MODULE, Ws, cowboy, _}) ->
    Ws ! {send, ["c", sockjs_util:encode([Code, list_to_binary(Reason)])]},
    Ws ! shutdown;

close(Code, Reason, {?MODULE, Ws, misultin, _}) ->
    Ws:send(["c", sockjs_util:encode([Code, list_to_binary(Reason)])]),
    exit(normal). %% TODO ?

