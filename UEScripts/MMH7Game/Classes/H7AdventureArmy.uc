//=============================================================================
// H7AdventureArmy
//=============================================================================
//
// Army used in the adventure map
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureArmy extends H7EditorArmy
 Implements(H7ITooltipable,H7IGUIListenable,H7IQuestTarget,H7IStackContainer, H7ILocaParamizable)
 placeable
 dependson(H7ITooltipable,H7IGUIListenable)
 native
 savegame
 perobjectconfig;

const HERO_FLAG_OFFSET = 550.0f;
const CREATURE_FLAG_OFFSET = 550.0f;

const NEUTRAL_ARMY_KEY = "TT_NEUTRAL_ARMY";
const NEUTRAL_ARMY_SECTION = "H7GFxActorTooltip";
const ADVENTURE_ARMY_NAME_KEY = "mName";

/** Custom name to use if this is a critter army. */
var(Naming) protected localized string mName<DisplayName="Custom Name"|EditCondition=mUseCustomName>;
/** Use custom name if this is a critter army. */
var(Naming) protected bool                      mUseCustomName<DisplayName="Use Custom Name"|EditCondition=mIsCustomNameAvailable>;
var private transient editoronly editconst bool mIsCustomNameAvailable;
var protected transient string                  mCustomNameInst;
// current grid pos on the adventure grid
var protected H7AdventureMapCell                mCell;
var protected savegame H7VisitableSite          mGarrisonedSite;
//savegame helpers
var savegame AdventureMapCellCoords             mCellCoords;
var protected savegame string                   mHeroArchetypeReference;
var protected savegame Rotator                  mSaveRotation;
var protected savegame bool                     mIsHidden;
var protected savegame SavegameHeroStruct       mHeroStruct;
var protected array<H7AdventureMapCell>         mDangerCells;
var protected savegame array<H7VisitableSite>   mReachableSites;
var protected savegame array<H7AdventureArmy>   mReachableArmies;
var protectedwrite savegame array<float>        mReachableSitesDistances;
var protectedwrite savegame array<float>        mReachableArmiesDistances;
var protected bool                              mReachabilityCheckDone;
var protected savegame H7AdventureHero	        mHero;
var protected savegame H7Ship                   mShip;
var protected savegame H7VisitableSite          mVisitableSite;
var protected H7Flag                            mFlag;
var protected savegame bool                     mIsAttacker;
var protected savegame bool                     mIsDefender;
var protected savegame bool                     mLocked;
var protected savegame bool		                mIsDead; // is a dead army that is waiting for being recruited
var protected bool                              mIsInCombat;
var protected bool                              mIsBeingRemoved;
var protected int								mNumTimesAlreadyRetreated;
var protected savegame int                      mGrowthOverwrite;
var protected savegame array<NegotiationData>   mNegotiatedArmies;
var(Growth) bool                                mSuppressCritterGrowth<DisplayName=Suppress Critter Growth>;
// Scripting
var protected H7HeroEventParam                  mHeroEventParam;
var protected H7PlayerEventParam                mPlayerEventParam;
var(Diplomacy) protected savegame EDispositionType       mDiplomaticDisposition<DisplayName=Negotiation Override>;
var(Diplomacy) protected savegame array<EPlayerNumber>   mDispositionTowardsPlayers<DisplayName=Players affected by Negotiation Override>;
var protected array<H7BaseCreatureStack>        mTempStackArray;
var protected array<H7MergePool>                mMergePools;
var protected bool                              mIsChilling;
// AI ignores this army
var(AISettings) protected bool	                mAiOnIgnore<DisplayName="Ignore">;
// Stay in Area of Control with the specified index if this army is controlled by AI
var(AISettings) protected int	                mAiStayInAoC<DisplayName="Stay in Area of Control with Index"|ClampMin=-1|ClampMax=32>;
var protected savegame array<float>             mAiTension; // tension values for individual actions
var protected savegame H7ResourceSet            mAIReplenishResouceStash;

var protected H7Flag                            mQuestFlag;

// Get / Set
// =======
function bool                       GetAiOnIgnore()                         { return mAiOnIgnore; }
function                            SetAiOnIgnore( bool val )               { mAiOnIgnore=val; }
function int                        GetAiStayInAoC()                        { return mAiStayInAoC; }
function                            SetAiStayInAoC( int val )               { mAiStayInAoC=val; }
function bool                       IsChilling()                            { return mIsChilling; }
function                            SetChilling( bool val )                 { mIsChilling=val; }

function H7ResourceSet              GetAIReplenishStash()                   
{ 
	if( mAIReplenishResouceStash == none )
	{
		ResetAIReplenishStash();
	}
	return mAIReplenishResouceStash; 
}
function                            ResetAIReplenishStash()                 
{ 
	local array<ResourceStockpile> resources;
	local ResourceStockpile resource;
	local int resCounter;

	mAIReplenishResouceStash = new class'H7ResourceSet'( GetPlayer().GetResourceSet() ); 
	mAIReplenishResouceStash.SetPlayer( GetPlayer() );
	resources = mAIReplenishResouceStash.GetAllResourcesAsArray();
	foreach resources( resource, resCounter )
	{
		mAIReplenishResouceStash.ClearIncome(resource.Type);
		mAIReplenishResouceStash.ClearQuantity(resource.Type);
	}
	mAIReplenishResouceStash.SetCurrencySilent(0);
}

function float GetAiTensionValue( EAdvActionID aid )
{
	local int k;
	if(mAiTension.Length<=aid)
	{
		for(k=mAiTension.Length;k<=__AID_MAX;k++)
		{
			mAiTension.AddItem(1.0f);
		}
	}
	
	return mAiTension[aid];
}

function ModAiTensionValue( EAdvActionID aid, H7AiTensionParameter tp )
{
	if( mAiTension.Length <= aid ) return;
	mAiTension[aid] = mAiTension[aid] + tp.Gain;
	if( mAiTension[aid] < tp.Base )
	{
		mAiTension[aid] = tp.Base;
	}
	if( mAiTension[aid] > tp.Cap )
	{
		mAiTension[aid] = tp.Cap;
	}
}

function SetAiTensionValue( EAdvActionID aid, float val )
{
	local int k;
	if( mAiTension.Length<=aid)
	{
		for(k=mAiTension.Length;k<=__AID_MAX;k++)
		{
			mAiTension.AddItem(1.0f);
		}
	}
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	mAiTension[aid] = val;
}

function							IncNumTimesAlreadyRetreated()	            { ++mNumTimesAlreadyRetreated; }
function							ResetNumTimesAlreadyRetreated()	            { mNumTimesAlreadyRetreated = 0; }

function SetPlayer(H7Player newPlayer)
{
	mPlayer = newPlayer;
	mPlayerNumber = newPlayer.GetPlayerNumber();

	if(mHero != none && mHero.GetPlayer().GetPlayerNumber() != newPlayer.GetPlayerNumber() )
	{
		mHero.SetPlayer(newPlayer);
	}
}

function String GetName()
{
	LocalizeName();
	return mCustomNameInst;
}

function LocalizeName()
{
	if(mCustomNameInst == "")
	{
		if(mUseCustomName)
		{
			mCustomNameInst = class'H7Loca'.static.LocalizeMapObject(self, ADVENTURE_ARMY_NAME_KEY, mName);
		}
		else
		{
			if(H7CaravanArmy(self) != none)
			{
				mCustomNameInst = class'H7Loca'.static.LocalizeSave("TT_CARAVAN_ARMY",NEUTRAL_ARMY_SECTION);
			}
			else
			{
				mCustomNameInst = class'H7Loca'.static.LocalizeSave(NEUTRAL_ARMY_KEY,NEUTRAL_ARMY_SECTION);
			}
		}
	}
}

function array<H7VisitableSite> GetReachableSites() { return mReachableSites; }
function array<H7AdventureArmy> GetReachableArmies() { return mReachableArmies; }

function SetReachableSites( array<H7VisitableSite> sites ) { mReachableSites = sites; }
function SetReachableArmies( array<H7AdventureArmy> armies ) { mReachableArmies = armies; }

function array<float> GetReachableSitesDistances() { return mReachableSitesDistances; }
function array<float> GetReachableArmiesDistances() { return mReachableArmiesDistances; }

function SetReachableSitesDistances( array<float> sites ) { mReachableSitesDistances = sites; }
function SetReachableArmiesDistances( array<float> armies ) { mReachableArmiesDistances = armies; }

function H7VisitableSite GetVisitableSite()                         { return mVisitableSite; }
function                 SetVisitableSite( H7VisitableSite site )   { mVisitableSite = site; }

function bool       IsBeingRemoved()                { return mIsBeingRemoved; }
function            SetIsBeingRemoved( bool value ) { mIsBeingRemoved = value; }

function bool       IsAttacker()                { return mIsAttacker; }
function            SetIsAttacker( bool value ) { mIsAttacker = value; }

function bool       IsDefender()                { return mIsDefender; }
function            SetIsDefender( bool value ) { mIsDefender = value; }

function bool       IsInCombat()                { return mIsInCombat; }
function            SetIsInCombat( bool value ) { mIsInCombat = value; }

function bool       IsInShelter()               { return H7Shelter( mVisitableSite ) != none; }

function String GetGarrisonedSiteIconPath()
{
	if(H7Garrison(mGarrisonedSite) != none)
	{
		return H7Garrison(mGarrisonedSite).GetIconPath();
	}
	else if(H7AreaOfControlSiteLord(mGarrisonedSite) != none)
	{
		return H7AreaOfControlSiteLord(mGarrisonedSite).GetIconPath();
	}
	return "no_garrison_icon";
	// OPTIONAL shelter stuff
}

function H7VisitableSite        GetGarrisonedSite()                         
{ 
	if( H7Town( mVisitableSite ) != none && !H7Town( mVisitableSite ).GetGarrisonArmy().HasUnits( true ) && !H7Town( mVisitableSite ).GetGarrisonArmy().GetHero().IsHero() )
	{
		return mVisitableSite;
	}
	return mGarrisonedSite; 
}
function                        SetGarrisonedSite( H7VisitableSite value )  
{ 
	mGarrisonedSite = value;

	if( value != none )
	{
		HideArmy();
	}
	if(GetHero() != none && GetHero().IsHero())
	{	
		GetHero().DataChanged();
	}
}

native function bool       IsGarrisoned();

