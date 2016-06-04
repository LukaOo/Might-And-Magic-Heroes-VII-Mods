//=============================================================================
// H7HallOfHeroesManager
//
// Serialization called from H7AdventureController
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7HallOfHeroesManager extends Object
	savegame
	native;

// player heroes pools
var protected savegame array<PlayerHeroesPoolData> mPlayerHeroesPools;
// heroes that can be randomly added to the hall of heroes
var protected savegame array<RandomHeroData> mRandomHeroes;

var protected H7AdventureController mAdventureController;

//=============================================================================
// Functions
//=============================================================================

function Init( array<H7Player> players, H7AdventureController adventureController )
{
	mAdventureController = adventureController;

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		// init mPlayerHeroesPools
		mPlayerHeroesPools.Add( players.Length );

		// init mRandomHeroes
		mRandomHeroes.Add( 1 );
		mRandomHeroes.Remove( 0, 1 );

		InitNative( players, adventureController );
		// insert the initial heroes into the pool
		UpdateEndDay( true );
	}
}

// returns true if the hero is already in the map at the start of the adventure map
native protected function bool IsHeroAlreadyInUse( H7EditorHero hero );
native function InitNative( array<H7Player> players, H7AdventureController adventureController );

// returns the heroes of one specific town
native function array<RecruitHeroData> GetHeroesPool( H7Player playerOwner, H7Town town );

// removes the gold from the player
// removes a hero from the heroes pool
// updates the cost of the new heroes
// returns the army where the hero is, will be none if the player doesnt have enough gold or the heroid is not found
function H7AdventureArmy RecruitHero( H7Player playerOwner, H7Town town, int HeroId )
{
	local H7AdventureArmy heroArmy;
	local int i;
	local JsonObject                    obj;
	local H7Player      OldOwner;
	local H7PlayerEventParam eventParam;

	for( i=0; i<mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool.Length; ++i )
	{
		if( mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool[i].Army.GetHero().GetID() == HeroId )
		{
			if( playerOwner.GetResourceSet().GetCurrency() < mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool[i].Cost )
			{
				;
				break;
			}
			if( !mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool[i].IsAvailable )
			{
				;
				break;
			}
			playerOwner.GetResourceSet().ModifyCurrency( -mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool[i].Cost, true );
			heroArmy = mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool[i].Army;
			heroArmy.SetIsDead( false );
			if( mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool[i].IsNew)
			{
				OldOwner = none;
			}
			else 
			{
				OldOwner = heroArmy.GetPlayer();    // for tracking 
			}
			heroArmy.SetPlayer( playerOwner );
			mPlayerHeroesPools[playerOwner.GetPlayerNumber()].HeroesPool.Remove( i, 1 );
			break;
		}
	}

	if( heroArmy == none )
	{
		;
	}
	else
	{
		mAdventureController.AddArmy( heroArmy );
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddHero( heroArmy.GetHero() );

		// update the cost of the new heroes
		UpdateAllHeroCosts( playerOwner );

		// trigger player recruit hero event
		eventParam = new class'H7PlayerEventParam';
		eventParam.mEventPlayerNumber = playerOwner.GetPlayerNumber();
		eventParam.mRecruitedHero = heroArmy.GetHeroTemplateSource();
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerRecruitHero', eventParam, heroArmy);
	}
	

	if(!playerOwner.IsControlledByAI() && playerOwner.IsControlledByLocalPlayer() )
	{
		obj = new class'JsonObject'();
		obj.SetStringValue("heroId", heroArmy.GetHero().GetOriginArchetype().GetArchetypeID() );
		obj.SetStringValue("heroName", heroArmy.GetHero().GetName());
		obj.SetIntValue("heroLevel", heroArmy.GetHero().GetLevel());
		obj.SetStringValue("heroClass", string ( heroArmy.GetHero().GetHeroClass().Name ));
		obj.SetBoolValue("isOwnHero", OldOwner == playerOwner);
		obj.SetBoolValue("isOtherPlayerHero", OldOwner != none && OldOwner != playerOwner);
		obj.SetStringValue("playerFaction", string( playerOwner.GetFaction().Name ));
		obj.SetIntValue("playerPosition", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() );
		obj.SetIntValue("nbTurns", class'H7AdventureController'.static.GetInstance().GetCalendar().GetDaysPassed()); 
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_HERO_RECRUITED","hero.recruited", obj );
		
		if( heroArmy.GetHero().HasPendingLevelUp() )
		{
			heroArmy.GetHero().InvokeLevelUp();
			heroArmy.GetHero().SetPendingLevelUp( false );
		}
	}


	return heroArmy;
}

