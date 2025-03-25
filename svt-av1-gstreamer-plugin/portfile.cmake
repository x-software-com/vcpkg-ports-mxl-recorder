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

vcpkg_find_acquire_program(PKGCONFIG)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}/gstreamer-plugin"
)
vcpkg_install_meson()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    # Move plugins to the gstreamer directory instead of the ${PORT} directory.
    # So the plugins can be found and linxdeploy can find them during AppImage creation.
    # set(PLUGIN_DIR "${PORT}")
    set(PLUGIN_DIR "gstreamer")
    # move plugins to ${prefix}/plugins/${PLUGIN_DIR} instead of ${prefix}/lib/gstreamer-1.0
    if(NOT VCPKG_BUILD_TYPE)
        file(GLOB DBG_BINS "${CURRENT_PACKAGES_DIR}/debug/lib/gstreamer-1.0/${CMAKE_SHARED_LIBRARY_PREFIX}*${CMAKE_SHARED_LIBRARY_SUFFIX}"
                           "${CURRENT_PACKAGES_DIR}/debug/lib/gstreamer-1.0/*.pdb"
        )
        file(COPY ${DBG_BINS} DESTINATION "${CURRENT_PACKAGES_DIR}/debug/plugins/${PLUGIN_DIR}")
    endif()
    file(GLOB REL_BINS "${CURRENT_PACKAGES_DIR}/lib/gstreamer-1.0/${CMAKE_SHARED_LIBRARY_PREFIX}*${CMAKE_SHARED_LIBRARY_SUFFIX}"
                       "${CURRENT_PACKAGES_DIR}/lib/gstreamer-1.0/*.pdb"
    )
    file(COPY ${REL_BINS} DESTINATION "${CURRENT_PACKAGES_DIR}/plugins/${PLUGIN_DIR}")
    file(REMOVE ${DBG_BINS} ${REL_BINS})
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/gstreamer-1.0" "${CURRENT_PACKAGES_DIR}/lib/gstreamer-1.0")
endif()

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md" "${SOURCE_PATH}/PATENTS.md")
