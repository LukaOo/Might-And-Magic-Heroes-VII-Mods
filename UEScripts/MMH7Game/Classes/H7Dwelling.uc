/*=============================================================================
* H7Dwelling
* =============================================================================
*  Class for adventure map objects that serve as Dwellings.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Dwelling extends H7AreaOfControlSiteVassal
	native
	implements(H7ITooltipable)
	dependson(H7ITooltipable)
	placeable;

/** The creature pool of this dwelling */
var(Dwelling) savegame protected array<H7DwellingCreatureData>	        mCreaturePool<DisplayName="Creature Pool">;
/** Is this dwelling upgraded? */
var(Upgrade) savegame protected bool									mIsUpgraded<DisplayName="Upgraded">;
/** The cost to upgrade this dwelling */
var(Upgrade) protected array<H7ResourceQuantity>				        mUpgradeCost<DisplayName="Upgrade cost">;
/** Does the dwelling produce creatures? */
var(Developer) savegame bool											mIsProductive<DisplayName="Is Productive">;
var protected savegame array<float>										mDailyGrowthBuffer;
var protected savegame int												mGrowthCycle;

function array<H7DwellingCreatureData> GetCreaturePool()		{ return mCreaturePool; }
function SetCreaturePool( array<H7DwellingCreatureData> pool)	{ mCreaturePool = pool; }
function InitIsUpgraded(bool isUpgraded)						{ self.mIsUpgraded = isUpgraded; }
function bool IsUpgraded()										{ return mIsUpgraded; }
function array<H7ResourceQuantity> GetUpgradeCost()				{ return mUpgradeCost;}
function SetProductive( bool productive )						{ mIsProductive = productive; }

native function EUnitType GetEntityType();

native function bool ProducesUnit( H7Unit unit );

event InitAdventureObject()
{
	local int i, j;
	local array<H7FactionCreatureData> factionData;
	local H7FactionCreatureData chosenData;
	local array<H7Creature> cores, elites, champions;
	local H7SynchRNG synchRNG;

	synchRNG = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG();

	super.InitAdventureObject();

	mDailyGrowthBuffer.Add( mCreaturePool.Length );

	if( mSiteOwner != PN_NEUTRAL_PLAYER ) {	mIsProductive = true; }
	class'H7AdventureController'.static.GetInstance().AddDwelling( self );

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{

		class'H7TransitionData'.static.GetInstance().GetGameData().GetCreatureLists( factionData );
		for( i = 0; i < factionData.Length; ++i )
		{
			if( factionData[i].Faction == GetFaction() )
			{
				chosenData = factionData[i];
				break;
			}
		}

	

		for( i = 0; i < E_H7_CL_MAX; ++i )
		{
			for( j = 0; j < chosenData.CreatureList.Creatures[i].Creatures.Length; ++j )
			{
				if( chosenData.CreatureList.Creatures[i].Creatures[j].GetTier() == CTIER_CORE )
				{
					cores.AddItem( chosenData.CreatureList.Creatures[i].Creatures[j] );
				}
				else if( chosenData.CreatureList.Creatures[i].Creatures[j].GetTier() == CTIER_ELITE )
				{
					elites.AddItem( chosenData.CreatureList.Creatures[i].Creatures[j] );
				}
				else
				{
					champions.AddItem( chosenData.CreatureList.Creatures[i].Creatures[j] );
				}
			}
		}
		for( i = 0; i < mCreaturePool.Length; ++i )
		{
			if( mCreaturePool[i].Creature == none )
			{
				if( mCreaturePool[i].CreatureTier == CTIER_CORE )
				{
					mCreaturePool[i].Creature = cores[ synchRNG.GetRandomInt( cores.Length ) ];
				}
				else if( mCreaturePool[i].CreatureTier == CTIER_ELITE )
				{
					mCreaturePool[i].Creature = elites[ synchRNG.GetRandomInt( elites.Length ) ];
				}
				else
				{
					mCreaturePool[i].Creature = champions[ synchRNG.GetRandomInt( champions.Length ) ];
				}
			}
		}
	}
}

protected function HandleOwnership( H7AdventureHero visitingHero )
{
	super.HandleOwnership( visitingHero );

	mIsProductive = true;
	SetVisitingArmy( visitingHero.GetAdventureArmy() );
	visitingHero.GetAdventureArmy().SetVisitableSite( self );
}

