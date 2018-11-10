////////////////////////////////////////////////////////////////////////////////////////////
// loader: command-line interface dll injector
// Copyright (C) 2009-2011 Wadim E. <wdmegrv@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////////////////////////
#include "injector_helper.h"

FARPROC
GetRemoteProcAddress(
	HANDLE hProcess,
	HMODULE hRemoteModule,
	LPCSTR lpProcName
	)
{
	HMODULE hLocalModule = 0;
	FARPROC fpLocalFunction = 0;
	LONG_PTR funcDelta = 0;
	FARPROC result = 0;
	WCHAR lpModuleName[MAX_PATH + 1] = {0};

	__try
	{
		
		if(!GetModuleFileNameExW(hProcess, hRemoteModule, lpModuleName, MAX_PATH))
		{
			PRINT_ERROR_MSGA("Could not get path to remote module.");
			__leave;
		}

		// DONT_RESOLVE_DLL_REFERENCES
		// If this value is used, and the executable module is a DLL,
		// the system does not call DllMain for process and thread
		// initialization and termination. Also, the system does not
		// load additional executable modules that are referenced by
		// the specified module.
		hLocalModule = LoadLibraryExW(lpModuleName, 0, DONT_RESOLVE_DLL_REFERENCES);

		if(!hLocalModule)
		{
			PRINT_ERROR_MSGA("Could not load module locally.");
			__leave;
		}

		// Find target function in module
		fpLocalFunction = GetProcAddress(hLocalModule, lpProcName);
		if(!fpLocalFunction)
		{
			PRINT_ERROR_MSGA("Could not find target function.");
			__leave;
		}

		// Calculate function delta
		funcDelta = (DWORD_PTR)(fpLocalFunction) - (DWORD_PTR)(hLocalModule);

		// Calculate function location in remote process
		result = (FARPROC)( (DWORD_PTR)(hRemoteModule) + funcDelta );
	}
	__finally
	{
		if(hLocalModule)
		{
			FreeLibrary(hLocalModule);
		}
	}

	return result;
}

BOOL
EnablePrivilegeW(
	LPCWSTR lpPrivilegeName,
	BOOL bEnable
	)
{
	HANDLE				hToken				= (HANDLE)0;
	HANDLE				hProcess			= (HANDLE)0;
	BOOL				bRet				= FALSE;
	LUID				luid				= {0};
	TOKEN_PRIVILEGES	token_privileges	= {1};

	__try
	{
		// Open current process token with adjust rights
		if(!OpenProcessToken(GetCurrentProcess(),
			TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY | TOKEN_READ, &hToken))
		{
			PRINT_ERROR_MSGA("Could not open process token.");
			__leave;
		}

		if(!LookupPrivilegeValueW((LPCWSTR)0, lpPrivilegeName, &luid))
		{
			PRINT_ERROR_MSGW(L"Could not look up privilege value for \"%s\".",
				lpPrivilegeName);
			__leave;
		}
		if(luid.LowPart == 0 && luid.HighPart == 0)
		{
			PRINT_ERROR_MSGW(L"Could not get LUID for \"%s\".", lpPrivilegeName);
			__leave;
		}

		// Set the privileges we need
		token_privileges.Privileges[0].Luid = luid;
		token_privileges.Privileges[0].Attributes = bEnable ? SE_PRIVILEGE_ENABLED : 0;

		// Apply the adjusted privileges
		if(!AdjustTokenPrivileges(hToken, FALSE, &token_privileges, sizeof(TOKEN_PRIVILEGES),
			(PTOKEN_PRIVILEGES)0, (PDWORD)0))
		{
			PRINT_ERROR_MSGA("Could not adjust token privileges.");
			__leave;
		}

		bRet = TRUE;
	}
	__finally
	{
		if(hToken)
		{
			CloseHandle(hToken);
		}
	}

	return bRet;
}