function TransferItems( H7AdventureArmy receivingArmy )
{
	local array<H7HeroItem> transferItems;
	local H7HeroItem item;
	local int i;
	local H7HeroItem tearTemplate;
	local H7EventContainerStruct eventContainer;

	tearTemplate = class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate;

	transferItems = GetHero().GetInventory().GetItems();
	;
	i = 0;
	foreach transferItems( item, i )
	{
		;

		eventContainer.EffectContainer = item;
		eventContainer.Targetable = GetHero();

		GetHero().GetInventory().RemoveItemComplete( item );

		item.TriggerEvents(ON_LOSE_ITEM, false, eventContainer);

		receivingArmy.GetHero().GetInventory().AddItemToInventoryComplete( item );

		eventContainer.Targetable = none;
		GetHero().TriggerEvents(ON_LOSE_ITEM, false, eventContainer);
		receivingArmy.GetHero().TriggerEvents(ON_RECEIVE_ITEM, false, eventContainer);
		eventContainer.Targetable = receivingArmy.GetHero();
		item.TriggerEvents(ON_RECEIVE_ITEM, false, eventContainer);
		if( item.IsEqual( tearTemplate ) )
		{
			GetHero().SetHasTearOfAsha( false );
			receivingArmy.GetHero().SetHasTearOfAsha( true );
		}
	}
	GetHero().GetEquipment().GetItemsAsArray( transferItems );
	foreach transferItems( item )
	{
		eventContainer.EffectContainer = item;
		eventContainer.Targetable = GetHero();

		GetHero().GetEquipment().RemoveItemComplete( item );
		
		item.TriggerEvents(ON_LOSE_ITEM, false, eventContainer);

		receivingArmy.GetHero().GetInventory().AddItemToInventoryComplete( item );
		
		eventContainer.Targetable = none;
		GetHero().TriggerEvents(ON_LOSE_ITEM, false, eventContainer);
		receivingArmy.GetHero().TriggerEvents(ON_RECEIVE_ITEM, false, eventContainer);
		eventContainer.Targetable = receivingArmy.GetHero();
		item.TriggerEvents(ON_RECEIVE_ITEM, false, eventContainer);
		if( item.IsEqual( tearTemplate ) )
		{
			GetHero().SetHasTearOfAsha( false );
			receivingArmy.GetHero().SetHasTearOfAsha( true );
		}
	}
}