function OnVisit( out H7AdventureHero hero )
{
	super.OnVisit( hero );

	mVisitingArmy = hero.GetAdventureArmy();
	if( !hero.GetPlayer().IsControlledByAI() )
	{
		if( hero.GetPlayer().IsControlledByLocalPlayer() )
		{
			if( hero.GetPlayer() != GetPlayer()  && self.IsA('H7CustomNeutralDwelling'))
			{
				if( hero.GetPlayer().IsPlayerHostile( GetPlayer() ) )
				{
					class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GoToNeutralDwellingScreen(self);
				}
			}
			else
			{
				class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GoToDwellingScreen(self);
			}
		}
	}
	else if( hero.GetPlayer().IsControlledByAI() && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled() )
	{
		RecruitAll();
	}
}

// this function is called by the Ai to upgrade any creatures in the visiting army
function AiUpgradeCreatures()
{
	local array<H7BaseCreatureStack> visStacks;
	local H7BaseCreatureStack cstack;
	local array<ResourceStockpile> stockpiles;
	local ResourceStockpile stockpile;

	// make sure we have a visiting army
	if( mVisitingArmy == None ) return;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	//DbgDumpArmies();

	visStacks = mVisitingArmy.GetBaseCreatureStacks();
	stockpiles = mVisitingArmy.GetAIReplenishStash().GetAllResourcesAsArray();
	foreach stockpiles( stockpile )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		GetPlayer().GetResourceSet().ModifyResource( stockpile.Type, stockpile.Quantity, false );
	}
	mVisitingArmy.ResetAIReplenishStash();

	foreach visStacks(cstack)
	{
		UpgradeUnitAI(mVisitingArmy,cstack);
		cstack.SetLockedForUpgrade( false );
	}

	mVisitingArmy.UnifyStacks();
}

function bool UpgradeUnitAI( H7AdventureArmy army, H7BaseCreatureStack crStack, optional bool doSynchronise = true )
{
	local bool                          isVisiting;
	local array<H7BaseCreatureStack>    armyStacks;
	local int                           k;
	local int                           numOfUpgCreatures;
	local array<H7ResourceQuantity>     upgRes;

	isVisiting=false;
	if(army==None || crStack==None)
	{
		return false;
	}
	if(GetVisitingArmy()==army)
	{
		isVisiting=true;
	}
	// get slotID 
	armyStacks=army.GetBaseCreatureStacks();
	for(k=0;k<armyStacks.Length;k++)
	{
		if(crStack.IsLockedForUpgrade() && armyStacks[k]==crStack)
		{
			upgRes=GetUpgradeInfo(isVisiting,numOfUpgCreatures,crStack);
			if(upgRes.Length>0)
			{
				if(doSynchronise)
				{
					UpgradeUnit(k,isVisiting,numOfUpgCreatures);
				}
				else
				{
					UpgradeUnitComplete(k,isVisiting,numOfUpgCreatures);
				}
				return true;
			}
		}
	}
	return false;
}

/**
 * Gets upgrade costs and the amount of creatures that can be
 * upgraded by out parameter.
 * 
 * @param creature The creature for which to create the upgrade data
 * @param slotID If you set this pararamter you also have to set the next one
 * @param isVisitingArmy If the upgrade action should take place in the visiting army rather than the garrison
 * @param numOfUpgCreatures Shows how many creatures could be upgraded currently
 * @param singleUpgCost can hold the resource cost for upgrading only one unit of the stack, only for gui purposes
 * @param lockNum don't change numOfUpgCreatures
 * 
 * */