BOOL
SuspendResumeProcess(
	DWORD dwProcessId,
	BOOL bResumeProcess
	)
{
	BOOL	bRet		= FALSE; 
	HANDLE	hProcess	= 0;
	HMODULE hNtDll		= 0;

	LONG (NTAPI *_NtSuspendProcess)(HANDLE ProcessHandle) = 0;
	LONG (NTAPI *_NtResumeProcess)(HANDLE ProcessHandle) = 0;
	
	__try
	{
		hNtDll = GetModuleHandleW(L"ntdll");
		if(!hNtDll)
		{
			PRINT_ERROR_MSGA("Could not get handle to ntdll.");
			__leave;
		}
		
		_NtSuspendProcess = (LONG (NTAPI*)(HANDLE))GetProcAddress(hNtDll, "NtSuspendProcess");
		if(_NtSuspendProcess == 0)
		{
			PRINT_ERROR_MSGA("Could not get the address of NtSuspendProcess.");
			__leave;
		}

		_NtResumeProcess = (LONG (NTAPI*)(HANDLE))GetProcAddress(hNtDll, "NtResumeProcess");
		if(_NtResumeProcess == 0)
		{
			PRINT_ERROR_MSGA("Could not get the address of NtResumeProcess.");
			__leave;
		}
		
		// PROCESS_SUSPEND_RESUME (0x0800) Required to suspend or resume a process.
		hProcess = OpenProcess(
			PROCESS_SUSPEND_RESUME,
			FALSE,
			dwProcessId);
		if(!hProcess)
		{
			PRINT_ERROR_MSGA("Could not get handle to process.");
			__leave;
		}

		// Resume Process
		if(bResumeProcess)
		{
			LONG ntStatus = (*_NtResumeProcess)(hProcess);
			if(!NT_SUCCESS(ntStatus))
			{
				PRINT_ERROR_MSGA("NtResumeProcess. [NtStatus: 0x%X]", (ULONG)ntStatus);
				__leave;
			}
		}
		// Suspend Process
		else
		{
			LONG ntStatus = (*_NtSuspendProcess)(hProcess);
			if(!NT_SUCCESS(ntStatus))
			{
				PRINT_ERROR_MSGA("NtSuspendProcess. [NtStatus 0x%X]", (ULONG)ntStatus);
				__leave;
			}	
		}

		bRet = TRUE;
	}
	__finally
	{
		if(hProcess)
		{
			CloseHandle(hProcess);
		}
	}

	return bRet;
}

BOOL
HideThreadFromDebugger(
	DWORD dwThreadId
	)
{
	BOOL	bRet		= FALSE;
	HANDLE	hThread		= 0;
	HMODULE hNtDll		= 0;
	LONG	ntStatus	= 0;

	LONG (NTAPI *_NtSetInformationThread)(
		HANDLE ThreadHandle,
		NT_THREAD_INFORMATION_CLASS ThreadInformationClass,
		PVOID ThreadInformation,
		ULONG ThreadInformationLength) = 0;

	__try
	{
		hNtDll = GetModuleHandle(TEXT("ntdll"));
		if(!hNtDll)
		{
			PRINT_ERROR_MSGA("Could not get handle to ntdll.");
			__leave;
		}

		_NtSetInformationThread =
			(LONG (NTAPI*)(HANDLE, NT_THREAD_INFORMATION_CLASS, PVOID, ULONG))
			GetProcAddress(hNtDll, "NtSetInformationThread");
		if(_NtSetInformationThread == 0)
		{
			PRINT_ERROR_MSGA("Could not get the address of NtSetInformationThread.");
			__leave;
		}

		hThread = OpenThread(
			THREAD_SET_INFORMATION,
			FALSE,
			dwThreadId);
		if(hThread == 0)
		{
			PRINT_ERROR_MSGA("Could not open thread (ThreadId: %d).", dwThreadId);
			__leave;
		}

		ntStatus = (*_NtSetInformationThread)(hThread, ThreadHideFromDebugger, 0, 0);
		if(!NT_SUCCESS(ntStatus))
		{
			PRINT_ERROR_MSGA("NtSetInformationThread. [NtStatus 0x%X]", (ULONG)ntStatus);
			__leave;
		}

		bRet = TRUE;

	}
	__finally
	{
		if(hThread)
			CloseHandle(hThread);
	}

	return bRet;
}

