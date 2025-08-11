#include <windows.h>

// DLL entry point
BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        // DLL is being loaded
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

// Export a simple function
extern "C" __declspec(dllexport) int TestFunction()
{
    return 42;
}