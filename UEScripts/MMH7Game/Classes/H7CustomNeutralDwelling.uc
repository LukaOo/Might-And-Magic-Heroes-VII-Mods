/*=============================================================================
* H7CustomNeutralDwelling
* =============================================================================
*  Class for adventure map objects that serve as neutral creature shops.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7CustomNeutralDwelling extends H7Dwelling
	native
	hidecategories(Upgrade)
	dependson( H7ITooltipable )
	placeable;

var protected array<float> mWeeklyGrowthBuffer;
var protected savegame array<H7AdventureArmy> mVisitedHeroes;
var(Properties) protected archetype array<H7Faction> mAllowedFactions <DisplayName="Allowed Factions for Recruitment">;

function array<H7DwellingCreatureData> GetCreaturePool()		{ return mCreaturePool; }
function SetCreaturePool( array<H7DwellingCreatureData> pool)	{ mCreaturePool = pool; }

event InitAdventureObject()
{
	local int i, j, poolCount;
	local array<H7FactionCreatureData> factionData;
	local H7FactionCreatureData chosenData;
	local array<H7Creature> cores, elites, champions, chosenCreatures;
	local H7SynchRNG synchRNG;
	local H7ReplicationInfo repInfo;
	local bool done;
	local array<H7Faction> allowedFactions, finalFactions;
	local H7Faction faction;
	local H7DwellingCreatureData tempDwellingCreatureData;

	class'H7AdventureController'.static.GetInstance().AddAdvObject( self );
	repInfo = class'H7ReplicationInfo'.static.GetInstance();
	
	if( !repInfo.IsLoadedGame() )
	{
		mID = repInfo.GetNewID();
	}
	repInfo.RegisterEventManageable( self );

	mBuffManager = new(self) class 'H7BuffManager';
	mEventManager = new(self) class 'H7EventManager';
	mEffectManager = new(self) class 'H7EffectManager';
	mAbilityManager = new(self) class 'H7AbilityManager';
	mHeroEventParam = new(self) class'H7HeroEventParam';

	mAbilityManager.SetOwner( self );
	mEffectManager.Init( self );
	mBuffManager.Init( self );

	mWeeklyGrowthBuffer.Add( mCreaturePool.Length );

	class'H7AdventureController'.static.GetInstance().AddCustomNeutralDwelling( self );
	
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddVisitableSite( self ); // because it does not call it's super.Init

	if( !repInfo.IsLoadedGame() )
	{
		synchRNG = repInfo.GetSynchRNG();
		class'H7TransitionData'.static.GetInstance().GetGameData().GetFactions( allowedFactions, false );
		foreach mAllowedFactions( faction )
		{
			if( allowedFactions.Find( faction ) != INDEX_NONE )
			{
				finalFactions.AddItem( faction );
			}
		}

		if( mAllowedFactions.Length > 0 )
		{
			poolCount = 0;
			while( !done )
			{
				if( mCreaturePool[poolCount].Creature != none )
				{
					++poolCount;
					if( poolCount == mCreaturePool.Length )
					{
						done = true;
					}
					continue;
				}
				faction = finalFactions[ synchRNG.GetRandomInt( finalFactions.Length ) ];
				cores.Length = 0;
				elites.Length = 0;
				champions.Length = 0;

				class'H7TransitionData'.static.GetInstance().GetGameData().GetCreatureLists( factionData );
				for( i = 0; i < factionData.Length; ++i )
				{
					if( factionData[i].Faction == faction )
					{
						chosenData = factionData[i];
						break;
					}
				}

				for( i = 0; i < E_H7_CL_MAX; ++i )
				{
					for( j = 0; j < chosenData.CreatureList.Creatures[i].Creatures.Length; ++j )
					{
						if( chosenData.CreatureList.Creatures[i].Creatures[j].GetTier() == CTIER_CORE && chosenCreatures.Find( chosenData.CreatureList.Creatures[i].Creatures[j] ) == INDEX_NONE )
						{
							cores.AddItem( chosenData.CreatureList.Creatures[i].Creatures[j] );
						}
						else if( chosenData.CreatureList.Creatures[i].Creatures[j].GetTier() == CTIER_ELITE && chosenCreatures.Find( chosenData.CreatureList.Creatures[i].Creatures[j] ) == INDEX_NONE )
						{
							elites.AddItem( chosenData.CreatureList.Creatures[i].Creatures[j] );
						}
						else if( chosenData.CreatureList.Creatures[i].Creatures[j].GetTier() == CTIER_CHAMPION && chosenCreatures.Find( chosenData.CreatureList.Creatures[i].Creatures[j] ) == INDEX_NONE )
						{
							champions.AddItem( chosenData.CreatureList.Creatures[i].Creatures[j] );
						}
					}
				}

				if( cores.Length == 0 && elites.Length == 0 && champions.Length == 0 )
				{
					break;
				}

				if( mCreaturePool[poolCount].CreatureTier == CTIER_CORE )
				{
					mCreaturePool[poolCount].Creature = cores[ synchRNG.GetRandomInt( cores.Length ) ];
					chosenCreatures.AddItem( mCreaturePool[poolCount].Creature );
				}
				else if( mCreaturePool[poolCount].CreatureTier == CTIER_ELITE )
				{
					mCreaturePool[poolCount].Creature = elites[ synchRNG.GetRandomInt( elites.Length ) ];
					chosenCreatures.AddItem( mCreaturePool[poolCount].Creature );
				}
				else
				{
					mCreaturePool[poolCount].Creature = champions[ synchRNG.GetRandomInt( champions.Length ) ];
					chosenCreatures.AddItem( mCreaturePool[poolCount].Creature );
				}

				++poolCount;
				if( poolCount == mCreaturePool.Length )
				{
					done = true;
				}
			}
		}

		for( i = mCreaturePool.Length - 1; i >= 0 ; --i )
		{
			if( mCreaturePool[i].Creature == none )
			{
				mCreaturePool.Remove( i, 1 );
			}
		}
	
		//base and upg creature always need to be "next to each other"
		//sort base creature index < upgraded creature index
		for( i = 0; i < mCreaturePool.Length; i++)
		{
			if(mCreaturePool[i].Creature.GetUpgradedCreature() == none)
				continue;

			for(j = 0; j < mCreaturePool.Length; j++)
			{
				if(mCreaturePool[i].Creature.GetUpgradedCreature() == mCreaturePool[j].Creature &&
                   j < i)
				{
					tempDwellingCreatureData = mCreaturePool[i];
					mCreaturePool[i] = mCreaturePool[j];
					mCreaturePool[j] = tempDwellingCreatureData;
				}
			}
		}

		//check if base and upg are "too far apart", they need to be "next to each other"
		//sort base creature index + 1 = upgrade creature index
		for( i = 0; i < mCreaturePool.Length; i++)
		{
			if(mCreaturePool[i].Creature.GetUpgradedCreature() == none)
				continue;

			for(j = 0; j < mCreaturePool.Length; j++)
			{	
				if(mCreaturePool[i].Creature.GetUpgradedCreature() == mCreaturePool[j].Creature &&
                   i+1 != j)
				{
					tempDwellingCreatureData = mCreaturePool[j];
					mCreaturePool[j] = mCreaturePool[i+1];
					mCreaturePool[i+1] = tempDwellingCreatureData;
				}
	
			}
		}

	}
}

function bool HasCreature(H7Creature creature)
{
	local int i;

	for(i = 0; i < mCreaturePool.Length; i++)
		if(mCreaturePool[i].Creature == creature)
			return true;

	return false;
}

function bool HasVisited( H7AdventureHero hero )
{
	return mVisitedHeroes.Find( hero.GetAdventureArmy() ) != INDEX_NONE;
}

function OnVisit( out H7AdventureHero hero )
{
	local H7EventContainerStruct container;

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
	
	mVisitingArmy = hero.GetAdventureArmy();
	mVisitingArmy.SetVisitableSite( self );

	container.Targetable = hero;

	TriggerEvents( ON_VISIT, false, container );
	TriggerEvents( ON_POST_VISIT, false, container );

	if( hero.GetPlayer().IsControlledByAI() )
	{
		if( !HasVisited( hero ) ) // ai only gets one shot to recruit here, otherwise it would stick to the building indefinitely
		{
			mVisitedHeroes.AddItem( hero.GetAdventureArmy() );

			if(class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
			{
				RecruitAll();
			}
		}
	}
	else
	{
		if(hero.GetPlayer().GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
		{
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GoToNeutralDwellingScreen(self);		
		}
	}
}

function bool WillBenefitFromVisit( H7AdventureHero hero )
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local H7RecruitmentInfo data;
	local float heroArmyStrength;
	local float recruitArmyStrength;
	local int freeSlots;
	local array<H7ResourceQuantity> recruitmentCosts;

	if(hero==None || HasVisited(hero)==true )
	{
		return false;
	}

	heroArmyStrength=hero.GetAdventureArmy().GetStrengthValue(false);
	recruitArmyStrength=0.0f;
	freeSlots = 7-hero.GetAdventureArmy().GetNumberOfFilledSlots();

	recruitmentInfo = GetRecruitAllData(,,hero.GetAdventureArmy());
	foreach recruitmentInfo( data )
	{
		if( data.Count>0 && data.Creature!=None )
		{
			class'H7GameUtility'.static.CalculateCreatureCosts( data.Creature, data.Count, recruitmentCosts,,, hero.GetModifiedStatByID(STAT_NEUTRAL_CREATURE_COST) );

			if( hero.GetPlayer().GetResourceSet().CanSpendResources(recruitmentCosts) == true )
			{
				if( hero.GetAdventureArmy().HasCreature(data.Creature) == false )
				{
					if( freeSlots > 0 )
					{
						recruitArmyStrength+=data.Count * data.Creature.GetCreaturePower();
					}
					freeSlots--;
					if( freeSlots <= 0 )
					{
						break;
					}
				}
				else
				{
					recruitArmyStrength+=data.Count * data.Creature.GetCreaturePower();
				}
			}
		}
	}

	// we can end here
	if(recruitArmyStrength>0.0f && heroArmyStrength<=0.0f)
	{
		return true;
	}
	if(recruitArmyStrength>0.0f && (recruitArmyStrength/heroArmyStrength)>0.2f )
	{
		return true;
	}
	return false;
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

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local int i;
	local bool stockAvailable;

	;
	data.type = TT_TYPE_STRING;
	data.Title =  GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_CUSTOM_NEUTRAL_DWELLING","H7AdvMapObjectToolTip") $ "\n";
	if( mCreaturePool.Length > 0)
	{
		if(mIsProductive)
		{
			/*for( i = 0; i < mCreaturePool.Length; i++ )
			{
				if( mCreaturePool[i].Creature != none )
				{
					data.Description = data.Description $ `Localize("H7General", "TT_ADDS", "MMH7Game") @  mCreaturePool[i].Income @ mCreaturePool[i].Creature.GetName()@ `Localize("H7General", "TT_PER_WEEK", "MMH7Game") $ "\n";
				}
			}
			data.Description = data.Description $ `Localize("H7AdvMapObjectToolTip", "TT_CUSTOM_NEUTRAL_DWELLING_CAN_HIRED", "MMH7Game") @ "\n";
			*/
			data.type = TT_TYPE_DWELLING;
		}
		else
		{
			data.Description = data.Description $ class'H7Loca'.static.LocalizeSave("TT_CUSTOM_NEUTRAL_DWELLING_UNPRODUCTIVE","H7AdvMapObjectToolTip") @ "\n";
			
			for( i = 0; i < mCreaturePool.Length; i++ )
			{
				if( mCreaturePool[i].Creature != none && mCreaturePool[i].Reserve != 0)
				{
					stockAvailable = true;
					break;
				}
			}
			if(stockAvailable)
			{
				data.Description = data.Description $ "<font size='#TT_POINT#' color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_STOCK_AVAILABLE","H7AdvMapObjectToolTip") @ "\n" $ "</font>";
			}
			else
			{
				data.Description = data.Description $ "<font size='#TT_POINT#' color='#ff0000'>" $ class'H7Loca'.static.LocalizeSave("TT_STOCK_SOLD_OUT","H7AdvMapObjectToolTip") @ "\n" $ "</font>";
			}
		}
	}
	else
	{
		data.Description = data.Description $ class'H7Loca'.static.LocalizeSave("TT_DESERTED","H7Dwelling") @ "\n";
	}
	data.Description = data.Description $ "</font>";
	return data;
}

