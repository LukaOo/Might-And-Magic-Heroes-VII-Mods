#pragma once
#include <ostream>
#include <vector>

#include "CombatFeaturizer.h"
#include "HookBase.h"

/**
 * Combatfeatures dumper
 **/
class CombatDumper : public HookBase
{
public:
	CombatDumper(std::ostream& dump_stream, CombatFeaturizerPtr& );
	~CombatDumper(void);
	void PopulateBuffs(void* buff_manager, std::vector<float>& c_vec);

private :

	int CommandPlayFunc ( __int64 pthis, __int64 stach_frame, void* pResult);
	int CommandStopFunc ( __int64 pthis, __int64 stach_frame, void* pResult);
	///
	/// Detour combat  MMH7Game.H7CombatController.GetInstance
	///
	int GetInstanceFun ( __int64 pthis, __int64 stach_frame, void* pResult);
	///
	/// Dump current map state
	///
	void DumpMap();
private :
	///
	/// Command play function class
	///
	class CommandPlay : public HookFunction
	{
	public :
		CommandPlay(CombatDumper* pBase) : HookFunction(pBase, "Function MMH7Game.H7Command.CommandPlay"){}
		int Func(__int64 This, __int64 Stack_frame, void* pResult) 
		{  return ((CombatDumper*)_pBase)->CommandPlayFunc(This, Stack_frame, pResult); };
	} _fCommandPlay;

	///
	/// Command stop function
	///
	class CommandStop : public HookFunction
	{
	public :
		CommandStop(CombatDumper* pBase) : HookFunction(pBase, "Function MMH7Game.H7Command.CommandStop"){}
		int Func(__int64 This, __int64 Stack_frame, void* pResult) 
		{  return ((CombatDumper*)_pBase)->CommandStopFunc(This, Stack_frame, pResult); };

	} _fCommandStop;

	///
	/// Process internal function
	///
	class GetInstance : public HookFunction
	{
	public :
		GetInstance(CombatDumper* pBase) : HookFunction(pBase, "Function MMH7Game.H7CombatController.GetInstance"){}
		int Func(__int64 This, __int64 Stack_frame, void* pResult) 
		{  return ((CombatDumper*)_pBase)->GetInstanceFun(This, Stack_frame, pResult); };

	} _fGetInstance;


private :
	class AH7CombatController* _combat_controller;
	std::ostream& _dump_stream;
	CombatFeaturizerPtr _combatFeaturesers;
};


// externs 
int CombatDumper_ProcessInternal ( __int64 This, __int64 Stack_frame, void* pResult);
int  hkH7Command_CommandPlay ( __int64 This, __int64 Stack_frame, void* pResult );
int  hkH7Command_CommandStop ( __int64 This, __int64 Stack_frame, void* pResult );

typedef std::shared_ptr<CombatDumper> CombatDumperPtr;

