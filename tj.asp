#include <iostream>
#include <windows.h>

int main() {
    // 设置新的屏幕保护时间（以秒为单位）
    DWORD newScreenSaverTimeInSeconds = 600;  // 10分钟

    // 打开注册表键
    HKEY hKey;
    if (RegOpenKeyEx(HKEY_CURRENT_USER, L"Control Panel\\Desktop", 0, KEY_WRITE, &hKey) == ERROR_SUCCESS) {
        // 设置新的屏幕保护时间
        if (RegSetValueEx(hKey, L"ScreenSaveTimeOut", 0, REG_SZ, (const BYTE*)&newScreenSaverTimeInSeconds, sizeof(newScreenSaverTimeInSeconds)) == ERROR_SUCCESS) {
            std::cout << "屏幕保护时间已成功设置为 " << newScreenSaverTimeInSeconds << " 秒。" << std::endl;
        } else {
            std::cerr << "无法设置屏幕保护时间。" << std::endl;
        }

        // 关闭注册表键
        RegCloseKey(hKey);
    } else {
        std::cerr << "无法打开注册表键。" << std::endl;
    }

    return 0;
}




#include <windows.h>
#include <iostream>

// 服务名称
#define SERVICE_NAME L"MyService"

// 函数声明
VOID WINAPI ServiceMain(DWORD argc, LPWSTR* argv);
VOID WINAPI ServiceCtrlHandler(DWORD);
BOOL InstallService();
BOOL UninstallService();
VOID WriteToEventLog(const wchar_t* message);

// 服务主函数
VOID WINAPI ServiceMain(DWORD argc, LPWSTR* argv) {
    // 设置服务状态
    SERVICE_STATUS serviceStatus = { 0 };
    serviceStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
    serviceStatus.dwCurrentState = SERVICE_START_PENDING;
    serviceStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP;
    serviceStatus.dwWin32ExitCode = 0;
    serviceStatus.dwServiceSpecificExitCode = 0;
    serviceStatus.dwCheckPoint = 0;
    serviceStatus.dwWaitHint = 1000;

    SC_HANDLE serviceManager = OpenSCManager(NULL, NULL, SC_MANAGER_CONNECT);
    if (serviceManager == NULL) {
        WriteToEventLog(L"Failed to open Service Control Manager.");
        return;
    }

    SC_HANDLE serviceHandle = OpenService(serviceManager, SERVICE_NAME, SERVICE_CHANGE_CONFIG);
    if (serviceHandle == NULL) {
        WriteToEventLog(L"Failed to open the service.");
        CloseServiceHandle(serviceManager);
        return;
    }

    if (SetServiceStatus(serviceHandle, &serviceStatus) == FALSE) {
        WriteToEventLog(L"Failed to set service status as SERVICE_START_PENDING.");
        CloseServiceHandle(serviceHandle);
        CloseServiceHandle(serviceManager);
        return;
    }

    // 在此添加您的服务主要逻辑
    WriteToEventLog(L"MyService started successfully.");

    // 更新服务状态为SERVICE_RUNNING
    serviceStatus.dwCurrentState = SERVICE_RUNNING;
    if (SetServiceStatus(serviceHandle, &serviceStatus) == FALSE) {
        WriteToEventLog(L"Failed to set service status as SERVICE_RUNNING.");
        CloseServiceHandle(serviceHandle);
        CloseServiceHandle(serviceManager);
        return;
    }

    // 服务主要逻辑（此处示例不包含实际逻辑）

    // 等待服务停止信号
    WaitForSingleObject(serviceHandle, INFINITE);

    // 更新服务状态为SERVICE_STOP_PENDING
    serviceStatus.dwCurrentState = SERVICE_STOP_PENDING;
    if (SetServiceStatus(serviceHandle, &serviceStatus) == FALSE) {
        WriteToEventLog(L"Failed to set service status as SERVICE_STOP_PENDING.");
    }

    // 在此添加服务停止逻辑
    WriteToEventLog(L"MyService stopped.");

    // 更新服务状态为SERVICE_STOPPED
    serviceStatus.dwCurrentState = SERVICE_STOPPED;
    if (SetServiceStatus(serviceHandle, &serviceStatus) == FALSE) {
        WriteToEventLog(L"Failed to set service status as SERVICE_STOPPED.");
    }

    // 清理资源
    CloseServiceHandle(serviceHandle);
    CloseServiceHandle(serviceManager);
}

