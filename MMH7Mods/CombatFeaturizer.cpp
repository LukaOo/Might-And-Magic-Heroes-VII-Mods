#include "StdAfx.h"
#include "CombatFeaturizer.h"
#include "SdkClasses.h"

CombatFeaturizer::CombatFeaturizer(void)
{
}


CombatFeaturizer::~CombatFeaturizer(void)
{
}

void CombatFeaturizer::Init(void* pcombap)
{
	AH7CombatController* combat_controller = (AH7CombatController*) pcombap;
	if( !combat_controller ) return;

	_myArmy.Init( combat_controller->mArmyAttacker );
	_opponentArmy.Init( combat_controller->mArmyDefender );
}
