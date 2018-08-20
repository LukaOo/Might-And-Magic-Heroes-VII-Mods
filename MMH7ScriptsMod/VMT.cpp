#include "StdAfx.h"
#include "VMT.h"
#include <iostream>
#include <iomanip>

#pragma comment(lib,"libMinHook.x64.lib")

VMTManager::VMTManager(void *pUObject)
{
	 _Init(pUObject);

	 _mh_status = MH_Initialize();
//	 if (cs_open(CS_ARCH_X86, CS_MODE_64, &m_CapstoneHandle) == CS_ERR_OK)
//	     cs_option(m_CapstoneHandle, CS_OPT_DETAIL, CS_OPT_ON);
}

VMTManager::~VMTManager(void)
{
	 if(_mh_status != MH_OK )
		 MH_Uninitialize();
//	cs_close(&m_CapstoneHandle);
}

void VMTManager::_Init(void *pUObject)
{
	_pdwVMT = (PDWORD64) *(DWORD64*)pUObject;
	_CopyVMT();
}

void VMTManager::_CopyVMT()
{
	int tableSize =  GetCountSize();
	int i = 0;
	_copyVMT.swap(std::vector<DWORD64>());
	_copyVMT.resize(tableSize);
	while( !_IsBadAddress( _pdwVMT[i] ) ) { _copyVMT[i] =  _pdwVMT[i]; i++; }
}

PVOID VMTManager::HookFunction(void *phkFunction, int vfuncNum)
{
	if(_copyVMT.size() <= vfuncNum) return NULL ;

	DWORD oldProtection = 0;
	VirtualProtect( &_pdwVMT[vfuncNum], 8, PAGE_EXECUTE_READWRITE, &oldProtection );  

	_pdwVMT[vfuncNum] = (DWORD64) phkFunction; 

	VirtualProtect( & _pdwVMT[vfuncNum], 8, oldProtection, 0 );

	return (PVOID)_copyVMT[vfuncNum];
}

void VMTManager::UnhookFunction(int vfuncNum)
{
	if(_copyVMT.size() <= vfuncNum) return ;

	DWORD oldProtection = 0;
	VirtualProtect( &_pdwVMT[vfuncNum], 8, PAGE_EXECUTE_READWRITE, &oldProtection );  

	_pdwVMT[vfuncNum] = _copyVMT[vfuncNum]; 

	VirtualProtect( &_pdwVMT[vfuncNum], 8, oldProtection, 0 );
}

int VMTManager::GetCountSize()
{
	int i = 0;
	while( !_IsBadAddress( _pdwVMT[i] ) )  i++;

	return i;
}


void VMTManager::DumpVmt(){ DumpVmt(std::cout); }
void VMTManager::DumpVmt(std::ostream& out)
{
	int i = 0;
	out << "VMT DUMP: 0x" << std::setw(2) << std::setfill('0') << _pdwVMT  << " ("  << GetCountSize() << ") " <<  "\n";
	while(!_IsBadAddress( _pdwVMT[i] ) )
	{
		out << "\tvmt["<< i <<" ] = 0x" << std::setw(2) << std::setfill('0') << _pdwVMT[i] << "\n";
        i++;
	}

}

//void* VMTManager::DetourFunction(void* pSource, void* pDestination, std::ostream& log)
//{
//	DWORD dwLength = _CalculateAsmLength((BYTE*)pSource, 14); 
//	log << "Function length: " << dwLength << "\n";
//	if( dwLength == 0 ) return NULL;
//
//	return VMTManager::_DetourFunction((void*)pSource, pDestination, (int)dwLength);
//}
VMTManager::DetourPtr VMTManager::DetourFunction(void* pSource, void* pDestination)
{
	if( _mh_status != MH_OK) return NULL;

	VMTManager::DetourPtr result( new VMTManager::Detour(pSource) );
	void *original = NULL;
	if ( MH_CreateHook(pSource, pDestination, &original) == MH_OK ) 
	{
		 result->_origFunc = (DWORD64) original;
	}

	return result;
}


bool VMTManager::DetourRemove(VMTManager::DetourPtr& detour)
{
	if( _mh_status != MH_OK) return false;

	MH_STATUS stat = MH_RemoveHook((void*)detour->_source);

	detour->_origFunc = 0;
	return stat == MH_OK;
}

bool VMTManager::Detour::Stop()
{ 
	return _origFunc != 0 && MH_DisableHook((void*)_source) == MH_OK;
}

bool VMTManager::Detour::Start()
{ 
    return _origFunc != 0 &&	 MH_EnableHook((void*)_source) == MH_OK;
}


//DWORD VMTManager::_CalculateAsmLength(BYTE* Src, DWORD NeededLength)
//{
//	//Grab First 100 bytes of function, disasm until invalid instruction
//	cs_insn* InstructionInfo;
//	size_t InstructionCount = cs_disasm(m_CapstoneHandle, Src, 0x100, (uint64_t)Src, 0, &InstructionInfo);
//
//	//Loop over instructions until we have at least NeededLength's Size
//	DWORD InstructionSize = 0;
//	bool BigEnough = false;
//	for (int i = 0; i < InstructionCount && !BigEnough; i++)
//	{
//		cs_insn* CurIns = (cs_insn*)&InstructionInfo[i];
//		InstructionSize += CurIns->size;
//		if (InstructionSize >= NeededLength)
//			BigEnough = true;
//
//		XTrace("%I64X [%d]: ", CurIns->address, CurIns->size);
//		for (int j = 0; j < CurIns->size; j++)
//			XTrace("%02X ", CurIns->bytes[j]);
//		XTrace("%s %s\n", CurIns->mnemonic, CurIns->op_str);
//	}
//	if (!BigEnough)
//		InstructionSize = 0;
//
//	cs_free(InstructionInfo, InstructionCount);
//	return InstructionSize;
//}

