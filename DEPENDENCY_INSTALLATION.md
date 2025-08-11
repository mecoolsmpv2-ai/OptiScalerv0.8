# OptiScaler Dependency Installation

This document explains how to install the required dependencies for building OptiScaler on Windows.

## Quick Start

1. **Run the basic installer** (recommended for most users):
   ```
   install_dependencies.bat
   ```

2. **If the basic installer fails**, use the advanced installer:
   ```
   install_dependencies_advanced.bat
   ```

## What These Installers Do

Both installers will download and install the following dependencies:

- **spdlog** - Fast logging library
- **simpleini** - Simple INI file parser
- **unordered_dense** - Fast hash table implementation
- **Vulkan Headers** - Vulkan API headers
- **FidelityFX SDK** - AMD FidelityFX upscaling technology
- **magic_enum** - Compile-time enum utilities
- **Intel XeSS SDK** - Intel's upscaling technology

## Prerequisites

- **Git** (for the basic installer)
- **PowerShell** (for the advanced installer)
- **Visual Studio 2022** or **Visual Studio Build Tools**

## Installation Methods

### Method 1: Git Submodules (Basic Installer)
The `install_dependencies.bat` script:
- Uses git submodules to download dependencies
- Faster and more reliable if git is available
- Maintains proper version control

### Method 2: Direct Downloads (Advanced Installer)
The `install_dependencies_advanced.bat` script:
- Downloads dependencies directly from GitHub
- Works even without git
- Has fallback mechanisms for failed downloads
- Automatically fixes directory structures

## Troubleshooting

### Common Issues

1. **"Git is not installed"**
   - Download and install Git from: https://git-scm.com/download/win
   - Or use the advanced installer instead

2. **"Visual Studio build tools not found"**
   - Install Visual Studio Build Tools
   - Or run from a Visual Studio Developer Command Prompt

3. **"Some dependencies are missing"**
   - Run the installer again
   - Check your internet connection
   - Try the advanced installer if the basic one fails

### Manual Installation

If both installers fail, you can manually download dependencies:

1. **spdlog**: https://github.com/gabime/spdlog
2. **simpleini**: https://github.com/brofield/simpleini
3. **unordered_dense**: https://github.com/martinus/unordered_dense
4. **Vulkan Headers**: https://github.com/KhronosGroup/Vulkan-Headers
5. **FidelityFX SDK**: https://github.com/GPUOpen-LibrariesAndSDKs/FidelityFX-SDK
6. **magic_enum**: https://github.com/Neargye/magic_enum
7. **Intel XeSS**: https://github.com/intel/xess

Place them in the `external/` directory with the correct folder names.

## After Installation

Once dependencies are installed, you can:

1. **Open OptiScaler.sln** in Visual Studio 2022
2. **Build the solution** (Ctrl+Shift+B)
3. **Or use MSBuild** from command line

## Notes

- Some dependencies like NVIDIA DLSS SDK may require manual installation
- The installers automatically fix common directory structure issues
- Dependencies are downloaded to the `external/` folder
- The original `setup_windows.bat` is for installing the compiled DLL, not dependencies