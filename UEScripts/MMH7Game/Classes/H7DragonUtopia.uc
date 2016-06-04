/*=============================================================================
* H7DragonUtopia
* =============================================================================
* Child class of H7BattleSite
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7DragonUtopia extends H7BattleSite;

var(GeneralSetup)   protected bool                              mPedefinedArmy                      <DisplayName = "Enable Pedefined Army">;
/**Set the number(Faction) of the army, which is encountered, when visiting the battlesite*/
var(GeneralSetup)   protected int                               mPedefinedArmyNumber                <DisplayName = "Pedefined Army Number">;
/**RewardArray[0] = Reward for Army [0]*/
var(RewardSetup)    protected Array<H7MultiRewardData>          mRewardData                        <DisplayName = "Defined Tier Reward Data">;   
var(ArmySetup)      protected Array<H7MultiArmySetupData>       mMultiArmySetup                     <DisplayName = "Army Setup">;
/**The chance array number 0 defines the chance for array army 0 in the army setup above */
var(ArmySetup)      protected Array<int>                        mArmyRandomChances                  <DisplayName = "Random Chances for the armies">;
var                 protected savegame int                      mArmyEncounterNumber;
var                 protected bool                              mArmyEncounterSet;
var                 protected savegame Array<int>               mRewardItemIDdata;     

event InitAdventureObject()
{
	local H7GameData gameData;
	local int i,rnd,j;
	local array<H7HeroItem> localItemList;
	local array<H7HeroItem> sortedItemList;

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		ElectArmy();
	}
	else
	{
		mArmySetup = mMultiArmySetup[mArmyEncounterNumber].FactionArmy;
	}

	super.InitAdventureObject();

	gameData = class'H7GameData'.static.GetInstance();

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		if(mGlobalItemList)
		{
			//Random item from global list
			mItemReward.Length = 0;

			for(i = 0; i < mRewardData[mArmyEncounterNumber].RewardData.Length; i++)
			{

				if(mRewardData[mArmyEncounterNumber].RewardData[i].ItemTier != ITIER_MINOR_MAJOR && mRewardData[mArmyEncounterNumber].RewardData[i].ItemTier != ITIER_ALL)
				{
					localItemList = gameData.GetItemList(mRewardData[mArmyEncounterNumber].RewardData[i].ItemTier, false);
				}
				else
				{
					localItemList = DefineItemTier(mRewardData[mArmyEncounterNumber].RewardData[i].ItemTier);
				}

				for(j = 0; j < localItemList.Length; j++)
				{
					if(mRewardData[mArmyEncounterNumber].RewardData[i].ItemType == localItemList[j].GetType() 
						|| mRewardData[mArmyEncounterNumber].RewardData[i].ItemType == ITYPE_ALL)
					{
						sortedItemList.AddItem(localItemList[j]);
					}
				}
				rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(sortedItemList.Length);
				mItemReward.AddItem(sortedItemList[rnd]);
				mRewardItemIDdata.AddItem(sortedItemList[rnd].GetID());
				sortedItemList.Length = 0;
			}
		}
		else
		{
			//Perpared Items
			for (i = 0; i < mRewardData[mArmyEncounterNumber].RewardData.Length; i++)
			{
				mItemReward.AddItem(mRewardData[mArmyEncounterNumber].RewardData[i].Item);
			}
		}
	}
}

function array<H7HeroItem> DefineItemTier(ETier itemTier)
{
	local int rnd;
	local ETier electedTier;
	local H7GameData gameData;

	gameData = class'H7GameData'.static.GetInstance();

	if(itemTier == ITIER_MINOR_MAJOR)
	{
		rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(2);
		electedTier = ETier(rnd);

		return gameData.GetItemList(electedTier, false);
	}

	if(itemTier == ITIER_ALL)
	{
		rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(4);
		electedTier = ETier(rnd);

		return gameData.GetItemList(electedTier, false);
	}
}

function OnVisit( out H7AdventureHero hero )
{
	super.OnVisit( hero );
	//TODO Connect reward to winning condition after combat(After Combat GUI)
	//GetReward(hero);
}

function ElectArmy()
{
	local int rnd,i,j;
	local array<int> armyNumberPool;

	if( mPedefinedArmy )
	{
		mArmyEncounterNumber = mPedefinedArmyNumber;
	}
	else if(!mArmyEncounterSet)
	{
		if( mArmyRandomChances.Length > 0)
		{
			//Fill the random army num pool with all numbers and roll once
			for(i = 0; i < mArmyRandomChances.Length; i++ )
			{
				for(j = 0; j < mArmyRandomChances[i]; j++)
				{
					armyNumberPool.AddItem(i);
				}
			}
		}
		else
		{
			mArmyEncounterNumber = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(mMultiArmySetup.Length);
		}
		rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(armyNumberPool.Length);
		mArmyEncounterNumber = armyNumberPool[rnd];
		mArmyEncounterSet = true;
	}

	mArmySetup = mMultiArmySetup[mArmyEncounterNumber].FactionArmy;
}

