//=============================================================================
// H7MapInfo
//=============================================================================
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MapInfo extends H7MapInfoBase
	native;

var(MapGeneralProperties) protected SeqAct_Interp mEndMapMatinee<DisplayName="End Matinee">;
var(MapGeneralProperties) protected string mNextMap<DisplayName="Next Map (for quick testing)">;
var(MapGeneralProperties) protected array<localized string> mPreviouslyOn<DisplayName="Previously On">;
var(MapGeneralProperties) protected EMapType mMapType<DisplayName="Map Type">;
var(MapGeneralProperties) protected editconst EH7MapSize mMapSize<DisplayName="Map Size">;
var(MapGeneralProperties) protected int mStartDay<DisplayName="Start Day"|ClampMin=1|ClampMax=7>;
var(MapGeneralProperties) protected int mStartWeek<DisplayName="Start Week"|ClampMin=1|ClampMax=4>;
var(MapGeneralProperties) protected int mStartMonth<DisplayName="Start Month"|ClampMin=1|ClampMax=12>;
var(MapGeneralProperties) protected int mStartYear<DisplayName="Start Year"|ClampMin=1|ClampMax=1000>;
var(MapGeneralProperties) protected int mWaterHeight<DisplayName="Water Height"|ClampMin=1|ClampMax=100>;
var(MapGeneralProperties) protected int mUndergroundWaterHeight<DisplayName="Dungeon Water Height"|ClampMin=1|ClampMax=100>;
// Resource Set used for this map. Will override the global Resource Set
var(MapGeneralProperties) protected archetype H7ResourceSet mResourceSet<DisplayName="Resource Set">;
var(TearOfAsha) protectedwrite H7TearOfAsha mTearOfAshaTemplate<DisplayName="Tear of Asha Artifact Template">;
var(TearOfAsha) protectedwrite H7HeroAbility mTearOfAshaSpellTemplate<DisplayName="Tear of Asha Retrieval Spell Template">;

var(MapPlayerProperties) MapInfoPlayerProperty mPlayerProperties[EPlayerNumber.PN_MAX]<DisplayName="Player Properties">; //using index as player number
var(MapPlayerProperties) protected editconst int mPlayerAmount<DisplayName="Player Amount">;
var(MapPlayerProperties) protected editconst bool mRandomStartPositionAvailable<DisplayName="Random Start Position Available">;

var(MapLoadingProperties) protected bool mLoadingWaitingForKey<DisplayName="Wait for key press">;
var(MapLoadingProperties) protected string mLoadingTitle<DisplayName="Loading Title">;
var(MapLoadingProperties) protected string mLoadingText<DisplayName="Loading Text">;
var protected int mLoadingImageOption;
var protected string mLoadingImagePath;

var(MapWeeklyEvents) protected array<archetype H7Week> mWeeklyEvents<DisplayName="Weekly Events">;
var protected bool mInitedWeeklyEvents;//when false, mWeeklyEvents needs to be initialized

// Suppress the automatic generation of Victory Conditions for savegame compatibility
var(MapVictoryConditions) protected bool mLockVictoryConditions<DisplayName="Lock Victory Conditions">;
var(MapVictoryConditions) protected editconst array<EVictoryCondition> mAvailableVictoryConditions<DisplayName="Available Victory Conditions">;
var(MapVictoryConditions) private editconst EGameWinConditionType mWinConditionType<DisplayName="Specific Victory Condition">;
var(MapVictoryConditions) private editconst bool mIncludeStandardWinConditions<DisplayName="Includes Standard Condition">;
// For "defeat neutral army" victory condition
var(MapVictoryConditions) private editconst string mWinConditionArmyToDefeat<DisplayName="Army to defeat">;
// For "defeat AI hero" victory condition
var(MapVictoryConditions) private editconst string mWinConditionHeroToDefeat<DisplayName="Hero to defeat">;
// For "acquire artifact" victory condition
var(MapVictoryConditions) private editconst string mWinConditionArtifactToAcquire<DisplayName="Artifact to aquire">;
// For "accumulate resources" victory condition
var(MapVictoryConditions) private editconst array<H7ResourceQuantity> mWinConditionResourcesToCollect<DisplayName="Resources to accumulate">;
// For "capture town" victory condition
var(MapVictoryConditions) private editconst H7Town mWinConditionTownToCapture<DisplayName="Town to capture">;
// For "transfer artifact" victory condition
var(MapVictoryConditions, ArtifactTransfer) private editconst archetype H7HeroItem mWinConditionArtifactToTransfer<DisplayName="Artifact to transfer">;
// For "transfer artifact" victory condition
var(MapVictoryConditions, ArtifactTransfer) private editconst H7Town mWinConditionArtifactTransferTown<DisplayName="Town to transfer the artifact to">;
// For "accumulate creatures" victory condition
var(MapVictoryConditions, AccumulateCreatures) private editconst ECreatureTier mWinConditionAccumulateCreatureTier<DisplayName="Tier of creatures to accumulate">;
// For "accumulate creatures" victory condition
var(MapVictoryConditions, AccumulateCreatures) private editconst int mWinConditionAccumulateCreatureAmount<DisplayName="Amount of creatures to accumulate">;
var(MapVictoryConditions) protected editconst EGameLoseConditionType mLoseConditionType<DisplayName="Lose Condition">;
var(MapVictoryConditions) private editconst H7Town mLoseConditionTownToLose<DisplayName="Town to lose">;
var(MapVictoryConditions) private editconst H7AdventureArmy mLoseConditionHeroToLose<DisplayName="Hero Army to lose">;
var(MapVictoryConditions) private editconst int mLoseConditionWeekTimeLimit<DisplayName="Turn limit">;