function ProduceUnits()
{
	local int i;

	if(!mIsProductive)
	{
		return;
	}

	for( i = 0; i < mCreaturePool.Length; i++ )
	{

		if(mCreaturePool[i].Capacity < mCreaturePool[i].Reserve + mCreaturePool[i].Income)
		{
			mCreaturePool[i].Reserve = mCreaturePool[i].Capacity;
		}
		else
		{
			mCreaturePool[i].Reserve += mCreaturePool[i].Income;
		}

		;
	}
}

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

function RecruitDirect(string creatureName, int amount)
{
	local H7InstantCommandRecruitDirect command;

	command = new class'H7InstantCommandRecruitDirect';
	command.Init(creatureName,amount,self);
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
	local int indexSource, i;
	local H7Player thePlayer;
	local H7Creature creature, otherCreature;
	local array<H7ResourceQuantity> recruitmentCosts;
	local float currencyMod;

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

	if( mVisitingArmy != none )
	{
		currencyMod = mVisitingArmy.GetHero().GetModifiedStatByID( STAT_NEUTRAL_CREATURE_COST );
	}
	else
	{
		currencyMod = 1.0f;
	}
	
	class'H7GameUtility'.static.CalculateCreatureCosts( creature, count, recruitmentCosts,,, currencyMod );

	if( thePlayer.GetResourceSet().CanSpendResources( recruitmentCosts ) )
	{
		thePlayer.GetResourceSet().SpendResources( recruitmentCosts );
		
		// Dwelling has no garrison, so we can only recruit into the visiting army
		if( mVisitingArmy != none )
		{
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
		}
		else
		{
			; 
			return false;
		}

		//check if recruited creature has an upgrade / base version and if this upgrade / base version
		//is also recruitabel in this dwelling
		if(creature.GetUpgradedCreature() != none && HasCreature(creature.GetUpgradedCreature()))
		{
			otherCreature = creature.GetUpgradedCreature();
		}

		if(creature.GetBaseCreature() != none && HasCreature(creature.GetBaseCreature()))
		{
			otherCreature = creature.GetBaseCreature();
		}

		//reduce reserve for recruited creature and upgrade / base version of it
		for(i = 0; i < mCreaturePool.Length; i++)
		{
			if(mCreaturePool[i].Creature == creature) 
				mCreaturePool[i].Reserve -= count;
			
			if(otherCreature != none && mCreaturePool[i].Creature == otherCreature) 
				mCreaturePool[i].Reserve -= count;
		}
		return true;
	}
	else
	{
		return false;
	}
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
	
	foreach mCreaturePool( creaturePool )
	{
		if( creaturePool.Creature == none )
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("dwelling"@self@GetName()@"has invalid creature pool data",MD_QA_LOG);;
			continue;
		}
		
		recData.Creature = creaturePool.Creature;
		recData.Count = creaturePool.Reserve;
		recData.OriginCostumeDwelling = self;
		recruitmentInfo.AddItem( recData );
	}

	return recruitmentInfo;
}

