# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.6

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Bootstrap.cmk/cmake

# The command to remove a file.
RM = /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Bootstrap.cmk/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0

# Include any dependencies generated for this target.
include Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/depend.make

# Include the progress variables for this target.
include Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/progress.make

# Include the compile flags for this target's objects.
include Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/flags.make

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o: Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/flags.make
Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o: Tests/RunCMake/pseudo_iwyu.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o"
	cd /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake && /cm/local/apps/gcc/5.1.0/bin/gcc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o   -c /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake/pseudo_iwyu.c

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.i"
	cd /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake && /cm/local/apps/gcc/5.1.0/bin/gcc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake/pseudo_iwyu.c > CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.i

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.s"
	cd /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake && /cm/local/apps/gcc/5.1.0/bin/gcc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake/pseudo_iwyu.c -o CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.s

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.requires:

.PHONY : Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.requires

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.provides: Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.requires
	$(MAKE) -f Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/build.make Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.provides.build
.PHONY : Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.provides

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.provides.build: Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o


# Object files for target pseudo_iwyu
pseudo_iwyu_OBJECTS = \
"CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o"

# External object files for target pseudo_iwyu
pseudo_iwyu_EXTERNAL_OBJECTS =

Tests/RunCMake/pseudo_iwyu: Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o
Tests/RunCMake/pseudo_iwyu: Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/build.make
Tests/RunCMake/pseudo_iwyu: Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable pseudo_iwyu"
	cd /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/pseudo_iwyu.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/build: Tests/RunCMake/pseudo_iwyu

.PHONY : Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/build

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/requires: Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/pseudo_iwyu.c.o.requires

.PHONY : Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/requires

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/clean:
	cd /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake && $(CMAKE_COMMAND) -P CMakeFiles/pseudo_iwyu.dir/cmake_clean.cmake
.PHONY : Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/clean

Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/depend:
	cd /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0 /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0 /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Tests/RunCMake/CMakeFiles/pseudo_iwyu.dir/depend