BOOL
GetFileNameNtW(
	LPCWSTR lpFileName,
	LPWSTR lpFileNameNt,
	DWORD nSize
	)
{
	BOOL	bRet		= FALSE;
	HANDLE	hFile		= 0;
	HANDLE	hFileMap	= 0;
	LPVOID	lpMem		= 0;

	__try
	{
		hFile = CreateFileW(
			lpFileName,
			GENERIC_READ,
			FILE_SHARE_READ,
			0,
			OPEN_EXISTING,
			0,
			0);
		if(hFile == INVALID_HANDLE_VALUE)
		{
			PRINT_ERROR_MSGA("CreateFileW failed.");
			__leave;
		}

		hFileMap = CreateFileMappingW(
			hFile,
			0,
			PAGE_READONLY,
			0,
			1,
			0);
		if(hFileMap == 0)
		{
			PRINT_ERROR_MSGA("CreateFileMappingW failed.");
			__leave;
		}

		lpMem = MapViewOfFile(hFileMap, FILE_MAP_READ, 0, 0, 1);
		if(lpMem == 0)
		{
			PRINT_ERROR_MSGA("MapViewOfFile failed.");
			__leave;
		}

		if(GetMappedFileNameW(
			GetCurrentProcess(),
			lpMem,
			lpFileNameNt,
			nSize) == 0)
		{
			PRINT_ERROR_MSGA("GetMappedFileNameW failed.");
			__leave;
		}

		bRet = TRUE;
	}
	__finally
	{
		if(hFile)
		{
			CloseHandle(hFile);
		}

		if(hFileMap)
		{
			CloseHandle(hFileMap);
		}

		if(lpMem)
		{
			UnmapViewOfFile(lpMem);
		}
	}

	return bRet;
}

LPVOID
ModuleInjectedW(
	HANDLE hProcess,
	LPCWSTR lpLibPathNt)
{
	SIZE_T Memory = 0;
	SYSTEM_INFO sys_info = {0};
	WCHAR NtMappedFileName[MAX_PATH + 1] = {0};
	MEMORY_BASIC_INFORMATION mem_basic_info	= {0};

	GetSystemInfo(&sys_info);

	printf("Process handle: 0x%p, max mem address: 0x%p\n", hProcess, sys_info.lpMaximumApplicationAddress );

	for(Memory = 0;
		Memory < (SIZE_T)sys_info.lpMaximumApplicationAddress;
		Memory += mem_basic_info.RegionSize)
	{
		SIZE_T vqr = VirtualQueryEx(hProcess, (LPCVOID)Memory, &mem_basic_info,
			sizeof(MEMORY_BASIC_INFORMATION));
		if(vqr != 0)
		{
			if((mem_basic_info.AllocationProtect & PAGE_EXECUTE_WRITECOPY) && 
				(mem_basic_info.Protect & (PAGE_EXECUTE | PAGE_EXECUTE_READ |
				PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY)))
			{
				if(GetMappedFileNameW(hProcess, (HMODULE)mem_basic_info.AllocationBase,
					NtMappedFileName, MAX_PATH) == 0)
				{
					PRINT_ERROR_MSGA("GetMappedFileNameW failed.");
					return 0;
				}
				
				if(wcsncmp(NtMappedFileName, lpLibPathNt, wcslen(lpLibPathNt) + 1) == 0)
				{
					return mem_basic_info.AllocationBase;
				}
			}
		}
		// VirtualQueryEx failed
		else
		{
			PRINT_ERROR_MSGA("VirtualQueryEx failed.");
			return 0;
		}
			
	}

	return 0;
}

