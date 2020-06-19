PROGRAM					= skeleton


#CC                    = gcc
CXX                   = g++
#CC                    = $(CXX)

EXTRA_CFLAGS			= -g -fdata-sections -ffunction-sections

EXTRA_LDFLAGS			= -lSDL2 -lSDL2_image

INCLUDE					= -I./include -I./src

CPPFLAGS				= -Wall -Wextra -std=c++17   # helpful for writing better code (behavior-related)

LDFLAGS					=

SRCDIRS					:= ./src
BINDIR					= ./bin

# OS specific. 
EXTRA_CFLAGS_MACOS		= 
EXTRA_LDFLAGS_MACOS		= -Wl,-search_paths_first -Wl,-dead_strip -v
LDFLAGS_MACOS			=
EXTRA_CFLAGS_LINUX		=
EXTRA_LDFLAGS_LINUX		= -Wl,--gc-sections -Wl,--strip-all
LDFLAGS_LINUX			=
EXTRA_CFLAGS_WINDOWS	=
EXTRA_LDFLAGS_WINDOWS	=
LDFLAGS_WINDOWS			=

UNAME_S			:= $(shell uname -s)
ifeq ($(UNAME_S), Darwin)		# if MacOS
EXTRA_CFLAGS	+= $(EXTRA_CFLAGS_MACOS)
EXTRA_LDFLAGS	+= $(EXTRA_LDFLAGS_MACOS)
LDFLAGS			+= $(LDFLAGS_MACOS)
else ifeq ($(UNAME_S), Linux)	# if Linux
EXTRA_CFLAGS	+= $(EXTRA_CFLAGS_LINUX)
EXTRA_LDFLAGS	+= $(EXTRA_LDFLAGS_LINUX)
LDFLAGS			+= $(LDFLAGS_LINUX) 
else							# Windows, or... need to specify "MINGW" or "CYGWIN" to correctly detect. 
EXTRA_CFLAGS	+= $(EXTRA_CFLAGS_WINDOWS)
EXTRA_LDFLAGS	+= $(EXTRA_LDFLAGS_WINDOWS)
LDFLAGS			+= $(LDFLAGS_WINDOWS)
endif

CPPFLAGS		+= $(INCLUDE)

SRCEXTS = .c .C .cc .cpp .CPP .c++ .cxx .cp
HDREXTS = .h .H .hh .hpp .HPP .h++ .hxx .hp

CFLAGS		= -O3
CXXFLAGS	= -O3

RM			= rm -f

ETAGS		= etags
ETAGSFLAGS	=

CTAGS		= ctags
CTAGSFLAGS	=

ifeq ($(SRCDIRS),)
	SRCDIRS := $(shell find $(SRCDIRS) -type d)
endif
SOURCES = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCEXTS))))
HEADERS = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(HDREXTS))))
SRC_CXX = $(filter-out %.c,$(SOURCES))
OBJS	= $(addsuffix .o, $(addprefix $(BINDIR)/,$(notdir $(basename $(SOURCES)))))
DEPS    = $(OBJS:%.o=%.d) #replace %.d with .%.d (hide dependency files)
#DEPS	= $(foreach f, $(OBJS), $(addprefix $(dir $(f))., $(patsubst %.o, %.d, $(notdir $(f)))))

DEP_OPT = $(shell if `$(CC) --version | grep -i "GCC" >/dev/null`; then \
                  echo "-MM"; else echo "-M"; fi )