// when a town has no garrison and is attacked, the visiting army counts as GarrisonedButOutside
function bool       IsGarrisonedButOutside()              
{ 
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local bool unitsPresent;
	if( H7Town( mVisitableSite ) != none )
	{
		stacks = H7Town( mVisitableSite ).GetGarrisonArmy().GetBaseCreatureStacks();
	}
	foreach stacks( stack )
	{
		unitsPresent = stack.GetStackSize() > 0;
		if( unitsPresent ) { break; }
	}
	if( H7Town( mVisitableSite ) != none && !unitsPresent && !H7Town( mVisitableSite ).GetGarrisonArmy().GetHero().IsHero() )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function bool HasLocalGuardBacking()
{
	local H7Town town;

	if(IsGarrisoned())
	{
		town = H7Town(mGarrisonedSite);

		if(town != none)
		{
			return town.GetLocalGuardAsBaseCreatureStacks().Length > 0;
		}
	}

	if(IsGarrisonedButOutside())
	{
		town = H7Town(mVisitableSite);

		if(town != none)
		{
			return town.GetLocalGuardAsBaseCreatureStacks().Length > 0;
		}
	}

	return false;
}

function UnGarrison()
{
	if(mGarrisonedSite == none) { ; }
	
	if(H7AreaOfControlSiteLord(mGarrisonedSite) != none)
	{
		H7AreaOfControlSiteLord(mGarrisonedSite).TransferHero(ARMY_NUMBER_GARRISON,ARMY_NUMBER_VISIT);
	}
	else if(H7Garrison(mGarrisonedSite) != none)
	{
		H7Garrison(mGarrisonedSite).TransferHero(ARMY_NUMBER_GARRISON,ARMY_NUMBER_VISIT);
	}
	else if( H7Shelter(mGarrisonedSite) != none )
	{
		H7Shelter(mGarrisonedSite).ExpelArmy();
	}
	else
	{
		 ;
	}

}

function H7Ship     GetShip()                   { return mShip; }
function bool       HasShip()                   { return mShip != none; }
function            SetShip( H7Ship shippity )  
{ 
	if(mShip != none)
	{
		mShip.SetArmy(none);
	}
	if(shippity != none) 
	{
		shippity.SetArmy(self);
	}

	mShip = shippity; 
	mShip.SetPlayer(GetPlayer());
}

function bool       IsLocked()                  { return mLocked; }
function            SetArmyLocked( bool value ) { mLocked = value; }

function H7AdventureMapCell	GetCell() { return mCell; }

function H7Flag          GetFlag() { return mFlag; }
function H7AdventureHero GetHero() { return mHero; }

function bool       IsDead()					{ return mIsDead; }
event bool       IsACaravan()                { return false; }

function H7EditorHero GetEditorHero() { return mHero; }

// Implementation of H7IQuestTarget
function int                GetQuestTargetID()   { return mHero.GetID(); }
function H7AdventureMapCell GetCurrentPosition() { return mCell; }
function bool               IsHidden()           { return bHidden;   }
function bool               IsMovable()          { return true; }

function SetDiplomaticDisposition(EDispositionType value)               { mDiplomaticDisposition = value; }
function EDispositionType GetDiplomaticDisposition()                    { return mDiplomaticDisposition; }

function ClearNegotiationData()                                         { mNegotiatedArmies.Length = 0; }
function AddNegotiatedArmy( NegotiationData data )                      { mNegotiatedArmies.AddItem( data ); }
function bool HasNegotiatedWith( H7AdventureArmy army, out int lastNegotiationResult )
{
	local bool hasNegotiated;
	local int index;
	index = mNegotiatedArmies.Find( 'Army', army );
	hasNegotiated = index != INDEX_NONE;
	if( hasNegotiated )
	{
		lastNegotiationResult = mNegotiatedArmies[ index ].NegotiationResult;
	}
	return hasNegotiated;
}

function GetPlayerDispositions( out array<EPlayerNumber> playerDisposition )                   
{
	playerDisposition = mDispositionTowardsPlayers;
}

function bool IsInScoutingRangeOfLocalPlayer()
{
	local H7Player me;
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;
	local array<IntPoint> points;

	me = class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetAdventureController().GetLocalPlayer();
	heroes = me.GetHeroes();

	foreach heroes(hero)
	{
		if(!hero.CanScout()) { continue; }

		class'H7Math'.static.GetMidPointCirclePoints( points, hero.GetAdventureArmy().GetCell().GetCellPosition(), hero.GetScoutingRadius());
		if(class'H7GameUtility'.static.CellsContainIntPoint( points, GetCell().GetCellPosition() ))
		{
			return true;
		}
	}

	return false;
}

event Init( H7Player playerOwner, optional H7AdventureMapCell startPos, optional Vector garrisonLocation, optional bool pruneStacks = true )
{
	local H7Creature creature;
	local H7Ship ship;

	if( playerOwner.GetStatus() == PLAYERSTATUS_UNUSED && !playerOwner.IsNeutralPlayer() && !IsGarrisoned() )
	{
		class'H7AdventureController'.static.GetInstance().RemoveArmy( self );
		Destroy();
		return;
	}
	super.Init( playerOwner, startPos, garrisonLocation, pruneStacks );

	// play special sound for the neutral armies
	if( !IsACaravan() && !GetHero().IsHero() && !IsDead() && GetPlayerNumber() == PN_NEUTRAL_PLAYER )
	{
		creature = GetStrongestCreature();
		if( creature != none )
		{
			creature.PlayAdventureMapIdleSound( self );
		}
	}

	if( IsDead() )
	{
		HideArmy();
	}

	if( mGarrisonedSite != none )
	{
		if( H7AreaOfControlSiteLord( mGarrisonedSite ) != none )
		{
			mGarrisonedSite.OnVisit( mHero );
			H7AreaOfControlSiteLord( mGarrisonedSite ).TransferHeroComplete( ARMY_NUMBER_VISIT, ARMY_NUMBER_GARRISON );
		}
	}

	if( mCell != none )
	{
		if( mCell.mMovementType == MOVTYPE_WATER )
		{
			if( mHero.IsHero() && H7Ship( mCell.GetVisitableSite() ) == none )
			{
				ship = spawn(class'H7Ship',,, mCell.GetLocation(),,class'H7AdventureController'.static.GetInstance().GetConfig().mShip );
				mCell.RegisterShip( ship );
				SetCell( mCell, true, true, true );
			}
		}
	}

	mHeroEventParam = new class'H7HeroEventParam';
	mPlayerEventParam = new class'H7PlayerEventParam';

	mDeployment = new class 'H7Deployment';
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Role=ROLE_Authority;

	EnableAdventureIdleBridge();
}

function int GetAreaOfControlID()
{
	if(mCell != None) {
		return mCell.GetAreaOfControl();
	}
	return 0;

}

function array<H7ResourceQuantity> GetArmyCost( float mod )
{
	local CreatureStackProperties stackProps;
	local array<H7ResourceQuantity> armyCost;
	local H7BaseCreatureStack stack;
	local int i;
	
	if( mBaseCreatureStacks.Length != 0 ) 
	{
		foreach mBaseCreatureStacks(stack)
		{
			class'H7GameUtility'.static.CalculateCreatureCosts( stack.GetStackType(), stack.GetStackSize(), armyCost );
		}
	}
	else
	{
		foreach mCreatureStackProperties( stackProps )
		{
			class'H7GameUtility'.static.CalculateCreatureCosts( stackProps.Creature, stackProps.Size, armyCost );
		}
	}
	
	for( i = 0; i < armyCost.Length; ++i )
	{
		armyCost[i].Quantity = FCeil( armyCost[i].Quantity * mod );
	}
	return armyCost;
}

native function ShowArmy();

native function HideArmy( optional bool noHero );

native function SwitchToBoatVisuals();

// sets the focus of the camera if an enemy unit shows itself outside the FOW and clears the focus if the unit disappears in the FOW again.
event UpdateArmyCameraFocus()
{
	local H7Camera cam;

	cam = class'H7Camera'.static.GetInstance();
	if(GetHero().IsMoving() && cam.GetCurrentFocusActor() != GetHero())
	{
		cam.SetFocusActor(GetHero(), GetPlayerNumber(), true, false, true);
	}
}

function ClearQuestFlag()
{
	if( mQuestFlag != none )
	{
		mQuestFlag.Destroy();
		mQuestFlag = none;
	}
}

function AddQuestFlag()
{
	local Vector flagLocation;

	if( mIsNPC )
	{
		return;
	}

	// creating the flag
	if( mQuestFlag == none )
	{
		mQuestFlag = Spawn( class'H7Flag', GetFlag() );
	}
	mQuestFlag.SetScale( 5.0f );
	mQuestFlag.SetColor( class'H7AdventureController'.static.GetInstance().GetNeutralPlayer().GetColor() );
	mQuestFlag.SetBase( GetFlag() );
	flagLocation.Y += 50;
	
	mQuestFlag.InitAsQuestTargetFlag();
	mQuestFlag.SetMainFlag( false );

	mQuestFlag.InitLocation( flagLocation );
}

function ToggleVisibility()
{
	SetVisibility(bHidden);
}

function SetVisibility(bool show)
{
	if(show)
	{
		ShowArmy();
	}
	else
	{
		HideArmy();
	}
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

// methods
// =======
function CreateHero( optional SavegameHeroStruct saveGameData )
{
	if( mHeroArchetype != none )
	{
	
		mHero = H7AdventureHero( mHeroArchetype.CreateHero( self,, Location, true,, saveGameData.HasData, mHero ) );

		// deserialize the data after the creation of the hero
		if( saveGameData.HasData )
		{
			mHero.RestoreState( saveGameData );
			SetIsDead( mIsDead ); // update the dead state
		}
	}
	else
	{
		;
	}

	// re-attach the weapon mesh cause it will fail for non-editor-placed armies
	SkeletalMeshComponent.AttachComponentToSocket(mWeaponMesh, 'Weapon_Socket');
}

function PostCreateHero()
{
	local H7AdventureController advCntl;

	advCntl = class'H7AdventureController'.static.GetInstance();
	if( !mIsDead )
	{
		advCntl.AddArmy( self );
	}
	
	mHero.SetPlayer( GetPlayer() );
}

/**
 * Spawn the faction flag on hero position
 * 
 * */
function SpawnHeroFlag()
{
	// creating the flag
	if( mFlag == none )
	{
		mFlag = Spawn( class'H7Flag', self );
	}
	
	mFlag.SetScale( 5.0f );
	mFlag.SetBase( mHero );
	mFlag.SetMainFlag( true );

	mFlag.InitLocation( GetHeroFlagLocation() );
	
	if( IsNPC() )
	{
		mFlag.InitAsNPCFlag();
	}
	else
	{
		mFlag.SetFaction( mHero.GetFaction() );
	}
	mFlag.SetColor( GetPlayer().GetColor() );
	mFlag.SetHidden( bHidden );
}

event Vector GetHeroFlagLocation()
{
	if( mHero.IsHero() )
	{
		return mHero.GetRelativeHeightPos( HERO_FLAG_OFFSET );
	}
	else
	{
		if(GetStrongestCreature() != none)
		{
			return Vect( 0.f, 0.f, 1.f ) * (SkeletalMeshComponent.SkeletalMesh.Bounds.BoxExtent.Z + CREATURE_FLAG_OFFSET) * SkeletalMeshComponent.Scale * SkeletalMeshComponent.Scale3D.Z;
		}
		else
		{
			return vect( 0,0,0 );
		}
	}
}

function ChangeFlag()
{
	if( mFlag != none )
	{
		mFlag.ShowAnim();
		mFlag.SetFaction( mHero.GetFaction() );
		mFlag.SetColor( GetPlayer().GetColor() );
	}
}

function SetNPC(bool isNPC) 
{ 
	super.SetNPC( isNPC );
	SpawnHeroFlag();
}


function Select( bool doSelect, optional bool doFocus )
{
	mHero.Select( doSelect, doFocus );
}

function SetHoverHighlight(bool active)
{
	if( mHero != none && mShip == none )
	{
		//mHero.SetHoverHighlight(active);
	}
	else
	{
		// TODO how to hightlight armies without hero?
	}
}

/**
 * Handles the scouting by calculating the tiles around the
 * position of the army, based on the given radius which by
 * default should be the hero scouting skill. 
 * 
 * @param       r           The radius
 * 
 **/
event HandleScouting( optional int r = -1, optional H7AdventureMapCell cell, optional bool isInit = false )
{
	local array<EPlayerNumber> allies;
	local array<H7Player> players;
	local array<IntPoint> visiblePoints;
	local H7FOWController fogController;
	local H7AdventureMapGridController gridController;
	local int i;

	if( r == -1 )
	{
		mHero.GetScoutingRadius();
	}
	if( cell == none )
	{
		cell = mCell;
	}

	if( cell != none && mPlayerNumber != PN_NEUTRAL_PLAYER )
	{
		gridController = cell.GetGridOwner();
		fogController = gridController.GetFOWController();
	
		if( fogController != none )
		{
			class'H7Math'.static.GetMidPointCirclePoints( visiblePoints, cell.GetCellPosition(), r );

			if( GetHero().HasTearOfAsha() )
			{
				players = class'H7AdventureController'.static.GetInstance().GetPlayers();
				for( i = 0; i < players.Length; ++i )
				{
					if( players[i].GetPlayerNumber() != PN_NEUTRAL_PLAYER )
					{
						fogController.HandleExploredTiles( players[i].GetPlayerNumber(), visiblePoints, isInit );
					}
				}
			}   
			else
			{
				class'H7TeamManager'.static.GetInstance().GetAllAlliesAndSpectatorNumbers( mPlayerNumber, allies ); // share FoW with allied players
				allies.AddItem( mPlayerNumber );
				for( i = 0; i < allies.Length; ++i )
				{
					fogController.HandleExploredTiles( allies[i], visiblePoints, isInit );
				}
			}
		}
	}
}

// if you set the cell to none, be sure it does not cause other code to put warnings
// in general it is only allowed to set it to none for dead armies
function SetCell( H7AdventureMapCell newCellPos, optional bool updateHeroWorldLocation = true, optional bool registerCell = true, optional bool isInit = false )
{
	local H7AdventureMapCell oldCellPos;
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;
	local H7FOWController fogController;
	local H7EventContainerStruct container;
	local array<H7Player> players; local H7Player player;

	if( mIsDead )
	{
		ScriptTrace();
		;
		return;
	}
	if( mCell != none ) // I have old position I need to unregister myself from
	{
		mCell.UnregisterArmy( self, newCellPos );
	}
	if( newCellPos == none )
	{
		; // what about a town,fort or garrison?
	}

	if(newCellPos != none)
	{
		if( mCell != none )
		{
			if( mCell.GetVisitableSite() != none && mCell.GetVisitableSite().GetVisitingArmy() == self )
			{
				mCell.GetVisitableSite().SetVisitingArmy( none );
				mVisitableSite = none;
			}
		}

		if( newCellPos.GetVisitableSite() != none && newCellPos.GetVisitableSite().GetEntranceCell() == newCellPos && newCellPos.GetVisitableSite().GetPlayer() == GetPlayer() )
		{
			if( H7AreaOfControlSite( newCellPos.GetVisitableSite() ) != none && H7AreaOfControlSite( newCellPos.GetVisitableSite() ).GetGarrisonArmy() != self )
			{
				newCellPos.GetVisitableSite().SetVisitingArmy( self );
				mVisitableSite = newCellPos.GetVisitableSite();
			}
		}

		// Check if we have a ship..
		if( mShip != none)
		{
			// If we cross from water to land, leave the ship behind, else, move the ship?
			if( mCell.mMovementType == MOVTYPE_WATER && newCellPos.mMovementType != MOVTYPE_WATER )
			{
				hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
				hero.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_BOARDING_SHIP);

				if(hero != none)
				{
					hero.TriggerEvents(ON_DISEMBARK, false);
				}

				mShip.SetArmy(none);
				mShip = none;
				ShowArmy();

				if(mHeroEventParam != none)
				{
					mHeroEventParam.mEventHeroTemplate = GetHeroTemplateSource();
					mHeroEventParam.mEventPlayerNumber = mPlayerNumber;
					mHeroEventParam.mEventSite = mShip;
					mHeroEventParam.mShipInteraction = SI_DISEMBARK;
					class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_EnterLeaveShip', mHeroEventParam, self);
				}
			}
			else
			{
				mCell.UnregisterShip( mShip );
				newCellPos.RegisterShip( mShip );
				if(updateHeroWorldLocation)
				{
					mShip.SetLocation( newCellPos.GetLocation() );
				}

				if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None)
				{
					class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().ShipMoved( mShip );
				} 
			}
		}
		// Grab a ship if possible
		else if( newCellPos.GetShip() != none )
		{
			hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
			hero.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_BOARDING_SHIP);
			
			if(hero != none)
			{
				hero.TriggerEvents(ON_EMBARK, false, container);
			}

			SetShip( newCellPos.GetShip() );
			SetRotation( mShip.Rotation );
			mHero.SetRotation( mShip.Rotation );
			SwitchToBoatVisuals();

			if(mHeroEventParam != none)
			{
				mHeroEventParam.mEventHeroTemplate = GetHeroTemplateSource();
				mHeroEventParam.mEventPlayerNumber = mPlayerNumber;
				mHeroEventParam.mEventSite = mShip;
				mHeroEventParam.mShipInteraction = SI_BOARD;
				class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_EnterLeaveShip', mHeroEventParam, self);
			}
		}

		if(mHeroEventParam != none)
		{
			mHeroEventParam.mEventHeroTemplate = GetHeroTemplateSource();
			mHeroEventParam.mEventPlayerNumber = mPlayerNumber;
			mHeroEventParam.mEventMovementPoints = GetHero().GetCurrentMovementPoints();
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_HasMoved', mHeroEventParam, self);
		}
	}

	oldCellPos = mCell;
	mCell = newCellPos;

	if( newCellPos == none )
	{
		return;
	}
	if( registerCell )
	{
		if( mCell.GetArmy() == none || !mCell.GetArmy().IsAllyOf( GetPlayer() ) )
		{
			mCell.RegisterArmy( self );
		}
	}
	
	// Every time one army's position changes, redo the scouting for all heroes of the player whos hero moved
	if( mPlayerNumber != PN_NEUTRAL_PLAYER )
	{
		heroes = self.GetPlayer().GetHeroes();
		fogController = mCell.GetGridOwner().GetFOWController();
		if( fogController != none )
		{
			foreach heroes( hero )
			{
				// No need to include other grids than the one currently being stood on by this army
				if( hero.GetAdventureArmy().GetCell() != none && hero.GetAdventureArmy().GetCell().GetGridOwner() == mCell.GetGridOwner() )
				{
					hero.GetAdventureArmy().HandleScouting( hero.GetScoutingRadius(), , isInit );
				}
			}
			if( mPlayer.GetTeamNumber() == class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetTeamNumber() &&
				mCell.GetGridOwner() == class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid() )
			{
				fogController.ExploreFog();
			}
			else if( mPlayer.GetTeamNumber() != class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetTeamNumber() )
			{
				fogController.UpdateFogVisibility();
			}
		}
	}
	if( mHero != None )
	{		
		if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None)
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().HeroMoved( mHero );
		} 
		if(updateHeroWorldLocation)
		{
			mHero.SetLocation( newCellPos.GetLocation() );
		}
		if( class'H7AdventureController'.static.GetInstance().IsArmyOnMap( self ) )
		{
			mHero.UpdateSelectionFX();
		}
	}
	else
	{
		if( !IsACaravan() )
		{
			;
		}
	}

	//check if the army enters any other player's vision
	if( fogController != none )
	{
		players = class'H7AdventureController'.static.GetInstance().GetPlayers();
		foreach players( player )
		{
			//check for any active player that is not the owning player or the neutral player
			if( player.GetPlayerNumber() != PN_NEUTRAL_PLAYER && player != self.GetPlayer() && oldCellPos!=None )
			{
				if ( fogController.CheckExploredTile(player.GetPlayerNumber(), oldCellPos.GetCellPosition()) == false
					&& newCellPos != none && fogController.CheckExploredTile(player.GetPlayerNumber(), newCellPos.GetCellPosition()) == true )
				{
					mPlayerEventParam.mEventPlayerNumber = player.GetPlayerNumber();
					mPlayerEventParam.mGridIndex = fogController.GetGridIndex();
					mPlayerEventParam.mGridCoordinates.Length = 0;
					mPlayerEventParam.mGridCoordinates.AddItem(newCellPos);
					class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerGetsVisibilityOfArmy', mPlayerEventParam, self);
				}
			}
		}
	}

	if( oldCellPos != none && newCellPos != none && oldCellPos.GetGridOwner() != newCellPos.GetGridOwner() )
	{
		oldCellPos.GetGridOwner().GetAuraManager().UpdateAuras( false, oldCellPos.GetAuras(), newCellPos, oldCellPos, GetHero() );
		newCellPos.GetGridOwner().GetAuraManager().UpdateAuras( false, newCellPos.GetAuras(), newCellPos, oldCellPos, GetHero() );
	}
	else if( newCellPos != none )
	{
		newCellPos.GetGridOwner().GetAuraManager().UpdateAuras( false, newCellPos.GetAuras(), newCellPos, oldCellPos, GetHero() );
	}
	else if( oldCellPos != none )
	{
		oldCellPos.GetGridOwner().GetAuraManager().UpdateAuras( false, oldCellPos.GetAuras(), newCellPos, oldCellPos, GetHero() );
	}

	if(GetHero().GetHeroFX() != none)
	{
		if( IsGarrisoned() )
		{
			GetHero().GetHeroFX().HideFX();
		}
		else
		{
			GetHero().GetHeroFX().ShowFX();
		}
	}
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	local array<Object> objVars;
	local int idx;
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell pointingCell;
	local Actor tempActor;
	local Vector vec;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	// find the first supplied actor
	Action.GetObjectVars(objVars,"Destination");
	for (idx = 0; idx < objVars.Length; idx++)
	{
		tempActor = Actor(objVars[idx]);
		if( tempActor == None )
		{
			continue;
		}

		vec = tempActor.Location;
	}

	pointingCell = gridManager.GetCellByWorldLocation( vec );
	
	if( pointingCell != none )
	{
		if( !pointingCell.IsBlocked() )
		{
			GetHero().StopMoving();
			SetCell( pointingCell, , , true /* supress PlayerGetsVisibility triggers */ );
			if (self == class'H7AdventureController'.static.GetInstance().GetSelectedArmy())
			{
				class'H7Camera'.static.GetInstance().SetFocusActor( GetHero(), GetPlayerNumber(), true );
				gridManager.GetPathPreviewer().HidePreview();
			}
			gridManager.SetTeleportPhase( false );
		}
	}
}

