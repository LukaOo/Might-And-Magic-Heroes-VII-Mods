// MMH7SDKGenerator.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "tfl_ht.h"
#include <fstream>
#include <iomanip>
#include <iostream>

const DWORD64 GObjects_offset = 0x0000000002300448;
const DWORD64 GNames_offset = 0x0000000002300400;
const std::string dbg_path(".\dbg.file.txt");

void GenerateSDK()
{
  std::ofstream out(dbg_path.c_str());
  MODULEINFO info = TFLHACKT00LS::GetModuleInfo(NULL);
  out << "Process base: " << std::hex << std::setw(2) << std::setfill('0') << info.lpBaseOfDll << std::endl;
  out << "ImageSize: " << info.SizeOfImage << std::endl;
}