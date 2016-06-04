//=============================================================================
// H7Player
//=============================================================================
//
// Serialization called from H7AdventureController
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Player extends Actor implements ( H7IEffectTargetable,H7IGUIListenable )
	native
	dependson(H7StructsAndEnumsNative)
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	savegame;

var protected H7AdventureController             mAdventureController;

var(Player) protected savegame EPlayerType		mPlayerType<DisplayName=Type>;
var(Player) protected savegame EPlayerColor		mPlayerColor<DisplayName=Color>;
var(Player) protected savegame string			mName<DisplayName=Name>;
var(Player) protected savegame H7ResourceSet	mResourceSetTemplate<DisplayName=Resource Set>;
var(Player) protected savegame H7Faction		mFaction<DisplayName=Faction>;
var         protected savegame ETeamNumber      mTeamNumber;
var         protected savegame EPlayerStatus    mStatus;

var protectedwrite savegame float				mDifficultyAICreatureGrowthRateMultiplier;  
var protectedwrite savegame float				mDifficultyAIStartResourcesMultiplier; 
var protectedwrite savegame float				mDifficultyAIResourceIncomeMultiplier; 
var protectedwrite savegame float				mDifficultyAIAggressivenessMultiplier; 

var protected H7QuestController		            mQuestController;
var protected savegame int						mArmiesDefeated;

var protected savegame array<EPlayerColor>      mVisitedKeymasters;
var protected savegame array<H7Obelisk>         mVisitedObelisks;

var protected savegame EPlayerNumber			mPlayerNumber;
var protected savegame H7ResourceSet			mResourceSet;
var protected savegame bool                     mDiscoveredFromStart;
var protectedwrite savegame bool                mWonGame;
var protectedwrite savegame bool                mLostGame;
var protected savegame H7ThievesGuildManager    mThievesGuildManager;

var protected savegame ECombatPlayerType		mCombatPlayerType;
var protected savegame bool                     mIsControlledByAI;

var protected savegame H7ResourceSet            mAiSaveUpSpendingHero;
var protected savegame H7ResourceSet            mAiSaveUpSpendingRecruitment;
var protected savegame H7ResourceSet            mAiSaveUpSpendingTownDev;
var protected savegame H7ResourceSet            mAiNeedTownDev;
var protected savegame H7ResourceSet            mAiNeedRecruitment;
var protected savegame array<int>               mAiDiscoveredAoC;
var protected savegame H7Town                   mAiCapitol;
var protected float                             mAiPowerBalance;
var protected savegame int						mAiMainCounter;

var protected savegame bool                     mIsObserver;
var protected bool                              mEndedTurn;

// IEffectTargetable
var protected savegame H7BuffManager			mBuffManager;
var protected savegame H7AbilityManager			mAbilityManager;
var protected H7EventManager                    mEventManager;
var protected H7EffectManager                   mEffectManager;
var protected savegame array<H7Player>          mPlunderQueue;
var protected savegame array<H7EditorHero>      mForbiddenHeroes;

var protected savegame H7AdventureArmy          mLastSelectedArmy;
var protected savegame H7Town                   mLastConqueredTown;

// temporary storing of original reinforcement stacks for the case of an reset.
var protected array<H7BaseCreatureStack>        mOriginalReinforcementStacksTown;
var protected array<H7BaseCreatureStack>        mOriginalReinforcementStacksArmy;

function H7Town                         GetLastConqueredTown()                          { return mLastConqueredTown; }
function                                SetLastConqueredTown( H7Town town )             { mLastConqueredTown = town; }
function int                            GetAIMainCounter()                              { return mAiMainCounter; }
function                                IncrementAIMainCounter()                        { ++mAiMainCounter; }
function                                SetAICreatureGrowthRateMultiplier( float val )  { mDifficultyAICreatureGrowthRateMultiplier = val; }
function                                SetAIResourceIncomeMultiplier( float val )      { mDifficultyAIResourceIncomeMultiplier = val; }
function                                SetAIStartResourceMultiplier( float val )       { mDifficultyAIStartResourcesMultiplier = val; }
function                                SetAIAggresivenessMultiplier( float val )       { mDifficultyAIAggressivenessMultiplier = val; }
function                                SetForbiddenHeroes( array<H7EditorHero> heroes ){ mForbiddenHeroes = heroes; }
function array<H7EditorHero>            GetForbiddenHeroes()                            { return mForbiddenHeroes; }
function bool                           IsHeroAllowed( H7EditorHero hero )              { return mForbiddenHeroes.Find( hero ) == INDEX_NONE; }
function array<EPlayerColor>            GetVisitedKeymasters()                          { return mVisitedKeymasters; }
function                                AddVisitedKeymaster( EPlayerColor keyColor )    { mVisitedKeymasters.AddItem( keyColor ); }
function array<H7Obelisk>               GetVisitedObelisks()                            { return mVisitedObelisks; }
function int                            GetNumOfVisitedObelisks()                       { return mVisitedObelisks.Length; }
function EPlayerType					GetPlayerType()									{ return mPlayerType; }
function								SetPlayerType( EPlayerType playerType )			{ mPlayerType = playerType; }
function EPlayerColor					GetPlayerColor()								{ return mPlayerColor; }
function String					        GetPlayerColorString()						    { return String(mPlayerColor); }
function								SetPlayerColor( EPlayerColor playerColor )		{ mPlayerColor = playerColor; }
function EPlayerNumber					GetPlayerNumber()								{ return mPlayerNumber; }
function								SetPlayerNumber( int number )					{ mPlayerNumber = EPlayerNumber( number ); }
function								SetName( string newName )						{ mName = newName; } // localization happens in lobby and is then just passed along as-is: direct: mGlobalName.GetName(); mainmenu: LocalizeFieldParams
native function	                        GetResourceIncomeFromEffects(out H7ResourceSet effectSpecials);
function H7ResourceSet					GetResourceSet()								{ return mResourceSet; }
function                                SetResourceSetTemplate( H7ResourceSet value )   { mResourceSetTemplate = value; }
function								SetCombatPlayerType( ECombatPlayerType newType ){ mCombatPlayerType = newType; }
function ECombatPlayerType				GetCombatPlayerType()							{ return mCombatPlayerType; }
function                                SetTeamNumber( ETeamNumber number )             { mTeamNumber = number; }
function ETeamNumber                    GetTeamNumber()                                 { return mTeamNumber; }
function                                SetStatus (EPlayerStatus inNewStatus)           { mStatus = inNewStatus; }
function EPlayerStatus                  GetStatus()                                     { return mStatus; }
function                                SetLastSelectedArmy( H7AdventureArmy army )     { mLastSelectedArmy = army; }
function H7AdventureArmy                GetLastSelectedArmy()                           { return mLastSelectedArmy; }
function bool							IsNeutralPlayer()								{ return mPlayerNumber == PN_NEUTRAL_PLAYER; }
function H7ThievesGuildManager          GetThievesGuildManager()                        { return mThievesGuildManager;}
function                                SetThievesGuildManager(H7ThievesGuildManager m) { mThievesGuildManager = m; }
function bool                           IsDiscoveredFromStart()                         { return mDiscoveredFromStart; }
function                                SetDiscoveredFromStart(bool val)                { mDiscoveredFromStart = val; }
function                                SetWonGame()                                    { mWonGame = true ; }
function                                SetEndedTurn(bool val)                          { mEndedTurn = val; }
function bool                           HasEndedTurn()                                  { return mEndedTurn; }
/**
 * Check for auto-combat or any other case for which we want the AI to take actions for the player
 * */
