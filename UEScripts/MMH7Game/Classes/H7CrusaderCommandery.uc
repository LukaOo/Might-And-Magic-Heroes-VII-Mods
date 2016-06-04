/*=============================================================================
* H7CrusaderCommandery
* =============================================================================
* Child class of H7BattleSite
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7CrusaderCommandery extends H7BattleSite;

var(GeneralSetup)   protected bool                              mPedefinedArmy                      <DisplayName = "Enable Pedefined Army">;
/**Set the number(Faction) of the army, which is encountered, when visiting the battlesite*/
var(GeneralSetup)   protected int                               mPedefinedArmyNumber                <DisplayName = "Pedefined Army Number">;
var(RewardSetup)    protected Array<H7AdventureArmy>            mHeroReward                         <DisplayName = "Hero/Army Reward">;
/**Defining the number of heroes you will get as reward (Default = 1) Note: GUI currently only supports getting one hero per combat*/
var(RewardSetup)    protected int                               mMultiHeroReward                    <DisplayName = "Reward count of heroes">;
/**The number of the array slot (beginning at 0). Check Army Setup tabs*/
var(ArmySetup)      protected int                               mNumberOfFactions                   <DisplayName = "Number of prepared Factions">;
var(ArmySetup)      protected Array<H7MultiArmySetupData>       mMultiArmySetup                     <DisplayName = "Army Setup">;

var                 protected savegame int                      mChoosenHeroIndex;

event InitAdventureObject()
{
	local int i;

	super.InitAdventureObject();

	if( mHeroReward.Length == 0 )
	{
		;
		return;
	}

	//Set the hero state to dead
	for( i = 0; i < mHeroReward.Length; i++)
	{
		if(!mHeroReward[i].IsDead())
		{
			mHeroReward[i].SetIsDead(true);
		}
	}

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		//Choose a hero from the list as reward
		RollNewHeroReward();
	}
	

	
}

function RollNewHeroReward()
{
	mChoosenHeroIndex = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(mHeroReward.Length);
}

function H7EditorHero GetHeroRewardGUI()
{
	return mHeroReward[mChoosenHeroIndex].GetHeroTemplate();
}

function OnVisit( out H7AdventureHero hero )
{
	if(!mPedefinedArmy)
	{
		ElectFactionArmy();
	}
	else
	{
		ElectFactionArmy();
	}

	super.OnVisit( hero );
}

function ElectFactionArmy()
{
	local int randomArmy;

	if( mMultiArmySetup.Length == 0 )
	{
		;
		return;
	}

	if( !mPedefinedArmy )
	{
		randomArmy = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(mMultiArmySetup.Length);
	}
	else
	{
		randomArmy = mPedefinedArmyNumber;
	}

	mArmySetup = mMultiArmySetup[randomArmy].FactionArmy;
}

function GetReward(H7AdventureHero hero)
{
	local int i;

	super.GetReward(hero);

	if(mHeroReward.Length > 0 && mMultiHeroReward > 0)
	{
		for(i = 0; i < mMultiHeroReward; i++)
		{
			GetHeroReward(hero);
		}
	}
}

function GetHeroReward(H7AdventureHero hero)
{
	local H7AdventureMapCell spawnPosition, cell;
	local array<H7AdventureMapCell> possibleSpawnPositions;
	local H7AdventureController adventureController;
	local H7AdventureArmy rewardArmy;

	adventureController = class'H7AdventureController'.static.GetInstance();

	spawnPosition = self.GetEntranceCell();
	possibleSpawnPositions = spawnPosition.GetNeighbours();

	foreach possibleSpawnPositions(cell)
	{
		if(!cell.IsBlocked())
		{
			spawnPosition = cell;
			break;
		}
	}

	rewardArmy = Spawn(class'H7AdventureArmy',,,,,mHeroReward[mChoosenHeroIndex]);
	//rewardArmy = mHeroReward[i];
	rewardArmy.SetIsDead( false );
	rewardArmy.SetPlayer( hero.GetPlayer() );
	rewardArmy.Init( hero.GetPlayer() );
	rewardArmy.CreateHero();
	rewardArmy.SetCell( spawnPosition );
	// in case the hero was dead once, attach his/her army again (else it'll be invisible)
	adventureController.AddArmy( rewardArmy );
	adventureController.UpdateHUD();
	rewardArmy.ShowArmy();

	//To avoid multi hero rewards with the identical heroes
	mHeroReward.RemoveItem(mHeroReward[mChoosenHeroIndex]);
	//Roll new hero reward
	RollNewHeroReward();
}

