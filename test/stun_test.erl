-module(stun_test).

-include_lib("eunit/include/eunit.hrl").
-include_lib("stun/include/stun.hrl").

stun_test_() ->
  [
    {"sends a message", fun request_sends_message/0},
    {"receives a messages", fun request_receives_message/0}
  ].

request_sends_message() ->
  meck:new(socket),
  meck:expect(socket, with_socket_helpers, fun(Callback) ->
    Send = fun(Message) -> ?assertMatch("message", Message) end,
    Recv = fun() -> ok end,
    Callback(Send, Recv)
  end),

  stun:request("message"),

  ?assert(meck:validate(socket)),

  meck:unload(socket).

request_receives_message() ->
  meck:new(socket),
  meck:expect(socket, with_socket_helpers, fun(Callback) ->
    Send = fun(_) -> ok end,
    Recv = fun() -> "message" end,
    Callback(Send, Recv)
  end),

  ?assertMatch("message", stun:request()),
  ?assert(meck:validate(socket)),

  meck:unload(socket).
