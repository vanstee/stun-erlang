-module(stun).

-export([request/0, request/1]).

-spec request() -> string().
request() ->
  request(message()).

-spec request(Message :: string()) -> string().
request(Message) ->
  socket:with_socket_helpers(fun(Send, Recv) ->
    Send(Message),
    Recv()
  end).

-spec message() -> string().
message() ->
  "".