function bool                           IsControlledByAI()                              { return ( mPlayerType == PLAYER_AI || mIsControlledByAI == true ); } // because we can have human with auto combat
function                                SetControlledByAI( bool isControlled )          { mIsControlledByAI = isControlled; }
function H7Faction						GetFaction()									{ return mFaction; }
function                                SetFaction(H7Faction faction)                   { mFaction = faction;}
function H7QuestController				GetQuestController()							{ return mQuestController; }

//TODO: Use me with proper combatmap/adventuremap transition
function								SetDefeatedArmiesCount( int count )				{ mArmiesDefeated = count; }
function int							GetDefeatedArmiesCount()						{ return mArmiesDefeated; }
native function float GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);

function H7ResourceSet                  GetAiSaveUpSpendingHero()                       { return mAiSaveUpSpendingHero; }
function H7ResourceSet                  GetAiSaveUpSpendingRecruitment()                { return mAiSaveUpSpendingRecruitment; }
function H7ResourceSet                  GetAiSaveUpSpendingTownDev()                    { return mAiSaveUpSpendingTownDev; }
function H7ResourceSet                  GetAiNeedTownDev()                              { return mAiNeedTownDev; }
function H7ResourceSet                  GetAiNeedRecruitment()                          { return mAiNeedRecruitment; }
function int                            GetDiscoveredAoC()                              { return mAiDiscoveredAoC.Length; }
function H7Town                         GetAiCapitol()                                  { return mAiCapitol; }
function                                SetAiCapitol(H7Town t)                          { mAiCapitol=t; }
function float                          GetAiPowerBalance()                             { return mAiPowerBalance; }
function                                RecalcAiPowerBalance()
{
	local array<H7Player> players;
	local array<H7AdventureArmy> armies;
	local H7Player otherPlayer;
	local H7AdventureArmy army;
	local float ownPower, otherPower, highestPower, powerRatio;

	mAiPowerBalance=1.0f;
	ownPower=0.0f;
	otherPower=0.0f;
	highestPower=0.0f;

	players = class'H7AdventureController'.static.GetInstance().GetPlayers();
	foreach players(otherPlayer)
	{
		// find hostile players
		if(otherPlayer!=None && otherPlayer!=self && otherPlayer.IsNeutralPlayer()==false && otherPlayer.GetTeamNumber()!=GetTeamNumber())
		{
			otherPower=0.0f;
			armies=otherPlayer.GetArmiesByStrength();
			foreach armies(army)
			{
				if(army!=None)
				{
					otherPower+=army.GetStrengthValue(true);
				}
			}
			if(highestPower<otherPower)
			{
				highestPower=otherPower;
			}
		}
	}

	armies=GetArmiesByStrength();
	foreach armies(army)
	{
		if(army!=None)
		{
			ownPower+=army.GetStrengthValue(true);
		}
	}

	if(highestPower>0.0f && ownPower>0.0f)
	{
		powerRatio = ownPower / (highestPower*2.0f);
		if(powerRatio>1.0f) powerRatio=1.0f;
	}
	else if(highestPower>0.0f && ownPower<=0.0f)
	{
		powerRatio=0.0f;
	}
	else if(highestPower<=0.0f && ownPower<=0.0f)
	{
		powerRatio=0.5f;
	}
	else //highestPower<=0.0f && ownPower>0.0f
	{
		powerRatio=1.0f;
	}

	mAiPowerBalance=powerRatio;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
}


