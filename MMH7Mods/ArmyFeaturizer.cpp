#include "StdAfx.h"
#include "ArmyFeaturizer.h"
#include "SdkClasses.h"

ArmyFeaturizer::ArmyFeaturizer(void)
{
	//
	// Create creatures slots Initialization
	// We create creature 7 creature slots for each
	// createure tier.
	//
	for(int i=0; i < MAX_CREATURES_TIER_SLOTS; ++i)
		for (int j=0; j < MAX_CREATURES_SLOTS; ++j)
			_creatures_slots[i].push_back(CreatureStackFeaturizerPtr(new CreatureStackFeaturizer()));
}


ArmyFeaturizer::~ArmyFeaturizer(void)
{
}

void ArmyFeaturizer::Init(void* parmy)
{
	AH7CombatArmy* army = (AH7CombatArmy*) parmy;
	if( !army) return;
	
	std::vector<int> tiers_counter(MAX_CREATURES_TIER_SLOTS, 0);
	const int count = army->mCreatureStacks.Count;
	int creature_vec_size=0;
	for(int i=0; i < count; i++){
		const int creature_tier = army->mCreatureStacks.Data[i]->mCreature->mTier;
		if( creature_tier >= MAX_CREATURES_TIER_SLOTS ) continue;
		const int current_creature = tiers_counter[creature_tier];
		if( current_creature < MAX_CREATURES_SLOTS)
		{
			_creatures_slots[creature_tier][current_creature]->Init(army->mCreatureStacks.Data[i]);
			tiers_counter[creature_tier]++;
		}
	}

}
