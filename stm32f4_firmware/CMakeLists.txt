cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# specify toolchain file
set(CMAKE_TOOLCHAIN_FILE
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain-arm-none-eabi.cmake"
    CACHE STRING "Toolchain file")

# Use C and assembly
project(yet_another_bms_firmware LANGUAGES C ASM)

# Make exported compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Project wide-include paths
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/inc
  ${CMAKE_CURRENT_SOURCE_DIR}/lib/cmsis-f4/Include
  ${CMAKE_CURRENT_SOURCE_DIR}/lib/cmsis-f4/Source/Templates
  ${CMAKE_CURRENT_SOURCE_DIR}/lib/stm32f4-hal/Inc
  ${CMAKE_CURRENT_SOURCE_DIR}/lib/cmsis-core/Include
)

# Source files
set(SOURCES
  src/main.c
  utils/noinit.c
  utils/system_stm32f4xx.c
  utils/startup_stm32f411xe.s
  lib/stm32f4-hal/Src/stm32f4xx_ll_gpio.c
  lib/stm32f4-hal/Src/stm32f4xx_ll_rcc.c
  lib/stm32f4-hal/Src/stm32f4xx_ll_utils.c
)

add_executable(${PROJECT_NAME}.elf ${SOURCES})


# Compiler flags
target_compile_options(${PROJECT_NAME}.elf PRIVATE
  -mcpu=cortex-m4
  -mthumb
  -mfpu=fpv4-sp-d16
  -mfloat-abi=hard
  -g
  -Wall
  -ffunction-sections
  -fdata-sections
)

# Defines / preprocessors macros
target_compile_definitions(${PROJECT_NAME}.elf PRIVATE
  STM32F411xE
  USE_FULL_LL_DRIVER
)

# Linker script
target_link_options(${PROJECT_NAME}.elf PUBLIC
  "-T${CMAKE_CURRENT_SOURCE_DIR}/utils/linker.ld"
  "-Wl,-Map=${PROJECT_NAME}.map"
  "-Wl,--gc-sections"
)

# Optionally, after build produce .bin / .hex
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.bin
    COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.hex
)

## Optionally a “flash” target using OpenOCD or ST‑link
#find_program(OPENOCD openocd)
#if(OPENOCD)
#    add_custom_target(flash
#        COMMAND ${OPENOCD} -f interface/stlink.cfg -f target/stm32f4x.cfg \
#                -c "program ${PROJECT_NAME}.elf verify reset; exit"
#        DEPENDS ${PROJECT_NAME}.elf
#    )
#endif()

