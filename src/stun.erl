-module(stun).

-export([request/0]).

-spec(request() -> binary()).

request() ->
  "8.8.8.8".