VOID
ListModules(
	DWORD dwProcessId
	)
{
	SIZE_T Memory = 0;
	SYSTEM_INFO sys_info = {0};
	WCHAR ntMappedFileName[MAX_PATH + 1] = {0};
	MEMORY_BASIC_INFORMATION mem_basic_info	= {0};
	HANDLE hProcess = 0;
	PVOID ab = (PVOID)0;

	// Get a handle for the target process.
	hProcess = OpenProcess(
		PROCESS_QUERY_INFORMATION	|	// Required by Alpha
		PROCESS_CREATE_THREAD		|	// For CreateRemoteThread
		PROCESS_VM_OPERATION		|	// For VirtualAllocEx/VirtualFreeEx
		PROCESS_VM_WRITE			|	// For WriteProcessMemory
		PROCESS_VM_READ,
		FALSE, 
		dwProcessId);
	if(!hProcess)
	{
		PRINT_ERROR_MSGA("Could not get handle to process (PID: 0x%X).", dwProcessId);
		return;
	}

	GetSystemInfo(&sys_info);

	printf("BASE\t\t SIZE\t\t  MODULE\n\n");

	for(Memory = 0;
		Memory < (SIZE_T)sys_info.lpMaximumApplicationAddress;
		Memory += mem_basic_info.RegionSize)
	{
		ab = mem_basic_info.AllocationBase;

		if(VirtualQueryEx(hProcess, (LPCVOID)Memory, &mem_basic_info,
			sizeof(MEMORY_BASIC_INFORMATION)))
		{
			if(ab == mem_basic_info.AllocationBase)
			{
				continue;
			}

			if(GetMappedFileNameW(hProcess, (HMODULE)mem_basic_info.AllocationBase,
				ntMappedFileName, MAX_PATH))
			{
				IMAGE_NT_HEADERS nt_header = {0};
				IMAGE_DOS_HEADER dos_header = {0};
				SIZE_T NumBytesRead = 0;
				LPVOID lpNtHeaderAddress = 0;
				//WCHAR *pModuleName = (WCHAR)0;

				//pModuleName = wcsrchr(ntMappedFileName, '\\');
				//if(!pModuleName)
				//{
				//	return;
				//}
				//++pModuleName;
				
				if(ReadProcessMemory(hProcess, mem_basic_info.AllocationBase, &dos_header,
					sizeof(IMAGE_DOS_HEADER), &NumBytesRead) &&
					NumBytesRead == sizeof(IMAGE_DOS_HEADER))
				{
					lpNtHeaderAddress = (LPVOID)( (DWORD_PTR)mem_basic_info.AllocationBase +
						dos_header.e_lfanew );

					if(ReadProcessMemory(hProcess, lpNtHeaderAddress, &nt_header,
						sizeof(IMAGE_NT_HEADERS), &NumBytesRead) &&
						NumBytesRead == sizeof(IMAGE_NT_HEADERS))
					{
						if(sizeof(PVOID) == 4)
						{
							wprintf(L"0x%p\t 0x%x\t  %s\n",
								mem_basic_info.AllocationBase,
								nt_header.OptionalHeader.SizeOfImage,
								ntMappedFileName);
						}
						else if(sizeof(PVOID) == 8)
						{
							wprintf(L"0x%p 0x%x %s\n",
								mem_basic_info.AllocationBase,
								nt_header.OptionalHeader.SizeOfImage,
								ntMappedFileName);
						}
					}
				}
			}
		}
		// VirtualQueryEx failed
		else
		{
			PRINT_ERROR_MSGA("VirtualQueryEx failed.");
			return;
		}

	}
}

void
__stdcall
MyGetSystemInfo(
	LPSYSTEM_INFO lpSystemInfo
	)
{
	// WOW64 -> GetNativeSystemInfo
	void (WINAPI *_GetNativeSystemInfo)(LPSYSTEM_INFO) = 0;

	HMODULE hKernel32Dll = GetModuleHandleW(L"kernel32");
	if(!hKernel32Dll)
	{
		PRINT_ERROR_MSGA("Could not get handle to kernel32.");
		return;
	}

	_GetNativeSystemInfo = (void (__stdcall*)(LPSYSTEM_INFO))GetProcAddress(
		hKernel32Dll, "GetNativeSystemInfo");
	if(_GetNativeSystemInfo)
	{
		_GetNativeSystemInfo(lpSystemInfo);
	}
	else
	{
		GetSystemInfo(lpSystemInfo);
	}
}

INT
IsProcess64(
	DWORD dwProcessId
	)
{
	// Wenn es ein 64bit-System ist, sind alle Prozesse, f�r die IsWow64Process
	// TRUE zur�ckliefert, 32bit-Prozesse, alle anderen 64bit-Prozesse.
	// Unter einem 32bit-Windows ist sowieso alles 32bit.

	SYSTEM_INFO siSysInfo = {0};
	HANDLE hProcess = 0;
	HMODULE hKernel32Dll = 0;
	BOOL (WINAPI *_IsWow64Process)(HANDLE, PBOOL) = 0;

	MyGetSystemInfo(&siSysInfo);

	// x64 (AMD or Intel)
	if(siSysInfo.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64)
	{
		BOOL bIsWow64 = FALSE;
		hKernel32Dll = GetModuleHandleW(L"kernel32");
		if(!hKernel32Dll)
		{
			PRINT_ERROR_MSGA("Could not get handle to kernel32.");
			return -1;
		}

		_IsWow64Process = (BOOL (WINAPI*)(HANDLE, PBOOL))GetProcAddress(
			hKernel32Dll, "IsWow64Process");
		if(_IsWow64Process == 0)
		{
			PRINT_ERROR_MSGA("Could not get the address of IsWow64Process.");
			return -1;
		}

		hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, dwProcessId);
		if(!hProcess)
		{
			PRINT_ERROR_MSGA("Could not get handle to process (PID: 0x%X).", dwProcessId);
			return -1;
		}

		if(!_IsWow64Process(hProcess, &bIsWow64))
		{
			PRINT_ERROR_MSGA("IsWow64Process failed.");
			return -1;
		}

		CloseHandle(hProcess);
		
		return bIsWow64 ? 0 : 1;
	}
	// x86
	else if(siSysInfo.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL)
	{
		return 0;
	}

	return -1;
}