// adds a new hero to the hero pool of the player owner
// army of the hero with himself is created and set dead (waiting to be recruited)
protected function AddNewHero( int randomHeroesIndex, H7Player playerOwner )
{
	local int i;
	local RecruitHeroData newHero;
	local H7AdventureArmy newArmy;

	newArmy = playerOwner.Spawn( class'H7AdventureArmy' );
	newArmy.SetHeroTemplate( mRandomHeroes[randomHeroesIndex].HeroArchetype );
	newArmy.SetCreatureStackProperties( mRandomHeroes[randomHeroesIndex].HeroArchetype.GetHoHDefaultArmy() );
	newArmy.Init( playerOwner );
	newArmy.SetIsDead( true, false );
	mAdventureController.RemoveArmy( newArmy ); // the army is considered dead

	newHero.RandomHeroesIndex = randomHeroesIndex;
	newHero.Army = newArmy;
	newHero.IsNew = true;
	newHero.IsAvailable = true;
	newHero.Cost = CalculateHeroCost( 1, true, playerOwner );

	for( i=0; i<mPlayerHeroesPools.Length; ++i )
	{
		if( mPlayerHeroesPools[i].PlayerOwner == playerOwner)
		{
			mPlayerHeroesPools[i].HeroesPool.AddItem( newHero );
		}
	}
}

// to add a defeated hero (already exist in the game) to the hero pool of the player owner
// army = army that contains the defeated hero
function AddDefeatedHero( H7AdventureArmy army )
{
	local RecruitHeroData newHero;

	if( !army.GetHero().IsHero() ) { return; } //NOPE, no non-heroes

	newHero.RandomHeroesIndex = -1;
	newHero.Army = army;
	newHero.IsNew = false;
	newHero.IsAvailable = false;
	newHero.Cost = CalculateHeroCost( army.GetHero().GetLevel(), false, army.GetPlayer() );

	mPlayerHeroesPools[army.GetPlayer().GetPlayerNumber()].HeroesPool.AddItem( newHero );
}

//Add a hero archetype to hall of hero.
function SimulateAddNewHero( H7EditorHero hero, H7Player playerOwner )
{
	local int heroIdx;
	local RandomHeroData randomData;
	heroIdx = mRandomHeroes.Find('HeroArchetype', hero);
	if (heroIdx == INDEX_NONE)
	{
		randomData.HeroArchetype = hero;
		randomData.IsBeingUsed = false;
		mRandomHeroes.AddItem(randomData);
		heroIdx = mRandomHeroes.Length-1;
	}
	AddNewHero(heroIdx, playerOwner);
}

function UpdateEndDay( bool isStartWeek )
{
	local int i, j;
	
	// do the update of the new week
	if( isStartWeek && !class'H7ReplicationInfo'.static.GetInstance().mIsTutorial)
	{
		UpdateWeeklyNewHeroes();
	}

	// unlock all this-turn-defeated heroes
	for( i=0; i<mPlayerHeroesPools.Length; ++i )
	{
		if( mPlayerHeroesPools[i].PlayerOwner != mAdventureController.GetNeutralPlayer() )
		{
			// make available all the heroes that were added in the last day
			for( j=0; j<mPlayerHeroesPools[i].HeroesPool.Length; ++j )
			{
				if( !mPlayerHeroesPools[i].HeroesPool[j].IsAvailable )
				{
					mPlayerHeroesPools[i].HeroesPool[j].IsAvailable = true;
				}
			}
		}
	}
}

