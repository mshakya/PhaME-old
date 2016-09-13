# CMake generated Testfile for 
# Source directory: /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Utilities/cmcurl
# Build directory: /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Utilities/cmcurl
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(curl "LIBCURL" "http://open.cdash.org/user.php")
subdirs(lib)
