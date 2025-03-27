vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pipewire/pipewire
    REF "${VERSION}"
    SHA512 d861f55b199ddf5683374bbc2129fc4c370a3834d6d7fea0e66c5b2af7e13fb30a29c3aaa91207511581e03ac690b849619b820bec468295de3f918d14e0c3cb
    HEAD_REF master # branch name
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dalsa=disabled
        -Daudioconvert=enabled
        -Daudiomixer=disabled
        -Daudiotestsrc=disabled
        -Davb=disabled
        -Davahi=disabled
        -Dbluez5-backend-hfp-native=disabled
        -Dbluez5-backend-hsp-native=disabled
        -Dbluez5-backend-hsphfpd=disabled
        -Dbluez5-backend-ofono=disabled
        -Dbluez5-codec-aac=disabled
        -Dbluez5-codec-aptx=disabled
        -Dbluez5-codec-lc3plus=disabled
        -Dbluez5-codec-ldac=disabled
        -Dbluez5=disabled
        -Dcontrol=disabled
        -Ddbus=disabled
        -Ddocs=disabled
        -Decho-cancel-webrtc=disabled
        -Devl=disabled
        -Dexamples=disabled
        -Dffmpeg=disabled
        -Dgstreamer-device-provider=enabled
        -Dgstreamer=enabled
        -Dinstalled_tests=disabled
        -Djack-devel=false
        -Djack=disabled
        -Dlegacy-rtkit=false
        -Dlibcamera=disabled
        -Dlibcanberra=disabled
        -Dlibpulse=disabled
        -Dlibusb=disabled
        -Dlv2=disabled
        -Dman=disabled
        -Dopus=disabled
        -Dpipewire-alsa=disabled
        -Dpipewire-jack=disabled
        -Dpipewire-v4l2=disabled
        -Dpw-cat=disabled
        -Draop=disabled
        -Droc=disabled
        -Dsdl2=disabled
        -Dsndfile=disabled
        -Dspa-plugins=enabled # This one must be enabled or the resulting build won't be able to connect to pipewire daemon
        -Dsupport=enabled # This one must be enabled or the resulting build won't be able to connect to pipewire daemon
        -Dsystemd-system-service=disabled
        -Dsystemd-system-unit-dir=disabled
        -Dsystemd-user-service=disabled
        -Dsystemd-user-unit-dir=disabled
        -Dsystemd=disabled
        -Dtest=disabled
        -Dtests=disabled
        -Dudev=disabled
        -Dudevrulesdir=disabled
        -Dv4l2=disabled
        -Dvideoconvert=disabled
        -Dvideotestsrc=disabled
        -Dvolume=disabled
        -Dvulkan=disabled
        -Dx11-xfixes=disabled
        -Dx11=disabled
        -Dsession-managers=[]
        -Dc_args=-Wno-strict-prototypes
)
vcpkg_install_meson()
vcpkg_copy_pdbs()

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

# remove absolute paths
file(GLOB config_files "${CURRENT_PACKAGES_DIR}/share/${PORT}/*.conf")
foreach(file ${config_files})
    vcpkg_replace_string("${file}" "in ${CURRENT_PACKAGES_DIR}/etc/pipewire for system-wide changes\n# or" "" IGNORE_UNCHANGED)
    cmake_path(GET file FILENAME filename)
    vcpkg_replace_string("${file}" "# ${CURRENT_PACKAGES_DIR}/etc/pipewire/${filename}.d/ for system-wide changes or in" "" IGNORE_UNCHANGED)
endforeach()
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/pipewire/pipewire.conf" "${CURRENT_PACKAGES_DIR}/bin" "")
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/pipewire/minimal.conf" "${CURRENT_PACKAGES_DIR}/bin" "")


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