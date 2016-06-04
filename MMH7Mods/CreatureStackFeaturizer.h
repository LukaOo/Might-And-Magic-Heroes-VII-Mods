#pragma once
#include <memory>
#include "Featurizer.h"



///
/// Single stack featurizer on combat map
/// 
class CreatureStackFeaturizer : public Featurizer
{
public:
	CreatureStackFeaturizer(void);
	~CreatureStackFeaturizer(void);

	virtual void Init(void* params);
public :
	///
	/// Declare features set
	///
	Fea mInitialStackSize;
    Fea mStackSize;
    Fea mTopCreatureHealth;
    Fea mIsVisible;
    Fea mInitiative;
	Fea mModifiedInitiative;
    Fea mDefense;
	Fea mModifiedDefense;
    Fea mAttack;
	Fea mModifiedAttack;
	Fea mAttackCount;
	Fea mModifiedAttackCount;
    Fea mLeadership;
    Fea mModifiedLeadership;
	Fea mDestiny;
	Fea mModifiedDestiny;
	Fea mMoveCount;
	Fea mModifiedMoveCount;
	Fea mKillsOnCurrentTurn;
	Fea mIsMoralTurn;
	Fea mIsAdditionalTurn;
	Fea mAttackCountMod;
    Fea mSkipTurn;
	Fea mGridPos_X;
	Fea mGridPos_Y;
	Fea mRange;
	Fea mFlankingBonus;
	Fea mMaximumDamage;
	Fea mMinimumDamage;
	Fea mIsSummoned;
	Fea mSchoolType;
	Fea mMagicAbs;

    // from creature
    Fea mTier;
    Fea mCreatureLevel;
	Fea mBaseSize;
	Fea mMovementType;
	Fea mAttackRange;
	Fea mMeleePenalty;
	Fea mUseAmmo;
	Fea mXp;
	Fea mIsFlankable;
	Fea mIsFullFlankable;
	Fea mPowerValue;
	Fea mRetaliationCharges;
	Fea mAmmo;
	Fea mDefendAbilityPowerValue;
};

typedef std::shared_ptr<CreatureStackFeaturizer> CreatureStackFeaturizerPtr;