function array<H7RecruitmentInfo> GetRecruitAllData(optional bool checkGarrison=false, optional int freeSlots = -1, optional H7AdventureArmy aiArmy )
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local array<H7RecruitmentInfo> filteredRecruitmentInfo;
	local H7RecruitmentInfo info;
	local H7ResourceSet resourceSet;
	local array<H7ResourceQuantity> potentialCosts;
	local H7AdventureArmy armyToCheck;
	local int recruitableAmount;
	local float currencyMod;

	resourceSet =  class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetResourceSet();
	resourceSet = new class'H7ResourceSet' ( resourceSet );


	if( mVisitingArmy != none )
	{
		currencyMod = mVisitingArmy.GetHero().GetModifiedStatByID( STAT_NEUTRAL_CREATURE_COST );
	}
	else
	{
		currencyMod = 1.0f;
	}

	recruitmentInfo = GetRecruitAllDataSub( resourceSet , !mIsUpgraded );

	if(aiArmy != none)
		armyToCheck = aiArmy;
	else
		armyToCheck = mVisitingArmy;

	if(freeSlots == -1) freeSlots = armyToCheck.GetFreeSlotCount();

	// tried recruiting upgraded creatures, now check base versions
	
	recruitmentInfo = GetRecruitAllDataSub( resourceSet , true );

	//check how much of the creatures we can actualy recruit
	ForEach recruitmentInfo(info)
	{
		if(info.Count == 0) continue;
		recruitableAmount = GetPossibleRecruitCount( info.Creature, resourceSet, info.Count );
		if(recruitableAmount == 0) continue; 
		class'H7GameUtility'.static.CalculateCreatureCosts( info.Creature, recruitableAmount, potentialCosts,,, currencyMod );
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

native function int GetPossibleRecruitCount( H7Creature creature, H7ResourceSet resourceSet, int maxCount );

