// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include "fstream"
#include "tfl_ht.h"
#include <iomanip>
#include <iostream>

void OnAttach()
{
  char buffer[MAX_PATH];
  GetCurrentDirectoryA(MAX_PATH, buffer);
  std::ofstream out("C:\\Users\\Dima\\Documents\\MMH7Project\\dbg\\dbg.file.txt");
  MODULEINFO info = TFLHACKT00LS::GetModuleInfo(NULL);
  out << "Process base: " << std::hex << std::setw(2) << std::setfill('0') << info.lpBaseOfDll << std::endl;
  out << "ImageSize: " << info.SizeOfImage << std::endl;
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		OnAttach();
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

