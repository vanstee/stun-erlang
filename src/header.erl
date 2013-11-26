-module(header).

-export([bytes/2, bytes/4, message_type/1, message_class/1, transaction_id/0]).

-include_lib("stun/include/header.hrl").
-include_lib("stun/include/message.hrl").

-spec bytes(atom() | integer(), integer()) -> bitstring().
bytes(MessageType, MessageLength) when is_atom(MessageType) ->
  header:bytes(header:message_type(MessageType), MessageLength);

bytes(MessageType, MessageLength) when is_integer(MessageType) ->
  header:bytes(MessageType, MessageLength, ?MAGIC_COOKIE, header:transaction_id()).

-spec bytes(integer(), integer(), integer(), [byte()]) -> bitstring().
bytes(MessageType, MessageLength, MagicCookie, TransactionId) ->
  <<0:2, MessageType:14, MessageLength:16, MagicCookie:32, TransactionId/binary>>.

-spec message_type(atom()) -> integer().
message_type(MessageClass) ->
  header:message_class(MessageClass) band ?BINDING_METHOD.

-spec message_class(atom()) -> integer().
message_class(request) ->
  ?REQUEST_CLASS;

message_class(indication) ->
  ?INDICATION_CLASS.

-spec transaction_id() -> [byte()].
transaction_id() ->
  crypto:strong_rand_bytes(?TRANSACTION_ID_LENGTH).
