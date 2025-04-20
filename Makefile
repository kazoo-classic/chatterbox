REBAR3_URL=https://s3.amazonaws.com/rebar3/rebar3

# If there is a rebar in the current directory, use it
ifeq ($(wildcard rebar3),rebar3)
REBAR3 = $(CURDIR)/rebar3
endif

# Fallback to rebar3 on PATH
REBAR3 ?= $(shell which rebar3)

# If rebar3 not found, try rebar2
ifeq ($(REBAR3),)
REBAR3 = $(shell which rebar)
# If rebar2 found, use rebar2 commands
ifneq ($(REBAR3),)
REBAR_CLEAN = clean
REBAR_ALL = get-deps compile eunit ct
REBAR_REL = generate
else
# No rebar2 either, prep to download rebar3
REBAR3 = $(CURDIR)/rebar3
REBAR_CLEAN = clean
REBAR_ALL = do clean, compile, eunit, ct, dialyzer
REBAR_REL = release
endif
else
# Using rebar3, use rebar3 commands
REBAR_CLEAN = clean
REBAR_ALL = do clean, compile, eunit, ct, dialyzer
REBAR_REL = release
endif

clean: $(REBAR3)
	@$(REBAR3) $(REBAR_CLEAN)
	rm -rf _build .rebar ebin deps
	@$(REBAR3) compile

all: $(REBAR3)
	@$(REBAR3) $(REBAR_ALL)

rel: all
	@$(REBAR3) $(REBAR_REL)

$(REBAR3):
	curl -Lo rebar3 $(REBAR3_URL) || wget $(REBAR3_URL)
	chmod a+x rebar3