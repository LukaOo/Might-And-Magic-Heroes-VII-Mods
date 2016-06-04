#pragma once
#include "featurizer.h"
#include "ArmyFeaturizer.h"

///
/// Combat featurizer 
/// Support features for whole combat map
///
class CombatFeaturizer :
	public Featurizer
{
public:
	CombatFeaturizer(void);
	~CombatFeaturizer(void);

	void Init(void* pcombap);

private:
	ArmyFeaturizer _myArmy;
	ArmyFeaturizer _opponentArmy;
};

typedef std::shared_ptr<CombatFeaturizer> CombatFeaturizerPtr;