function array<H7ResourceQuantity> GetUpgradeInfo( bool isVisitingArmy, out int numOfUpgCreatures, H7BaseCreatureStack creature=none,optional int slotID=-1, optional out array<H7ResourceQuantity> singleUpgCost, optional bool lockNum = false )
{
	local array<H7ResourceQuantity> upgradeCosts;
	local int i;
	if(!lockNum)
	{
		numOfUpgCreatures = 0;
	}
	if(creature == none || creature.GetStackType().GetUpgradedCreature() == none || !mIsUpgraded ||
	   !CreatureIsInPool(creature.GetStackType().GetUpgradedCreature())) return upgradeCosts;

	//get the cost to upgrade ONE creature
	class'H7GameUtility'.static.CalculateCreatureCosts( creature.GetStackType().GetUpgradedCreature(), 1, upgradeCosts, true, creature.GetStackType() );

	/// Week of Training or Idle
	if( class'H7AdventureController'.static.GetInstance().HasUpradeCostWeekEffect())
	{
		for (i=0;i<upgradeCosts.Length;++i)
		{
			if( upgradeCosts[i].Type == GetPlayer().GetResourceSet().GetCurrencyResourceType() )
			{
				upgradeCosts[i].Quantity *= class'H7AdventureController'.static.GetInstance().GetUpgradeCostWeekEffect();
			}
		}
	}

	if(!lockNum)
	{
		if(mVisitingArmy != none && GetPlayer() != mVisitingArmy.GetPlayer())
			numOfUpgCreatures = mVisitingArmy.GetPlayer().GetResourceSet().CanSpendResourcesTimes(upgradeCosts);
		else
			numOfUpgCreatures = GetPlayer().GetResourceSet().CanSpendResourcesTimes(upgradeCosts);	
	}
	if(numOfUpgCreatures > creature.GetStackSize()) numOfUpgCreatures = creature.GetStackSize();

	// return upgCost for one creature so we can show it in gui
	if(numOfUpgCreatures == 0)
		singleUpgCost = upgradeCosts;

	//multiply the single upgrade costs by the amount of actualy upgradeable creatures
	for(i = 0; i < upgradeCosts.Length; i++)
		upgradeCosts[i].Quantity *= numOfUpgCreatures;

	return upgradeCosts;
}


/**
 * Upgrades a specific stack to the next available "upgrade" creature.
 * 
 * @param slotID            The slot number of the stack (in the army) to be upgraded
 * @param isVisitingArmy    Determines whether the command came from the visiting army/garrisoned army
 * @param count             How many of the stack will be upgraded
 * */
function UpgradeUnit( int slotID, bool isVisitingArmy, int count )
{
	local H7InstantCommandUpgradeUnit command;

	command = new class'H7InstantCommandUpgradeUnit';
	command.Init( self, slotID, isVisitingArmy, count );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function UpgradeUnitComplete(int slotID, bool isVisitingArmy, int count)
{
	local H7AdventureArmy army;
	local H7BaseCreatureStack newStack, stack, upgradedStack;
	local array<H7ResourceQuantity> costs;
	local H7Player thePlayer;
	local array<H7BaseCreatureStack> stacks;

	if(mVisitingArmy!=none && GetPlayer() != mVisitingArmy.GetPlayer())
		thePlayer = mVisitingArmy.GetPlayer();
    else
		thePlayer = GetPlayer();

	if( isVisitingArmy ) { army = mVisitingArmy; }
	stacks = army.GetBaseCreatureStacks();
	costs = GetUpgradeInfo( isVisitingArmy, count, stacks[ slotID ],,,true);

	stack = stacks[ slotID ];

	// upgrade all creatures in stack
	if( stack.GetStackSize() == count )
	{
		stack.SetStackType( stack.GetStackType().GetUpgradedCreature() );
	}
	else
	{
		// if we upgrade part of the stack, prefer splitting the stack to merging a new stack with an exisitng one
		if( army.CheckFreeArmySlot() )
		{
			newStack = new class'H7BaseCreatureStack'();
			newStack.SetStackType( stack.GetStackType().GetUpgradedCreature() );
			newStack.SetStackSize( count );
			army.PutCreatureStackToEmptySlot(newStack);
            stack.SetStackSize( stack.GetStackSize() - count );
		}
		else
		{
			upgradedStack = army.GetStackByName(stack.GetStackType().GetUpgradedCreature().GetName());
			if(upgradedStack != none)
			{
				upgradedStack.SetStackSize( upgradedStack.GetStackSize() + count );
				stack.SetStackSize( stack.GetStackSize() - count );
			}
			else
			{
				;
				return;
			}
		}
	}

	if( thePlayer.GetResourceSet().CanSpendResources( costs ) )
	{
		thePlayer.GetResourceSet().SpendResources( costs );
	}

	if( thePlayer.IsControlledByLocalPlayer() )
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons(thePlayer.GetResourceSet().GetAllResourcesAsArray());
	}
}

