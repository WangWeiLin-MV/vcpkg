# This library cannot easily be found only. Be aware that the original source repository is not accessible.
# Checking for updates needs to be done manually by trying to increase the version in the link.
# med-fichier is needed to build all libraries of the https://www.salome-platform.org/ since it is the io 
# entry point to open and read .med files.
vcpkg_download_distfile(ARCHIVE
    URLS "https://files.salome-platform.org/Salome/medfile/med-${VERSION}.tar.gz"
    HEADERS "Referer: https://www.salome-platform.org/"
    FILENAME "med-${VERSION}.tar.gz"
    SHA512 f211fa82750a7cc935baa3a50a55d16e40117a0f2254b482492ba8396d82781ca84960995da7a16b2b5be0b93ce76368bf4b311bb8af0e5f0243e7051c9c554c
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES
        hdf5.patch                  # CMake patches for hdf5
        hdf5-2.patch                # source patches to fix API version of HDF5
        more-fixes.patch            # include fixes
        0005-tools-copy.patch
)

foreach(_source_file IN ITEMS
    "src/CMakeLists.txt"
    "src/CMakeLists.txt.in"
    "tools/medimport/CMakeLists.txt"
    "tools/medimport/CMakeLists.txt.in"
    )
    vcpkg_replace_string("${SOURCE_PATH}/${_source_file}" [[ DESTINATION lib${LIB_SUFFIX})]] [[ DESTINATION lib${LIB_SUFFIX} RUNTIME DESTINATION bin)]])
endforeach()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static"  MEDFILE_BUILD_STATIC_LIBS)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" MEDFILE_BUILD_SHARED_LIBS)

# If there are problems with the cmake build try switching to autotools for !windows
vcpkg_cmake_configure(
    DISABLE_PARALLEL_CONFIGURE # Writes into the source dir
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMEDFILE_BUILD_SHARED_LIBS=${MEDFILE_BUILD_SHARED_LIBS}
        -DMEDFILE_BUILD_STATIC_LIBS=${MEDFILE_BUILD_STATIC_LIBS}
        -DMEDFILE_INSTALL_DOC=OFF
        -DMEDFILE_BUILD_TESTS=OFF
        -DCMAKE_Fortran_COMPILER=NOTFOUND # Disable Fortran
)

vcpkg_cmake_install()

set(_config_path "")
if(VCPKG_TARGET_IS_WINDOWS)
    set(_config_path "cmake")
else()
    set(_config_path "share/cmake/medfile-${VERSION}")
endif()

vcpkg_cmake_config_fixup(PACKAGE_NAME MEDFile CONFIG_PATH ${_config_path})
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/MEDFile/MEDFileConfig.cmake" "${_config_path}" "share/MEDFile")

set(tool_list mdump mdump2 mdump3 mdump4 medconforme)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    list(APPEND tool_list medimport)
endif()

vcpkg_copy_tools(TOOL_NAMES ${tool_list} AUTO_CLEAN)

foreach(xdump_file IN ITEMS xmdump xmdump2 xmdump3 xmdump4)
    file(RENAME "${CURRENT_PACKAGES_DIR}/bin/${xdump_file}" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/${xdump_file}")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/${xdump_file}" "${CURRENT_PACKAGES_DIR}/bin/" [[`dirname $0`/]])
    file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/${xdump_file}")
endforeach()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING.LESSER") # GPL seems to be mentioned due to autotools stuff