function OnMoveTo(H7AdventureMapCell target, bool useMovementPoints, bool teleport, bool moveNear, bool camFollow)
{
	local H7AdventureMapCell start;
	local H7AdventureGridManager gridManager;
	local H7AdventureHero hero;
	local array<H7AdventureMapCell> path;
	local int numOfWalkableCells;
	local H7CommandQueue commandQueue;
	local H7Garrison garrison;
	local H7AreaOfControlSiteLord lord;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();


	hero = GetHero();

	if(useMovementPoints)
	{
		hero.SetScriptedBehaviour(ESB_ScriptedUseResources);
	}
	else
	{
		hero.SetScriptedBehaviour(ESB_Scripted);
	}

	if( IsGarrisoned() )
	{
		lord = H7AreaOfControlSiteLord( mGarrisonedSite );
		garrison = H7Garrison( mGarrisonedSite );
		if( lord != none )
		{
			lord.TransferHero( ARMY_NUMBER_GARRISON, ARMY_NUMBER_VISIT );
		}
		if( garrison != none )
		{
			garrison.TransferHero( ARMY_NUMBER_GARRISON, ARMY_NUMBER_VISIT );
		}
	}
	
	start = hero.GetCell();

	if( target == none )
	{
		target = start;
	}

	//TODO: teleport should use unit command.
	if (teleport)
	{
		hero.StopMoving();
		SetCell(target);
		gridManager.SetTeleportPhase( false );
		hero.ClearScriptedBehaviour();
	}
	else
	{
		path = gridManager.GetPathfinder().GetPath(start, target, hero.GetPlayer(), HasShip(), true);
		if(useMovementPoints)
		{
			gridManager.GetPathfinder().GetPathCosts(path, start, hero.GetCurrentMovementPoints(), numOfWalkableCells);
			path.Remove(numOfWalkableCells, path.Length - numOfWalkableCells);
		}

		if(moveNear)
		{
			path.Remove(path.Length - 1, 1);
		}

		if(path.Length == 0)
		{
			hero.ClearScriptedBehaviour();
		}
		else
		{
			hero.SetCurrentPath(path);
			commandQueue = class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue();
			if(camFollow)
			{
				commandQueue.Enqueue(class'H7Command'.static.CreateCommand(hero, UC_MOVE,,,,hero.GetCurrentPath()));
			}
			else
			{
				commandQueue.Enqueue(class'H7Command'.static.CreateCommand(hero, UC_MOVE, ACTION_MOVE_NO_FOLLOW,,,hero.GetCurrentPath()));
			}
			gridManager.GetPathPreviewer().HidePreview();
		}
	}
}

// currently selected army is leaving... a town?
// - this code seems old and weird, OPTIONAL consider refactor
function HandleVisitSlotLeaving()
{
	local H7VisitableSite site;
	
	site = GetVisitableSite();
	SetVisitableSite( none );

	if( site != none && site.GetVisitingArmy() == self )
	{
		site.SetVisitingArmy( none );
		;
	}

	// find town actor
	;
}

function OnMoveToTile(H7SeqAct_MoveToTile action)
{
	OnMoveTo(action.GetTargetCell(), action.IsUsingMovementPoints(), action.IsTeleporting(), action.IsMovingNearTarget(), action.IsCamFollowing());
}

function OnMoveToArmy(H7SeqAct_MoveToArmy action)
{
	OnMoveTo(action.GetTargetCell(), action.IsUsingMovementPoints(), action.IsTeleporting(), action.IsMovingNearTarget(), action.IsCamFollowing());
}

function OnMoveToBuilding(H7SeqAct_MoveToBuilding action)
{
	OnMoveTo(action.GetTargetCell(), action.IsUsingMovementPoints(), action.IsTeleporting(), action.IsMovingNearTarget(), action.IsCamFollowing());
}

function OnAttackArmy(H7SeqAct_AttackArmy action)
{
	local H7AdventureHero hero;
	local H7AdventureArmy defendingArmy;

	hero = GetHero();
	defendingArmy = action.GetDefendingArmy();

	if(defendingArmy == none || defendingArmy.IsNPC() || hero.GetPlayer() == defendingArmy.GetPlayer() || 
		hero.GetPlayer().IsPlayerAllied( defendingArmy.GetPlayer()))
	{
		// Nothing to attack here
		hero.ClearScriptedBehaviour();
		return;
	}

	hero.SetScriptedBehaviour(ESB_Scripted);

	// MEET
	class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().Enqueue(class'H7Command'.static.CreateCommand(hero, UC_MEET,,, defendingArmy.GetHero()));
}

function OnInteractWithBuilding(H7SeqAct_InteractWithBuilding action)
{
	local H7AdventureHero hero;
	local H7VisitableSite site;

	hero = GetHero();
	site = action.GetSite();

	if(site == none )
	{
		// Nothing to do here
		hero.ClearScriptedBehaviour();
		return;
	}

	hero.SetScriptedBehaviour(ESB_Scripted);

	// VISIT
	class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().Enqueue(class'H7Command'.static.CreateCommand(hero, UC_VISIT,,, site));
}

function OnInterruptAction(H7SeqAct_InterruptAction action)
{
	EnqueueInterruptCommand();
}

function OnStartNpcScene(H7SeqAct_StartNpcScene action)
{
	EnqueueInterruptCommand();
}

function OnRotateArmy(H7SeqAct_RotateArmy action)
{
	local H7AdventureGridManager gridManager;
	local H7AdventureHero hero;
	local H7CommandQueue commandQueue;
	local H7Command rotateCommand;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	hero = GetHero();

	if (action.IsInstant())
	{
		hero.SetRotation(action.GetTargetRotation());
		hero.ClearScriptedBehaviour();
	}
	else
	{
		commandQueue = class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue();
		rotateCommand = class'H7Command'.static.CreateCommand(GetHero(), UC_MOVE, ACTION_MOVE_ROTATE,,,,,,,,action.GetTargetRotation().Yaw);
		commandQueue.Enqueue(rotateCommand);
		gridManager.GetPathPreviewer().HidePreview();
	}
}

function EnqueueInterruptCommand()
{
	local H7CommandQueue queue;
	local H7Command interrupt;

	queue = class'H7AdventureController'.static.GetInstance().GetCommandQueue();
	if(queue.IsCommandRunningForCaster(mHero))
	{
		interrupt = class'H7Command'.static.CreateCommand(mHero, UC_ABILITY, ACTION_INTERRUPT,, mHero,,,,, true);
		queue.Enqueue(interrupt);
	}
	else
	{
		mHero.ClearScriptedBehaviour();
	}
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		SetHidden(True);
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		SetHidden(False);
	}
	else
	{
		SetHidden(!bHidden);
	}
}

native function bool HasUnits( optional bool excludeLocalGuard );

function GrowCritterArmy()
{
	local H7BaseCreatureStack currentStack;
	local float growth, growthRate, growthBase;
	local H7AdventureController advCntl;
	
	if( GetHero().IsHero() || mGarrisonedSite != none || mSuppressCritterGrowth ) { return; }
	advCntl = class'H7AdventureController'.static.GetInstance();
	foreach mBaseCreatureStacks( currentStack )
	{
		;
		;

		growthRate = mGrowthOverwrite == INDEX_NONE ? currentStack.GetStackType().GetWeeklyGrowthRate() : mGrowthOverwrite;
		growthRate /= 100.f;
		growthBase = currentStack.GetStackSizeAtMapStart();
		growth = growthBase * 0.3f * growthRate * advCntl.mDifficultyCritterGrowthRateMultiplier;
		growth += currentStack.GetRemainingGrowth();
		
		currentStack.SetStackSize( currentStack.GetStackSize() + growth );
		currentStack.SetRemainingGrowth(growth - int(growth));
		;

		;

		if(advCntl.GetNeutralGrowthMultiplier() != 1.0f  )
		{
			currentStack.SetStackSize( currentStack.GetStackSize() * advCntl.GetNeutralGrowthMultiplier() );
		}
	}
}

static function ClearAllArmyNegotiationData()
{
	local H7AdventureArmy currentArmy;
	local array<H7AdventureArmy> armies;

	armies = class'H7AdventureController'.static.GetInstance().GetArmies();
	
	foreach armies( currentArmy )
	{
		currentArmy.ClearNegotiationData();
	}
}

static function GrowEveryCritterArmy()
{
	local H7AdventureArmy currentArmy;
	local array<H7AdventureArmy> armies;

	armies = class'H7AdventureController'.static.GetInstance().GetArmies();
	
	foreach armies( currentArmy )
	{
		currentArmy.GrowCritterArmy();
	}
}

event SaveTransform()
{
	mSaveRotation = Rotation;
}

event RestoreTransform()
{
	if(!IsGarrisoned())
	{
		SetRotation(mSaveRotation);
		mHero.SetRotation(mSaveRotation);
	}
	
} 

