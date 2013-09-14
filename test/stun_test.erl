-module(stun_test).

-include_lib("eunit/include/eunit.hrl").

stun_test_() ->
  [{"Request returns 8.8.8.8", fun request_returns_address/0}].

request_returns_address() ->
  ?assertEqual("8.8.8.8", stun:request()).
