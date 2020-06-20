#### PROJECT SETTINGS ####
# The name of the executable to be created
BIN_NAME := skeleton
# Compiler used
CXX ?= g++
# Extension of source files used in the project
SRC_EXT = cpp
# Path to the source directory, relative to the makefile
SRC_PATH = ./src
# Path to the external includes, relative to the makefile
INCLUDE_PATH = ./include
# Path to the external libraries, relative to the makefile
LIBS_PATH = ./lib
# Space-separated pkg-config libraries used by this project
LIBS =
# General compiler flags
COMPILE_FLAGS = -std=c++14 -Wall -Wextra -g
# Additional release-specific flags
RCOMPILE_FLAGS = -D NDEBUG
# Additional debug-specific flags
DCOMPILE_FLAGS = -D DEBUG
# Add additional include paths
INCLUDES = -I$(SRC_PATH) -I$(INCLUDE_PATH)
# General linker settings
LINK_FLAGS = -L$(LIBS_PATH)
# Additional release-specific linker settings
RLINK_FLAGS =
# Additional debug-specific linker settings
DLINK_FLAGS =
# Destination directory, like a jail or mounted system
DESTDIR = /
# Install path (bin/ is appended automatically)
INSTALL_PREFIX = usr/local
#### END PROJECT SETTINGS ####