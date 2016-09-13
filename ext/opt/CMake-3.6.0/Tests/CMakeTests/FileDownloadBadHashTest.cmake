set(url "file:///panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/CMakeTests/FileDownloadInput.png")
set(dir "/panfs/biopan01/users/312793/PhaME/ext/opt/CMake-3.6.0/Tests/CMakeTests/downloads")

file(DOWNLOAD
  ${url}
  ${dir}/file3.png
  TIMEOUT 2
  STATUS status
  EXPECTED_HASH SHA1=5555555555555555555555555555555555555555
  )
