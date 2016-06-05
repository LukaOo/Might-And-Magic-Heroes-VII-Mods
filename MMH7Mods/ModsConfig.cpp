#include "StdAfx.h"
#include <Windows.h>
#include <iostream>
#include <cstdlib>
#include "ModsConfig.h"

#pragma comment( lib, "libconfig++.lib" )

void ReadConfig(libconfig::Config& conf)
{
	try
	{
		char path[2048];
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
			std::string config(path);
			config += ".cfg";
			conf.readFile(config.c_str());
		}
	}
	catch(const libconfig::FileIOException& ex )
	{
		std::cerr << "Error reading config file: " << ex.what() << std::endl;
	}

}


ModsConfig::ModsConfig(void) 
{
	ReadConfig(_cfg);
	LogFileName = GetValue("LogFile", std::string(""));

}




ModsConfig::~ModsConfig(void)
{
}