// 服务控制处理函数
VOID WINAPI ServiceCtrlHandler(DWORD ctrl) {
    switch (ctrl) {
        case SERVICE_CONTROL_STOP:
            // 在此添加停止服务的逻辑
            WriteToEventLog(L"Received stop signal. Stopping MyService.");
            // 停止服务
            // ...
            break;
        default:
            break;
    }
}

// 安装服务
BOOL InstallService() {
    SC_HANDLE serviceManager = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);
    if (serviceManager == NULL) {
        WriteToEventLog(L"Failed to open Service Control Manager.");
        return FALSE;
    }

    wchar_t exePath[MAX_PATH];
    if (GetModuleFileName(NULL, exePath, MAX_PATH) == 0) {
        WriteToEventLog(L"Failed to get executable path.");
        CloseServiceHandle(serviceManager);
        return FALSE;
    }

    SC_HANDLE serviceHandle = CreateService(
        serviceManager,
        SERVICE_NAME,
        SERVICE_NAME,
        SERVICE_ALL_ACCESS,
        SERVICE_WIN32_OWN_PROCESS,
        SERVICE_DEMAND_START,
        SERVICE_ERROR_NORMAL,
        exePath,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    );

    if (serviceHandle == NULL) {
        WriteToEventLog(L"Failed to create the service.");
        CloseServiceHandle(serviceManager);
        return FALSE;
    }

    CloseServiceHandle(serviceHandle);
    CloseServiceHandle(serviceManager);
    WriteToEventLog(L"MyService has been installed successfully.");
    return TRUE;
}

// 卸载服务
BOOL UninstallService() {
    SC_HANDLE serviceManager = OpenSCManager(NULL, NULL, SC_MANAGER_CONNECT);
    if (serviceManager == NULL) {
        WriteToEventLog(L"Failed to open Service Control Manager.");
        return FALSE;
    }

    SC_HANDLE serviceHandle = OpenService(serviceManager, SERVICE_NAME, DELETE);
    if (serviceHandle == NULL) {
        WriteToEventLog(L"Failed to open the service.");
        CloseServiceHandle(serviceManager);
        return FALSE;
    }

    if (DeleteService(serviceHandle) == FALSE) {
        WriteToEventLog(L"Failed to delete the service.");
        CloseServiceHandle(serviceHandle);
        CloseServiceHandle(serviceManager);
        return FALSE;
    }

    CloseServiceHandle(serviceHandle);
    CloseServiceHandle(serviceManager);
    WriteToEventLog(L"MyService has been uninstalled successfully.");
    return TRUE;
}

// 写入事件日志
VOID WriteToEventLog(const wchar_t* message) {
    HANDLE eventLog = RegisterEventSource(NULL, SERVICE_NAME);
    if (eventLog != NULL) {
        wprintf(L"%s\n", message);
        const wchar_t* messageStrings[1] = { message };
        ReportEvent(eventLog, EVENTLOG_INFORMATION_TYPE, 0, 0, NULL, 1, 0, messageStrings, NULL);
        DeregisterEventSource(eventLog);
    }
}

int main(int argc, char* argv[]) {
    if (argc > 1) {
        if (_wcsicmp(argv[1], L"install") == 0) {
            InstallService();
        } else if (_wcsicmp(argv[1], L"uninstall") == 0) {
            UninstallService();
        }
    } else {
        // 启动服务
        SERVICE_TABLE_ENTRY serviceTable[] = {
            { SERVICE_NAME, ServiceMain },
            { NULL, NULL }
        };

        if (StartServiceCtrlDispatcher(serviceTable) == FALSE) {
            WriteToEventLog(L"Failed to start Service Control Dispatcher.");
        }
    }

    return 0;
}
