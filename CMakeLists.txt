cmake_minimum_required(VERSION 3.15)
project(MasmAlignmentTest LANGUAGES ASM_MASM)

set(MASM32_PATH "${CMAKE_CURRENT_SOURCE_DIR}/MASM32-SDK")

include_directories(${MASM32_PATH}/include)
link_directories(${MASM32_PATH}/lib)

add_executable(AlignmentTest main.asm)

set_target_properties(AlignmentTest PROPERTIES
    LINK_FLAGS "/SUBSYSTEM:CONSOLE /MACHINE:X86"
)

target_compile_options(AlignmentTest PRIVATE
    $<$<COMPILE_LANGUAGE:ASM_MASM>:/c /nologo /Cp /coff>
)

target_link_libraries(AlignmentTest kernel32 user32 masm32)