#include "pch_minimal.h"
#include <iostream>

// DLL entry point
BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        dllModule = hModule;
        processId = GetCurrentProcessId();
        // Initialize basic functionality
        break;
    case DLL_THREAD_ATTACH:
        // New thread is being created
        break;
    case DLL_THREAD_DETACH:
        // Thread is being destroyed
        break;
    case DLL_PROCESS_DETACH:
        // DLL is being unloaded
        break;
    }
    return TRUE;
}

// Export basic functions
extern "C" __declspec(dllexport) HMODULE GetOptiScalerModule()
{
    return dllModule;
}

extern "C" __declspec(dllexport) DWORD GetOptiScalerProcessId()
{
    return processId;
}

extern "C" __declspec(dllexport) const char* GetOptiScalerVersion()
{
    return "OptiScaler Minimal Build v1.0";
}