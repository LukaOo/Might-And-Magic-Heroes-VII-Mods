#pragma once
#include <ostream>
#include <vector>

#include "CombatFeaturizer.h"

/**
 * Combatfeatures dumper
 **/
class CombatDumper
{
public:
	CombatDumper(std::ostream& dump_stream, CombatFeaturizerPtr& );
	~CombatDumper(void);
	///
	/// Detour combat  MMH7Game.H7CombatController.GetInstance
	///
	int ProcessInternal ( __int64 pthis, __int64 stach_frame, void* pResult);
	void PopulateBuffs(void* buff_manager, std::vector<float>& c_vec);

	///
	/// Dump current map state
	///
	void DumpMap();

private :
	class AH7CombatController* _combat_controller;
	std::ostream& _dump_stream;
	CombatFeaturizerPtr _combatFeaturesers;
};


// externs 
int CombatDumper_ProcessInternal ( __int64 This, __int64 Stack_frame, void* pResult);
int  hkH7Command_CommandPlay ( __int64 This, __int64 Stack_frame, void* pResult );
int  hkH7Command_CommandStop ( __int64 This, __int64 Stack_frame, void* pResult );
extern std::shared_ptr<CombatDumper> _combat_dumper;