function bool CreatureIsInPool(H7Creature creature)
{
	local H7DwellingCreatureData data;

	foreach mCreaturePool(data)
	{
		if(data.Creature.GetUpgradedCreature() == creature) return true;
	}
	return false;
}

function int GetGrowthBonus( H7Creature creature, optional out array<H7TooltipModifierInfo> modifiers )
{
	return 0; //growthBonus;
}

function Upgrade()
{
	local H7InstantCommandUpgradeDwelling command;

	if( GetPlayer().GetResourceSet().CanSpendResources( mUpgradeCost ) && !IsUpgraded() )
	{
		command = new class'H7InstantCommandUpgradeDwelling';
		command.Init( self );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	}
}

function UpgradeComplete()
{
	mIsUpgraded = true;
	// owner of building pays, not current or local player
	GetPlayer().GetResourceSet().SpendResources( mUpgradeCost );
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ICON_SELECT");
}

function RecruitDirect(string creatureName, int amount)
{
	local H7InstantCommandRecruitDirect command;

	command = new class'H7InstantCommandRecruitDirect';
	command.Init( creatureName, amount,self );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

/**
 * Recruits a certain amount of a creature from this dwelling
 * 
 * @param creatureName      The name of the creature
 * @param count             The amount of creatures to recruit
 * @param targetIndex       The army slot index into which new recruits have been added
 * 
 * */
function bool Recruit( string creatureName, int count, optional out int targetIndex )
{
	local H7BaseCreatureStack stack;
	local int indexSource;
	local H7Player thePlayer;
	local H7Creature creature;
	local array<H7ResourceQuantity> recruitmentCosts;

	;

	if( mVisitingArmy == none )
	{
		; 
		return false;
	}

	thePlayer = mVisitingArmy.GetPlayer();

	if( count <= 0 ) { return false; }

	creature = GetBaseCreature( creatureName, indexSource );

	if( creature == none ) ;

	// only possible to recruit as much as the current reserve
	if( count > mCreaturePool[ indexSource ].Reserve ) { count = mCreaturePool[ indexSource ].Reserve; }

	;
	
	class'H7GameUtility'.static.CalculateCreatureCosts( creature, count, recruitmentCosts );

	if( thePlayer.GetResourceSet().CanSpendResources( recruitmentCosts ) )
	{	
		// Dwelling has no garrison, so we can only recruit into the visiting army
		stack = mVisitingArmy.GetStackByIDString( creatureName );

		if( stack != none )
		{
			stack.SetStackSize( stack.GetStackSize() + count );
			targetIndex = mVisitingArmy.GetIndexOfStack(stack);
		}
		else if( mVisitingArmy.CheckFreeArmySlot( ) )
		{
			stack = new class'H7BaseCreatureStack'();
			stack.SetStackType( creature );
			stack.SetStackSize( count );
			targetIndex = mVisitingArmy.PutCreatureStackToEmptySlot(stack);
		}
		else
		{
			; 
			return false;
		}

		thePlayer.GetResourceSet().SpendResources( recruitmentCosts );
		mCreaturePool[ indexSource ].Reserve -= count;
		return true;
	}
	else
	{
		return false;
	}
}

function RecruitAll()
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local H7RecruitmentInfo data;

	recruitmentInfo = GetRecruitAllData();

	foreach recruitmentInfo( data )
	{
		RecruitDirect( data.Creature.GetIDString(), data.Count );
	}
}

/**
 * Recruits all possible creatures from the dwelling according to the
 * resources of the current player.
 * the optional parameter is only used at H7AreaOfControlSiteLords implementation
 */
