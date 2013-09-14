REBAR = ./rebar

.PHONY: all compile deps clean distclean test

all: deps compile

compile: deps
	@$(REBAR) compile

deps:
	@$(REBAR) get-deps

clean:
	@$(REBAR) clean

distclean: clean
	@$(REBAR) delete-deps

test: all
	@$(REBAR) skip_deps=true eunit
