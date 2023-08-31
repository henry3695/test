#include <Windows.h>
#include <iostream>
#include <string>
#include <atlbase.h>
#include <comdef.h>
#include "Netfw.h"
int main() {
	CoInitialize(nullptr);

	HRESULT hr = S_OK;
	INetFwPolicy2* fwPolicy2 = nullptr;
	hr = CoCreateInstance(__uuidof(NetFwPolicy2), nullptr, CLSCTX_INPROC_SERVER, __uuidof(INetFwPolicy2), (void**)&fwPolicy2);
	if (FAILED(hr)) {
		std::cout << "Failed to create INetFwPolicy2 instance." << std::endl;
		CoUninitialize();
		return hr;
	}

	INetFwRules* rules = nullptr;
	hr = fwPolicy2->get_Rules(&rules);
	if (FAILED(hr)) {
		std::cout << "Failed to get firewall rules." << std::endl;
		fwPolicy2->Release();
		CoUninitialize();
		return hr;
	}

	long count = 0;
	hr = rules->get_Count(&count);
	if (FAILED(hr)) {
		std::cout << "Failed to get rule count." << std::endl;
		rules->Release();
		fwPolicy2->Release();
		CoUninitialize();
		return hr;
	}
	BSTR ruleName = SysAllocString(L"8080PORT");
	//从规则集合中获取指定名称的规则
	INetFwRule* rule = nullptr;
	hr = rules->Item(ruleName, &rule);
	if (SUCCEEDED(hr)) {
		std::cout << "Firewall rule is exist" << std::endl;

		BSTR newScope = SysAllocString(L"192.168.101.200,192.168.101.201"); // Replace with your desired new scope
		if (newScope) {
			hr = rule->put_RemoteAddresses(newScope);
			if (SUCCEEDED(hr)) {
				std::wcout << L"Scope modified for rule " << ruleName << std::endl;
			}
			SysFreeString(newScope);
		}
	}
	SysFreeString(ruleName);
	rules->Release();
	fwPolicy2->Release();
	CoUninitialize();

	return 0;
}


https://www.cnblogs.com/TechNomad/p/17649345.html