function array<H7Town> GetCaravanTargets() 
{ 
	local array<H7Town> towns, targetTowns;
	local H7Town town;
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local array<H7VisitableSite> sites;
	local int siteIndex, closestIndex;
	local float closestDistance;

	armies = GetArmies();
	towns = GetTowns();
	closestIndex = INDEX_NONE;
	closestDistance = 1000000000;

	foreach armies( army )
	{
		if( army.GetHero().IsHero() && ( army.GetHero().GetAiRole() == HRL_MAIN || army.GetHero().GetAiRole() == HRL_SECONDARY || army.GetHero().GetAiRole() == HRL_GENERAL ) )
		{
			foreach towns( town )
			{
				sites = army.GetReachableSites();
				siteIndex = sites.Find( town );
				if( siteIndex != INDEX_NONE )
				{
					if( closestDistance > army.mReachableSitesDistances[ siteIndex ] )
					{
						closestDistance = army.mReachableSitesDistances[ siteIndex ];
						closestIndex = siteIndex;
					}
				}
			}
			if(closestIndex!=INDEX_NONE)
			{
				town = H7Town( sites[ closestIndex ] );
				if( town != none && targetTowns.Find( town ) == INDEX_NONE )
				{
					targetTowns.AddItem( town );
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
			}
		}
	}
	return targetTowns;
}

function float CalcAiAoCModifierFromTargetSite( H7AiConfigCompound cfg, H7VisitableSite site )
{
	local H7AdventureMapCell ce;
	local array<H7Town> towns;
	local H7Town town;
	local array<H7Fort> forts;
	local H7Fort fort;
	local int aoc_num;
	local float pb;
	
	if(site==None) return 1.0f;
	ce=site.GetEntranceCell();
	if(ce==None) return 1.0f;

	pb = 1.0f - mAiPowerBalance;

	aoc_num=ce.GetAreaOfControl();
	if(aoc_num<=0) 
	{
		if(pb<=0.5f)
			return Lerp( cfg.AoCMod.OwnAoC.PBWeak, cfg.AoCMod.OwnAoC.PBBalanced, (pb*2.0f) );
		else
			return Lerp( cfg.AoCMod.OwnAoC.PBBalanced, cfg.AoCMod.OwnAoC.PBStrong, ((pb-0.5f)*2.0f) );
	}
	
	towns=class'H7AdventureController'.static.GetInstance().GetTownList();
	foreach towns(town)
	{
		if(town!=None && town.GetAreaOfControlID()==aoc_num)
		{
			if( town.GetPlayer()==self ||
				town.GetPlayer().IsNeutralPlayer()==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.OwnAoC.PBWeak, cfg.AoCMod.OwnAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.OwnAoC.PBBalanced, cfg.AoCMod.OwnAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}
			if(IsPlayerAllied(town.GetPlayer())==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.AlliedAoC.PBWeak, cfg.AoCMod.AlliedAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.AlliedAoC.PBBalanced, cfg.AoCMod.AlliedAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}

			if(pb<=0.5f)
				return Lerp( cfg.AoCMod.HostileAoC.PBWeak, cfg.AoCMod.HostileAoC.PBBalanced, (pb*2.0f) );
			else
				return Lerp( cfg.AoCMod.HostileAoC.PBBalanced, cfg.AoCMod.HostileAoC.PBStrong, ((pb-0.5f)*2.0f) );
		}
	}

	forts=class'H7AdventureController'.static.GetInstance().GetFortList();
	foreach forts(fort)
	{
		if(fort!=None && fort.GetAreaOfControlID()==aoc_num)
		{
			if( fort.GetPlayer()==self ||
				fort.GetPlayer().IsNeutralPlayer()==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.OwnAoC.PBWeak, cfg.AoCMod.OwnAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.OwnAoC.PBBalanced, cfg.AoCMod.OwnAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}
			if(IsPlayerAllied(fort.GetPlayer())==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.AlliedAoC.PBWeak, cfg.AoCMod.AlliedAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.AlliedAoC.PBBalanced, cfg.AoCMod.AlliedAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}

			if(pb<=0.5f)
				return Lerp( cfg.AoCMod.HostileAoC.PBWeak, cfg.AoCMod.HostileAoC.PBBalanced, (pb*2.0f) );
			else
				return Lerp( cfg.AoCMod.HostileAoC.PBBalanced, cfg.AoCMod.HostileAoC.PBStrong, ((pb-0.5f)*2.0f) );
		}
	}
	return 1.0f;
}

function UpdateTownInfoIcons()
{
	local int i;
	local array<H7Town> towns;
	
	towns = GetTowns();

	for( i = 0; i < towns.Length; ++i )
	{
		towns[i].DataChanged();
	}
}

function float CalcAiAoCModifierFromTargetArmy( H7AiConfigCompound cfg, H7AdventureArmy army )
{
	local H7AdventureMapCell ce;
	local array<H7Town> towns;
	local H7Town town;
	local array<H7Fort> forts;
	local H7Fort fort;
	local int aoc_num;
	local float pb;

	if(army==None) return 1.0f;
	ce=army.GetCell();
	if(ce==None) return 1.0f;

	pb = 1.0f - mAiPowerBalance;

	aoc_num=ce.GetAreaOfControl();
	if(aoc_num<=0) 
	{
		if(pb<=0.5f)
			return Lerp( cfg.AoCMod.OwnAoC.PBWeak, cfg.AoCMod.OwnAoC.PBBalanced, (pb*2.0f) );
		else
			return Lerp( cfg.AoCMod.OwnAoC.PBBalanced, cfg.AoCMod.OwnAoC.PBStrong, ((pb-0.5f)*2.0f) );
	}
	
	towns=class'H7AdventureController'.static.GetInstance().GetTownList();
	foreach towns(town)
	{
		if(town!=None && town.GetAreaOfControlID()==aoc_num)
		{
			if( town.GetPlayer()==self ||
				town.GetPlayer().IsNeutralPlayer()==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.OwnAoC.PBWeak, cfg.AoCMod.OwnAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.OwnAoC.PBBalanced, cfg.AoCMod.OwnAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}
			if(IsPlayerAllied(town.GetPlayer())==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.AlliedAoC.PBWeak, cfg.AoCMod.AlliedAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.AlliedAoC.PBBalanced, cfg.AoCMod.AlliedAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}
			if(pb<=0.5f)
				return Lerp( cfg.AoCMod.HostileAoC.PBWeak, cfg.AoCMod.HostileAoC.PBBalanced, (pb*2.0f) );
			else
				return Lerp( cfg.AoCMod.HostileAoC.PBBalanced, cfg.AoCMod.HostileAoC.PBStrong, ((pb-0.5f)*2.0f) );
		}
	}

	forts=class'H7AdventureController'.static.GetInstance().GetFortList();
	foreach forts(fort)
	{
		if(fort!=None && fort.GetAreaOfControlID()==aoc_num)
		{
			if( fort.GetPlayer()==self ||
				fort.GetPlayer().IsNeutralPlayer()==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.OwnAoC.PBWeak, cfg.AoCMod.OwnAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.OwnAoC.PBBalanced, cfg.AoCMod.OwnAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}
			if(IsPlayerAllied(fort.GetPlayer())==true)
			{
				if(pb<=0.5f)
					return Lerp( cfg.AoCMod.AlliedAoC.PBWeak, cfg.AoCMod.AlliedAoC.PBBalanced, (pb*2.0f) );
				else
					return Lerp( cfg.AoCMod.AlliedAoC.PBBalanced, cfg.AoCMod.AlliedAoC.PBStrong, ((pb-0.5f)*2.0f) );
			}
			if(pb<=0.5f)
				return Lerp( cfg.AoCMod.HostileAoC.PBWeak, cfg.AoCMod.HostileAoC.PBBalanced, (pb*2.0f) );
			else
				return Lerp( cfg.AoCMod.HostileAoC.PBBalanced, cfg.AoCMod.HostileAoC.PBStrong, ((pb-0.5f)*2.0f) );
		}
	}
	return 1.0f;
}

// ===================================
// H7IEffectTargetable implementations
// ===================================
function String                     GetName()                               { return mName==""? string(GetPlayerNumber()): mName; }
native function H7AbilityManager	GetAbilityManager();
native function H7BuffManager		GetBuffManager();
native function H7EventManager      GetEventManager();
function H7EffectManager            GetEffectManager()                      { return mEffectManager; }
function IntPoint                   GetGridPosition()                       { local IntPoint point; return point; }
native function int					GetID();
native function EUnitType           GetEntityType();

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) 
{
	if(GetAbilityManager() != none)
		GetAbilityManager().UpdateAbilityEvents(triggerEvent, forecast, container);
	if(GetBuffManager() != none)
		GetBuffManager().UpdateBuffEvents(triggerEvent, forecast, container);
}

