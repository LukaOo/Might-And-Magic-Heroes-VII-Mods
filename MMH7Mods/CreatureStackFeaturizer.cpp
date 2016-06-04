#include "StdAfx.h"
#include "CreatureStackFeaturizer.h"
#include "SdkClasses.h"


CreatureStackFeaturizer::CreatureStackFeaturizer(void)
{
}


CreatureStackFeaturizer::~CreatureStackFeaturizer(void)
{
}

void CreatureStackFeaturizer::Init(void* pcreature_stack)
{
   AH7CreatureStack* creature_stack = (AH7CreatureStack*)pcreature_stack;
   mInitialStackSize = creature_stack->mInitialStackSize;
   mStackSize = creature_stack->mStackSize;
   mTopCreatureHealth = creature_stack->mTopCreatureHealth;
   mIsVisible = creature_stack->mIsVisible;
   mInitiative = creature_stack->mInitiative;
   mModifiedInitiative = creature_stack->GetModifiedStatByID(STAT_INITIATIVE, 0);
   mDefense = creature_stack->mDefense;
   mModifiedDefense = creature_stack->GetModifiedStatByID(STAT_DEFENSE, 0);
   mAttack = creature_stack->mAttack;
   mModifiedAttack = creature_stack->GetModifiedStatByID(STAT_ATTACK, 0);
   mAttackCount = creature_stack->mAttackCount;
   mModifiedAttackCount = creature_stack->GetModifiedStatByID(STAT_ATTACK_COUNT, 0);
   mLeadership = creature_stack->mLeadership;
   mModifiedLeadership = creature_stack->GetModifiedStatByID(STAT_MORALE_LEADERSHIP, 0);
   mDestiny = creature_stack->mDestiny;   
   mModifiedDestiny = creature_stack->GetLuckDestiny();
   mMoveCount = creature_stack->mMoveCount;
   mModifiedMoveCount = creature_stack->GetModifiedStatByID(STAT_MOVE_COUNT, 0);
   mKillsOnCurrentTurn = creature_stack->mKillsOnCurrentTurn;
   mIsMoralTurn = creature_stack->mIsMoralTurn;
   mIsAdditionalTurn = creature_stack->mIsAdditionalTurn;
   mAttackCountMod = creature_stack->mAttackCountMod;
   mSkipTurn = creature_stack->mSkipTurn;
   mGridPos_X = creature_stack->mGridPos.X;
   mGridPos_Y = creature_stack->mGridPos.Y;
   mRange = creature_stack->mRange;
   mFlankingBonus = creature_stack->mFlankingBonus;
   mMaximumDamage = creature_stack->mMaximumDamage;
   mMinimumDamage = creature_stack->mMinimumDamage;
   mIsSummoned = creature_stack->mIsSummoned;
   mSchoolType = creature_stack->mSchoolType;
   mMagicAbs = creature_stack->mMagicAbs;

   // creature
   AH7Creature *creature = creature_stack->mCreature;
   mTier = creature->mTier;
   mCreatureLevel = creature->mCreatureLevel;
   mBaseSize = creature->mBaseSize;
   mMovementType = creature->mMovementType;
   mAttackRange = creature->mAttackRange;
   mMeleePenalty = creature->mMeleePenalty;
   mUseAmmo = creature->mUseAmmo;
   mXp = creature->mXp;
   mIsFlankable = creature->mIsFlankable;
   mIsFullFlankable = mIsFullFlankable;
   mPowerValue = creature->mPowerValue;
   mRetaliationCharges = creature->mRetaliationCharges;
   mAmmo = creature->mAmmo;
   mDefendAbilityPowerValue = creature->mDefendAbility->mPowerValue; 
}
