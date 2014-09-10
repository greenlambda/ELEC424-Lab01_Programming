# Makefile for C and C++ projects. 
# Author: Jeremy Hunt
# I wrote this for another project and stripped it down here

# Here are all of the targets that will be placed in the output directory
TARGETS := sort

# Hack in a ORDER flag
ORDER ?= ASC

# Everything with a *.cpp ending will be built
SRCEXT := c
SOURCES := sort.c
OBJECTS := $(SOURCES:.$(SRCEXT)=.o)
DEPENDENCIES := $(SOURCES:.$(SRCEXT)=.d)

# Define the compiler, linker and preprocessor and associated flags. The 
# preprocessor flags are added to the compiler flags by default and the
# include flags are addded to the preprocessor.
CC := gcc
# Define the extra include directory locations
CINCLUDEFLAGS :=
CPREPROCFLAGS := -g -Wall -Werror -D$(ORDER) $(CINCLUDEFLAGS)
CCOMPILEFLAGS := $(CPREPROCFLAGS)
# The linker libarary list for gcc/ld
LDLIBFLAGS := 

# Begin build rules
all: $(TARGETS)

# Prints information about the build system, etc.
.PHONY: info depend-info
info:
	@echo "Targets: $(TARGETS)"
	@echo "Building everything in directory $(SRCDIR) with extension *.$(SRCEXT)."
	@echo "Intermediate build directory: $(BUILDDIR)"
	@echo "Final output directory: $(OUTPUTDIR)"
	@echo "Compiler: $(CC)"
	@echo "Include Flags: $(CINCLUDEFLAGS)"
	@echo "Preprocessor Flags: $(CPREPROCFLAGS)"
	@echo "Full Compiler Flags: $(CCOMPILEFLAGS)"
	@echo "Libraries: $(LDLIBFLAGS)"


# The main C program target. Link all the objects into an ELF
sort: $(OBJECTS) read_data.a
	@echo "  LINK   ($^) -> $@" && $(CC) $^ -o $@ $(LDLIBFLAGS)


# Build source files into objects
%.o: %.$(SRCEXT)
	@echo "  $(CC)    $< -> $@" && $(CC) $(CCOMPILEFLAGS) -o $@ -c $<

# Because we build everything into the build directory, we can just delete
# it and the targets and we are done. Also remove backup files ending in ~
.PHONY: clean
clean:
	@echo "Deleting the following backup files..."
	@find . -name '*~' -type f -printf '  %p\n' -delete
	@echo "Cleaning up intermediate and target files..."	
	$(RM) -rf $(OBJECTS) $(DEPENDENCIES) $(TARGETS)

# This clever bit of make-fu builds dependency files for each source file so
# that if the included files for that source file are updated, the object for
# that file is also rebuilt. This rule generates a coresponding %.d file in
# the build directory for each source file. These %.d files contain makefile
# dependency rules which are included at the bottom of this makefile. Even
# more clever, this rule adds the %.d file as a target in addition to the %.o
# file for the rule that is generated for each source file, so that if one of
# the headers, or the source file changes, the dependency file is also
# rebuilt. This covers all of the necessary dependencies.
depend-info:
	@echo "Dependency settings:\n  $(CC) $(CPREPROCFLAGS) -M -MF<DEST> -MT<DEST> -MT<SOURCEOBJ> \"<SOURCE>\""

%.d: %.$(SRCEXT)
	@echo "  DEPEND $< -> $@" && $(CC) $(CPREPROCFLAGS) -M -MF"$@" -MT"$@" -MT"$(@:.d=.o)" "$<"

# This include will fail at first if one of the needed %.d files does not yet
# exist, but this is NOT a problem, because 
include $(DEPENDENCIES)

