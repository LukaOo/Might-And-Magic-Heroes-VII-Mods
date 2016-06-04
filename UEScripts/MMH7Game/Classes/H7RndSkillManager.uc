//=============================================================================
// H7RndSkillManager
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RndSkillManager extends Object
	native;

var protected H7SkillManager            mSkillManager;
var protected array<H7Skill>            mPickableSkillPool;
var protected array<H7HeroAbility>      mPickableAbilityPool;
var protected array<int>                mWeightForAbilities;
var protected array<int>                mWeightForSkills;

var protected array<H7Skill>            mPickedSkills;
var protected array<H7HeroAbility>      mPickedAbilities;
var protected array<H7Skill>            mLearnedSkills;

var protected array<H7LevelUpData>      mStatIncreases;

var protected H7RelativeWeightData      mWeightDataConfig;
var protected bool                      IsOptionalAbility;
var protected int                       mAbilitySlot; 
var protected int                       mSkillSlot; 
var protected int                       mMaxSkillSlot; 

var protected int                       mSumAbilityProbability;
var protected int                       mSumSkillProbability;

var protected bool                      mIsReset;


function array<H7Skill>         GetPickedSkills()           { return mPickedSkills; }
function array<H7Skill>         GetLeanedSkills()           { return mLearnedSkills; }
function array<H7HeroAbility>   GetPickedAbilities()        { return mPickedAbilities; }
function int                    GetPickedAbilitiesLength()  { return mPickedAbilities.Length; }   
function array<H7LevelUpData>   GetStatIncreases()          { return mStatIncreases; }

function int                    GetMaxSkillSlot()           { return mMaxSkillSlot; }
function int                    GetSkillSlot()              { return mSkillSlot; }
function int                    GetmAbilitySlot()           { return mAbilitySlot; }

function bool                   IsReset()                   { return mIsReset; }

function AddSkillToPool(H7Skill skill , int weight)
{
	mPickableSkillPool.AddItem(skill);
	mWeightForSkills.AddItem(weight);
}

function AddAbilityToPool(H7HeroAbility ability, int weight)
{
	 mPickableAbilityPool.AddItem(ability);
	 mWeightForAbilities.AddItem(weight);
}

function array<H7LevelUpData>   GetCurrentStatIncreases()    
{
	//local H7LevelUpData data;
	return mStatIncreases;//.Length > 0 ? mStatIncreases[0] : data;
}


function Init( H7SkillManager skillManager)
{
	local H7AdventureConfiguration AdvConfig;
	AdvConfig = class'H7AdventureController'.static.GetInstance().GetConfig();
	IsOptionalAbility = AdvConfig.mOptionalAbility;
	mMaxSkillSlot = AdvConfig.mMaxSkillSlot;
	mSkillSlot = AdvConfig.mSkillSlot; 
	mAbilitySlot = AdvConfig.mAbilitySlot; 
	mSkillManager = skillManager;
	mWeightDataConfig = AdvConfig.mWeightData;
	mIsReset = true;
}

function GenerateNewBatch()
{
     Reset();
	 GeneratePoolOfSkillsToLearn();
	 GeneratePoolOfAbilitesToLearn();
	 SetNewSkillsForPicking();
	 SetNewAbilitiesForPicking();
	 mIsReset = false;
}

function Reset()
{
	mPickableSkillPool.Length = 0;
	mPickableAbilityPool.Length = 0;

	mPickedSkills.Length = 0;
	mPickedAbilities.Length = 0;
	mWeightForAbilities.Length = 0;
	mSumAbilityProbability = 0;

	mWeightForSkills.Length = 0;
	mSumSkillProbability = 0;
	mIsReset = true;
}

function int NumberOfSkillsMaxed()
{
	local H7Skill skill;
	local int amount;

	foreach mLearnedSkills( skill )
	{
		if( mSkillManager.HasSkillMaxedOut( skill.GetID(), skill.GetSkillTier()) ) 
			amount++;
	}

	return amount;
}