event PostSerialize() // used to bridge native to uc
{
	local H7AdventureController advCntl;
	local array<float> dummy1, dummy2;
	local array<H7VisitableSite> dummySites;
	local array<H7AdventureArmy> dummyArmies;

	advCntl = class'H7AdventureController'.static.GetInstance();
	mPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mPlayerNumber);
	if( FindObject( mHeroArchetypeReference, class'H7EditorHero' ) != none ) // neutral armies doesnt have hero, so we need to do this check
	{
		mHeroArchetype = H7EditorHero( DynamicLoadObject( mHeroArchetypeReference, class'H7EditorHero' ) );
	}
	else if ( IsACaravan() )
	{
		if(class'H7GameUtility'.static.IsArchetype(mHeroArchetype)) // Spawn only when mHeroArchetype hold ref to archetype and not object
		{
			mHeroArchetype = Spawn( class'H7Caravan' );
		}
	}
	else
	{
		if(class'H7GameUtility'.static.IsArchetype(mHeroArchetype)) // Spawn only when mHeroArchetype hold ref to archetype and not object
		{
			mHeroArchetype = Spawn( class'H7EditorHero' ); 
		}

		mHeroArchetype.SetIsHero( false );
	}

	CreateHero( mHeroStruct );
	mHero.SetPlayer( mPlayer );

	if(mHeroEventParam == none)
		mHeroEventParam = new class'H7HeroEventParam';
	if(mPlayerEventParam == none)
		mPlayerEventParam = new class'H7PlayerEventParam';

	if( mIsDead )
	{

	}
	else
	{
		CreateCreatureStackProperies();

		if( advCntl.IsArmyOnMap( self ) )
		{
			HandleAddToMap();
		}
		else
		{
			if( H7CaravanArmy(self) != none )
			{
				if(!H7CaravanArmy(self).IsInTown())
				{
					advCntl.AddCaravan(H7CaravanArmy( self ) );
				}
				
			}
			else 
			{
				advCntl.AddArmy( self );
			}
		}
		advCntl.UpdateHUD();
		
		if( mGarrisonedSite != none && H7AreaOfControlSite( mGarrisonedSite ) != none && mGarrisonedSite.GetPlayer().GetPlayerNumber() != GetPlayerNumber() )
		{
			mGarrisonedSite = none;
		}
		if( !IsInShelter() )
		{
			if(mGarrisonedSite == none || (mGarrisonedSite != none && H7Garrison(mGarrisonedSite) == none) )
			{
				if( mCellCoords.GridIndex != INDEX_NONE )
				{
					SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCell( mCellCoords.Coordinates.X, mCellCoords.Coordinates.Y, mCellCoords.GridIndex ), true, true, true );
				}
			}
			else if(mGarrisonedSite != none && H7Garrison(mGarrisonedSite) != none )
			{
				H7Garrison(mGarrisonedSite).SetGarrisonArmy(self);
			}
		}
		else if(mGarrisonedSite != none)
		{
			H7Shelter( mGarrisonedSite ).EnterShelter();
		}

		if(!IsGarrisoned())
		{
			SetRotation( mSaveRotation );
		}
	}
	if( HasShip() )
	{
		SwitchToBoatVisuals();
	}

	if( mIsHidden || IsGarrisoned() || IsACaravan() && H7CaravanArmy( self ).IsInTown() )
	{
		HideArmy();
	}
	else
	{
		// If current armyCell is not none -> Restore PathPreview
		if(mCell != none)
		{
			mHero.RestoreSavedPath(mHeroStruct);
		}
		
		ShowArmy();
	}
	if( GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER && !IsACaravan() && !IsGarrisoned() )
	{
		class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetReachableSitesAndArmies( mCell, GetPlayer(), HasShip(), dummySites, dummyArmies, dummy1, dummy2, true );
	}
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	if( GetHero().IsHero() )
	{
		data.type = TT_TYPE_HERO_ARMY;
	}
	else
	{
		data.type = TT_TYPE_CRITTER_ARMY;
	}
	data.strData = "<font size='#TT_BODY#'>"$self.GetHero().GetName()$"</font>";
	data.addRightMouseIcon = true;
	return data;
}

function SetIsDead( bool newIsDead, optional bool spamEvent = true, optional bool clearArmyStacks = true )
{
	local H7DestructibleObjectManipulator theDOManipulator;
	local H7EventContainerStruct conti;

	if( newIsDead && newIsDead != mIsDead )
	{
		if( mHero != none && mHero.IsHero() )
		{
			mHero.SetDead( false );
			conti.Targetable = mHero;
		}
		if( spamEvent )
		{
			class'H7AdventureController'.static.GetInstance().UpdateEvents( ON_HERO_DIE, GetPlayerNumber(), conti );
			if( clearArmyStacks )
				ClearCreatureStackProperties();
		}
	}

	mIsDead = newIsDead;

	if( mIsDead )
	{
		if( GetCell() != none )
		{
			theDOManipulator = H7DestructibleObjectManipulator( GetCell().GetVisitableSite() );
			if( theDOManipulator != none )
			{
				theDOManipulator.AbortMyManipulation();
			}
			if( mShip != none )
			{
				GetCell().UnregisterShip( mShip );
			}
			GetCell().UnregisterArmy( self );
			mCell = none;
		}

		if( GetVisitableSite() != none && GetVisitableSite().GetVisitingArmy() == self ) // visitor died in visiting slot
		{
			GetVisitableSite().SetVisitingArmy(none);
		}

		ClearQuestFlag();
		if(class'H7AdventureHudCntl'.static.GetInstance() != none)
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().RemoveQuestIcon(GetQuestTargetID());
		}
		

		HideArmy();
		SetLocation( vect( -100000, -100000, -100000 ) );
		if( mShip != none )
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().RemoveIcon(mShip.GetID());
			mShip.SetArmy( none );
			mShip.SetPlayer( none );
			mShip.Destroy();
			mShip = none;
		}

		if( GetGarrisonedSite() != none && H7AreaOfControlSite( GetGarrisonedSite() ) != none && H7AreaOfControlSite( GetGarrisonedSite() ).GetGarrisonArmy() == self )
		{
			H7AreaOfControlSite( GetGarrisonedSite() ).SetGarrisonArmy( none );
			H7AreaOfControlSite( GetGarrisonedSite() ).CreateEmptyGarrison();
		}
		mGarrisonedSite = none;
		SetVisitableSite( none );
	}
}

simulated event Destroyed()
{
	// check in case that the army is destroyed in the load game
	SetIsDead( true );
	if( mFlag != none )
	{
		mFlag.Destroy();
	}
	if( mHero != none )
	{
		mHero.Destroy();
	}
	if( mShip != none )
	{
		mShip.Destroy();
	}
	SetOwner( none );
	super.Destroyed();
}

function MergeToTargetStackCount(int count)
{
	local int i;
	local int j;

	local bool merged;

	if(GetNumberOfFilledSlots() <= count) return;

	for(i=0; i < GetMaxArmySize(); i++)
	{
		merged = false;		
		if(mBaseCreatureStacks[i]==none) continue;
		
		for(j = 0; j < GetMaxArmySize(); j++)
		{
			if(i == j) continue;
			if(mBaseCreatureStacks[j]==none) continue;
			if(mBaseCreatureStacks[i].GetStackType() == mBaseCreatureStacks[j].GetStackType())
			{
				mBaseCreatureStacks[i].AddToStack(mBaseCreatureStacks[j].GetStackSize());
				RemoveCreatureStackByIndexComplete(j);
				merged = true;
			}
			if(merged) break;
		}
		if(GetNumberOfFilledSlots() <= count) return;
	}
	CreateCreatureStackProperies();
}

function bool IsTheFirstStackOfItsKind(H7BaseCreatureStack stack)
{
	local int i;

	for(i=0; i < GetMaxArmySize(); i++)
	{
		if(mBaseCreatureStacks[i] == stack)
		{
			return true;
		}
		else if(mBaseCreatureStacks[i].GetStackType() == stack.GetStackType())
		{
			return false;
		}
	}
	return true;
}

function bool CanMergeStacks(array<H7BaseCreatureStack> stacks)
{
	local int i, j;
	local bool foundIt;
	local int freeSlotsLeft;
	local array<H7Creature> newCreatureTypes;
	
	freeSlotsLeft = GetFreeSlotCount();

	// remove the slots that will be used in case that the merge happens
	for( i=0; i < stacks.Length; i++ )
	{
		if( stacks[i] != none )
		{
			foundIt = HasStackType( stacks[i] );

			if( foundIt ) continue;

			//check newCreatureTypes
			for( j=0; j < newCreatureTypes.Length; j++ )
			{       
				if(newCreatureTypes[j] == stacks[i].GetStackType())
				{
					foundIt = true;
					break;
				}
			}
			if( foundIt ) continue;

			// add the new creature into an empty slot
			if( !foundIt )
			{
				freeSlotsLeft--;
				newCreatureTypes.AddItem(stacks[i].GetStackType());
			}
		}
	}

	return freeSlotsLeft >= 0;
}


function MergeStacks( array<H7BaseCreatureStack> stacks )
{
	local int i, j;
	local bool foundIt;

	// remove the slots that will be used in case that the merge happens
	for( i=0; i < stacks.Length; ++i )
	{
		if( stacks[i] != none )
		{
			foundIt = HasStackType( stacks[i] );
			if( foundIt )
			{
				j = GetStackTypeIndex( stacks[i] );
				mBaseCreatureStacks[j].AddToStack( stacks[i].GetStackSize() );
			}

			// add the new creature into an empty slot
			if( !foundIt )
			{
				if( HasEmptySlot() )
				{
					j = GetEmptySlotIndex();
					AddStack( j, stacks[i] );
				}
				else
				{
					;
				}
			}
		}
	}

	CreateCreatureStackProperies();
}

function UnifyStacks()
{
	local H7InstantCommandUnifyStacks command;

	command = new class'H7InstantCommandUnifyStacks';
	command.Init(self);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function UnifyStacksComplete()
{
	local int i,j;

	for( i = 0; i < mBaseCreatureStacks.Length; ++i )
	{
		for( j = 0; j < mBaseCreatureStacks.Length; ++j )
		{
			if( mBaseCreatureStacks[i] != none && mBaseCreatureStacks[j] != none )
			{
				if( i != j && mBaseCreatureStacks[i].GetStackType() == mBaseCreatureStacks[j].GetStackType() )
				{
					mBaseCreatureStacks[i].SetStackSize( mBaseCreatureStacks[i].GetStackSize() + mBaseCreatureStacks[j].GetStackSize() );
					mBaseCreatureStacks[j].SetStackSize( 0 );
				}
			}
		}
	}
	for( i = mBaseCreatureStacks.Length - 1; i >= 0; --i )
	{
		if( mBaseCreatureStacks[i] != none && mBaseCreatureStacks[i].GetStackSize() == 0 )
		{
			mBaseCreatureStacks[i] = none;
		}
	}
	CreateCreatureStackProperies();
}

// used by AI to combine all instances of same creature type into one big stack.
function PackStacks()
{
	local H7InstantCommandSplitCreatureStack command;
	local int i, j;

	for( i=0; i<mBaseCreatureStacks.Length-1; i++ )
	{
		if( mBaseCreatureStacks[i]!=None )
		{
			for( j=i+1; j<mBaseCreatureStacks.Length; j++ )
			{
				if( mBaseCreatureStacks[j]!=None )
				{
					if( mBaseCreatureStacks[i].GetStackType() == mBaseCreatureStacks[j].GetStackType() )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						command = new class'H7InstantCommandSplitCreatureStack';
						command.Init(self, self, j, mBaseCreatureStacks[j].GetStackSize(), i, self);
						if(!class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command))
						{
							return;
						}
						j=i;
					}
				}
			}
		}
	}
}

function bool HasCreature( optional H7Creature creature )
{
	local int i;
	for( i=0; i<mBaseCreatureStacks.Length; i++ )
	{
		if( mBaseCreatureStacks[i] != None && (creature == none || mBaseCreatureStacks[i].GetStackType() == creature))
		{
			return true;
		}
	}
	return false;
}

// we cannot merge an army that has an hero into this army
// returns true if we can merge army into this army
function bool CanMergeArmy( H7AdventureArmy army )
{
	local array<H7BaseCreatureStack> baseCreatureStacks;

	if( GetHero().IsHero() && army.GetHero().IsHero() )
	{
		return false;
	}

	baseCreatureStacks = army.GetBaseCreatureStacks();

	return CanMergeStacks(baseCreatureStacks);
}