// The 4 random heroes (respectively the remaining random heroes) get replaced at the end of the week by 4 new random heroes.
// 2 of the 4 random heroes are of the town?s faction
// The other 2 are randomly chosen from the remaining factions.
protected function UpdateWeeklyNewHeroes()
{
	local int i, j;
	local array<H7Player> players;
	local H7Player currentPlayer;
	local int totalNewHeroes;
	local H7SynchRNG synchRNG;

	// return the heroes that are still in the HoH
	for( i=0; i<mPlayerHeroesPools.Length; ++i )
	{
		if( mPlayerHeroesPools[i].PlayerOwner != mAdventureController.GetNeutralPlayer() )
		{
			for( j = mPlayerHeroesPools[i].HeroesPool.Length-1; j >= 0 ; --j )
			{
				if( mPlayerHeroesPools[i].HeroesPool[j].IsNew )
				{
					mRandomHeroes[mPlayerHeroesPools[i].HeroesPool[j].RandomHeroesIndex].IsBeingUsed = false; // enable again the hero
					mPlayerHeroesPools[i].HeroesPool[j].Army.GetHero().Destroy();
					mPlayerHeroesPools[i].HeroesPool[j].Army.Destroy();
					mPlayerHeroesPools[i].HeroesPool.Remove( j, 1 );
				}
			}
		}
	}
	
	synchRNG = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG();

	// assign the same faction heroes
	for( i=0; i<mAdventureController.GetConfig().mNumHeroesSameFaction; ++i )
	{
		players.Length = 0; // reset
		for( j=0; j<mPlayerHeroesPools.Length; ++j )
		{
			if( mPlayerHeroesPools[j].PlayerOwner != mAdventureController.GetNeutralPlayer() && mPlayerHeroesPools[j].PlayerOwner.GetStatus() == PLAYERSTATUS_ACTIVE )
			{
				players.AddItem( mPlayerHeroesPools[j].PlayerOwner );
			}
		}

		while( players.Length > 0 )
		{
			currentPlayer = players[ synchRNG.GetRandomInt( players.Length ) ];
			InsertHeroSameFaction( currentPlayer );
			players.RemoveItem( currentPlayer );
		}
	}

	// assign the other faction heroes
	totalNewHeroes = mAdventureController.GetConfig().mNumHeroesOtherFactions + mAdventureController.GetConfig().mNumHeroesSameFaction;
	for( i=0; i<totalNewHeroes; ++i )
	{
		players.Length = 0; // reset
		for( j=0; j<mPlayerHeroesPools.Length; ++j )
		{
			if( mPlayerHeroesPools[j].PlayerOwner != mAdventureController.GetNeutralPlayer() && mPlayerHeroesPools[j].PlayerOwner.GetStatus() == PLAYERSTATUS_ACTIVE 
				&& GetNumNewHeroes( j ) < totalNewHeroes )
			{
				players.AddItem( mPlayerHeroesPools[j].PlayerOwner );
			}
		}

		while( players.Length > 0 )
		{
			currentPlayer = players[ synchRNG.GetRandomInt( players.Length ) ];
			InsertHeroAnyFaction( currentPlayer );
			players.RemoveItem( currentPlayer );
		}
	}
}

function int GetNumNewHeroes( int index )
{
	local int i;
	local int newHeroes;

	for( i=0; i<mPlayerHeroesPools[index].HeroesPool.Length; ++i )
	{
		if( mPlayerHeroesPools[index].HeroesPool[i].IsNew )
		{
			++newHeroes;
		}
	}
	
	return newHeroes;
}

protected function InsertHeroSameFaction( H7Player thePlayer )
{
	local int j, randomIndex;
	local array<int> indexArray;
	
	for( j=0; j<mRandomHeroes.Length; ++j )
	{
		if( !mRandomHeroes[j].IsBeingUsed && 
			mRandomHeroes[j].HeroArchetype.GetFaction() == thePlayer.GetFaction() && 
			thePlayer.IsHeroAllowed( mRandomHeroes[j].HeroArchetype ) )
		{
			indexArray.AddItem( j );
		}
	}

	if( indexArray.Length > 0 )
	{
		randomIndex = indexArray[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( indexArray.Length )];
		AddNewHero( randomIndex, thePlayer );
		mRandomHeroes[randomIndex].IsBeingUsed = true;
	}
	else
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("There are no more might heroes available.",MD_QA_LOG);;
	}
}

protected function InsertHeroAnyFaction( H7Player thePlayer )
{
	local int j, randomIndex;
	local array<int> indexArray;

	for( j=0; j<mRandomHeroes.Length; ++j )
	{
		if( !mRandomHeroes[j].IsBeingUsed && mRandomHeroes[j].HeroArchetype.GetFaction() != thePlayer.GetFaction() &&
			thePlayer.IsHeroAllowed( mRandomHeroes[j].HeroArchetype ) )
		{
			indexArray.AddItem( j );
		}
	}

	if( indexArray.Length > 0 )
	{
		randomIndex = indexArray[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( indexArray.Length )];
		AddNewHero( randomIndex, thePlayer );
		mRandomHeroes[randomIndex].IsBeingUsed = true;
	}
	else
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("There are not more heroes available.",MD_QA_LOG);;
	}
}

protected function int CalculateHeroCost( int heroLevel, bool isNewHero, H7Player ownerPlayer )
{
	local array<H7AdventureArmy> armies;

	if( isNewHero )
	{
		armies = mAdventureController.GetPlayerArmies( ownerPlayer, true );
		return mAdventureController.GetConfig().mBaseNewHeroCost + mAdventureController.GetConfig().mPerNumHeroesNewHeroCost * armies.Length;
	}
	else
	{
		return mAdventureController.GetConfig().mBaseLostHeroCost + mAdventureController.GetConfig().mPerLevelLostHeroCost * heroLevel;
	}
}

protected function UpdateAllHeroCosts( H7Player owner )
{
	local int j;
	local array<RecruitHeroData> pool;

	pool = mPlayerHeroesPools[owner.GetPlayerNumber()].HeroesPool;
	for( j=0; j<pool.Length; ++j )
	{
		if( pool[j].IsNew )
		{
			pool[j].Cost = CalculateHeroCost( 1, true, owner );
		}
	}
	mPlayerHeroesPools[owner.GetPlayerNumber()].HeroesPool = pool;
}
