#pragma once
#include <windows.h>
#include <iostream>
#include <memory>
#include <map>
#include <string>
#include "vmt.h"

#ifdef _MSC_VER
	#pragma pack ( push, 0x4 )
#endif

void OnAttach();
void Init_Core();
void Init_Functions();
void __fastcall hkProcessEvent ( void* pthis, class UFunction* pFunction, void* pParms, void* pResult = NULL );

int __fastcall hkProcessInternal ( __int64 pthis, __int64 stach_frame, void* pResult );

typedef  void (*ProcessEventPtr) ( void* thisptr, class UFunction* pFunction, void* pParms, void* pResult) ;
typedef  int (*ProcessInternalPtr) ( __int64 pthis, __int64 stach_frame, void* pResult) ;

#define SDKMC_SSHEX( value, width )		"0x" << std::hex << std::uppercase << std::setfill ( '0' ) << std::setw ( width ) << std::right << value << std::nouppercase

extern std::ofstream clog;
extern std::shared_ptr<VMTManager> _vmt;
extern VMTManager::DetourPtr OriginalProcessInternal;

class UObject;
class UFunction;

///
/// Stack frame
///
struct FFrame
{
	void *Stack;              // 0x0000 //0x08
	char Unknown00[0xC];      // 0x0008 //0x0C  
	UFunction *Node;          // 0x0014 //0x08 // pointer to function
	UObject* Object;          // 0x001C //0x08
	void* Code;               // 0x0024 //0x08 // pointer to stack code
	void* Locals;             // 0x002C //0x08 // local variables   
};

///
/// Class for function hooks list  
///
class ProcessInternalHooks
{
public:

	void Add(const char* name, ProcessInternalPtr func) { _hooks[std::string(name)] = func; };

	///
	/// Get hook function pointer 
	///
	ProcessInternalPtr Get(const std::string& func_name) 
	{ 
		std::map<std::string, ProcessInternalPtr>::iterator it = _hooks.find(func_name);
		return (_hooks.end() == it)? NULL: it->second;
	}

private:
	std::map<std::string, ProcessInternalPtr> _hooks;
};

void DumpH7Command(class UH7Command* command);

#ifdef _MSC_VER
	#pragma pack ( pop )
#endif
