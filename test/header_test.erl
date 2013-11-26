-module(header_test).

-include_lib("eunit/include/eunit.hrl").
-include_lib("stun/include/header.hrl").
-include_lib("stun/include/message.hrl").

header_test_() ->
  [
    {"converts to bytes with message type atom", fun header_bytes_from_message_type_atom/0},
    {"converts to bytes with message type integer", fun header_bytes_from_message_type_integer/0},
    {"converts to bytes", fun header_bytes/0},
    {"combines message classs and method to produce type", fun combine_message_type/0},
    {"looksup message class", fun lookup_message_class/0}
  ].

header_bytes_from_message_type_atom() ->
  meck:new(header, [unstick, passthrough]),
  meck:expect(header, transaction_id, fun fake_transaction_id/0),

  Header = header:bytes(request, 128),
  ?assertMatch(<<0,0,0,128,33,18,164,66,255,255,255,255,255,255,255,255,255,255,255,255>>, Header),

  meck:unload(header).

header_bytes_from_message_type_integer() ->
  meck:new(header, [unstick, passthrough]),
  meck:expect(header, transaction_id, fun fake_transaction_id/0),

  Header = header:bytes(header:message_type(request), 128),
  ?assertMatch(<<0,0,0,128,33,18,164,66,255,255,255,255,255,255,255,255,255,255,255,255>>, Header),

  meck:unload(header).

header_bytes() ->
  Header = header:bytes(header:message_type(request), 128, ?MAGIC_COOKIE, fake_transaction_id()),
  ?assertMatch(<<0,0,0,128,33,18,164,66,255,255,255,255,255,255,255,255,255,255,255,255>>, Header).

combine_message_type() ->
  ?assertMatch(?REQUEST_CLASS band ?BINDING_METHOD, header:message_type(request)).

lookup_message_class() ->
  ?assertMatch(?REQUEST_CLASS, header:message_class(request)),
  ?assertMatch(?INDICATION_CLASS, header:message_class(indication)).

fake_transaction_id() ->
  <<16#FFFFFFFFFFFFFFFFFFFFFFFF:96>>.