native function H7Player GetPlayer(); // because reasons... ( H7IEffectTargetable )
function int GetStackSize()  {} 
function int GetHitPoints()  {}

function array<H7BaseCreatureStack> GetOriginalReinforcementStacksTown()            
{ 
	return mOriginalReinforcementStacksTown; 
}

function array<H7BaseCreatureStack> GetOriginalReinforcementStacksArmy() 
{
	return mOriginalReinforcementStacksArmy; 
}

// creates a copy of the stacks (new objects) to be used in case of reset and for diff-calculations
function SetOriginalReinforcementStacksTown(array<H7BaseCreatureStack> stacks) 
{ 
	local int i;

	mOriginalReinforcementStacksTown.Length = 0;
	for(i=0; i<stacks.Length; i++)
	{
		mOriginalReinforcementStacksTown.Add(1);
		if(stacks[i] != none)
		{	
			mOriginalReinforcementStacksTown[i] = new class'H7BaseCreatureStack';
			mOriginalReinforcementStacksTown[i].SetStackSize(stacks[i].GetStackSize());
			mOriginalReinforcementStacksTown[i].SetStackType(stacks[i].GetStackType());
			mOriginalReinforcementStacksTown[i].SetCustomPosition(stacks[i].GetCustomPositionBool(),stacks[i].GetCustomPositionX(),stacks[i].GetCustomPositionY());
		}
		else
		{
			mOriginalReinforcementStacksTown[i] = none;
		}
	}
}

// creates a copy of the stacks (new objects) to be used in case of reset and for diff-calculations
function SetOriginalReinforcementStacksArmy(array<H7BaseCreatureStack> stacks)
{ 
	local int i;

	mOriginalReinforcementStacksArmy.Length = 0;
	for(i=0; i<stacks.Length; i++)
	{
		mOriginalReinforcementStacksArmy.Add(1);
		if(stacks[i] != none)
		{	
			mOriginalReinforcementStacksArmy[i] = new class'H7BaseCreatureStack';
			mOriginalReinforcementStacksArmy[i].SetStackSize(stacks[i].GetStackSize());
			mOriginalReinforcementStacksArmy[i].SetStackType(stacks[i].GetStackType());
			mOriginalReinforcementStacksArmy[i].SetCustomPosition(stacks[i].GetCustomPositionBool(),stacks[i].GetCustomPositionX(),stacks[i].GetCustomPositionY());
		}
		else
		{
			mOriginalReinforcementStacksArmy[i] = none;
		}
	}
}

function AddVisitedObelisk( H7Obelisk obelisk )          
{ 
	mVisitedObelisks.AddItem( obelisk );
}

native function bool HasCapitol();

function bool AddDiscoveredAoC( int aoc_number )
{
	if( aoc_number>0 && mAiDiscoveredAoC.Find(aoc_number)==INDEX_NONE )
	{
		mAiDiscoveredAoC.AddItem(aoc_number);
		return true;
	}
	return false;
}

/** will return false if thaPlayer == self */
native function bool IsPlayerAllied( H7Player thaPlayer );

native function bool IsInSpectatorMode();

function WinGame()
{
	if( mLostGame || mWonGame ) { return; }

	mWonGame = true;
	mLostGame = false;
	SetStatus(PLAYERSTATUS_QUIT);

	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
	{
		class'H7AdventureController'.static.GetInstance().GetLocalPlayer().UpdateObserverState();
	}
}

function LoseGame()
{
	local H7CombatController combatController;

	if( mLostGame || mWonGame || GetPlayerNumber() == PN_NEUTRAL_PLAYER) { return; }

	mWonGame = false;
	mLostGame = true;
	if(GetStatus() == PLAYERSTATUS_QUIT)
	{
		return;
	}

	SetStatus(PLAYERSTATUS_QUIT);
	SendDefeatMessage();
	
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
	{
		if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
		{
			combatController = class'H7CombatController'.static.GetInstance();

			if(!combatController.IsInState('CombatEpilog') && combatController.IsPlayerParticipatingInCombat(self))
			{
				// player disconnected or quittet -> end the combat for the other players
				if(combatController.GetActiveArmy().GetPlayer() == self)
				{
					combatController.LoseCombat();
				}
				else
				{
					combatController.WinCombat();
				}
			}
		}

		if(class'H7AdventureController'.static.GetInstance().GetRemainingActivePlayerCount() > 1)
		{
			if(!class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() == self && !IsControlledByAI())
			{
				class'H7AdventureController'.static.GetInstance().EndMyTurnComplete();
			}
		}

		class'H7AdventureController'.static.GetInstance().GetLocalPlayer().UpdateObserverState();
	}

	class'H7AdventureController'.static.GetInstance().RemoveArmiesOfPlayer(self);
	class'H7AdventureController'.static.GetInstance().SetAllAOCSitesOfPlayerToNeutral(self);
}

function BecomeObserver()
{
	mIsObserver = true;
	mLastSelectedArmy = none;
	class'H7PlayerController'.static.GetPlayerController().GetHud().SetHUDMode(HM_WAITING_FOR_OTHERS_TURN);

	if(AllAlliesLost())
	{
		RevealFOWOfAllPlayers();
	}
}