function array<H7RecruitmentInfo> GetRecruitAllData(optional bool checkGarrison=false, optional int freeSlots = -1, optional H7AdventureArmy aiArmy )
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local array<H7RecruitmentInfo> filteredRecruitmentInfo;
	local H7RecruitmentInfo info;
	local H7ResourceSet resourceSet;
	local array<H7ResourceQuantity> potentialCosts;
	local H7AdventureArmy armyToCheck;
	local int recruitableAmount;

	resourceSet =  class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet();
	resourceSet = new class'H7ResourceSet' ( resourceSet );

	if(aiArmy != none)
		armyToCheck = aiArmy;
	else
		armyToCheck = mVisitingArmy;

	if(freeSlots == -1) freeSlots = armyToCheck.GetFreeSlotCount();

	if(mIsUpgraded)
	{
		recruitmentInfo = GetRecruitAllDataSub( resourceSet , false );

		//check how much of the creatures we can actualy recruit
		ForEach recruitmentInfo(info)
		{
			if(info.Count == 0) continue;
			recruitableAmount = GetPossibleRecruitCount( info.Creature, resourceSet, info.Count );
			if(recruitableAmount == 0) continue; 
			class'H7GameUtility'.static.CalculateCreatureCosts( info.Creature, recruitableAmount, potentialCosts );
			info.Count = recruitableAmount;
			info.Costs = potentialCosts;

			if(armyToCheck.HasCreature(info.Creature) )
			{
				filteredRecruitmentInfo.AddItem(info);
				resourceSet.SpendResources( potentialCosts, false );
				potentialCosts.Length = 0;
			}
			else if(freeSlots >= 1)
			{
				filteredRecruitmentInfo.AddItem(info);
				freeSlots--;
				resourceSet.SpendResources( potentialCosts, false );
				potentialCosts.Length = 0;
			}
		}
	}

	// tried recruiting upgraded creatures, now try base versions
	recruitmentInfo = GetRecruitAllDataSub( resourceSet , true );

	//check how much of the creatures we can actualy recruit
	ForEach recruitmentInfo(info)
	{
		// we are already recruiting the upgraded creature so we cant recruit the base creature
		if(isRecruitingUpgradedVersionAlready(filteredRecruitmentInfo, info.Creature)) continue;
		
		if(info.Count == 0) continue;
		recruitableAmount = GetPossibleRecruitCount( info.Creature, resourceSet, info.Count );
		if(recruitableAmount == 0) continue; 
		class'H7GameUtility'.static.CalculateCreatureCosts( info.Creature, recruitableAmount, potentialCosts );
		info.Count = recruitableAmount;
		info.Costs = potentialCosts;

		if(armyToCheck.HasCreature(info.Creature) )
		{
			filteredRecruitmentInfo.AddItem(info);
			resourceSet.SpendResources( potentialCosts, false );
			potentialCosts.Length = 0;
		}
		else if(freeSlots >= 1)
		{
			filteredRecruitmentInfo.AddItem(info);
			freeSlots--;
			resourceSet.SpendResources( potentialCosts, false );
			potentialCosts.Length = 0;
		}
	}

	return filteredRecruitmentInfo;
}

function String GetRecruitAllBlockReason(optional int freeSlots = -1)
{
	local array<H7RecruitmentInfo> tempRecInfo;
	local H7ResourceSet resourceSet;
	local H7RecruitmentInfo singleRecInfo;
	local int recruitableAmount;

	local bool allReservesEmpty, noResources, noFreeSlots;
	allReservesEmpty = true;
	noResources = true;
	noFreeSlots = true;

	// duplicate the current resource set as a "simulation" resource set to calculate costs
	resourceSet = new class'H7ResourceSet' ( class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet() );
	if(freeSlots == -1) freeSlots = mVisitingArmy.GetFreeSlotCount();

	tempRecInfo = GetRecruitAllDataSub( resourceSet , !mIsUpgraded );

	foreach tempRecInfo(singleRecInfo)
	{
    	if(singleRecInfo.Count == 0)
			continue;

		allReservesEmpty = false;

		recruitableAmount = GetPossibleRecruitCount( singleRecInfo.Creature, resourceSet, singleRecInfo.Count );

		if(recruitableAmount == 0)
			continue;

		noResources = false;

	}

	if(allReservesEmpty) return "ALL_RESERVES_EMPTY";
	if(noResources)      return "NOT_ENOUGH_RESOURCES";
	if(noFreeSlots)      return "NO_FREE_UNIT_SLOTS";

	return "";
}

function bool isRecruitingUpgradedVersionAlready(array<H7RecruitmentInfo> filteredRecruitmentInfo, H7Creature creature)
{
	local H7RecruitmentInfo info;

	ForEach filteredRecruitmentInfo(info)
	{
		if( info.Creature == creature.GetUpgradedCreature())
			return true;
	}
	return false;
}

