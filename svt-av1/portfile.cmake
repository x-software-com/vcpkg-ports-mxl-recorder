vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.com
    OUT_SOURCE_PATH SOURCE_PATH
    REPO AOMediaCodec/SVT-AV1
    REF "v${VERSION}"
    SHA512 f86ced4728f8334d40cb52a9be1c397e2a8419299ae92295cfd4f81f8678332bce4dc6d8ca48f303d337cfb6e04122f084b5a0359f17aa8a07b5b6795afcfb93
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