function UpdateObserverState()
{
	if(mIsObserver)
	{
		if(mQuestController.IsGameWonBySomeone())
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().OKPopup("PU_GAME_ENDED", "EGA_MAINMENU", GameEndedConfirm);
		}
		else if(AllAlliesLost())
		{
			RevealFOWOfAllPlayers();
		}
	}
}

function bool AllAlliesLost()
{
	local array<H7Player> allies;
	local H7Player ally;

	allies = class'H7TeamManager'.static.GetInstance().GetAllAlliesOf(self);

	foreach allies(ally)
	{
		if(ally.GetStatus() != PLAYERSTATUS_QUIT)
		{
			return false;
		}
	}
	
	return true;
}

function GameEndedConfirm()
{
	class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
}

function RevealFOWOfAllPlayers()
{
	local H7AdventureMapGridController gridController;
	local H7AdventureGridManager gridManager;
	local array<H7Player> enemies;
	local H7Player enemy;
	local array<int> exploredTiles;
	local array<IntPoint> exploredTilesIntPoint;
	local int gridCols, gridListCounter, enemyCounter;
	local bool lastExplore;

	enemies = class'H7TeamManager'.static.GetInstance().GetAllEnemiesOf(self);
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	foreach gridManager.mGridList ( gridController )
	{
		gridListCounter++;
		enemyCounter = 0;
		gridCols = gridController.GetGridSizeX();

		foreach enemies(enemy)
		{
			enemyCounter++;
			exploredTiles = gridController.GetFOWController().GetExploredTilesForPlayer(enemy.GetPlayerNumber());
			exploredTilesIntPoint = RevealFOWOfforTiles(exploredTiles, gridCols);
			lastExplore = gridListCounter >= gridManager.mGridList.Length && enemyCounter >= enemies.Length;
			gridController.GetFOWController().HandleExploredTiles(mPlayerNumber, exploredTilesIntPoint, !lastExplore);
			
			if(lastExplore)
			{
				class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetCell().GetGridOwner().GetFOWController().ExploreFog( false );
			}
		}
	}
}

native function array<IntPoint> RevealFOWOfforTiles(array<int> exploredTiles, int gridCols);

function SendDefeatMessage()
{
	local H7Message message;
	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mPlayerDefeated.CreateMessageBasedOnMe();
	message.AddRepl("%player",GetName());
	if(class'H7MessageSystem'.static.GetInstance() != none && message != none)
	{
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}
}

native function bool IsPlayerHostile( H7Player thaPlayer );

function InitThievesGuildManager( Array<H7Player> players)
{
	mThievesGuildManager = new class'H7ThievesGuildManager';
	mThievesGuildManager.Initialize(players, GetID());
}

function array<H7CaravanArmy> GetCaravans()
{
	local array<H7CaravanArmy> caravans;
	local H7CaravanArmy caravan; 
	local array<H7CaravanArmy> playerCaravans;

	caravans = class'H7AdventureController'.static.GetInstance().GetCurrentCaravanArmies();
	foreach caravans( caravan ) 
	{   
		if( mPlayerNumber != caravan.GetPlayerNumber() || caravan.GetTargetLord() == none ) 
			continue;

		if( caravan.IsA('H7CaravanArmy') ) 
		{
			playerCaravans.AddItem( caravan ) ;		
		}
	}

	return playerCaravans;
}

// Convenience function for GUI
native function array<H7Town> GetTowns(optional H7Town except);

// Returns town of highest level
function H7Town GetBestTown()
{
	local array<H7Town> towns;
	local H7Town bestTown;
	local int i;

	towns = GetTowns();

	for( i = towns.Length - 1; i >= 0; --i)
	{
		if(i == towns.Length - 1)
		{
			bestTown = towns[i];
		}

		if(towns[i].GetLevel() > bestTown.GetLevel())
		{
			bestTown = towns[i];
		}
	}

	return bestTown;
}

// Convenience function for GUI
function array<H7Fort> GetForts(optional H7Fort except)
{
	local H7Fort fort;
	local array<H7Fort> forts, ownedForts;

	forts = class'H7AdventureController'.static.GetInstance().GetFortList();
	foreach forts( fort )
	{
		if( fort.GetPlayerNumber() == mPlayerNumber && except != fort)
		{
			ownedForts.AddItem( fort );
		}
	}
	return ownedForts;
}

// Convenience function for GUI
function array<ArrivedCaravan> GetAllArrivedCaravans()
{
	local array<H7Town> towns;
	local H7Town town;
	local array<ArrivedCaravan> towncaravans,allcaravans;
	local ArrivedCaravan caravan;

	towns = GetTowns();
	foreach towns( town )
	{
		towncaravans = town.GetArrivedCaravans();
		foreach towncaravans(caravan)
		{
			allcaravans.AddItem(caravan);
		}
	}

	return allcaravans;
}

/** Get Active Hero in Combat*/
function H7CombatHero GetHeroInCombat()
{
	if( class'H7CombatController'.static.GetInstance().GetArmyDefender().GetPlayer() == self )
		return class'H7CombatController'.static.GetInstance().GetArmyDefender().GetHero();
	
	return class'H7CombatController'.static.GetInstance().GetArmyAttacker().GetHero();
}

function array<H7AdventureHero> GetHeroes()
{
	local array<H7AdventureHero> heroes;
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;

	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies(self);
	foreach armies(army)
	{
		if(army.GetHero().IsHero()) heroes.AddItem(army.GetHero());
	}
	
	return heroes;
}

function H7AdventureHero GetBestHero()
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local H7AdventureHero bestHero;

	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies(self);
	
	foreach armies(army)
	{
		// to avoid none errors in the console
		if(bestHero == none)
		{
			if(army.GetHero().IsHero())
				bestHero = army.GetHero();
			else
				continue;
		}

		if(army.GetHero().IsHero() && army.GetHero().GetLevel() > bestHero.GetLevel()) 
			bestHero = army.GetHero();
	}

	return bestHero;
}

function array<H7AdventureArmy> GetArmies()
{
	local array<H7AdventureArmy> armies;
	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies(Self);
	return armies;
}

function array<H7AdventureArmy> GetArmiesByStrength()
{
	local array<H7AdventureArmy> armies;
	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies(Self);
	class'H7AdventureArmy'.static.SortArmyListByStrength(armies);
	return armies;
}

