.SUFFIXES: 

FC=gfortran
COMPILE.f08 = $(FC) $(FCFLAGS) $(TARGET_ARCH) -c
MAKEMOD.f08 = $(FC) $(FCFLAGS) $(TARGET_ARCH) -fsyntax-only -c

SOURCES=day11.f90 utils.f90

day11: $(subst .f90,.o,$(SOURCES))
	$(FC) -o $@ $+

.PHONY: clean
clean:
	-rm -f *.o *.mod *.smod *.anc day11 

%.anc: %.f90
	$(MAKEMOD.f08) $<
	@touch $@

%.o: %.anc
	$(COMPILE.f08) -o $*.o $(<:.anc=.f90)
	@touch $@

day11.anc: utils.anc

utils.anc: utils.mod utils.smod
utils.mod utils.smod:
