if(PkgConfig_FOUND)
    pkg_check_modules(FFMPEG REQUIRED IMPORTED_TARGET libavcodec libavfilter libavformat libavutil libswscale libswresample)
else()
    find_package(FFMPEG QUIET)
endif()

if(FFMPEG_FOUND)
    message(STATUS "Found FFmpeg: ${FFMPEG_CONFIG} (found version \"${FFMPEG_VERSION}\")")
    add_compile_definitions(WITH_FFMPEG)
    include_directories(${FFMPEG_INCLUDE_DIRS})
    link_directories(${FFMPEG_LIBRARY_DIRS})

    file(GLOB codeFile src/modules/endecode/*.cpp src/nodes/ffvcodec/*.c??)
    set(LibFiles "${LibFiles};${codeFile}")

    file(GLOB ModuleLibFiles src/modules/codec/*.cpp)
    add_library(gddi_codec SHARED ${ModuleLibFiles})
    set_target_properties(gddi_codec PROPERTIES PUBLIC_HEADER "src/modules/codec/demux_stream_v3.h;src/modules/codec/decode_video_v3.h")
    set_target_properties(gddi_codec PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
    target_link_libraries(gddi_codec PRIVATE ${FFMPEG_LIBRARIES} spdlog::spdlog Boost::filesystem)

    if(${TARGET_CHIP} STREQUAL "rv1126")
        target_link_libraries(gddi_codec PRIVATE rockchip_mpp)
        set(LinkLibraries "${LinkLibraries};gddi_codec;${FFMPEG_LIBRARIES};rockchip_mpp")
    elseif(${TARGET_CHIP} STREQUAL "mlu370")
        target_link_libraries(gddi_codec PRIVATE cncodec_v3)
        set(LinkLibraries "${LinkLibraries};gddi_codec;${FFMPEG_LIBRARIES};cncodec_v3")
    elseif(${TARGET_CHIP} STREQUAL "jetson")
        target_link_libraries(gddi_codec PRIVATE v4l2)
        set(LinkLibraries "${LinkLibraries};gddi_codec;${FFMPEG_LIBRARIES};v4l2")
    else()
        set(LinkLibraries "${LinkLibraries};gddi_codec;${FFMPEG_LIBRARIES}")
    endif()

    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/release/${CMAKE_SYSTEM_PROCESSOR}/${TARGET_CHIP}/${CHIP_NAME}")
        install(TARGETS gddi_codec
            ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
            PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
    endif()
else()
    message(STATUS "FFmpeg not found, decoder with FFmpeg disabled!")
endif()