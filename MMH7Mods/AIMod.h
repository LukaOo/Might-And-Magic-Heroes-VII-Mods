#pragma once
#include "HookBase.h"

class AH7AdventureGridManager;
class AH7AdventureController;
class AH7AdventureHero;
class AH7CombatController;

///
/// AIMod configuration
///
class AIModConfig
{
public:

	AIModConfig(const ModsConfig& config);

public:
	// configuration parameters
	const std::string sectionName;
	const bool isEnabled;  // true if mod enabled
	const bool isAdventureMapEnabled; // true if AI on Adventure map enabled
	const bool isCombatEnabled; // true if AI on Adventure map enabled
};

///
/// Main class for AI behavior modification 
///
class AIMod :
	public HookBase
{
public:
	AIMod(const ModsConfig& config);
	virtual ~AIMod();

private:
	///
	/// Config
	///
	AIModConfig _config;

	///
	/// Game static pointers
	///
	AH7AdventureGridManager* _pAdventureGridManager;
	AH7AdventureController*  _pAdventureController;
	AH7AdventureHero* _pAttackingHero;
	AH7AdventureHero* _pDefendingHero;
	AH7CombatController* _pCombatController;
	unsigned long _QuickCombatAllowed;

	/// 
	/// Functions
	///
	int AiAdventureMap_ThinkFunc(__int64 pthis, __int64 stack_frame, void* pResult);
	int H7AdventureGridManager_PostBeginPlay(__int64 pthis, __int64 stack_frame, void* pResult);
	int GetInstanceFun(__int64 pthis, __int64 stack_frame, void* pResult);
	int H7CombatController_GetInstance(__int64 pthis, __int64 stack_frame, void* pResult);
	int H7InstantCommandDoCombat_Init(__int64 pthis, __int64 stack_frame, void* pResult);
	int H7InstantCommandDoCombat_Execute(__int64 pthis, __int64 stack_frame, void* pResult);
	int H7CombatController_EndOfCombat_TravelBack(__int64 pthis, __int64 stack_frame, void* pResult);
	int H7AdventureController_DoBackToAdventureFromCombat(__int64 pthis, __int64 stack_frame, void* pResult);

	///
	/// Function to initialize grid manager poiner
	///

	///
	/// H7AiAdventureMap.Think function
	///
	class AiAdventureMap_Think : public HookFunction
	{
	public:
		AiAdventureMap_Think(AIMod* pBase) : HookFunction(pBase, "Function MMH7Game.H7AiAdventureMap.Think") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->AiAdventureMap_ThinkFunc(This, Stack_frame, pResult);
		};
	} _fAiAdventureMap_Think;

	///
	/// Need to initialize grid manager
	///
	class H7AdventureGridManager_PostBeginPlay : public HookFunction
	{
	public:
		H7AdventureGridManager_PostBeginPlay(AIMod* pBase) : HookFunction(pBase, "Function MMH7Game.H7AdventureGridManager.PostBeginPlay") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->H7AdventureGridManager_PostBeginPlay(This, Stack_frame, pResult);
		};
	} _fH7AdventureGridManager_PostBeginPlay;

	///
    /// Process internal function
    ///
	class GetInstance : public HookFunction
	{
	public:
		GetInstance(AIMod* pBase) : HookFunction(pBase, "Function MMH7Game.H7AdventureController.GetInstance") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->GetInstanceFun(This, Stack_frame, pResult);
		};

	} _fGetInstance;

	///
	/// Process internal function H7InstantCommandDoCombat.Init
	///  try to change mQuickCombatFlag to true
	///
	class H7InstantCommandDoCombat_Init : public HookFunction
	{
	public:
		H7InstantCommandDoCombat_Init(AIMod* pBase) : HookFunction(pBase, "Function MMH7Game.H7InstantCommandDoCombat.Init") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->H7InstantCommandDoCombat_Init(This, Stack_frame, pResult);
		};

	} _fH7InstantCommandDoCombat_Init;

	///
	/// Process internal function H7InstantCommandDoCombat.Execute
	///  try to execute combat Ai vs Ai neutrals
	///
	class H7InstantCommandDoCombat_Execute : public HookFunction
	{
	public:
		H7InstantCommandDoCombat_Execute(AIMod* pBase) : HookFunction(pBase, "Function MMH7Game.H7InstantCommandDoCombat.Execute") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->H7InstantCommandDoCombat_Execute(This, Stack_frame, pResult);
		};

	} _fH7InstantCommandDoCombat_Execute;

	///
	/// Function H7CombatController.EndOfCombat.TravelBack
	/// EndOfCombat - controller state
	/// Returns to Adventure map after combat
	///
	class H7CombatController_EndOfCombat_TravelBack : public HookFunction
	{
	public:
		H7CombatController_EndOfCombat_TravelBack(AIMod* pBase) : HookFunction(pBase, "Function H7CombatController.EndOfCombat.TravelBack") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->H7CombatController_EndOfCombat_TravelBack(This, Stack_frame, pResult);
		};

	} _fH7CombatController_EndOfCombat_TravelBack;

	///
    /// Process internal function H7CombatController_GetInstance
	/// To get instance of current combat controller
    ///
	class H7CombatController_GetInstance : public HookFunction
	{
	public:
		H7CombatController_GetInstance(AIMod* pBase) : HookFunction(pBase, "Function MMH7Game.H7CombatController.GetInstance") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->H7CombatController_GetInstance(This, Stack_frame, pResult);
		};

	} _fH7CombatController_GetInstance;

	//
	// Function MMH7Game.H7AdventureController.DoBackToAdventureFromCombat
	// Rewrite to return defended army back to map
	// 
	class H7AdventureController_DoBackToAdventureFromCombat : public HookFunction
	{
	public:
		H7AdventureController_DoBackToAdventureFromCombat(AIMod* pBase) : HookFunction(pBase, "Function MMH7Game.H7AdventureController.DoBackToAdventureFromCombat") {}
		int Func(__int64 This, __int64 Stack_frame, void* pResult)
		{
			return ((AIMod*)_pBase)->H7AdventureController_DoBackToAdventureFromCombat(This, Stack_frame, pResult);
		};

	} _fH7AdventureController_DoBackToAdventureFromCombat;

};

typedef std::shared_ptr<AIMod> AIModPtr;
