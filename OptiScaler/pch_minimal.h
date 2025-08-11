#pragma once
#pragma warning(disable : 4996)

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_DEPRECATE
#include <Windows.h>
#include <string>
#include <stdint.h>
#include <libloaderapi.h>
#include <ranges>
#include <algorithm>

#define NV_WINDOWS
#define NVSDK_NGX
#define NGX_ENABLE_DEPRECATED_GET_PARAMETERS
#define NGX_ENABLE_DEPRECATED_SHUTDOWN
#include <nvsdk_ngx.h>
#include <nvsdk_ngx_defs.h>

#define VK_USE_PLATFORM_WIN32_KHR

#define BUFFER_COUNT 4

// Simplified logging without spdlog
#define LOG_TRACE(msg, ...) 
#define LOG_DEBUG(msg, ...) 
#define LOG_DEBUG_ONLY(msg, ...) 
#define LOG_DEBUG_ASYNC(msg, ...) 
#define LOG_INFO(msg, ...) 
#define LOG_WARN(msg, ...) 
#define LOG_ERROR(msg, ...) 
#define LOG_FUNC() 
#define LOG_FUNC_RESULT(result) 

inline HMODULE dllModule = nullptr;
inline HMODULE exeModule = nullptr;
inline HMODULE originalModule = nullptr;
inline HMODULE skModule = nullptr;
inline HMODULE reshadeModule = nullptr;
inline HMODULE vulkanModule = nullptr;
inline HMODULE d3d11Module = nullptr;
inline DWORD processId;

struct feature_version
{
    unsigned int major;
    unsigned int minor;
    unsigned int patch;

    bool operator==(const feature_version& other) const
    {
        return major == other.major && minor == other.minor && patch == other.patch;
    }

    bool operator!=(const feature_version& other) const { return !(*this == other); }

    bool operator<(const feature_version& other) const
    {
        if (major != other.major)
            return major < other.major;
        if (minor != other.minor)
            return minor < other.minor;
        return patch < other.patch;
    }

    bool operator>(const feature_version& other) const { return other < *this; }

    bool operator<=(const feature_version& other) const { return !(other < *this); }

    bool operator>=(const feature_version& other) const { return !(*this < other); }
};

enum Value : uint32_t
{
    Invalid = 0,
    Microsoft = 0x1414, // Software Render Adapter
    Nvidia = 0x10DE,
    AMD = 0x1002,
    Intel = 0x8086,
};

inline static std::string wstring_to_string(const std::wstring& wide_str)
{
    if (wide_str.empty()) return std::string();
    int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wide_str[0], (int)wide_str.size(), NULL, 0, NULL, NULL);
    std::string strTo(size_needed, 0);
    WideCharToMultiByte(CP_UTF8, 0, &wide_str[0], (int)wide_str.size(), &strTo[0], size_needed, NULL, NULL);
    return strTo;
}

inline static std::wstring string_to_wstring(const std::string& str)
{
    if (str.empty()) return std::wstring();
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), NULL, 0);
    std::wstring wstrTo(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), &wstrTo[0], size_needed);
    return wstrTo;
}

inline static void to_lower_in_place(std::string& string)
{
    std::transform(string.begin(), string.end(), string.begin(), ::tolower);
}