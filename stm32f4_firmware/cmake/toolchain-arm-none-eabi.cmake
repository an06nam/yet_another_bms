# Simple toolchain-arm-none-eabi.cmake
# Minimal cross-toolchain file for Cortex-M (arm-none-eabi)
# Usage:
#   cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-arm-none-eabi.cmake

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Default compiler prefix (edit if your toolchain has a different name)
set(TOOLCHAIN_PREFIX "arm-none-eabi-")

# Compilers and common tools (use prefix; assume tools are in PATH)
set(CMAKE_C_COMPILER   "${TOOLCHAIN_PREFIX}gcc")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}g++")
set(CMAKE_OBJCOPY      "${TOOLCHAIN_PREFIX}objcopy")
set(CMAKE_SIZE         "${TOOLCHAIN_PREFIX}size")

# Language standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Basic target CPU/FPU flags commonly used for STM32F4 (override in project if needed)
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")

# Linker flags (minimal; project can add -T linker script and -Wl,-Map=...)
set(CMAKE_EXE_LINKER_FLAGS "-nostdlib -Wl,--gc-sections --specs=nosys.specs")

# Small helpful summary when CMake configures the project
message(STATUS "[toolchain] prefix=${TOOLCHAIN_PREFIX}")
message(STATUS "[toolchain] c compiler=${CMAKE_C_COMPILER}")
message(STATUS "[toolchain] objcopy=${CMAKE_OBJCOPY}")
