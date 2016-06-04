/*=============================================================================
* H7BattleSite
* =============================================================================
* Base class for Battle Sites
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7BattleSite extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	dependson(H7ITooltipable)
	hideCategories(Defenses)
	placeable
	native
	savegame;

var(GeneralSetup)   protected bool                                  mIgnoredByAI            <DisplayName = "Site is ignored by AI">;
/**If enabled the size of the challenging battle site army will growth every week*/
var(GeneralSetup)   protected bool                                  mWeeklyGrowth           <DisplayName = "Weekly Army growth enabled">;
/**Enable to use a custom stack positioning on the combat map. Grid XY Position can be added to the Army Setup*/
var(GeneralSetup)   protected bool                                  mUseCustomPosition      <DisplayName = "Custom Stack Positioning">;
/**If enabled every Hero can do this challenge for his own. If disabled only one hero can once finish this challenge*/
var(GeneralSetup)   protected bool                                  mMultiHero              <DisplayName = "Multiple Hero challenge">;
var(GeneralSetup)   protected string                                mCombatMapName          <DisplayName = "Combat Map Name">;
var(Naming)         protected localized string                      mDescription            <DisplayName = "Description">;
var(ArmySetup)      protected Array<H7BattleSiteArmySetupData>      mArmySetup              <DisplayName = "Stack Properties (max. 7)">;
var(ArmySetup)      protected archetype Array<H7EditorWarUnit>      mWarUnitSetup           <DisplayName = "WarUnit (max. 3)">;
var(ArmySetup)      protected bool                                  mDisableQuickCombat     <DisplayName = "Disable Quick Combat">;
/**If enabled the army will surround the heroes army, which is then placed in the middle of the combat map*/
var(Developer)      protected bool                                  mCreateAmbush           <DisplayName = "Enable Army Ambush">;
var(CostSetup)      protected Array<H7ResourceQuantity>             mCosts;
var(RewardSetup)    protected Array<H7ResourceQuantity>             mResourceReward	        <DisplayName = "Resources">;
var(RewardSetup)    protected savegame archetype Array<H7HeroItem>  mItemReward             <DisplayName = "Specific Artefacts">;
/**If enabled, it will take the global item list from the map info. If disabled you've to defineSpecific Artefacts */
var(RewardSetup)    protected bool                                  mGlobalItemList         <DisplayName = "Global Itemlist">;
var(RewardSetup)    protected Array<H7RewardData>                   mRandomItemDefinition   <DisplayName = "Random Item Definition"|EditCondition=mGlobalItemList>;
var(RewardSetup)    protected int                                   mNumberofItemRewards    <DisplayName = "Number of Item rewards"|ClampMin=0>;
var(Developer)	    protected Array<H7MeModifiesStat>               mStatModReward          <DisplayName = "Statmodifier Reward">;
var                 protected savegame bool						    mIsHidden;
var                 protected savegame bool						    mIsVisited;
var                 protected savegame array<H7AdventureArmy>       mVisitedArmies;
var                 Vector                                          mHeroMsgOffset;
var                 savegame H7AdventureArmy                        mDefenderArmy;
//Global map loottable
var                 archetype array <H7HeroItem>                    mItems;
var                 array <int>                                     mGlobalItemNumbers;
var                 archetype array <H7HeroItem>                    mRandomItemRewards;


native function bool IsHiddenX();

//GETTER
function bool GetIsIgnoredByAI()                                {  return mIgnoredByAI;         }
function Array<H7BattleSiteArmySetupData> GetArmySetup()        {  return mArmySetup;           }
function Array<H7ResourceQuantity> GetCostsSetup()              {  return mCosts;               }
function Array<H7ResourceQuantity> GetResourceRewardSetup()     {  return mResourceReward;      }
function Array<H7HeroItem> GetItemRewardSetup()                 {  return mItemReward;          }
function Array<H7MeModifiesStat> GetStatModRewardSetup()        {  return mStatModReward;       }
function bool IsLootableDefined()                               {  return mGlobalItemList;      }
function string GetCombatMapName()                              {  return mCombatMapName;       }
function H7AdventureArmy GetDefenderArmy()                      {  return mDefenderArmy;        }
function bool   IsLooted()                                      {  return mIsVisited;           }
function bool   IsMultiHero()                                   {  return mMultiHero;           }


event InitAdventureObject()
{
	local H7GameData gameData;
	local int i,rnd,j;
	local array<H7HeroItem> localItemList;
	local array<H7HeroItem> sortedItemList;

	super.InitAdventureObject();


	class'H7AdventureController'.static.GetInstance().AddBattleSite( self );
	gameData = class'H7GameData'.static.GetInstance();


	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		if(mGlobalItemList)
		{
			mItemReward.Length = 0;

			for(i = 0; i < mRandomItemDefinition.Length; i++)
			{
				localItemList = gameData.GetItemList(mRandomItemDefinition[i].ItemTier, false);

				for(j = 0; j < localItemList.Length; j++)
				{
					if(mRandomItemDefinition[i].ItemType == localItemList[j].GetType() || mRandomItemDefinition[i].ItemType == ITYPE_ALL)
					{
						sortedItemList.AddItem(localItemList[j]);
					}
				}
				rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(sortedItemList.Length);
				mItemReward.AddItem(sortedItemList[rnd]);
				sortedItemList.Length = 0;
			}
		}

		CreateDefenderAdventureArmy();
	}
	
}

