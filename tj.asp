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