DEPEND.d	= $(CC) $(DEP_OPT) $(EXTRA_CFLAGS) $(CFLAGS) $(CPPFLAGS)
COMPILE.c	= $(CC) $(EXTRA_CFLAGS) $(CFLAGS) $(CPPFLAGS) -c
COMPILE.cxx	= $(CXX) $(EXTRA_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -c
LINK.c		= $(CC) $(EXTRA_CFLAGS) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LINK.cxx	= $(CXX) $(EXTRA_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

.PHONY: all dirs objs tags ctags clean distclean help show

.SUFFIXES:

all: $(BINDIR)/$(PROGRAM)

dirs:
	@echo "Creating directories"
	@mkdir -p $(dir $(OBJS))
	@mkdir -p $(BINDIR)

# Rules for creating dependency files (.d).
#------------------------------------------

$(BINDIR)/%.d: $(SRCDIRS)/%.c
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

$(BINDIR)/%.d: $(SRCDIRS)/%.C
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

$(BINDIR)/%.d: $(SRCDIRS)/%.cc
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

$(BINDIR)/%.d: $(SRCDIRS)/%.cpp
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

$(BINDIR)/%.d: $(SRCDIRS)/%.CPP
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

$(BINDIR)/%.d: $(SRCDIRS)/%.c++
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

$(BINDIR)/%.d: $(SRCDIRS)/%.cp
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

$(BINDIR)/%.d: $(SRCDIRS)/%.cxx
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

# Rules for generating object files (.o).
#----------------------------------------
objs:$(OBJS)

$(BINDIR)/%.o: $(SRCDIRS)/%.c
	$(COMPILE.c) $< -o $@

$(BINDIR)/%.o: $(SRCDIRS)/%.C
	$(COMPILE.cxx) $< -o $@

$(BINDIR)/%.o: $(SRCDIRS)/%.cc
	$(COMPILE.cxx) $< -o $@

$(BINDIR)/%.o: $(SRCDIRS)/%.cpp
	$(COMPILE.cxx) $< -o $@

$(BINDIR)/%.o: $(SRCDIRS)/%.CPP
	$(COMPILE.cxx) $< -o $@

$(BINDIR)/%.o: $(SRCDIRS)/%.c++
	$(COMPILE.cxx) $< -o $@

$(BINDIR)/%.o: $(SRCDIRS)/%.cp
	$(COMPILE.cxx) $< -o $@

$(BINDIR)/%.o: $(SRCDIRS)/%.cxx
	$(COMPILE.cxx) $< -o $@

# Rules for generating the tags.
#-------------------------------------
tags: $(HEADERS) $(SOURCES)
	$(ETAGS) $(ETAGSFLAGS) $(HEADERS) $(SOURCES)

ctags: $(HEADERS) $(SOURCES)
	$(CTAGS) $(CTAGSFLAGS) $(HEADERS) $(SOURCES)

# Rules for generating the executable.
#-------------------------------------
$(BINDIR)/$(PROGRAM):$(OBJS)
ifeq ($(SRC_CXX),)              # C program
	$(LINK.c) $(OBJS) $(EXTRA_LDFLAGS) -o $@
	@echo Type ./$@ to execute the program.
else                            # C++ program
	$(LINK.cxx) $(OBJS) $(EXTRA_LDFLAGS) -o $@
	@echo Type ./$@ to execute the program.
endif

	-include $(DEPS)

clean:
	$(RM) $(OBJS) $(BINDIR)/$(PROGRAM) $(BINDIR)/$(PROGRAM).exe

distclean: clean
	$(RM) $(DEPS) TAGS

# Show help.
help:
	@echo "Pear's Generic Makefile for C/C++ Projects"
	@echo 'Copyright (C) 2016 Pear <service AT pear DOT hk>'
	@echo 'Copyright (C) 2007, 2008 whyglinux <whyglinux AT hotmail DOT com>'
	@echo 
	@echo 'Usage: make [TARGET]'
	@echo 'TARGETS:'
	@echo '  all       (=make) compile and link.'
	@echo '  NODEP=yes make without generating dependencies.'
	@echo '  objs      compile only (no linking).'
	@echo '  tags      create tags for Emacs editor.'
	@echo '  ctags     create ctags for VI editor.'
	@echo '  clean     clean objects and the executable file.'
	@echo '  distclean clean objects, the executable and dependencies.'
	@echo '  show      show variables (for debug use only).'
	@echo '  help      print this message.'
	@echo 
	@echo 'Report bugs to <whyglinux AT gmail DOT com>.'

# Show variables (for debug use only.)
show:
	@echo 'program		:' $(PROGRAM)
	@echo 'SRCDIRS		:' $(SRCDIRS)
	@echo 'headers		:' $(HEADERS)
	@echo 'SOURCES		:' $(SOURCES)
	@echo 'SRC_CXX		:' $(SRC_CXX)
	@echo 'OBJS			:' $(OBJS)
	@echo 'DEPS			:' $(DEPS)
	@echo 'DEPEND		:' $(DEPEND)
	@echo 'DEPEND.d		:' $(DEPEND.d)
	@echo 'COMPILE.c	:' $(COMPILE.c)
	@echo 'COMPILE.cxx	:' $(COMPILE.cxx)
	@echo 'link.c		:' $(LINK.c)
	@echo 'link.cxx		:' $(LINK.cxx)