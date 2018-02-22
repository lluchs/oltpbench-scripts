# call with b=<benchmark name>

AWK ?= gawk

ifndef b
$(error need b=<name of benchmark>)
endif

all: analysis/$(b) profiles

analysis/$(b):
	mkdir -p $@

profiles: results/$(b)/log extract-profiles.awk
	cd analysis/$(b) && $(AWK) -f ../../extract-profiles.awk ../../$<

.PHONY: all profiles