// Forbidden spells
var(MapPools) array<H7HeroAbility> mForbiddenSpells<DisplayName="Forbidden Spells">;

// Forbidden weeks, use string to match 
var(MapPools) array<string> mForbiddenWeeks<DisplayName="Forbidden Weeks">;

// Forbidden artifacts
var(MapPools) array<H7HeroItem> mForbiddenHeroItems<DisplayName="Forbidden Artifacts">;

// Custom Heroes that are added to the game's Hall of Hero
var(MapPools) array<H7EditorHero> mCustomHallOfHeroes<DisplayName="Custom Hall of Heroes">;

// Custom Factions/Heroes/Creatures list for heropedia
var (MapPools) array<H7Faction> mCustomFactions<DisplayName="Custom Factions to show in Heropedia">;
var (MapPools) array<H7EditorHero> mCustomHeroes<DisplayName="Custom Heroes to show in Heropedia">; 
var (MapPools) array<H7Creature> mCustomCreatures<DisplayName="Custom Creatures to show in Heropedia">;

// Custom creature list for heropedia

//Map saved object references, necessary for storing archetypes in the map package!
var private array<Object> mStoredObjects;

var protected H7MapData mMapData; // Internal data that should be accessed without loading the map (during map listing)

function SeqAct_Interp GetEndMatinee() { return mEndMapMatinee; }
function string GetNextMap() { return mNextMap; }
native function EMapType GetMapType();
function int GetStartDay() { return mStartDay; } 
function int GetStartWeek() { return mStartWeek; } 
function int GetStartMonth() { return mStartMonth; } 
function int GetStartYear() { return mStartYear; }
function int GetMaxHeroLevelForPlayer( EPlayerNumber playerNumber ) { return mPlayerProperties[ playerNumber ].mMaxLevel; }
function int GetPlayerAmount() { return mPlayerAmount; }
function array <H7HeroItem> GetForbiddenItemList(){ return mForbiddenHeroItems; }
function H7MapData GetMapData() { return mMapData; };

function array<H7Faction> GetCustomFactions() {return mCustomFactions;}
function array<H7EditorHero> GetCustomHeroes() {return mCustomHeroes;}
function array<H7Creature> GetCustomCreatures() {return mCustomCreatures;}

native function array<H7BaseAbility> GetAllowedSpellList();

function array<MapInfoPlayerProperty> GetPlayerProperties() 
{ 
	local array<MapInfoPlayerProperty> playerProperties;
	local int i;

	for( i = 0; i < ArrayCount( mPlayerProperties ); ++i )
	{
		if( mPlayerProperties[i].mSlot != EPlayerSlot_Closed)
		{
			playerProperties.AddItem( mPlayerProperties[i] );
		}
	}
	return playerProperties;
}

function array<EStartPosition> GetAvailableStartPositions()
{
	local array<EStartPosition> availableStartPositions;
	local EStartPosition startPosition;
	local int i;
	local array<MapInfoPlayerProperty> playerProperties;
	
	playerProperties = GetPlayerProperties();

	for(i=1;i<playerProperties.Length;i++)
	{
		startPosition = EStartPosition(i);
		if(playerProperties[startPosition].mPlayerStartAvailable)
		{
			availableStartPositions.AddItem(startPosition);
		}
	}
	return availableStartPositions;
}

function H7ResourceSet GetResourceSet()
{
	if(mResourceSet == none)
	{
		return class'H7GameData'.static.GetInstance().GetResourceSet();
	}
	return mResourceSet;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

