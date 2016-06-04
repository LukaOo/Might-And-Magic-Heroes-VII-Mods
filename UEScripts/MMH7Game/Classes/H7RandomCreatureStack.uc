/*=============================================================================
 * H7RandomCreatureStack
 * 
 * 1x1 tile object as placeholder for a randomly composed Creature Stack
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
=============================================================================*/
class H7RandomCreatureStack extends H7AdventureObject
	implements(H7IRandomSpawnable)
	hideCategories(Editor)
	native
	placeable;



var(RandomCreatureStack) protected EPlayerNumber mPlayerNumber<DisplayeName="Player Number">;

// Minimal this amount of stacks will be part of this army. Cannot be higher than Max Stack Number.
var(RandomCreatureStack) protected int mMinStackNumber<DisplayName="Min Stack Number"|ClampMin=1|ClampMax=7>;
// Maximal this amount of stacks will be part of this army. Cannot be lower than Min Stack Number.
var(RandomCreatureStack) protected int mMaxStackNumber<DisplayName="Max Stack Number"|ClampMin=1|ClampMax=7>;

// List of all factions to be checked for random picking.
var(RandomCreatureStack) protected archetype array<H7Faction> mAllowedFactions<DisplayName="Permitted Factions">;

// How to resolve the faction of this army.
var(RandomCreatureStack) protected ERandomSiteFaction mFactionType<DisplayName="Faction Type">;

// This stack will take the same faction as the selected building.
var(RandomCreatureStack) protected H7AreaOfControlSiteLord mReferenceLord<DisplayName="Faction as Town/Fort">;

// Enables to select a creature level to get the random creature chosen from.
var(RandomCreatureStack) protected bool mUseCreatureLevel<DisplayName="Use Creature Level">;
// Creature level to get the random creature chosen from.
var(RandomCreatureStack) protected H7BooleanStruct mAllowedLevels[ECreatureLevel.E_H7_CL_MAX]<DisplayName="Allowed Creature Levels"|EditCondition=mUseCreatureLevel>;

// Enables to use an amount of xp to define the strength of this army. When unchecked the army will be created from random stacksizes.
var(RandomCreatureStack) protected bool mUseXPStrength<DisplayName="Use XP Strength">;
// This amount of experience points will be divided through the number of stacks and then devided through the single xp of the respective chosen creature to get the stacksizes.
var(RandomCreatureStack) protected int	mXPStrength<DisplayName="XP Strength"|EditCondition=mUseXPStrength>;
// Minimal this amount of creatures will be part in stacks. Cannot be higher than Max Stack Size.
var(RandomCreatureStack) protected int  mMinStackSize<DisplayName="Min Stack Size"|EditCondition=!mUseXPStrength|ClampMin=1>;
// Maximal this amount of creatures will be part in stacks. Cannot be lower than Min Stack Size.
var(RandomCreatureStack) protected int  mMaxStackSize<DisplayName="Max Stack Size"|EditCondition=!mUseXPStrength|ClampMin=1>;

// Enables the usage of different Creatures in the various stacks
var(RandomCreatureStack) protected bool mChooseRandomCreatures<DisplayName="Choose Random Creatures">;
// Forces all Creatures to be chosen from the same Faction
var(RandomCreatureStack) protected bool mChooseSameFaction<DisplayName="Use Same Faction For All">;
// Limits the Allowed Creature Levels (Tiers) based on the specified XP Strength
var(RandomCreatureStack) protected bool mLimitLevelsFromXP<DisplayName="Limit Allowed Creature Levels from XP Strength"|EditCondition=mUseXPStrength>;

// Factor for the standard growthrate.
var(RandomCreatureStack) protected int mGrowthratePercent<DisplayName="Growth Rate Modifier (%)"|ClampMin=0>;
// Types of possible creature upgrades 
var(RandomCreatureStack) protected EArmyCompositionType mCreatureUpgrades<DisplayName="Creature Upgrades">;

var(RandomCreatureStack,Diplomacy) protected EDispositionType       mDiplomaticDisposition<DisplayName="Negotiation Override">;
var(RandomCreatureStack,Diplomacy) protected array<EPlayerNumber>   mDispositionTowardsPlayers<DisplayName="Players affected by Negotiation Override">;

// AI focuses on this army while conquering further areas
var(AISettings) protected bool mAiIsBorderControl<DisplayName="Is Border Control">;
// AI ignores this army
var(AISettings) protected bool mAiOnIgnore<DisplayName="Ignore">;

// Handle with care!
var(Developer) protected bool mOverrideRandomIndex<DisplayName="Override Random Index">;
// Handle with care!
var(Developer) protected int mOverridenRandomIndex<DisplayName="Overriden Random Index">;

const MAX_BIG_CREATURE_STACKS = 4;

function ERandomSiteFaction GetFactionType() { return mFactionType; }

function InitFromStruct( RandomLordDefenseData data )
{
	local int i;

	mMinStackNumber			   =  data.mMinStackNumber;			
	mMaxStackNumber			   =  data.mMaxStackNumber;			
	mAllowedFactions		   =  data.mAllowedFactions;		
	mFactionType			   =  data.mFactionType;
	if( data.mUseFactionOfLord )
	{
		mReferenceLord = data.mReferenceLord;
	}
	mUseCreatureLevel		   =  data.mUseCreatureLevel;		
	for( i = 0; i < E_H7_CL_MAX; ++i )
	{
		mAllowedLevels[i] = data.mAllowedLevels[i];
	}
	mUseXPStrength			   =  data.mUseXPStrength;			
	mXPStrength				   =  data.mXPStrength;				
	mMinStackSize			   =  data.mMinStackSize;			
	mMaxStackSize			   =  data.mMaxStackSize;			
	mChooseRandomCreatures	   =  data.mChooseRandomCreatures;	
	mChooseSameFaction		   =  data.mChooseSameFaction;		
	mLimitLevelsFromXP		   =  data.mLimitLevelsFromXP;		
	mCreatureUpgrades		   =  data.mCreatureUpgrades;		
}

event DisposeShell()
{
	local H7AdventureController advController;
	local H7AdventureMapCell cell;

	advController = class'H7AdventureController'.static.GetInstance();

	cell = advController.GetGridController().GetCellByWorldLocation( Location );

	if( cell != none )
	{
		SetCollisionType( COLLIDE_NoCollision );
		advController.RemoveAdvObject( self );
		cell.SetHasPickable( false );
		SetHidden(true);
	}

	Destroy();
}

event HatchRandomSpawnable()
{
	HatchRandomCreatureStack();
}

event H7Faction GetChosenFaction() { return none; }
function H7AreaOfControlSite GetSpawnedSite() { return none; }

function native SetRandomPlayerNumber( EPlayerNumber number );
function native SetFactionType( ERandomSiteFaction factionType );

protected event RegisterArmy( H7AdventureArmy army )
{
	local H7AdventureController advController;
	local H7AdventureMapCell cell;

	advController = class'H7AdventureController'.static.GetInstance();

	if( army == none || advController == none )
	{
		return;
	}
	
	cell = advController.GetGridController().GetCellByWorldLocation( Location );
	army.Init( advController.GetPlayerByNumber( mPlayerNumber ), cell,, false );

	army.SetCell( cell, true, true, true );
	army.SetAiIsBorderControl(mAiIsBorderControl);
	army.SetAiOnIgnore(mAiOnIgnore);

	advController.AddArmy( army );
}

native function H7AdventureArmy HatchRandomCreatureStack();

static native function AddRandomCreaturestackToArmy( H7AdventureArmy army, H7Faction faction, int amount, ECreatureTier tier = CTIER_MAX );

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

