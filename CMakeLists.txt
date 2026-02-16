cmake_minimum_required(VERSION 3.10)
project(project_name C)

set(PROJECT_VERSION "1.0.0")

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Compiler: ${CMAKE_C_COMPILER_ID}")

if(WIN32)
    #find_package(unofficial-sodium CONFIG REQUIRED)
    #find_package(FLTK CONFIG REQUIRED)
else()
    #find_package(FLTK REQUIRED)
    #find_package(PkgConfig REQUIRED)
    #pkg_check_modules(SODIUM REQUIRED libsodium)
endif()


add_executable(project_name
    src/main.c
)

if(WIN32)
    #set_target_properties(project_name PROPERTIES WIN32_EXECUTABLE TRUE)
endif()

if(WIN32)
    #target_link_libraries(project_name PRIVATE unofficial-sodium::sodium)
else()
    #target_include_directories(project_name PRIVATE ${SODIUM_INCLUDE_DIRS})
    #target_link_libraries(project_name PRIVATE ${SODIUM_LIBRARIES})
endif()

target_include_directories(project_name PRIVATE
    ${PROJECT_SOURCE_DIR}/include
)

target_compile_definitions(project_name PRIVATE
    PROJECT_VERSION=\"${PROJECT_VERSION}\"
)

# ==============================
# Compiler-specific configuration
# ==============================

if (MSVC)

    # Debug
    target_compile_options(project_name PRIVATE
        $<$<CONFIG:Debug>:/Zi /Od>
    )
    target_link_options(project_name PRIVATE
        $<$<CONFIG:Debug>:/DEBUG>
    )
    target_compile_definitions(project_name PRIVATE
        $<$<CONFIG:Debug>:DEBUG_MODE=1>
    )

    # Release
    target_compile_options(project_name PRIVATE
        $<$<CONFIG:Release>:/O2>
    )
    target_compile_definitions(project_name PRIVATE
        $<$<CONFIG:Release>:NDEBUG>
    )

else() # GCC / Clang

    # Debug
    target_compile_options(project_name PRIVATE
        $<$<CONFIG:Debug>:-g -O0 -fno-omit-frame-pointer>
    )
    target_compile_definitions(project_name PRIVATE
        $<$<CONFIG:Debug>:DEBUG_MODE=1>
    )

    # Optional ASAN (ONLY here)
    target_compile_options(project_name PRIVATE
        $<$<CONFIG:Debug>:-fsanitize=address>
    )
    target_link_options(project_name PRIVATE
        $<$<CONFIG:Debug>:-fsanitize=address>
    )

    # Release
    target_compile_options(project_name PRIVATE
        $<$<CONFIG:Release>:-O3>
    )
    target_compile_definitions(project_name PRIVATE
        $<$<CONFIG:Release>:NDEBUG>
    )

endif()