// be sure of CanMergeArmy returned true before doing the merge
// merges army into this army
function MergeArmy( H7AdventureArmy army, optional bool transferOnly )
{
	local array<H7BaseCreatureStack> baseCreatureStacks;
	local int i, j;
	local bool foundIt;
	local H7BaseCreatureStack newStack;

	baseCreatureStacks = army.GetBaseCreatureStacks();

	// remove the slots that will be used in case that the merge happens
	for( i=0; i < baseCreatureStacks.Length; ++i )
	{
		if( baseCreatureStacks[i] != none )
		{
			foundIt = HasStackType( baseCreatureStacks[i] );
			if( foundIt )
			{
				j = GetStackTypeIndex( baseCreatureStacks[i] );
				mBaseCreatureStacks[j].AddToStack( baseCreatureStacks[i].GetStackSize() );
				army.RemoveCreatureStackByIndexComplete( i );
			}

			// add the new creature into an empty slot
			if( !foundIt )
			{
				if( HasEmptySlot() )
				{
					j = GetEmptySlotIndex();
					newStack = new class'H7BaseCreatureStack'( baseCreatureStacks[i] );
					AddStack( j, newStack );
					army.RemoveCreatureStackByIndexComplete( i );
				}
				else if( !transferOnly )
				{
					;
				}
			}
		}
	}

	// destroy the army after the merge
	if( !transferOnly )
	{
		class'H7AdventureController'.static.GetInstance().RemoveArmy( army );

		class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
	
		SetIsBeingRemoved( false );
	}

	CreateCreatureStackProperies();
	army.CreateCreatureStackProperies();

	foreach baseCreatureStacks(newStack)
	{
		if(newStack.GetStackType() != none && newStack.GetStackSize() > 0)
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, Location, GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_RECIEVED_UNIT","H7FCT"), MakeColor(0,255,0,255), newStack.GetStackType().GetIcon());
		}
	}
}

function bool HasStackType( H7BaseCreatureStack stack ) 
{
	return GetStackTypeIndex(stack) != -1;
}

function int GetStackTypeIndex( H7BaseCreatureStack stack ) 
{
	local int i,index;
	index = -1;

	for ( i=0; i<mBaseCreatureStacks.Length; ++i )
	{
		if( mBaseCreatureStacks[i] != none && mBaseCreatureStacks[i].IsUnitType( stack ) && !mBaseCreatureStacks[i].IsLockedForUpgrade() )
		{
			index = i;
			break;
		}
	}

	return index;
}

function int GetFreeSlotCount()
{
	local int i,count;

	for ( i=0;i<mBaseCreatureStacks.Length;++i)
	{
		if( mBaseCreatureStacks[i] == none ) ++count;

	}
	return count;
}

function int GetStackCount( H7BaseCreatureStack stack )
{
	local int i,count;

	for ( i=0;i<mBaseCreatureStacks.Length;++i)
	{
		if( mBaseCreatureStacks[i] != none && mBaseCreatureStacks[i].IsUnitType( stack ) ) 
			++count;

	}
	return count;
}

function H7BaseCreatureStack GetStackByIndex(int index)
{
	local H7BaseCreatureStack stack;

	if( index > mBaseCreatureStacks.Length-1 || index < 0 )
	{
		stack = none;
	}
	else
	{
		stack = mBaseCreatureStacks[ index ];
	}
	
	return stack;
}