function string GetDescription()
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		return class'H7Loca'.static.LocalizeContent(self, "mDescription", mDescription );
	}
	else
	{
		return H7BattleSite( ObjectArchetype ).GetDescription();
	}
}

function OnVisit( out H7AdventureHero hero )
{
	local H7AdventureArmy attackingArmy;
	local bool aiWon;
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }

	super.OnVisit( hero );

	if( mCosts.Length > 0 )
	{
		if(!hero.GetPlayer().GetResourceSet().CanSpendResources( mCosts ))
		{
			return;
		}
	}

	if(!HasVisited(hero) && !mIsVisited)
	{
		attackingArmy = hero.GetAdventureArmy();

		if( !hero.GetPlayer().IsControlledByAI() )
		{
			mDefenderArmy.GetHero().SetLocation(class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ).GetLocation());

			if(hero.GetPlayer().IsControlledByLocalPlayer())
			{
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetCombatPopUpCntl().ShowStartCombatPopUp( attackingArmy, mDefenderArmy);
			}
		}
		else
		{
			PayBattleSiteCosts( hero );
			aiWon = class'H7AdventureController'.static.GetInstance().QuickCombatWithAdventureArmies( attackingArmy, mDefenderArmy );
			if( aiWon )
			{
				OnAccept( hero );
				GetReward( hero );
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
		}
	}
	else
	{
		if(mMultiHero)
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, hero.GetLocation(), hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("ALREADY_LOOTED_BY_CURRENT_HERO","H7Adventure"));
		else
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, hero.GetLocation(), hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("ALREADY_LOOTED","H7Adventure"));
	}
}

function OnAccept(H7AdventureHero hero)
{
	//If the player has sucessfully finished the challenge
	mVisitedArmies.AddItem(hero.GetAdventureArmy());

	if(mMultiHero)
	{
		CreateDefenderAdventureArmy();
		return;
	}
	else
	{
		mIsVisited = true;
	}
}

function OnCancel()
{
	//If the player cancels the challenge or gives up the battle
	mVisitedArmies.RemoveItem(mVisitedArmies[mVisitedArmies.Length]);
}

function PayBattleSiteCosts(H7AdventureHero hero)
{
	if(hero.GetPlayer().GetResourceSet().CanSpendResources( mCosts ))
	{
		hero.GetPlayer().GetResourceSet().SpendResources( mCosts );
	}
}

function CreateDefenderAdventureArmy()
{
	local int i;
	local H7BaseCreatureStack defenderStack;
	local array<H7BaseCreatureStack> stacks;
	
	mDefenderArmy = Spawn( class'H7AdventureArmy',,,,, mEditorArmy );
	mDefenderArmy.Init( class'H7AdventureController'.static.GetInstance().GetNeutralPlayer() );
	mDefenderArmy.SetGarrisonedSite( self );
	SetArmy(mDefenderArmy);
	mDefenderArmy.HideArmy();
	mDefenderArmy.SetPlayer( class'H7AdventureController'.static.GetInstance().GetNeutralPlayer() );
	mDefenderArmy.SetIsDead( false );
	
	if(mDisableQuickCombat && !mDefenderArmy.IsForcingManualCombat())
	{
		mDefenderArmy.SetForcingManualCombat(mDisableQuickCombat);
	}

	if(mCreateAmbush)
	{
		mDefenderArmy.SetArmyIsAmbush(mCreateAmbush);
	}
	
	for( i = 0; i < mDefenderArmy.GetMaxArmySize(); ++i )
	{
		defenderStack = new class'H7BaseCreatureStack'();

		//Adding CreatureStacks to Defender
		if( mArmySetup.Length > i && mArmySetup[i].Creature != none && mArmySetup[i].Reserve > 0)
		{
			defenderStack.SetStackSize( mArmySetup[i].Reserve );
			defenderStack.SetStackType( mArmySetup[i].Creature );

			//Custom position, when ambush is enabled
			if(mCreateAmbush)
			{
				defenderStack.SetCustomPosition(true, mArmySetup[i].Position.X, mArmySetup[i].Position.Y);
			}

			stacks.AddItem( defenderStack );
		}
		else
		{
			stacks.AddItem( none );
		}
	}

	//Adding WarUnits to Defender
	for( i = 0; i < mWarUnitSetup.Length; ++i )
	{
		if(mWarUnitSetup[i] != none && mWarUnitSetup.Length > i)
		{
			mDefenderArmy.AddWarUnitTemplate(mWarUnitSetup[i]);
		}
	}
	mDefenderArmy.SetBaseCreatureStacks( stacks );
}