function int GetFreeStackSlots()
{
	;
	if(mVisitingArmy == none) return 0;
	return mVisitingArmy.GetFreeSlotCount(); 
}

/**
 * Gets recruitment data for this particular dwelling.
 * 
 * @param resourceSet               The resource set with which we determine the amount of creatures we can actually recruit
 */
function array<H7RecruitmentInfo> GetRecruitAllDataSub( H7ResourceSet resourceSet, bool recruitBaseCreature )
{
	local H7DwellingCreatureData creaturePool;
	local H7RecruitmentInfo recData;
	local array<H7RecruitmentInfo> recruitmentInfo;

	if( resourceSet == none )
	{
		;
	}

	resourceSet = new class'H7ResourceSet' ( resourceSet );
	
	foreach mCreaturePool( creaturePool )
	{
		if( creaturePool.Creature == none )
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("dwelling"@self@GetName()@"has invalid creature pool data",MD_QA_LOG);;
			continue;
		}
		// check for upgraded status
		if( mIsUpgraded && !recruitBaseCreature )   
		{ 
			recData.Creature = creaturePool.Creature.GetUpgradedCreature(); 
		}
		else                
		{
			recData.Creature = creaturePool.Creature;
		}

		recData.Count = creaturePool.Reserve;
		recData.OriginDwelling = self;
		recruitmentInfo.AddItem( recData );
	}

	recruitmentInfo.Sort(creatureStrength);

	return recruitmentInfo;
}

function int creatureStrength(H7RecruitmentInfo info1, H7RecruitmentInfo info2)
{
	if(info1.Creature.GetCreaturePower() < info2.Creature.GetCreaturePower())
		return -1;
	else
		return 1;
}

native function int GetPossibleRecruitCount( H7Creature creature, H7ResourceSet resourceSet, int maxCount );

function ProduceUnits()
{
	local int i, income;
	local float dailyGrowth;
	local H7AdventureController advCntl;

	advCntl = class'H7AdventureController'.static.GetInstance();

	if( !mIsProductive ) { ; return; }
	if( advCntl.GetConfig().mEnableDailyGrowth )
	{
		mGrowthCycle++;
	}
	for( i = 0; i < mCreaturePool.Length; i++ )
	{
		;
		;
		if( advCntl.GetConfig().mEnableDailyGrowth )
		{
			income = ( float( GetCreatureIncome( mCreaturePool[i].Creature ) ) ) / 7.0f;
			if( GetPlayer().IsControlledByAI() )
			{
				income *= GetPlayer().mDifficultyAICreatureGrowthRateMultiplier;
			}
			dailyGrowth = income;
			mDailyGrowthBuffer[i] += dailyGrowth - int( dailyGrowth );
			mCreaturePool[i].Reserve += int( dailyGrowth ) + int( mDailyGrowthBuffer[i] );
			;
			mDailyGrowthBuffer[i] = mDailyGrowthBuffer[i] - int( mDailyGrowthBuffer[i] );
			if( mGrowthCycle == 7 )
			{
				mDailyGrowthBuffer[i] = 0;
			}
		}
		else
		{
			income = GetCreatureIncome( mCreaturePool[i].Creature );
			if( GetPlayer().IsControlledByAI() && GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER )
			{
				income *= GetPlayer().mDifficultyAICreatureGrowthRateMultiplier;
			}
			mCreaturePool[i].Reserve += income;
		}
		
		;
	}

	if( mGrowthCycle == 7 )
	{
		mGrowthCycle = 0;
		;
	}
}

function int GetCreatureIncome( H7Creature creature )
{
	switch( creature.GetTier() ) 
	{
		case CTIER_CORE:
			return( GetModifiedStatByID(STAT_CORE_PRODUCTION, creature ) );
		case CTIER_ELITE:
			return( GetModifiedStatByID(STAT_ELITE_PRODUCTION, creature ) );
		case CTIER_CHAMPION:
			return( GetModifiedStatByID(STAT_CHAMPION_PRODUCTION, creature ) );
		default:
			return 0;
	}
}

