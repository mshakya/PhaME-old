# CMake generated Testfile for 
# Source directory: /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0
# Build directory: /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
include("/panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/EnforceConfig.cmake")
add_test(SystemInformationNew "/panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/bin/cmake" "--system-information" "-G" "Unix Makefiles")
subdirs(Source/kwsys)
subdirs(Utilities/KWIML)
subdirs(Utilities/cmzlib)
subdirs(Utilities/cmcurl)
subdirs(Utilities/cmcompress)
subdirs(Utilities/cmbzip2)
subdirs(Utilities/cmliblzma)
subdirs(Utilities/cmlibarchive)
subdirs(Utilities/cmexpat)
subdirs(Utilities/cmjsoncpp)
subdirs(Source/CursesDialog/form)
subdirs(Source)
subdirs(Utilities)
subdirs(Tests)
subdirs(Auxiliary)