function H7AdventureHero GetActiveHero_DoNotUse()
{
	// TODO needs taskforce to solve
	local array<H7AdventureArmy> armies;
	
	armies = GetArmies();

	return armies[0].GetHero();
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.PrintLogMessage("H7Player.PostBeginPlay", 0);;

}

protected function CreateResourcesSet()
{
	local array<ResourceStockpile> resources;
	local ResourceStockpile resource;
	local int resCounter;

	if( mResourceSetTemplate != none )
	{
		mResourceSet = new class'H7ResourceSet' (mResourceSetTemplate);
		mResourceSet.SortByGUIPriority();
		mResourceSet.SetPlayer(self);
		resources = mResourceSet.GetAllResourcesAsArray();
		foreach resources( resource, resCounter )
		{
			// We know the last resource in the array is the currency
			if( resCounter != resources.Length - 1 )
			{
				mResourceSet.LogGatheredResource( resource.Type, 0, false );
			}
			else
			{
				mResourceSet.LogGatheredResource( resource.Type, 0, true );
			}
			mResourceSet.ClearIncome(resource.Type);
		}
		mResourceSet.ApplyDifficultyMultiplier();

		mAiSaveUpSpendingHero = new class'H7ResourceSet'(mResourceSetTemplate);
		mAiSaveUpSpendingHero.SetPlayer(self);
		resources = mAiSaveUpSpendingHero.GetAllResourcesAsArray();
		foreach resources( resource, resCounter )
		{
			mAiSaveUpSpendingHero.ClearIncome(resource.Type);
			mAiSaveUpSpendingHero.ClearQuantity(resource.Type);
		}
		mAiSaveUpSpendingHero.SetCurrencySilent(0);
		mAiSaveUpSpendingRecruitment = new class'H7ResourceSet'(mResourceSetTemplate);
		mAiSaveUpSpendingRecruitment.SetPlayer(self);
		resources = mAiSaveUpSpendingRecruitment.GetAllResourcesAsArray();
		foreach resources( resource, resCounter )
		{
			mAiSaveUpSpendingRecruitment.ClearIncome(resource.Type);
			mAiSaveUpSpendingRecruitment.ClearQuantity(resource.Type);
		}
		mAiSaveUpSpendingRecruitment.SetCurrencySilent(0);
		mAiSaveUpSpendingTownDev = new class'H7ResourceSet'(mResourceSetTemplate);
		mAiSaveUpSpendingTownDev.SetPlayer(self);
		resources = mAiSaveUpSpendingTownDev.GetAllResourcesAsArray();
		foreach resources( resource, resCounter )
		{
			mAiSaveUpSpendingTownDev.ClearIncome(resource.Type);
			mAiSaveUpSpendingTownDev.ClearQuantity(resource.Type);
		}
		mAiSaveUpSpendingTownDev.SetCurrencySilent(0);
		mAiNeedTownDev = new class'H7ResourceSet'(mResourceSetTemplate);
		mAiNeedTownDev.SetPlayer(self);
		AiClearNeedForTownDev();
		mAiNeedRecruitment = new class'H7ResourceSet'(mResourceSetTemplate);
		mAiNeedRecruitment.SetPlayer(self);
		AiClearNeedForRecruitment();
	}
	else if( mPlayerNumber == PN_NEUTRAL_PLAYER )
	{
		return;
	}
	else
	{
		;
	}

}

function bool AiDumpResources( H7ResourceSet rs )
{
	local array<ResourceStockpile> stocks;
	local ResourceStockpile pile;
	stocks=rs.GetResources();
	foreach stocks(pile)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	return true;
}

function bool AiCanSpendResourcesOnRecruitment( array<H7ResourceQuantity> resources)
{
	local H7ResourceQuantity cost;
	foreach resources( cost )
	{
		if( cost.Quantity > (mResourceSet.GetResource(cost.Type)+mAiSaveUpSpendingRecruitment.GetResource(cost.Type)) )
		{
			return false;
		}
	}
	return true;
}

function AiModifyNeedForRecruitment( array<H7ResourceQuantity> costs )
{
	local H7ResourceQuantity    cost;
	local int                   needRes;

	foreach costs(cost)
	{
		// (R.main + R.safe + R.income) - cost
		needRes = cost.Quantity - (/*mResourceSet.GetResource(cost.Type) +*/ mAiSaveUpSpendingRecruitment.GetResource(cost.Type) /*+ mResourceSet.GetIncome(cost.Type)*/);
		if( needRes > 0 )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			mAiNeedRecruitment.ModifyResource(cost.Type,needRes,false);
		}
	}
}

function AiClearNeedForRecruitment()
{
	local array<ResourceStockpile> resources;
	local ResourceStockpile resource;
	resources = mAiNeedRecruitment.GetAllResourcesAsArray();
	foreach resources(resource)
	{
		mAiNeedRecruitment.ClearIncome(resource.Type);
		mAiNeedRecruitment.ClearQuantity(resource.Type);
	}
	mAiNeedRecruitment.SetCurrencySilent(0);
}

function bool AiCanSpendResourcesOnTownDev( array<H7ResourceQuantity> resources)
{
	local H7ResourceQuantity cost;
	foreach resources( cost )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( cost.Quantity > (mResourceSet.GetResource(cost.Type)+mAiSaveUpSpendingTownDev.GetResource(cost.Type)) )
		{
			return false;
		}
	}
	return true;
}

function AiModifyNeedForTownDev( array<H7ResourceQuantity> costs )
{
	local H7ResourceQuantity    cost;
	local int                   needRes;

	foreach costs(cost)
	{
		// (R.main + R.safe + R.income) - cost
		needRes = cost.Quantity - (mResourceSet.GetResource(cost.Type) + mAiSaveUpSpendingTownDev.GetResource(cost.Type) + mResourceSet.GetIncome(cost.Type));
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( needRes > 0 )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			mAiNeedTownDev.ModifyResource(cost.Type,needRes,false);
		}
	}
}

function AiClearNeedForTownDev()
{
	local array<ResourceStockpile> resources;
	local ResourceStockpile resource;
	resources = mAiNeedTownDev.GetAllResourcesAsArray();
	foreach resources(resource)
	{
		mAiNeedTownDev.ClearIncome(resource.Type);
		mAiNeedTownDev.ClearQuantity(resource.Type);
	}
	mAiNeedTownDev.SetCurrencySilent(0);
}

