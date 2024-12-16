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
