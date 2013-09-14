Stun
====

Just a humble STUN (Session Traversal Utilities for NAT) client in Erlang
conforming to [rfc5389](http://tools.ietf.org/rfc/rfc5389.txt).

Usage
-----

In most cases you'll just want to know your public facing IP address. To simply
ask a STUN server your address without setting any custom options use the
following:

```erlang
1> stun:request().
"8.8.8.8"
```
