#include "StdAfx.h"
#include <Windows.h>
#include <psapi.h>
#include <iostream>
#include <cstdlib>
#include "ModsConfig.h"

#pragma comment( lib, "libconfig++.lib" )

bool ReadConfig(libconfig::Config& conf)
{
	char path[2048];
	std::string config("");
	bool init = false;
	try
	{
		HMODULE hm = NULL;
		const char* localFunc="MMH7Mods.dll";

		if (!GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | 
				GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
				(LPCSTR)ReadConfig, 
				&hm))
		{
			int ret = GetLastError();
		    std::cerr << "GetModuleHandle returned %d\n" << ret;
		}
		else
		{
			GetModuleFileNameA(hm, path, sizeof(path));
			config = path;
			config += ".cfg";
			conf.readFile(config.c_str());
			init = true;
		}
	}
	catch(const libconfig::FileIOException& ex )
	{
		std::cerr << "Error reading config file: " << config.c_str() << ", " << ex.what() << std::endl;
	}

	return init;
}

bool GetModuleName(std::string& name)
{
	HANDLE hProcess = GetCurrentProcess();
	if (hProcess == 0)
	{
		std::cerr << "Get current process handle failed: GetLastError:" << GetLastError() << std::endl;
		return false;
	}

	char path[2048];
	DWORD result = GetProcessImageFileNameA(hProcess, path, sizeof(path));
	if (result == 0) {
		std::cerr << "Get Process image file name failed.  GetLastError: " << GetLastError() << std::endl;
		return false;
	}
    
	name = path;
	size_t p = name.find_last_of("\\");
	if (p != std::string::npos && p < name.size()) 
	{
		name = name.substr(p + 1);
	}

	return true;
}

ModsConfig::ModsConfig(void) 
{
	
	GetModuleName(_processName);
	_isConfigured = false;
	if (ReadConfig(_cfg)) 
	{
		_isConfigured = true;
	}

}




ModsConfig::~ModsConfig(void)
{
}
