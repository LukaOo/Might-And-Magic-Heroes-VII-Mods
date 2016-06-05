#include "StdAfx.h"
#include "CombatDumper.h"
#include "SdkClasses.h"
#include "SDK_HEADERS\MMH7Game_f_structs.h"
#include "MMH7Mods.h"


DumperConfig::DumperConfig(const ModsConfig& config) :
	       sectionName("Dumper"),
		   dumpFile(config.GetValue((sectionName+"/FilePath").c_str(), std::string("") ) ),
		   isEnabled(config.GetValue((sectionName+"/Enabled").c_str(), false ))

{

}

CombatDumper::CombatDumper(const ModsConfig& config, CombatFeaturizerPtr& combatFeturizer) : HookBase("CombatDumper"),
	           _config(config), 
			   _fCommandPlay(this),
			   _fCommandStop(this),
			   _fGetInstance(this),
              _combat_controller(NULL),
			  _dump_stream(_config.dumpFile.c_str()),
			  _combatFeaturesers(combatFeturizer)
{
}


CombatDumper::~CombatDumper(void)
{
}

void CombatDumper::PopulateBuffs(void* buff_manager, std::vector<float>& c_vec)
{
   UH7BuffManager* buffManager = (UH7BuffManager*) buff_manager;
   const int cbuff = buffManager->mBuffs.Count;

   std::vector<float> stat_buff(STAT_MAX+1, 0.0);

   c_vec.push_back((float)1000 + cbuff);
   for(int i=0; i < cbuff; i++){
	   c_vec.push_back((float)buffManager->mBuffs.Data[i]->mIsDebuff);
	   c_vec.push_back((float)buffManager->mBuffs.Data[i]->mIsActive);

	   const int cbuff_mods = buffManager->mBuffs.Data[i]->mStatModEffects.Count;	   
	   c_vec.push_back((float)10000 + i);
	   c_vec.push_back((float)cbuff_mods);
	   for(int j=0; j < cbuff_mods; j++){
		   FH7StatEffect& statEffect = buffManager->mBuffs.Data[i]->mStatModEffects.Data[j];
		   stat_buff[statEffect.mStatMod.mStat] = statEffect.mStatMod.mModifierValue;
		   c_vec.push_back((float)statEffect.mStatMod.mStat);
		   c_vec.push_back((float)statEffect.mStatMod.mModifierValue);
	   }
   } 

   //c_vec.insert(c_vec.end(), stat_buff.begin(), stat_buff.end();
}

void CombatDumper::DumpMap()
{
	if( !_config.isEnabled || !_combat_controller ) return;

	_combatFeaturesers->ResetFeatures();
	_combatFeaturesers->Init(_combat_controller);
	//CTIER_MAX
	const std::vector<float>& features(_combatFeaturesers->GetFeatures());

	std::vector<float>::const_iterator it = features.begin();
	for( ; it != features.end(); ++it) _dump_stream << " " << (*it);
	_dump_stream << "\n";
}

int CombatDumper::GetInstanceFun ( __int64 This, __int64 Stack_frame, void* pResult)
{
	FFrame* pStack = (FFrame*) Stack_frame;
	
	int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);

	AH7CombatController_execGetInstance_Parms* params = (AH7CombatController_execGetInstance_Parms*) pResult;
 	_combat_controller = params->ReturnValue;

	return retval; 
}

int  CombatDumper::CommandPlayFunc ( __int64 This, __int64 Stack_frame, void* pResult )
{
	UH7Command* command = (UH7Command*)This;
	FFrame * Stack = (FFrame*) Stack_frame;
	bool is_runing = command->mRunning;

	DumpH7Command(command);

    int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);

 return retval;
}

int  CombatDumper::CommandStopFunc ( __int64 This, __int64 Stack_frame, void* pResult )
{
	UH7Command* command = (UH7Command*)This;
	FFrame * Stack = (FFrame*) Stack_frame;
	bool is_runing = command->mRunning;

	DumpH7Command(command);

	DumpMap();

    int retval = ((ProcessInternalPtr)OriginalProcessInternal->get())(This,  Stack_frame, pResult);

 return retval;
}