function bool AiCanSpendResourcesHero( array<H7ResourceQuantity> resources)
{
	local H7ResourceQuantity cost;
	foreach resources( cost )
	{
		if( cost.Quantity > (mResourceSet.GetResource(cost.Type)+mAiSaveUpSpendingHero.GetResource(cost.Type)) )
		{
			return false;
		}
	}
	return true;
}

function bool AiCanSpendCurrencyHero( int currency )
{
	if( currency > (mResourceSet.GetCurrency()+mAiSaveUpSpendingHero.GetCurrency()) )
	{
		return false;
	}
	return true;
}

function Init()
{
	local array<H7BaseAbility> empty;
	empty = empty;
	if( mQuestController == none )
	{
		mQuestController = new class'H7QuestController'();
	}
	else
	{
		mQuestController = new class'H7QuestController'( mQuestController );
	}
	mQuestController.SetPlayer( self );
	mQuestController.Init();
	mAdventureController = class'H7AdventureController'.static.GetInstance();
	mBuffManager = new(self) class 'H7BuffManager';
	mAbilityManager = new(self) class 'H7AbilityManager';
	mEventManager = new(self) class 'H7EventManager';
	mEffectManager = new(self) class 'H7EffectManager';
	mEffectManager.Init( self );
	mBuffManager.Init( self );
	mAbilityManager.SetOwner( self );
	CreateResourcesSet();
}

// OPTIONAL more modable
event Color GetColor()
{
	return class'H7GameUtility'.static.GetColor(mPlayerColor);
}

function int GetUndefeatedHeroesAmount()
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local int count;

	count = 0;
	armies = GetArmies();
	
	foreach armies(army)
	{
		if( !army.IsDead() && army.GetHero().IsHero() )
		{
			count++;
		}
	}
	
	return count;
}

function array<H7AdventureArmy> GetUndefeatedHeroArmies()
{
	local array<H7AdventureArmy> allArmies;
	local array<H7AdventureArmy> undefeatedHeroArmies;
	local H7AdventureArmy army;

	allArmies = GetArmies();
	
	foreach allArmies(army)
	{
		if( !army.IsDead() && army.GetHero().IsHero() )
		{
			undefeatedHeroArmies.AddItem(army);
		}
	}
	
	return undefeatedHeroArmies;
}

// returns true if the player is controlled by the local player in MP
native function bool IsControlledByLocalPlayer();

function int GetExplorationPercentage()
{
	local array<H7AdventureMapGridController> gridList;
	local H7AdventureMapGridController grid;
	//because float operations require floats
	local float exploredTiles;
	local float totalTiles;
	
	gridList = class'H7AdventureGridManager'.static.GetInstance().GetGridList();
	foreach gridList( grid )
	{
		totalTiles += grid.GetGridSizeX() * grid.GetGridSizeY();
		exploredTiles += grid.GetFOWController().GetNumberOfExploredTilesFor( mPlayerNumber );
	}
	return exploredTiles / totalTiles * 100;
}

function ApplySabotage(H7Player sabotagingPlayer)
{
	local array<H7Town> towns;
	local H7Town town;
	local array<H7TownBuildingData> dwellings,playerDwellings;
	local H7TownBuildingData dwelling;

	local int i, targets, index, j;
	local array<H7ResourceQuantity> costs; 
	local H7ResourceQuantity cost;
	local H7Message message;
	local array<H7TownDwelling> sabotagedDwellings;

	if( !CanApplySabotage() )
	{
		return;
	}
	towns = GetTowns();
	targets = sabotagingPlayer.GetModifiedStatByID( STAT_SPY_INFILTRATION_TARGETS );
	
	foreach towns(town)
	{
		town.GetDwellings( dwellings );
		foreach dwellings(dwelling)
		{
			playerDwellings.AddItem(dwelling);
		}
	}

	for(i = playerDwellings.Length-1;i>0;--i )
	{
		if( playerDwellings[i].Building == none ) { continue; }
		// no sabotage for Champions or already sabotaged buildings
		if( H7TownDwelling( playerDwellings[i].Building ).GetCreaturePool().Creature.GetTier() == CTIER_CHAMPION || H7TownDwelling( playerDwellings[i].Building ).IsSabotaged() )
		{
			playerDwellings.Remove( i, 1 );
		}
	}
	
	for( i = 0; i < targets && playerDwellings.Length > 0; ++i )
	{
		index = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( playerDwellings.Length );
		
		H7TownDwelling( playerDwellings[ index ].Building ).SetSabotaged( true );
		sabotagedDwellings.AddItem(H7TownDwelling( playerDwellings[ index ].Building));
	}

	sabotagingPlayer.GetThievesGuildManager().IncreaseRunningSabotageCount(GetID());
	
	cost.Type = sabotagingPlayer.GetResourceSet().GetCurrencyResourceType();
	cost.Quantity = class'H7AdventureController'.static.GetInstance().GetConfig().mSabotageCost;
	costs.AddItem(cost);
	sabotagingPlayer.GetResourceSet().SpendResources(costs, true, true);

	;

	if(!sabotagingPlayer.IsControlledByAI())
	{
		for(j = 0; j < sabotagedDwellings.Length; j++)
		{
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mSabotageSuccess.CreateMessageBasedOnMe();
			message.mPlayerNumber = sabotagingPlayer.GetPlayerNumber();
			message.AddRepl("%dwelling", sabotagedDwellings[j].GetName());
			message.AddRepl("%town", sabotagedDwellings[j].GetTown().GetName());
			message.AddRepl("%player", GetName());
			message.settings.referenceObject = sabotagedDwellings[j].GetTown();
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}

	if(!IsControlledByAI())
	{
		for(j = 0; j < sabotagedDwellings.Length; j++)
		{
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mSabotage.CreateMessageBasedOnMe();
			message.mPlayerNumber = GetPlayerNumber();
			message.AddRepl("%dwelling", sabotagedDwellings[j].GetName());
			message.AddRepl("%town", sabotagedDwellings[j].GetTown().GetName());
			message.AddRepl("%player", sabotagingPlayer.GetName());
			message.settings.referenceObject = sabotagedDwellings[j].GetTown();
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}
	
}

function bool CanApplySabotage()
{
	local array<H7Town> towns;

	towns = GetTowns();
	return towns.Length > 0;
}

 function ApplyPlunder( H7Player plunderingPlayer )
{
	local array<H7ResourceQuantity> costs; 
	local H7ResourceQuantity cost;
	mPlunderQueue.AddItem( plunderingPlayer );
	plunderingPlayer.GetThievesGuildManager().IncreaseRunningPlundersCount(GetID());
	
	cost.Type = plunderingPlayer.GetResourceSet().GetCurrencyResourceType();
	cost.Quantity = class'H7AdventureController'.static.GetInstance().GetConfig().mPlunderCost;
	costs.AddItem(cost);
	plunderingPlayer.GetResourceSet().SpendResources(costs, true, true);
}

function ExecutePlunder()
{
	local array<H7Mine> mines;
	local int i, targets, index;
	local H7Player plunderingPlayer;
	foreach mPlunderQueue( plunderingPlayer )
	{
		if( !CanApplyPlunder() )
		{
			return;
		}
		targets = plunderingPlayer.GetModifiedStatByID( STAT_SPY_INFILTRATION_TARGETS );
		mines = class'H7AdventureController'.static.GetInstance().GetMines();
	
		for( i = mines.Length - 1; i >= 0; --i )
		{
			if( mines[i].GetPlayer() != self || mines[i].IsPlundered() )
			{
				mines.Remove( i, 1 );
			}
		}

		for( i = 0; i < targets && mines.Length > 0; ++i )
		{
			index = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mines.Length );
			mines[ index ].PlunderFromMission( plunderingPlayer );
			
			mines.Remove( index, 1 );

			//class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("asfdasdfadsf", MD_NOTE_BAR);
		}
	}
	mPlunderQueue.Length = 0;
}

function bool CanApplyPlunder()
{
	local array<H7Mine> mines;
	local int i;

	mines = class'H7AdventureController'.static.GetInstance().GetMines();
	
	for( i = mines.Length - 1; i >= 0; --i )
	{
		if( mines[i].GetPlayerNumber() != GetPlayerNumber() )
		{
			mines.Remove( i, 1 );
		}
	}
	return mines.Length > 0;
}

// Game Object needs to know how to write its data into GFx format
function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	;
}
// WriteInto this GFxObject if DataChanged
function GUIAddListener(GFxObject data,optional H7ListenFocus focus) 
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}
// Game Object needs to know what to do when its data changes (usually they just call ListeningManager)
function DataChanged(optional String cause) 
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