function float GetModifiedStatByID( Estat desiredStat, H7Creature creature )
{
	local float statBase,statAdd,statMulti;

	statBase = GetBaseStatByID( desiredStat, creature );
	statAdd =  GetAddBoniOnStatByID( desiredStat, creature );
	statMulti = GetMultiBoniOnStatByID( desiredStat, creature );
	
//	`log_uss(desiredStat @ "(" @ statBase @ "+" @ statAdd @ ") *" @ statMulti);
	return ( statBase + statAdd ) * statMulti;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of additive modifications, coming from abilities, buffs etc.
 */
function float GetAddBoniOnStatByID(Estat desiredStat, H7Creature creature)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADD,,creature);
	foreach applicableMods(currentMod)
	{
		modifierSum += currentMod.mModifierValue;
	}

	return modifierSum;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of percentages in modifications, where 50% extra means 1.5f
 */
function float GetMultiBoniOnStatByID(Estat desiredStat, H7Creature creature)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;	
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADDPERCENT, OP_TYPE_MULTIPLY, creature);
	modifierSum = 1; 

	foreach applicableMods(currentMod)
	{
		
		if(currentMod.mCombineOperation == OP_TYPE_ADDPERCENT)
		{
			modifierSum += modifierSum * currentMod.mModifierValue * 0.01f;
		} 
		else if(currentMod.mCombineOperation == OP_TYPE_MULTIPLY)
		{
			modifierSum *= currentMod.mModifierValue;
		}
	}
	return modifierSum;
}

//Base Stats
function float GetBaseStatByID(Estat desiredStat, H7Creature creature )
{
	local H7DwellingCreatureData data;

	foreach mCreaturePool( data )
	{
		if( data.Creature == creature )
		{
			switch(desiredStat)
			{
				case STAT_PRODUCTION: 
					return data.Income;
				case STAT_CORE_PRODUCTION:
					if( data.Creature.GetTier() != CTIER_CORE )
						return 0;
					return data.Income;
				case STAT_ELITE_PRODUCTION:
					if( data.Creature.GetTier() != CTIER_ELITE )
						return 0;
					return data.Income;
				case STAT_CHAMPION_PRODUCTION:
					if( data.Creature.GetTier() != CTIER_CHAMPION )
						return 0;
					return data.Income;

			}

		}
	}

	return 0;
}

native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType checkForOperation1 = -1, optional EOperationType checkForOperation2 = -1, optional H7Creature specificCreature);

/**
 * Removes a part of the creature reserve of the dwelling
 * 
 * @param creatureName          The name of the creature to be recruited in plain text
 * @param count                 The amount of creatures to be recruited
 */
function HireUnits( string creatureName, int count )
{
	local int indexSource;

	GetBaseCreature( creatureName, indexSource );
	if( count <= mCreaturePool[ indexSource ].Reserve )
	{
		;
		mCreaturePool[ indexSource ].Reserve -= count;
	}
	else
	{
		;
	}
}

/**
 * Returns the base version of a given creature in this dwelling's creature pool
 * 
 * @param creatureName      The name of this creature as plain text
 * @param indexSource       The index of this creature's data in the creature pool
 * 
 * @return                  The base creature determined from the given creature's name
 *  
 * */
function H7Creature GetBaseCreature( string creatureName, out int indexSource )
{
	local int i;
	local bool isMatch, hasUpgrade;
	local H7Creature creature;

	for( i = 0; i < mCreaturePool.Length; i++ )
	{
		if( mCreaturePool[ i ].Creature.GetBaseCreature() != none )
		{
			creature = mCreaturePool[ i ].Creature.GetBaseCreature();
		}
		else
		{
			creature = mCreaturePool[ i ].Creature;
		}
		// check if the creature name sent is the base creature itself or any of its upgrades
		do {
			if( creature.GetIDString() == creatureName )
			{
				isMatch = true;
				indexSource = i;
				
				break;
			}
			if( creature.GetUpgradedCreature() != none )
			{
				hasUpgrade = true;
				creature = creature.GetUpgradedCreature();
			}
			else
			{
				hasUpgrade = false;
			}
		} until( !hasUpgrade );
		if( isMatch ) break;
	}
	if( !isMatch ) 
	{ 
		; 
		return none;
	}

	return creature;
}

function Conquer( H7AdventureHero conqueror )
{
	super.Conquer( conqueror );

	SetVisitingArmy( conqueror.GetAdventureArmy() );
}


function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_DWELLING;
	
	return data;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