function SetNewSkillsForPicking()
{
	local int i,index,numOfSkillsToLearn;
	local H7Skill skill; 

	numOfSkillsToLearn = NumberOfSkillsMaxed();

	for(i=0;i<mSkillSlot;++i)
	{
		// check if it is possible to learn a new skill
		if( (mLearnedSkills.Length - numOfSkillsToLearn) < mMaxSkillSlot )
		{
			skill = PickSkillFromPool(true);
			index = mPickableSkillPool.Find( skill );
			if( index != INDEX_NONE )
			{
				mPickedSkills.AddItem( skill );
				mPickableSkillPool.Remove( index, 1 );
				mSumSkillProbability -= mWeightForSkills[index];
				mWeightForSkills.Remove( index, 1);
			}
		}
		else 
		{
			skill = PickSkillFromPool(false);
			index = mPickableSkillPool.Find( skill );
			if( index != INDEX_NONE )
			{
				mPickedSkills.AddItem( skill );
				mPickableSkillPool.Remove( index, 1 );
				mSumSkillProbability -= mWeightForSkills[index];
				mWeightForSkills.Remove( index, 1);
			}
		}
	}
}

function SetNewAbilitiesForPicking()
{
	local int i,index;
	local H7HeroAbility pickedAbility; 

	// do it for the ability slots 
	for(i=0;i<mAbilitySlot;++i)
	{
		if(IsOptionalAbility)
		{
			pickedAbility = PickAbilityFromPool();
			
			if( pickedAbility == none )
				return;
		}
		else
		{
			pickedAbility = PickAbilityFromPool();

			if( pickedAbility == none )
				return;
		}
			
		index = mPickableAbilityPool.Find( pickedAbility );
		if( index != INDEX_NONE ) 
		{
			mPickableAbilityPool.Remove( index, 1 );
			mSumAbilityProbability -= mWeightForAbilities[index];
			mWeightForAbilities.Remove( index, 1);
		}
		mPickedAbilities.AddItem( pickedAbility );
	}
}

function GeneratePoolOfSkillsToLearn()
{
	local array<H7Skill> skills;
	local H7Skill skill;

	skills = mSkillManager.GetAllSkills();
	
	

	foreach skills(skill)
	{
		if( skill.GetCurrentSkillRank() >= SR_NOVICE && mLearnedSkills.Find(skill) == -1)
		{
			mLearnedSkills.AddItem(skill);
		}

		if( mSkillManager.CanIncreaseSkillRank( skill.GetID() ) )
		{
			mPickableSkillPool.Additem( skill );
		}
	}
	GenerateWeightsForSkillPool();
}


function GeneratePoolOfAbilitesToLearn()
{
	mPickableAbilityPool =  mSkillManager.GetAllUnlearnedAbilites(false);
	GenerateWeightsForAbilityPool();
}


function GenerateWeightsForAbilityPool()
{
	local int i;

	for(i=0; i<mPickableAbilityPool.Length; ++i)
	{
		mWeightForAbilities.InsertItem( i, GetWeightForAbility(mPickableAbilityPool[i]));
		mSumAbilityProbability += mWeightForAbilities[i];
	}
}


function GenerateWeightsForSkillPool()
{
	local int i;
	
	for(i=0;i<mPickableSkillPool.Length;++i)
	{
		mWeightForSkills.InsertItem( i, GetWeightForSkill( mPickableSkillPool[i] )); 
		mSumSkillProbability += mWeightForSkills[i];
	}
}


function int GetWeightForSkill( H7Skill skill )
{
	switch ( skill.GetNextSkillRank()  )
	{
		case SR_EXPERT:
			return mWeightDataConfig.SkillWeightExpert;
		case SR_MASTER:
			return mWeightDataConfig.SkillWeightMaster;
		case SR_NOVICE:
		default:
			return  mWeightDataConfig.SkillWeightNovice; 
	}
}

function int GetWeightForAbility( H7HeroAbility ability )
{
	switch ( ability.GetRank()  )
	{
		case SR_EXPERT:
			return mWeightDataConfig.AbilityWeightExpert;
		case SR_MASTER:
			return ability.IsGrandMasterAbility() ? mWeightDataConfig.AbilityWeightGrandmaster :  mWeightDataConfig.AbilityWeightMaster ;
		case SR_NOVICE:
		default:
			return  mWeightDataConfig.AbilityWeightNovice; 
	}
}

