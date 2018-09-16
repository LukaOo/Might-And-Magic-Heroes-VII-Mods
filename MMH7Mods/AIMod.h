#pragma once
#include "HookBase.h"

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
	/// Functions
	///
	int AiAdventureMap_ThinkFunc(__int64 pthis, __int64 stach_frame, void* pResult);

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
};

typedef std::shared_ptr<AIMod> AIModPtr;