function WeeklyBattleSideArmyGrowth()
{
	local int i;
	
	if(!mWeeklyGrowth)
	{
		return;
	}

	for(i = 0; i < mDefenderArmy.GetNumberOfFilledSlots(); i++)
	{
		if( mDefenderArmy.GetStackByIndex(i) != none )
		{
			//if capacity = 0 it's unlimited
			if(mArmySetup[i].Capacity == 0)
			{
				mDefenderArmy.GetStackByIndex(i).SetStackSize( mDefenderArmy.GetStackByIndex(i).GetStackSize() + mArmySetup[i].Income); 
			}
			else if ((mDefenderArmy.GetStackByIndex(i).GetStackSize() + mArmySetup[i].Income) < mArmySetup[i].Capacity)
			{
				mDefenderArmy.GetStackByIndex(i).SetStackSize( mDefenderArmy.GetStackByIndex(i).GetStackSize() + mArmySetup[i].Income); 
			}
			else
			{
				mDefenderArmy.GetStackByIndex(i).SetStackSize( mArmySetup[i].Capacity ); 
			}
		}
	}
}

function GetReward(H7AdventureHero hero)
{
	mHeroMsgOffset = Vect(0,0,600);

	mDefenderArmy.SetIsDead( true );

	if(mResourceReward.Length > 0)
	{
		GetResourceReward(hero);
	}

	if(mItemReward.Length > 0)
	{
		GetItemReward(hero);
	}

	if(mStatModReward.Length > 0)
	{
		GetStatModReward(hero);
	}

	//erase the current battlesite after the player has accepted the reward
	class'H7AdventureController'.static.GetInstance().SetCurrentBattleSite( none );
}

protected function GetResourceReward(H7AdventureHero hero)
{
	local H7ResourceQuantity resReward;
	local H7Player heroplayer;
	local int i;

	heroplayer = hero.GetPlayer();

	foreach mResourceReward(resReward, i)
	{
		if( resReward.Type == heroplayer.GetResourceSet().GetCurrencyResourceType() )
		{
			heroplayer.GetResourceSet().ModifyCurrency( resReward.Quantity, true );
		}
		else
		{
			heroplayer.GetResourceSet().ModifyResource( resReward.Type, resReward.Quantity, true );
		}

		if(heroplayer.IsControlledByLocalPlayer())
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_RESOURCE_PICKUP, hero.GetLocation() + mHeroMsgOffset, heroplayer, "+" $resReward.Quantity , MakeColor(0,255,0,255) , resReward.Type.GetIcon() );
		}
	}
}

protected function GetItemReward(H7AdventureHero hero)
{
	local H7HeroItem itemReward, itemInstance;
	local int i;

	foreach mItemReward(itemReward,i)
	{
		itemInstance = class'H7HeroItem'.static.CreateItem( itemReward );
		hero.GetInventory().AddItemToInventoryComplete( itemInstance );
		if(hero.GetPlayer().IsControlledByLocalPlayer())
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ITEM_PICKUP, hero.GetLocation() + mHeroMsgOffset, hero.GetPlayer(), "+"$itemReward.GetName() , MakeColor(0,255,0,255) , itemReward.GetIcon() );
		}
	}
}

protected function GetStatModReward(H7AdventureHero hero)
{
	local H7MeModifiesStat statReward;
	local string floatingText;
	local int i;

	foreach mStatModReward(statReward, i)
	{
		hero.IncreaseBaseStatByID(statReward.mStat, statReward.mModifierValue);

		if(hero.GetPlayer().IsControlledByLocalPlayer())
		{
			floatingText = "+"$int(statReward.mModifierValue);
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_STAT_MOD, hero.GetLocation() + mHeroMsgOffset, hero.GetPlayer(), floatingText@class'H7EffectContainer'.static.GetLocaNameForStat(statReward.mStat,true), MakeColor(0,255,0,255), class'H7PlayerController'.static.GetPlayerController().GetHud().GetStatIcons().GetStatIcon(statReward.mStat, hero));
		}
	}
}

function bool HasVisited( H7AdventureHero hero )
{
	return mVisitedArmies.Find( hero.GetAdventureArmy() ) != INDEX_NONE;
}

function bool WasLootedByCurrentHero()
{
	return mVisitedArmies.Find(class'H7AdventureController'.static.GetInstance().GetSelectedArmy()) != -1;
}

function OnLeave()
{
	//Only if the hero decides, to not take the challenge and is allowed to come again
	mVisitedArmies.RemoveItem(mVisitedArmies[mVisitedArmies.Length]);
	if(class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite() == self)
	{
		class'H7AdventureController'.static.GetInstance().SetCurrentBattleSite( none );
	}
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	data.type = TT_TYPE_BATTLESITE;
	return data;
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