function DistributeUnits( H7BaseCreatureStack stack ) 
{
	local int i,count, distribute, rest; 
	
	// counts the stacks for given type
	count = GetStackCount( stack ) ;

	// need more that one stack
	if( count <= 1 ) 
		return;
	
	distribute = stack.GetStackSize() / count;
	rest = stack.GetStackSize() % count;
	
	// add for all
	for ( i=0; i<mBaseCreatureStacks.Length;++i)
	{
		if( mBaseCreatureStacks[i].IsUnitType( stack ) ) 
		{
			mBaseCreatureStacks[i].AddToStack( distribute );
		}
	}
	
	// one gets the rest
	AddRestUnits( stack , rest );
	CreateCreatureStackProperies();
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

function AddRestUnits( H7BaseCreatureStack stack, optional int value )
{
	local int i;

	for ( i=0; i<mBaseCreatureStacks.Length; ++i )
	{
		if( mBaseCreatureStacks[i].IsUnitType( stack ) )
		{
			if( value > 0 )
			{
				mBaseCreatureStacks[i].AddToStack( value );
				return;
			}
		}	
	}	

	CreateCreatureStackProperies();
}

function AddStack( int index, H7BaseCreatureStack stack )
{
	mBaseCreatureStacks[index] = new class'H7BaseCreatureStack';
	mBaseCreatureStacks[index].SetStackSize( stack.GetStackSize() );
	mBaseCreatureStacks[index].SetStackType( stack.GetStackType() );
	OverrideDeploymentFromBaseStacks( true );
}

// Used for Restarting BaseCreatureStacks when combat is Replayed
function ResetAllCreatureStack()
{
	local array<CreatureStackProperties> props;
	local int i, stackCounter;

	// Restore creature stacks from Properties
	props = GetCreatureStackProperties();
	for(i = 0; i < props.Length; ++i)
	{
		if(mBaseCreatureStacks[i] != none)
		{
			mBaseCreatureStacks[i].SetStackSize( props[stackCounter].Size );
			mBaseCreatureStacks[i].SetStartingSize( props[stackCounter].Size );
			mBaseCreatureStacks[i].SetStackType( props[stackCounter].Creature );
			stackCounter++;
		}
	}
	
}

function RemoveAllCreatureStacks()
{
	local int i;
	for(i = 0; i < mBaseCreatureStacks.Length; i++)
	{
		RemoveCreatureStackByIndex(i);
	}
}

function RemoveAllCreatureStacksComplete()
{
	local int i;
	for(i = 0; i < mBaseCreatureStacks.Length; i++)
	{
		RemoveCreatureStackByIndexComplete(i);
	}
}

function RemoveCreatureStackByIndex( int index )
{
	local H7InstantCommandDismissCreatureStack command;

	command = new class'H7InstantCommandDismissCreatureStack';
	command.Init( GetHero(), index );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function RemoveCreatureStackByIndexComplete( int index )
{
	;
	if( index < mBaseCreatureStacks.Length )
	{
		mBaseCreatureStacks[index] = none;
	}
	if( index < mCreatureStackProperties.Length )
	{
		mCreatureStackProperties[ index ].Creature = none;
		mCreatureStackProperties[ index ].Size = 0;
	}
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

function bool HasEmptySlot()
{
	return GetEmptySlotIndex() != -1;
}

function int GetEmptySlotIndex()
{
	local int i;
	
	for ( i=0; i < mBaseCreatureStacks.Length; ++i ) 
	{
		if( mBaseCreatureStacks[i] == none )
			return i;
	}
	return INDEX_NONE;
}


// Combat -> Adventure fromcombat backtoadventure updatefromcombat
// other way see: H7AdventureHero.Convert
function int UpdateAfterCombat( H7CombatArmy combatArmy, EPlayerNumber enemyPlayer, optional bool isQuickCombat = false )
{
	local H7Creature creatureType;
	local array<H7BaseCreatureStack> baseCreatureStacks,finalBaseStacks;
	local array<H7WarUnit> warUnitsManualCombat;
	local array<H7EditorWarUnit> warUnits;
	local H7WarUnit warUnitManualCombat;
	local H7EditorWarUnit warUnit;
	local H7BaseCreatureStack baseCreatureStack;
	local int baseCreatureStackIndex;
	local int baseCreatureStackDiff;
	local int tmpLength,i;
	local array<H7CreatureCounter> creatureLosses;
	local H7CreatureCounter creatureLoss;
	local H7EditorHero defeatedHero;
	local int losses;

	losses = 0;

	// update creature stacks
	
	if( isQuickCombat )
	{
		;
		// this is most likely quick combat
		baseCreatureStacks = combatArmy.GetBaseCreatureStacks();
		for(baseCreatureStackIndex = 0; baseCreatureStackIndex<baseCreatureStacks.Length; baseCreatureStackIndex++)
		{
			if( baseCreatureStackIndex < mBaseCreatureStacks.Length && mBaseCreatureStacks[baseCreatureStackIndex] == none ) 
			{ 
				continue;
			}
			else if( baseCreatureStackIndex >= mBaseCreatureStacks.Length && baseCreatureStacks[baseCreatureStackIndex] == none )
			{
				continue;
			}

			baseCreatureStack = baseCreatureStacks[baseCreatureStackIndex];
			

			if(baseCreatureStack == none || baseCreatureStack.GetStackSize() <= 0)
			{
				baseCreatureStackDiff = mBaseCreatureStacks[baseCreatureStackIndex].GetStackSize();
				creatureType = mBaseCreatureStacks[baseCreatureStackIndex].GetStackType();
				mBaseCreatureStacks[baseCreatureStackIndex] = none;
			}
			else
			{
				if( baseCreatureStack.IsLocalGuard() )
				{
					baseCreatureStackDiff = combatArmy.WonBattle() ? baseCreatureStack.GetStartingSize() - baseCreatureStack.GetStackSize() : baseCreatureStack.GetStartingSize();
					creatureType = baseCreatureStack.GetStackType();
				}
				else
				{
					baseCreatureStackDiff = combatArmy.WonBattle() ? mBaseCreatureStacks[baseCreatureStackIndex].GetStackSize() - baseCreatureStack.GetStackSize() : mBaseCreatureStacks[baseCreatureStackIndex].GetStackSize();
					mBaseCreatureStacks[baseCreatureStackIndex].SetStackSize( baseCreatureStack.GetStackSize() );
					creatureType = mBaseCreatureStacks[baseCreatureStackIndex].GetStackType();
				}
			}

			// update losses tracker
			if(baseCreatureStackDiff > 0)
			{
				losses += baseCreatureStackDiff;
				creatureLoss.Counter = baseCreatureStackDiff;
				creatureLoss.Creature = creatureType;
				creatureLoss.PlayerID = mPlayerNumber;
				creatureLoss.EnemyID = enemyPlayer;
				creatureLosses.AddItem(creatureLoss);
			}
		}

		// remove warfare units from defeated hero's army
		if( !combatArmy.WonBattle() )
		{
			warUnits = combatArmy.GetWarUnitTemplates();
			for( baseCreatureStackIndex = 0; baseCreatureStackIndex < warUnits.Length; ++baseCreatureStackIndex )
			{
				warUnit = warUnits[baseCreatureStackIndex];
				if( warUnit == none ) continue;
				if( warUnit.GetWarUnitClass() == WCLASS_SIEGE ) continue;

				RemoveWarUnit( warUnit );
			}
		}
	}
	else
	{
		finalBaseStacks = GetBaseCreatureStacksAfterCombat(combatArmy, enemyPlayer, creatureLosses, losses);
		
		// 3) delete all adventure-basestacks
		// 4) copy all combat-basestacks into adventure-basestacks
		// just take the combat-references to adventure, seems to work
		mBaseCreatureStacks = finalBaseStacks;

		// 5) fill up adv army with none slots
		tmpLength = mBaseCreatureStacks.Length;
		for(i=tmpLength;i<7;i++)
		{
			mBaseCreatureStacks.AddItem(none);
		}

		warUnitsManualCombat = combatArmy.GetWarUnits();
		for( baseCreatureStackIndex = 0; baseCreatureStackIndex < warUnitsManualCombat.Length; ++baseCreatureStackIndex )
		{
			warUnitManualCombat = warUnitsManualCombat[baseCreatureStackIndex];

			if( warUnitManualCombat == none || warUnitManualCombat.GetStackSize() == 0 )
			{
				RemoveWarUnit( warUnitManualCombat.GetTemplate() );
			}
		}

	}

	// Update the CreatureStackProperties so all data about stacks is synchronized
	for(i = 0; i < mBaseCreatureStacks.Length; ++i)
	{
		if(mBaseCreatureStacks[i] != none)
		{
			if(i < mCreatureStackProperties.Length) 
			{
				mCreatureStackProperties[i].Creature = mBaseCreatureStacks[i].GetStackType();
				mCreatureStackProperties[i].CustomPositionX = mBaseCreatureStacks[i].mCustomPositionX;
				mCreatureStackProperties[i].CustomPositionY = mBaseCreatureStacks[i].mCustomPositionY;
				mCreatureStackProperties[i].Size = mBaseCreatureStacks[i].GetStackSize();
			}
			else // more BaseStack then properties, add new Properties
			{
				mCreatureStackProperties.Add(1);
				mCreatureStackProperties[mCreatureStackProperties.Length - 1].Creature = mBaseCreatureStacks[i].GetStackType();
				mCreatureStackProperties[mCreatureStackProperties.Length - 1].Size = mBaseCreatureStacks[i].GetStackSize();
			}
		}
	}

	// report creature losses
	defeatedHero = combatArmy.WonBattle() ? none : combatArmy.GetAdventureHero();
	class'H7ScriptingController'.static.GetInstance().UpdateAfterCombatLosses(creatureLosses, mPlayerNumber, defeatedHero);

	SetDeployment( combatArmy.GetDeployment() );

	// update hero COPY BULLSHIT
	if( GetHero() != none )
	{
		GetHero().SetCurrentMana( combatArmy.GetHero().GetCurrentMana() );
		GetHero().SetQuickBarSpells( combatArmy.GetHero().GetQuickBarSpells(true) , true );	
		GetHero().OverrideSkillManager( GetHero().GetSkillManager() );
		GetHero().OverrideAbilityManager( GetHero().GetAbilityManager() );
		GetHero().OverrideBuffManager( combatArmy.GetHero().GetBuffManager(), combatArmy.GetHero() );
		GetHero().GetEquipment().SetEquipmentOwner( GetHero() ); 
		
		// this is called after real combat (where combat hero has the xp) and also after quick combat (where adv hero has the xp)
		if( combatArmy.GetHero().GetExperiencePoints() > GetHero().GetExperiencePoints())
		{
			// it was real combat, combat hero has the xp, give it to the adv hero as well
			GetHero().AddXp( combatArmy.GetHero().GetExperiencePoints() - GetHero().GetExperiencePoints() );
		}

		// what else are we forgetting...?
	}

	if( !combatArmy.WonBattle() || combatArmy.GetStrengthValue() == 0 )
	{
		// add the hero to the hall of heroes
		GetHero().SetCurrentMana( GetHero().GetMaxMana() ); // set back full mana
		GetHero().SetCurrentMovementPoints( GetHero().GetMovementPoints() ); // set back movement points
		if( combatArmy.AreAllCreaturesDead() )
		{
			GetHero().SetDead();
		}

		if( mHero.IsHero() )
		{
			class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().AddDefeatedHero( self );
		}

		SetIsBeingRemoved( true );
		if(isQuickCombat)
		{
			StartRemoveEffect();
			RemoveArmyAfterCombat();
		}
		else
		{
			class'H7AdventureController'.static.GetInstance().RemoveArmyOnlyFromList( self );
			SetTimer(1.0f, false, 'StartRemoveEffect');
			SetTimer(1.2f, false, 'RemoveArmyAfterCombat');
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	return losses;
}

function array<H7BaseCreatureStack> GetBaseCreatureStacksAfterCombat(H7CombatArmy combatArmy, EPlayerNumber enemyPlayer, out array<H7CreatureCounter> creatureLosses, out int losses)
{
	local array<H7CreatureStack> combatSpawnedCreatureStacks;
	local H7CreatureStack creatureStack;
	local array<H7BaseCreatureStack> baseCreatureStacks,finalBaseStacks, actualFinalBaseStacks;
	local H7BaseCreatureStack baseCreatureStack;
	local int baseCreatureStackDiff;
	local int i, j, idx;
	local H7CreatureCounter creatureLoss;

	;
	// NEW CODE 

	// Alright, since there is no design about how to sync it we do:
	// 1) collect all surviving stacks from the map
	// 2) update all combat-basestacks
	// 2.1) add undeployed stacks
	// 2.2) merge stack 8 and 9 into 1-7
	// 3) delete all adventure-basestacks
	// 4) copy all combat-basestacks into adventure-basestacks
	// 5) fill up adv army with none slots

	// 1) collect all surviving spawned stacks from the map and also the undeployed spawned stacks
	combatSpawnedCreatureStacks = combatArmy.GetCreatureStacks();
		
	;

	// 2) update all combat-basestacks with data from the spawned combat-creaturestacks
	for(i=0;i<combatSpawnedCreatureStacks.Length;i++)
	{
		creatureStack = combatSpawnedCreatureStacks[i];
		if(creatureStack == none) continue;

		// update baseCreatureStack of this creatureStack
		baseCreatureStack = creatureStack.GetBaseCreatureStack();
		if(baseCreatureStack == none || creatureStack.IsSummoned())
		{
			;
			creatureStack.Destroy();
			continue;
		}

		// loss count for quests/scripts/local guard update
		baseCreatureStackDiff = combatArmy.WonBattle() ? creatureStack.GetInitialStackSize() - creatureStack.GetStackSize() : creatureStack.GetInitialStackSize();
		losses += baseCreatureStackDiff;
		creatureLoss.Counter = baseCreatureStackDiff;
		creatureLoss.Creature = creatureStack.GetCreature();
		creatureLoss.PlayerID = mPlayerNumber;
		creatureLoss.EnemyID = enemyPlayer;
		creatureLosses.AddItem(creatureLoss);

		if( baseCreatureStack.IsLocalGuard() )
		{
			;
			if( H7AreaOfControlSite( mGarrisonedSite ) != none )
			{
				H7AreaOfControlSite( mGarrisonedSite ).UpdateLocalGuardByCreature( baseCreatureStack.GetStackType(), baseCreatureStackDiff );
			}
		}
		else
		{
			if( creatureStack.IsDead() )
			{
				;
				baseCreatureStack.SetStackSize(0);
			}
			else
			{
				baseCreatureStack.SetStackSize(creatureStack.GetStackSize());
				;
				finalBaseStacks.AddItem(baseCreatureStack);
			}
		}
	}

	// 2.1) add undeployed stacks (OPTIONAL probably not neccessary anymore, because undeployed stacks were above in combatSpawnedCreatureStacks??)
	baseCreatureStacks = combatArmy.GetBaseCreatureStacks();
	for(i=0;i<baseCreatureStacks.Length;i++)
	{
		baseCreatureStack = baseCreatureStacks[i];
		if(baseCreatureStack == none) continue;
		if(!baseCreatureStack.IsLocalGuard() && !baseCreatureStack.IsDeployed() && finalBaseStacks.Find(baseCreatureStack) == INDEX_NONE)
		{
			;
			finalBaseStacks.AddItem(baseCreatureStack);
		}
	}

	actualFinalBaseStacks.Add( baseCreatureStacks.Length );

	for( i = 0; i < finalBaseStacks.Length; ++i )
	{
		idx = baseCreatureStacks.Find( finalBaseStacks[i] );
		if( idx != INDEX_NONE )
		{
			actualFinalBaseStacks[idx] = finalBaseStacks[i];
		}
		else
		{
			actualFinalBaseStacks.AddItem( finalBaseStacks[i] );
		}
	}

	if(actualFinalBaseStacks.Length > 7)
	{
		// 2.2) merge stack 8 and 9 into 1-7, so index 8 and index 7 into index 0-6
		for(i=actualFinalBaseStacks.Length-1;i>=7;i--)
		{
			for(j=i-1;j>=0;j--)
			{
				if(actualFinalBaseStacks[i].GetStackType() == actualFinalBaseStacks[j].GetStackType()) // i can go into j
				{
					actualFinalBaseStacks[j].SetStackSize( actualFinalBaseStacks[i].GetStackSize() + actualFinalBaseStacks[j].GetStackSize() );
					actualFinalBaseStacks.Remove(i,1);
					break;
				}
			}
		}
	}

	return actualFinalBaseStacks;
}

function StartRemoveEffect()
{
	local AkEvent vanishSFX;

	vanishSFX = AkEvent'H7SFX_GUI.gui_vanishing_army';
	
	if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetPlayer().IsControlledByLocalPlayer())
	{
		class'H7AdventureController'.static.GetInstance().GetSelectedArmy().PlayAkEvent(vanishSFX,true);
	}

	WorldInfo.MyEmitterPool.SpawnEmitter( ParticleSystem'FX_Disappearing.PS_Disappearing', Location + Vect(0, 0, 150) );
}

function RemoveArmyAfterCombat()
{
	// remove the army from the adventure controller, but keep it invisible in case that is recruited again
	class'H7AdventureController'.static.GetInstance().RemoveArmy( self );
	if( class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == GetPlayer() )
	{
		class'H7AdventureController'.static.GetInstance().UpdateHUD();
	}
	
	SetIsBeingRemoved( false );
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}



static native function SortArmyListByStrength( out array<H7AdventureArmy> alist );

// currently all armies of any other player than the owning one will be considered as enemies. 
function bool IsEnemyOf( H7Player ply )
{
	if( ply == None ) return false;
	if( ply.GetPlayerNumber() != mPlayerNumber ) return true;
	return false;
}

function bool IsAllyOf( H7Player ply )
{
	if(mPlayer!=None) return mPlayer.IsPlayerAllied(ply);
	return false;
}

function float GetHeroPower()
{
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local float thePower;
	
	abilities = mHero.GetAbilities();

	foreach abilities( ability )
	{
		thePower += ability.GetPowerValue();
	}

	return thePower;
}

function JoinArmy( H7AdventureArmy armyJoiner, bool join, bool canMerge )
{
	local H7InstantCommandJoinArmy command;

	command = new class'H7InstantCommandJoinArmy';
	command.Init( self, armyJoiner, join, canMerge );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function JoinArmyComplete( H7AdventureArmy armyJoiner, bool join, bool canMerge )
{
	if( join )
	{
		if( canMerge )
		{
			MergeArmy( armyJoiner );
		}

		// Scripting
		class'H7ScriptingController'.static.GetInstance().UpdateCollectedArmies(self.mPlayerNumber, armyJoiner);
		class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		mHeroEventParam.mEventHeroTemplate = GetHeroTemplateSource();
		mHeroEventParam.mEventPlayerNumber = mPlayerNumber;
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_CollectArmy', mHeroEventParam, self);

		mHeroEventParam.mEventTargetArmy = armyJoiner;
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_CollectSpecificArmy', mHeroEventParam, self);
	}
	class'H7AdventureController'.static.GetInstance().RemoveArmy( armyJoiner );
}

// MP SimTurns: an army can only retreat if it has enough movement poinst and it didn't retreat already this turn
function bool CanRetreat()
{
	return GetHero().GetCurrentMovementPoints() >= 1 && mNumTimesAlreadyRetreated == 0;
}

// ------------------------------------------------------------------------------------------------
// post combat merge pool parking lot mechanic
// ------------------------------------------------------------------------------------------------
// new mechanic for necromancy and Shadow Of Death
function AddStackToMergePool(H7BaseCreatureStack addedStack,String poolKey)
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local bool wasMerged;
	local int poolIndex;
	
	poolIndex = GetMergePoolIndex(poolKey);
	if(poolIndex == INDEX_NONE)
	{
		poolIndex = CreateMergePool(poolKey);
	}
	stacks = mMergePools[poolIndex].PoolStacks;
	
	foreach stacks(stack)
	{
		if(stack.GetStackType() == addedStack.GetStackType())
		{
			stack.SetStackSize(stack.GetStackSize() + addedStack.GetStackSize());
			wasMerged = true;
		}
	}
	if(!wasMerged)
	{
		stacks.AddItem(addedStack);
	}
	
	mMergePools[poolIndex].PoolStacks = stacks;
}

function CleanAllCombatMergePools()
{
	mMergePools.Length = 0;
}

function DeleteMergePool(String poolKey)
{
	local int i;

	i = GetMergePoolIndex(poolKey);
	if(i != INDEX_NONE)
	{
		mMergePools.Remove(i,1);
	}
}

function H7MergePool GetAMergePool()
{
	local H7MergePool pool;
	if(mMergePools.Length > 0)
	{
		pool = mMergePools[0];
		return pool;
	}
	return pool;
}

function int GetPoolCount()
{
	return mMergePools.Length;
}

function UpdateMergePool(String poolKey, array<H7BaseCreatureStack> poolStacks)
{
	local int poolIndex;
	poolIndex = GetMergePoolIndex(poolKey);
	if(poolIndex != INDEX_NONE)
	{
		mMergePools[poolIndex].PoolStacks = poolStacks;
	}
}

private function int GetMergePoolIndex(String poolKey)
{
	local H7MergePool pool;
	local int i;
	foreach mMergePools(pool,i)
	{
		if(pool.PoolKey == poolKey) return i;
	}
	return INDEX_NONE;
}
private function int CreateMergePool(String poolKey)
{
	local H7MergePool pool;
	pool.PoolKey = poolKey;
	mMergePools.AddItem(pool);
	return mMergePools.Length-1;
}

function HandleAddToMap()
{
	if( GetHero().IsHero() )
	{
		LoadMeshes();
	}
	else
	{
		LoadMeshes( true );
	}
	GetHero().InitFX();
	GetHero().SpawnAnimControl();

	GetHero().GetSelectionFX().SetBase( GetHero() );
	SpawnHeroFlag();
}

function MergeArmiesAI( H7AdventureArmy receivingArmy )
{
	local array<H7BaseCreatureStack> localStacks;
	local int threshold;
	local H7InstantCommandMergeArmiesAI command;
	local H7BaseCreatureStack stack;

	if(!class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
	{
		return;
	}

	if( IsGarrisoned() && H7Town( GetGarrisonedSite() ) != none )
	{
		if( H7Town( GetGarrisonedSite() ).mAiThreateningArmy != none )
		{
			threshold = H7Town( GetGarrisonedSite() ).mAiThreateningArmy.GetStrengthValue( false );
		}
		localStacks = H7Town( GetGarrisonedSite() ).GetLocalGuardAsBaseCreatureStacks();
		foreach localStacks( stack )
		{
			threshold -= stack.GetCreatureStackStrength();
		}
	}

	command = new class'H7InstantCommandMergeArmiesAI';
	command.Init(self, receivingArmy, threshold);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function MergeArmiesAIComplete( H7AdventureArmy receivingArmy, int threshold )
{
	local array<H7BaseCreatureStack> receivingStacks, transferredStacks;
	local H7BaseCreatureStack stack;
	local int amountToTransfer;
	local float powerToSubtract;
	local array<H7HeroItem> items;
	local H7HeroItem item;

	local array<H7BaseCreatureStack> stackPool;
	local int i, j, end;
	
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;	
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	foreach mBaseCreatureStacks( stack )
	{
		stackPool.AddItem( stack );
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	receivingStacks = receivingArmy.GetBaseCreatureStacks();
	foreach receivingStacks( stack )
	{
		stackPool.AddItem( stack );
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	receivingStacks.Length = 0;
	
	for( i = 0; i < stackPool.Length; ++i )
	{
		for( j = 0; j < stackPool.Length; ++j )
		{
			if( i != j && stackPool[i].GetStackType() == stackPool[j].GetStackType() )
			{
				stackPool[i].SetStackSize( stackPool[i].GetStackSize() + stackPool[j].GetStackSize() );
				stackPool[j].SetStackSize( 0 );
			}
		}
	}

	for( i = stackPool.Length - 1; i >= 0; --i )
	{
		if( stackPool[i].GetStackSize() == 0 )
		{
			stackPool.Remove( i, 1 );
		}
	}

	stackPool.Sort( SortStackPoolMerge );

	receivingArmy.ClearCreatureStackProperties();
	ClearCreatureStackProperties();
	end = stackPool.Length > MAX_ARMY_SIZE ? stackPool.Length - MAX_ARMY_SIZE : 0;
	for( i = stackPool.Length - 1; i >= end; --i )
	{
		transferredStacks.AddItem( stackPool[i] );
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		stackPool.Remove( i, 1 );
	}

	if( stackPool.Length > 0 )
	{
		foreach stackPool( stack )
		{
			receivingStacks.AddItem( stack );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		stackPool.Length = 0;
	}
	else
	{
		transferredStacks.Sort( SortStackPoolByCreaturePower ); // sort by creature power so we keep the least powerful creatures, we want the receiving army to have the best possible army
		for( i = transferredStacks.Length - 1; i >= 0; --i )
		{
			amountToTransfer = 0;
			for( j = 0; j < transferredStacks[i].GetStackSize(); ++j )
			{
				if( powerToSubtract < threshold )
				{
					powerToSubtract += transferredStacks[i].GetStackType().GetCreaturePower();
					++amountToTransfer;
				}
				else
				{
					break;
				}
			}
			if( amountToTransfer > 0 )
			{
				stack = new class'H7BaseCreatureStack';
				stack.SetStackSize( amountToTransfer );
				stack.SetStackType( transferredStacks[i].GetStackType() );
				transferredStacks[i].AddToStack( -amountToTransfer );
				receivingStacks.AddItem( stack );
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			if( powerToSubtract >= threshold )
			{
				break;
			}
		}
	}

	foreach transferredStacks( stack, i )
	{
		if( stack.GetStackSize() > 0 )
		{
			receivingArmy.AddStack( i, stack );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}

	foreach receivingStacks( stack, i )
	{
		if( stack.GetStackSize() > 0 )
		{
			AddStack( i, stack );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}

	receivingArmy.CreateCreatureStackProperies();
	CreateCreatureStackProperies();
	
	items = mHero.GetInventory().GetItems();
	foreach items( item )
	{
		mHero.GetInventory().RemoveItemComplete( item );
		receivingArmy.GetHero().GetInventory().AddItemToInventoryComplete( item );
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	if( !receivingArmy.HasWarUnitType( WCLASS_ATTACK ) && !receivingArmy.HasWarUnitType( WCLASS_HYBRID ) )
	{
		if( ( HasWarUnitType( WCLASS_HYBRID ) ) )
		{
			receivingArmy.AddWarUnitTemplate( GetWarUnitByType( WCLASS_HYBRID ) );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		else if( HasWarUnitType( WCLASS_ATTACK ) )
		{
			receivingArmy.AddWarUnitTemplate( GetWarUnitByType( WCLASS_ATTACK ) );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}
	if( !receivingArmy.HasWarUnitType( WCLASS_SUPPORT) && !receivingArmy.HasWarUnitType( WCLASS_HYBRID ) )
	{
		if( ( HasWarUnitType( WCLASS_HYBRID ) ) )
		{
			receivingArmy.AddWarUnitTemplate( GetWarUnitByType( WCLASS_HYBRID ) );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		else if( HasWarUnitType( WCLASS_SUPPORT ) )
		{
			receivingArmy.AddWarUnitTemplate( GetWarUnitByType( WCLASS_SUPPORT ) );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
}

function int SortStackPoolMerge( H7BaseCreatureStack a, H7BaseCreatureStack b )
{
	local float str1, str2;
	str1 = class'H7AiActionCongregate'.static.GetStackStrengthGlobal( GetPlayer(), a.GetStackType() );
	str2 = class'H7AiActionCongregate'.static.GetStackStrengthGlobal( GetPlayer(), b.GetStackType() );
	return str2 - str1;
}

function int SortStackPoolByCreaturePower( H7BaseCreatureStack a, H7BaseCreatureStack b )
{
	return a.GetStackType().GetCreaturePower() - b.GetStackType().GetCreaturePower();
}

//AdventureArmies are a separat actor. Even if there is adventure hero inside the actor volume must be adjusted correctly.

function EnableAdventureIdleBridge()
{
	SetRTPCValue('Idle_Bridge_AdventureMap', 100.f);
	SetRTPCValue('Idle_Bridge_CombatMap', 0.f);
}

function array<H7EditorWarUnit> GetWarUnitKillListWhenBuying(bool attackHybrid,H7Town town)
{
	local H7EditorWarUnit heroUnit,townUnit;
	local array<H7EditorWarUnit> killList;

	// calculate the lost warfare units:
	if(attackHybrid)
	{
		// well is it attack or is it hyprid?
		townUnit = town.GetBuildingWarfare(true).GetWarunitTemplate();
		if(townUnit.GetWarUnitClass() == WCLASS_ATTACK) // attack unit kills attack & hybrid
		{
			heroUnit = GetWarUnitByType(WCLASS_ATTACK);
			if(heroUnit != none && killList.Find(heroUnit) == INDEX_NONE) killList.AddItem(heroUnit);
			heroUnit = GetWarUnitByType(WCLASS_HYBRID);
			if(heroUnit != none && killList.Find(heroUnit) == INDEX_NONE) killList.AddItem(heroUnit);
		}
		else // support unit kills attack & hybrid & support
		{
			heroUnit = GetWarUnitByType(WCLASS_ATTACK);
			if(heroUnit != none && killList.Find(heroUnit) == INDEX_NONE) killList.AddItem(heroUnit);
			heroUnit = GetWarUnitByType(WCLASS_HYBRID);
			if(heroUnit != none && killList.Find(heroUnit) == INDEX_NONE) killList.AddItem(heroUnit);
			heroUnit = GetWarUnitByType(WCLASS_SUPPORT);
			if(heroUnit != none && killList.Find(heroUnit) == INDEX_NONE) killList.AddItem(heroUnit);
		}
	}
	else // support unit kills support & hybrid
	{
		heroUnit = GetWarUnitByType(WCLASS_SUPPORT);
		if(heroUnit != none && killList.Find(heroUnit) == INDEX_NONE) killList.AddItem(heroUnit);
		heroUnit = GetWarUnitByType(WCLASS_HYBRID);
		if(heroUnit != none && killList.Find(heroUnit) == INDEX_NONE) killList.AddItem(heroUnit);
	}

	return killList;
}

// ------------------------------------------------------------------------------------------------


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

/* Logs current game state for OOS */
function DumpCurrentState()
{
	local H7BaseCreatureStack stack;
	
	if(!mHero.IsHero())
	{
		return;
	}
	class'H7ReplicationInfo'.static.PrintLogMessage("    ID"@mHero.GetID()@"Location:"@mCell.GetCellPosition().X@mCell.GetCellPosition().Y, 0);;
	mHero.DumpCurrentState();

	class'H7ReplicationInfo'.static.PrintLogMessage("    Creature Stacks:", 0);;
	foreach mBaseCreatureStacks(stack)
	{
		stack.DumpCurrentState();
	}
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