// returns the H7AdventurePlayerController associated to this player, ONLY WORKS FOR THE SERVER
function H7AdventurePlayerController GetAdventurePlayerController()
{
	local H7AdventurePlayerController currentPlayerController;

	forEach WorldInfo.AllControllers( class'H7AdventurePlayerController', currentPlayerController )
	{
		if( currentPlayerController.GetPlayerReplicationInfo().GetPlayerNumber() == GetPlayerNumber() )
		{
			return currentPlayerController;
		}
	}
	;
}

native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType checkForOperation1 = -1, optional EOperationType checkForOperation2 = -1, optional bool nextRound);

function float GetModifiedStatByID(Estat desiredStat)
{
	local float statBase,statAdd,statMulti;

	statBase = GetBaseStatByID(desiredStat);
	statAdd =  GetAddBoniOnStatByID(desiredStat);
	statMulti = GetMultiBoniOnStatByID(desiredStat);

	//`log_gui("town income"@desiredStat @ "(" @ statBase @ "+" @ statAdd @ ") *" @ statMulti);
	return ( statBase + statAdd ) * statMulti;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of additive modifications, coming from abilities, buffs etc.
 */
function float GetAddBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADD);
	foreach applicableMods(currentMod)
	{
		modifierSum += currentMod.mModifierValue;
	}

	return modifierSum;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of percentages in modifications, where 50% extra means 1.5f
 */
function float GetMultiBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;	
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADDPERCENT, OP_TYPE_MULTIPLY);
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

// multiplayer - human host saves autosave when it's his turn & orders all client to make the same
// hotseat - every human player saves autosave on his turn
// singleplayer - human player saves autosave on his turn
function bool IsResponsibleForAutoSave()
{
	if(IsControlledByAI()) return false;

	if(class'H7AdventureController'.static.GetInstance().GetCurrentGameMode() == MULTIPLAYER)
	{
		return class'H7PlayerController'.static.GetPlayerController().IsServer();
	}
	else
	{
		return true;
	}
}

//Base Stats
function float GetBaseStatByID(Estat desiredStat)
{
	switch(desiredStat)
	{
		case STAT_SPY_INFILTRATION_TARGETS: 
			return 1;
	}
	return 0;
}

function bool HasTownsOfFaction(H7Faction faction)
{
	local array<H7Town> townsOnMap;
	local H7Town town;
	townsOnMap = class'H7AdventureController'.static.GetInstance().GetTownList();
	foreach townsOnMap(town)
	{
		if(town.GetPlayer() == self && town.GetFaction() == faction)
		{
			return true;
		}
	}
	return false;
}

event PostSerialize()
{
	mQuestController = new class'H7QuestController'();
	mQuestController.SetPlayer( self );
	mQuestController.Init();
	mAdventureController = class'H7AdventureController'.static.GetInstance();

	// Update loca name but only for non-human players
	InitAIPlayerName();
}

function InitAIPlayerName()
{
	local array<H7MapHeaderPlayerInfoProperty> playerList;
	local int i;

	if(mAdventureController != none && mPlayerType != PLAYER_HUMAN) 
	{
		playerList = mAdventureController.GetMapInfo().GetMapData().mPlayerInfoProperties;
		for(i = 0; i < playerList.Length; ++i)
		{
			if(mPlayerNumber == playerList[i].Position)
			{
				break;
			}
		}

		if(mPlayerNumber == PN_NEUTRAL_PLAYER)
		{
			SetName( class'H7Loca'.static.LocalizeSave("NEUTRAL_PLAYER","H7General") );
		}
		else if(class'H7Loca'.static.IsLocaParamsEmpty(playerList[i].Name))
		{
			mName = class'H7Loca'.static.LocalizePlayerName(mPlayerNumber);
		}
		else
		{
			mName = class'H7Loca'.static.LocalizeFieldParams(playerList[i].Name);
		}
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


