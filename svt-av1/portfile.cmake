vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.com
    OUT_SOURCE_PATH SOURCE_PATH
    REPO AOMediaCodec/SVT-AV1
    REF "v${VERSION}"
    SHA512 2b3af9bd9afa19a2f90e6c9413f1b47047800440c02b67f68f2fe77f2a5385d73bec42057d4f5948e4a267e72d88114d40cdd3d56305f31557f7a8547c69a9c9
    HEAD_REF master
    PATCHES
        ${PATCHES}
)

vcpkg_find_acquire_program(FLEX)
vcpkg_find_acquire_program(BISON)
vcpkg_find_acquire_program(NASM)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_APPS=OFF
    ADDITIONAL_BINARIES
        flex='${FLEX}'
        bison='${BISON}'
        nasm='${NASM}'
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()

# Remove duplicated folders in debug directory
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/tools"
)

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md" "${SOURCE_PATH}/PATENTS.md")