/* Pick an ability from our pool **/
function H7HeroAbility PickAbilityFromPool(optional bool withoutWeight, optional bool ignoreUltimate )
{
	local int i, CurrProbability,Probability, randomNumber;
	local H7HeroAbility ability;
	local array<H7HeroAbility> possibleAbilities;

	;
	// we need a pool to pick from
	if( mPickableAbilityPool.Length <= 0 ) 
		return none;

		if(!withoutWeight)
	{
		// weights should be set already
		if( mWeightForAbilities.Length <= 0) 
			return none;

		// mismatch can lead to errors 
		if( mPickableAbilityPool.Length != mWeightForAbilities.Length )
			return none; 

 		Probability = Rand( mSumAbilityProbability );

		for( i=0; i<mWeightForAbilities.Length; ++i )
		{
			CurrProbability += mWeightForAbilities[i];
			if( Probability <= CurrProbability )
			{
				return mPickableAbilityPool[i];
			}
		}
	}
	else
	{
		randomNumber = Rand(mPickableAbilityPool.Length);

		if(mPickableAbilityPool[randomNumber].IsGrandMasterAbility() && ignoreUltimate)
		{
			foreach mPickableAbilityPool(ability)
			{
				if(!ability.IsGrandMasterAbility())
				{
					possibleAbilities.AddItem(ability);
				}
			}

			if(possibleAbilities.Length > 0)
			{
				randomNumber = Rand(possibleAbilities.Length);
				return possibleAbilities[randomNumber];
			}
			else
			{
				return none;
			}
		}
		else
		{
			return mPickableAbilityPool[randomNumber];
		}
	}

	return none;
}

/* Pick an skill from our pool **/
function H7Skill PickSkillFromPool( bool FromPool)
{
	local int i, CurrProbability,Probability;

	// we need a pool to pick from
	if( mPickableSkillPool.Length <= 0 && FromPool) 
		return none;

	// weights should be set already
	if( mWeightForSkills.Length <= 0 && FromPool) 
		return none;

	// mismatch can lead to errors 
	if( mPickableSkillPool.Length != mWeightForSkills.Length && FromPool)
		return none; 
	
	if( !FromPool )
	{
		mSumSkillProbability = 0;
 		for(i=0; i< mLearnedSkills.Length; ++i) 
		{ 
			if( mPickedSkills.Find(mLearnedSkills[i]) == INDEX_NONE && mSkillManager.CanIncreaseSkillRank( mLearnedSkills[i].GetID() ))
			{
				mSumSkillProbability += GetWeightForSkill( mLearnedSkills[i]);
			}
		}
	}

	Probability = Rand( mSumSkillProbability );

	if( FromPool )
	{
		for( i=0; i<mWeightForSkills.Length; ++i )
		{
			CurrProbability += mWeightForSkills[i];
			if( Probability <= CurrProbability )
			{
				return mPickableSkillPool[i];
			}
		}
	}
	else // pick from learned skills
	{
		for(i=0; i< mLearnedSkills.Length; ++i) 
		{ 
			if( mPickedSkills.Find(mLearnedSkills[i]) == INDEX_NONE && mSkillManager.CanIncreaseSkillRank( mLearnedSkills[i].GetID() ) )
			{
				CurrProbability += GetWeightForSkill( mLearnedSkills[i] );
				if( Probability <= CurrProbability )
				{
					return mLearnedSkills[i];
				}
			}
		}
	}
	return none;
}

function DequeueStatIncreases()
{
	// delete the all
	mStatIncreases.Remove( 0, mStatIncreases.Length );
}

function QueueStatIncrease( H7LevelUpData str ) 
{
	mStatIncreases.AddItem( str );
}

function ClearPickedAbilitiesAndSkills()
{
	mPickedAbilities.Length = 0;
	mPickedSkills.Length = 0;
}

function SetIsReset( bool isReset )
{
	mIsReset = isReset;
}

function AddPickedAbility( H7HeroAbility ability )
{
	mPickedAbilities.AddItem( ability );
}

function AddPickedSkill( H7Skill skill )
{
	mPickedSkills.AddItem( skill );
}
