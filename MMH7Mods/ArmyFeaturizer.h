#pragma once
#include <memory>
#include <vector>
#include "featurizer.h"
#include "CreatureStackFeaturizer.h"

typedef std::vector<CreatureStackFeaturizerPtr> CreatureStackFeaturesArray;

#define MAX_CREATURES_TIER_SLOTS 3
#define MAX_CREATURES_SLOTS 7

///
/// Army featurizer
/// Support for creature army features
///
class ArmyFeaturizer :
	public Featurizer
{
public:
	ArmyFeaturizer(void);
	~ArmyFeaturizer(void);

	//
	// Override base class initialization 
	//
	void Init(void* pcreature_stack);

private:
	CreatureStackFeaturesArray _creatures_slots[MAX_CREATURES_TIER_SLOTS];
};

