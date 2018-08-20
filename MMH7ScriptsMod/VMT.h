#pragma once
#include <windows.h>
#include <vector>
#include <ostream>
#include "MinHook\MinHook.h"


//#include "capstone.h"
//#pragma comment(lib,"capstone.lib")
///
/// Virtual table  menegaer class
///
class VMTManager
{
public:
	VMTManager(void *pUObject);
	~VMTManager(void);
	
	 // 
	 // get sizeof virtual table
	 //
     int GetCountSize();

	 ///
	 /// get pointer to virtual table
	 ///
	 inline PDWORD64 GetVMT() { return _pdwVMT; }

     ///
     /// get original pointer to function
     ///
     inline DWORD64 GetOriginalFuncPtr(int num) { return _copyVMT[num]; }

	 ///
	 /// Dump vmt to stream
	 ///
	 void DumpVmt();
     void DumpVmt(std::ostream& );
	 //
	 // Hooking virtual function
	 //
	 PVOID HookFunction(void *phkFunction, int vfuncNum);

	 ///
	 // unhooking virtual function
	 //
	 void UnhookFunction(int vfuncNum);


	 class Detour
	 {
	  friend class VMTManager;

		 Detour(void* pSource) : _source((DWORD64) pSource), _origFunc(NULL) {};
	 public:
		 inline void* get() { return (void *) _origFunc; }
		 bool Start();
		 bool Stop();
	 private:
		 DWORD64 _source;
		 DWORD64 _origFunc;
	 };

	 typedef std::shared_ptr<Detour> DetourPtr;

	 ///
	 /// Detour any of unknown function
	 ///
	 /// void* DetourFunction(void* pSource, void* pDestination, std::ostream& log);
	 DetourPtr DetourFunction(void* pSource, void* pDestination);

	 ///
	 /// 
	 ///
	 bool DetourRemove(VMTManager::DetourPtr& detour);
	 
private :

	void _Init (void *pUObject);
	void _CopyVMT();
	inline BOOL _IsBadAddress(DWORD64 address) { return IsBadCodePtr ( ( FARPROC ) address ); };

private :
	PDWORD64 _pdwVMT; // old vmt table	
	std::vector<DWORD64> _copyVMT; // old vmt table
	MH_STATUS _mh_status;
	//csh m_CapstoneHandle;

};



