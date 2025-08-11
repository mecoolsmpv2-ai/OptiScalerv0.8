# Makefile for building OptiScaler DLL using MinGW-w64 cross-compilation
# This is a simplified build that focuses on the core functionality

# Cross-compilation tools
CC = x86_64-w64-mingw32-gcc
CXX = x86_64-w64-mingw32-g++
WINDRES = x86_64-w64-mingw32-windres
AR = x86_64-w64-mingw32-ar
STRIP = x86_64-w64-mingw32-strip

# Build configuration
BUILD_CONFIG = Release
PLATFORM = x64
TARGET = OptiScaler.dll

# Directories
SRC_DIR = OptiScaler
BUILD_DIR = build
OUTPUT_DIR = $(BUILD_DIR)/$(BUILD_CONFIG)/$(PLATFORM)

# Compiler flags
CXXFLAGS = -std=c++17 -O2 -DNDEBUG -D_WINDOWS -D_USRDLL -D_UNICODE -DUNICODE
CXXFLAGS += -DWIN32_LEAN_AND_MEAN -D_WIN32_WINNT=0x0601
CXXFLAGS += -I$(SRC_DIR) -I$(SRC_DIR)/include -I$(SRC_DIR)/include/imgui
CXXFLAGS += -I$(SRC_DIR)/include/sl.param -I$(SRC_DIR)/include/imgui/misc/freetype
CXXFLAGS += -I/usr/x86_64-w64-mingw32/include
CXXFLAGS += -Iexternal/freetype/include -Iexternal/simpleini -Iexternal/spdlog/include
CXXFLAGS += -Iexternal/nlohmann -Iexternal/magic_enum/include -Iexternal/unordered_dense/include
CXXFLAGS += -Iexternal/nvngx_dlss_sdk

# Linker flags
LDFLAGS = -shared -Wl,--subsystem,windows
LDFLAGS += -Lexternal/freetype/lib -lfreetype
LDFLAGS += -luser32 -lkernel32 -lgdi32 -ldxgi -ld3d11 -ld3d12 -lvulkan-1
LDFLAGS += -ld3dcompiler -ldxguid -ldbghelp

# Source files (core functionality)
SOURCES = \
	$(SRC_DIR)/dllmain.cpp \
	$(SRC_DIR)/Config.cpp \
	$(SRC_DIR)/Logger.cpp \
	$(SRC_DIR)/Util.cpp \
	$(SRC_DIR)/State.cpp \
	$(SRC_DIR)/menu/menu_common.cpp \
	$(SRC_DIR)/menu/menu_dx_base.cpp \
	$(SRC_DIR)/menu/menu_dx11.cpp \
	$(SRC_DIR)/menu/menu_dx12.cpp \
	$(SRC_DIR)/menu/menu_overlay_base.cpp \
	$(SRC_DIR)/menu/menu_overlay_dx.cpp \
	$(SRC_DIR)/menu/menu_overlay_vk.cpp \
	$(SRC_DIR)/hooks/HooksDx.cpp \
	$(SRC_DIR)/hooks/HooksVk.cpp \
	$(SRC_DIR)/hooks/wrapped_swapchain.cpp \
	$(SRC_DIR)/include/imgui/imgui.cpp \
	$(SRC_DIR)/include/imgui/imgui_demo.cpp \
	$(SRC_DIR)/include/imgui/imgui_draw.cpp \
	$(SRC_DIR)/include/imgui/imgui_tables.cpp \
	$(SRC_DIR)/include/imgui/imgui_widgets.cpp \
	$(SRC_DIR)/include/imgui/imgui_impl_dx11.cpp \
	$(SRC_DIR)/include/imgui/imgui_impl_dx12.cpp \
	$(SRC_DIR)/include/imgui/imgui_impl_win32.cpp \
	$(SRC_DIR)/include/imgui/imgui_impl_vulkan.cpp \
	$(SRC_DIR)/include/imgui/misc/freetype/imgui_freetype.cpp \
	$(SRC_DIR)/include/sl.param/parameters.cpp

# Object files
OBJECTS = $(SOURCES:%.cpp=$(BUILD_DIR)/%.o)

# Default target
all: $(OUTPUT_DIR)/$(TARGET)

# Create output directory
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Build the DLL
$(OUTPUT_DIR)/$(TARGET): $(OBJECTS) | $(OUTPUT_DIR)
	$(CXX) $(OBJECTS) -o $@ $(LDFLAGS)
	$(STRIP) $@
	@echo "Build complete: $@"

# Compile source files
$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean build files
clean:
	rm -rf $(BUILD_DIR)

# Install dependencies (placeholder)
deps:
	@echo "Note: External dependencies should be pre-built or obtained separately"
	@echo "This Makefile assumes pre-built libraries are available in external/ directories"

# Help
help:
	@echo "Available targets:"
	@echo "  all      - Build the OptiScaler DLL"
	@echo "  clean    - Remove build files"
	@echo "  deps     - Show dependency information"
	@echo "  help     - Show this help message"

.PHONY: all clean deps help