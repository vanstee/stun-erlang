-module(socket).

-export([with_socket_helpers/1]).

-include_lib("stun/include/stun.hrl").

-type send_with_socket_fun() :: fun((string()) -> no_return()).
-type recv_with_socket_fun() :: fun(() -> string()).
-type with_socket_helpers_fun() :: fun((send_with_socket_fun(), recv_with_socket_fun()) -> string()).
-type with_socket_fun() :: fun((inet:socket()) -> string()).

-spec with_socket_helpers(Callback :: with_socket_helpers_fun()) -> string().
with_socket_helpers(Callback) ->
  with_socket(fun(Socket) ->
    Send = send_with_socket(Socket),
    Recv = recv_with_socket(Socket),
    Callback(Send, Recv)
  end).

-spec with_socket(Callback :: with_socket_fun()) -> string().
with_socket(Callback) ->
  Socket = open(),
  Result = Callback(Socket),
  close(Socket),
  Result.

-spec send_with_socket(Socket :: inet:socket()) -> send_with_socket_fun(). 
send_with_socket(Socket) ->
  fun(Packet) ->
    send(Socket, Packet)
  end.

-spec recv_with_socket(Socket :: inet:socket()) -> recv_with_socket_fun(). 
recv_with_socket(Socket) ->
  fun() ->
    recv(Socket)
  end.

-spec open() -> inet:socket().
open() ->
  {ok, Socket} = gen_udp:open(?PORT),
  Socket.

-spec send(Socket :: inet:socket(), Packet :: string()) -> no_return().
send(Socket, Packet) ->
  ok = gen_udp:send(Socket, ?SERVER, 0, Packet).

-spec recv(Socket :: inet:socket()) -> string().
recv(Socket) ->
  {ok, {_Address, _Port, Packet}} = gen_udp:recv(Socket, ?MAX_RESPONSE_LENGTH),
  Packet.

-spec close(Socket :: inet:socket()) -> no_return().
close(Socket) ->
  ok = gen_udp:close(Socket).
