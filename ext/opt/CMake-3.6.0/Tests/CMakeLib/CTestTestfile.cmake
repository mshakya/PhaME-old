# CMake generated Testfile for 
# Source directory: /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/CMakeLib
# Build directory: /panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/CMakeLib
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(CMakeLib.testGeneratedFileStream "CMakeLibTests" "testGeneratedFileStream")
add_test(CMakeLib.testRST "CMakeLibTests" "testRST" "/panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/CMakeLib")
add_test(CMakeLib.testSystemTools "CMakeLibTests" "testSystemTools")
add_test(CMakeLib.testUTF8 "CMakeLibTests" "testUTF8")
add_test(CMakeLib.testXMLParser "CMakeLibTests" "testXMLParser")
add_test(CMakeLib.testXMLSafe "CMakeLibTests" "testXMLSafe")
subdirs(PseudoMemcheck)
