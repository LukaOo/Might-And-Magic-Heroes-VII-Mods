/*=============================================================================
* H7AreaOfControlSite
* =============================================================================
* Base class for adventure map objects that are affected by Area of Controls.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7AreaOfControlSite extends H7VisitableSite implements(H7IDefendable, H7IOwnable)
	dependson( H7Player, H7Creature )
	implements( H7IHideable )
	native
	placeable
	savegame;

/** The player that owns this building */
var(Owner) protected savegame EPlayerNumber mSiteOwner<DisplayName="Owning Player">;
/** The radius of fog of war that is uncovered by this building */
var(Properties) protected int mSightRadius<DisplayName="Sight Radius"|ClampMin=1|ClampMax=300>;
var(Defenses) protected archetype H7AdventureArmy mEditorArmy<DisplayName="Garrison Army"|Tooltip="The garrison army that protects this building">;
var(Defenses) protected savegame array<H7DwellingCreatureData> mLocalGuard<DisplayName="Local Guard"|ToolTip="The stacks protecting this building">;
// Enables to use an amount of xp to define the strength of this local guard. When unchecked the army will be created from random stacksizes.
var(Defenses) protected bool mUseXPStrength<DisplayName="Use XP Strength">;
// This amount of experience points will be divided through the number of stacks and then divided through the single xp of the respective chosen creature to get the stacksizes.
var(Defenses) protected int	mXPStrength<DisplayName="XP Strength"|EditCondition=mUseXPStrength>;
var(Defenses) protected array<H7Faction> mLocalGuardFactions <DisplayName="Allowed Factions for Local Guard">;
/** The current faction of this town or fort */
var(Developer) archetype H7Faction mFaction<DisplayName=Faction>;

var(Visuals) protected Texture2D            mIcon<DisplayName=Main Icon>;
//var(Visuals) protected Texture2D            mMinimapIcon<DisplayName=Icon Minimap>;
var(Visuals) protected bool                 mHasMinimapIcon<DisplayName=Show Minimap Icon>;

var(Audio)      protected AkEvent           mOnVisitSound<DisplayName=Visiting sound>;
var(Audio)      protected AkEvent           mOnTakeOverSound<DisplayName=Taking Over sound>;
var(Audio)      protected AkEvent           mOnRepairSound<DisplayName=Repairing sound>;
var             protected bool              mInInit;

var             protected savegame H7CaravanArmy     mCaravanArmy;  // the CaravanArmy that belongs to this building

var             protected H7Flag            mFlag;

var             protected savegame bool     mHiddenBuilding;

var             protected savegame float    mAiThreatLevel;

var             protectedwrite savegame H7AdventureArmy    mAiThreateningArmy;

// Creature pool for Local - actual data (Town Guard in Town; Fort Guard in Fort) 
// - will be send through the highest existing localGuard-building on init to be corrected, in case illegal values were entered


native function OnTerrainChange(LandscapeLayerInfoObject newLayer, LandscapeProxy newLandscape);
native function H7Player GetPlayer();
native function bool      IsHiddenX();

function MergeArmies( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	//override in kids
}

function bool MergeArmiesComplete( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	return false;
}

function TransferHero( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	//override in kids
}

function bool TransferHeroComplete( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	return false;
}

// override in kids
function CreateEmptyGarrison() {}

function bool            GetInitState()                         { return mInInit; }
function                 SetInitState(bool val)                 { mInInit = val; }             
function float           GetAiThreatLevel()                     { return mAiThreatLevel; }
function                 SetAiThreatLevel( float f )            { mAiThreatLevel = f; }
function H7Faction       GetFaction()                           { return mFaction; }
function SetFaction( H7Faction fac)                             { mFaction = fac; }
function String          GetIconPath()                          { return "img://" $ PathName(mIcon); }
function Texture2D      GetIcon()                               { return mIcon; }
function int             GetLevel()                             { return 1; }
function EPlayerNumber   GetPlayerNumber()                      { return mSiteOwner; }
function H7CaravanArmy   GetCaravanArmy()                       { return mCaravanArmy; }
function                 SetCaravanArmy( H7CaravanArmy army ) 
{
	mCaravanArmy = army;
	if( mCaravanArmy != none ) 
	{
		mCaravanArmy.SetIsInLord( true ); 
		mCaravanArmy.HideArmy(true); 
		mCaravanArmy.SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ) ); 
	}
}

function                  RemoveCaravanArmy()            { mCaravanArmy = none; };
event H7AdventureArmy     GetGarrisonArmy()                     { return none; }
function                  SetGarrisonArmy(H7AdventureArmy army) { }
function H7AdventureArmy  GetGuardingArmy()                     { return none; }
function                  SetGuardingArmy(H7AdventureArmy army) { }
function bool            GetHasMinimap()                { return mHasMinimapIcon; }
function Texture2D       GetMinimapIcon()               { return mMinimapIcon; }
function String          GetFlashMinimapPath()          { return "img://" $ Pathname( mMinimapIcon ); }
function H7VisitableSite GetSite()                      { return Self; }
function String          GetFlashIconPath()             { return "img://" $ PathName(mIcon); }

function RenderDebugInfo( Canvas myCanvas ) {}

protected function HandleOwnership( H7AdventureHero visitingHero ) {};

function InitSiteOwner(EPlayerNumber initialOwner)
{
	mSiteOwner = initialOwner;
}

native function CalculateThreat();

function SetSiteOwner( EPlayerNumber newOwner, optional bool showMessage = true ) 
{
	local H7AdventureHudCntl adventureHudCntl;
	local H7Player newPlayer,oldPlayer;
	local H7Message message;
	local H7EventContainerStruct container;
	local H7Flag flag;
	local H7AreaOfControlSiteVassal meAsVassal;
	local array<H7AdventureArmy> newOwnerArmies;
	local H7EventContainerStruct conti;
	local int i;

	if(mSiteOwner == newOwner)
	{
		return; // Already owned
	}
	
	// inform old player that he lost it
	if( class'H7MessageSystem'.static.GetInstance() != none )
	{
		// forts are technically captured by neutral players, but we don't tell nobody && also we don't trigger for mines && dwellings
		if( newOwner != PN_NEUTRAL_PLAYER && !self.IsA('H7Mine') && !self.IsA('H7Dwelling')) 
		{
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mTownlost.CreateMessageBasedOnMe();
			message.mPlayerNumber = mSiteOwner;
			message.AddRepl("%site",GetName());
			message.AddRepl("%player",class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(newOwner).GetName());
			message.settings.referenceObject = self;
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	
			message = new class'H7Message';
			message.mPlayerNumber = mSiteOwner;
			message.text = "MSG_YOU_LOST";
			message.AddRepl("%name",GetName());
			message.destination = MD_LOG;
			message.settings.referenceObject = self;
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}

	;
	oldPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner );
	mSiteOwner = newOwner;  
	newPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( newOwner );
	mFlag.SetOwningPlayer( newPlayer );
	
	foreach mBuffFlags( flag )
	{
		flag.SetOwningPlayer( newPlayer );
	}

	if( mCaravanArmy != none )
	{
		mCaravanArmy.SetPlayer( newPlayer );
	}
	HandleSightRadius();
	
	// Inform new player that he captured it
	if( class'H7MessageSystem'.static.GetInstance() != none && showMessage && newOwner == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
	{
		message = new class'H7Message';
		message.mPlayerNumber = newOwner;
		message.text = "MSG_YOU_CAPTURED";
		message.AddRepl("%name",GetName());
		message.destination = MD_LOG;
		message.settings.referenceObject = self;
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}
	
	ChangeFlag();
	
	if( class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None && class'H7AdventureHudCntl'.static.GetInstance() != none)
	{
		adventureHudCntl = class'H7AdventureHudCntl'.static.GetInstance();
		if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == newPlayer)
		{
			adventureHudCntl.GetTownList().SetData(newPlayer.GetTowns());
		}
		if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == oldPlayer)
		{
			adventureHudCntl.GetTownList().SetData(oldPlayer.GetTowns());
		}
		adventureHudCntl.GetMinimap().Update(); // updates for everybody
	}

	mHeroEventParam.mEventHeroTemplate = (mVisitingArmy == none ? none : mVisitingArmy.GetHeroTemplateSource());
	mHeroEventParam.mEventPlayerNumber = newOwner;//event player is the new owner
	mHeroEventParam.mEventSite = self;

	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_SiteCaptured', mHeroEventParam, class'H7AdventureController'.static.GetInstance().GetSelectedArmy());

	class'H7AdventureController'.static.GetInstance().UpdateEvents( ON_ANY_BUILDING_CONQUERED );
	
	container.Targetable = self;

	TriggerEvents( ON_BUILDING_CHANGEOWNER, false, container );
	if( H7AreaOfControlSiteVassal( self ) != none && H7AreaOfControlSiteVassal( self ).GetLord() != none)
	{
		meAsVassal = H7AreaOfControlSiteVassal( self );
		meAsVassal.GetLord().TriggerEvents( ON_BUILDING_CHANGEOWNER, false, container );
		if( H7Town( meAsVassal.GetLord() ) != none )
		{
			H7Town( meAsVassal.GetLord() ).UpdateGovernorAuras();
		}
	}

	if( H7Town( self ) != none)
	{
		conti.Targetable = self;
		newOwnerArmies = newPlayer.GetArmies();
		// notify all heroes about the new town (in case they want to give it a buff)
		for(i=0; i<newOwnerArmies.Length; ++i)
		{
			newOwnerArmies[i].GetHero().TriggerEvents( ON_LORD_CONQUERED, false, conti);
		}

		// switch target to conquering hero ("self" would be very very pointless)
		if( mVisitingArmy != none )
		{
			conti.Targetable = mVisitingArmy.GetHero();
		}
		GetEventManager().Raise( ON_LORD_CONQUERED, false, conti );
	}

}

native function HandleSightRadius(optional bool isInit);

function Conquer( H7AdventureHero conqueror )
{
	SetVisitingArmy( none ); // the attacker still stands 1 field outside and is not visiting yet, but the defender is removed
	SetSiteOwner( conqueror.GetPlayer().GetPlayerNumber() );
}

function protected ChangeFlag()
{
	local H7AdventureController advCon;

	if( !mHiddenBuilding )
	{
		advCon = class'H7AdventureController'.static.GetInstance();

		if( mFlag != none )
		{
			mFlag.ShowAnim();
			mFlag.SetColor( advCon.GetPlayerByNumber( mSiteOwner ).GetColor() );
			mFlag.SetFaction( GetFaction() );
		}
	}
}

event InitAdventureObject()
{
	local H7Faction faction;
	local array<H7FactionCreatureData> factionData;
	local H7FactionCreatureData chosenData;
	local array<H7Creature> cores, elites, champions;
	local int i,j, realLocalGuardCount;
	local H7SynchRNG synchRNG;
	local H7Player dasPlayer;
	local array<H7Faction> allowedFactions, finalFactions;
	super.InitAdventureObject();

	mInInit = true;

	dasPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner );
	if( dasPlayer == none || dasPlayer.GetStatus() == PLAYERSTATUS_UNUSED  )
	{
		mSiteOwner = PN_NEUTRAL_PLAYER;
	}

	SpawnFlag();

	//if( class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None )
	//{
	//	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddAoCSite( self );
	//}

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		synchRNG = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG();
		class'H7TransitionData'.static.GetInstance().GetGameData().GetFactions( allowedFactions, false );
		foreach mLocalGuardFactions( faction )
		{
			if( allowedFactions.Find( faction ) != INDEX_NONE )
			{
				finalFactions.AddItem( faction );
			}
		}

		if( mLocalGuardFactions.Length > 0 )
		{
			faction = finalFactions[ synchRNG.GetRandomInt( finalFactions.Length ) ];
			
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
		}

		for( i = 0; i < mLocalGuard.Length; ++i )
		{
			if( mLocalGuard[i].Creature == none )
			{
				if( mLocalGuard[i].CreatureTier == CTIER_CORE )
				{
					mLocalGuard[i].Creature = cores[ synchRNG.GetRandomInt( cores.Length ) ];
				}
				else if( mLocalGuard[i].CreatureTier == CTIER_ELITE )
				{
					mLocalGuard[i].Creature = elites[ synchRNG.GetRandomInt( elites.Length ) ];
				}
				else
				{
					mLocalGuard[i].Creature = champions[ synchRNG.GetRandomInt( champions.Length ) ];
				}
			}

			if( mLocalGuard[i].Creature != none )
			{
				++realLocalGuardCount;
			}
		}

		for( i = 0; i < mLocalGuard.Length; ++i )
		{
			if( mUseXPStrength )
			{
				mLocalGuard[i].Capacity = FMax( 1.0f, mXPStrength / realLocalGuardCount / mLocalGuard[i].Creature.GetExperiencePoints() );
				mLocalGuard[i].Reserve = mLocalGuard[i].Capacity;
				if( mLocalGuard[i].Reserve == 0 )
				{
					mLocalGuard[i].Reserve = FMax( 1.0f,  mLocalGuard[i].Income );
				}
			}
		}
	}

	mInInit = false;
}

function CreateEmptyCaravan() 
{
	mCaravanArmy = Spawn( class'H7CaravanArmy' );
	mCaravanArmy.Init( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( GetPlayerNumber() ), , GetTargetLocation() ) ;
	mCaravanArmy.HideArmy(true);
	mCaravanArmy.SetIsInLord( true ) ;
	mCaravanArmy.SetSourceLord( H7AreaOfControlSiteLord( self ) ) ;
}

function vector GetHeightPos( float offset )
{
	return mMesh.Bounds.Origin + Vect( 0.f, 0.f, 1.f ) * (mMesh.Bounds.BoxExtent.Z + offset);
}



function SpawnFlag()
{
	local Vector flagLocation;
	local H7Player siteOwner;
	
	// creating the flag
	flagLocation = GetHeightAsVector( 0.f ) * 3;
	mFlag = Spawn( class'H7Flag', self ,,, Rotation );
	mFlag.SetScale( 5.0f );
	mFlag.SetBase( self );
	mFlag.InitLocation( flagLocation );
	mFlag.SetMainFlag( true );
	mFlag.SetFaction( mFaction );

	siteOwner = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner );
	if(siteOwner != none)
	{
		mFlag.SetColor( siteOwner.GetColor() );
	}
}

function H7Flag GetFlag()
{
	return mFlag;
}

// overwritten in town
function ProduceUnits() { }


function Color GetColor()
{
	return class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( GetPlayerNumber() ).GetColor();
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit( hero );
	
	HandleOwnership( hero );

	// do the visit army check again, maybe they can now visit
	if( GetPlayer() == none || GetPlayer() == hero.GetPlayer() )
	{
		// a visit is handled with newCellPos.GetVisitableSite().SetVisitingArmy( self ); in H7AdventureArmy
		// also this function is called for battles and conquers without battles where the attacker is 1 tile away, so we also don't set visiting in this case		
		//	mVisitingArmy = hero.GetAdventureArmy();
		//	mVisitingArmy.SetVisitableSite( self );
	}

	if(mOnVisitSound!=None && hero.GetPlayer().IsControlledByLocalPlayer())
	{
		 class'H7SoundController'.static.PlayGlobalAkEvent(mOnVisitSound,true);
	}
}

function array<H7RecruitmentInfo> GetRecruitAllData(optional bool checkGarrison, optional int freeSlots = -1, optional H7AdventureArmy aiArmy)
{
	local array<H7RecruitmentInfo> dummy;
	;
	dummy = dummy; // to prevent compiler warning
	return dummy;
}

function String GetRecruitAllBlockReason(optional int freeSlots = -1)
{
	;
	return "";
}

function float CheckPathToSite( optional H7AreaOfControlSite site )
{
	local array<H7AdventureMapCell> path;

	if(site == self) return -1;
	path = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPath( self.GetEntranceCell(), site.GetEntranceCell(), GetPlayer(), false );
	;

	return class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetTotalPathCosts(path, self.GetEntranceCell());
}

function int GetFreeStackSlots()
{
	;
	return 0;
}

function array<H7DwellingCreatureData> GetLocalGuard()
{
	return mLocalGuard;
}

// pendant to army.GetStrengthValue() taking local guards into account
function float GetStrengthValue()
{
	local float strengthValue;
	local H7DwellingCreatureData dcd;
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack bcs;
	local array<float> powersToBe;
	local int k,l;
	local float tmpVal;
	local int heroLevel;
	local float heroMod;

	strengthValue=0.0f;
	heroLevel=1;
	heroMod=1.0f;
	if( GetGarrisonArmy() != None )
	{
		stacks=GetGarrisonArmy().GetBaseCreatureStacks();
		foreach stacks(bcs)
		{
			if(bcs!=None && bcs.GetStackType()!=None)
			{
				powersToBe.AddItem( bcs.GetStackType().GetCreaturePower() * bcs.GetStackSize() );
			}
		}

		if(GetGarrisonArmy().GetHero()!=None && GetGarrisonArmy().GetHero().IsHero())
		{
			heroLevel=GetGarrisonArmy().GetHero().GetLevel();
			if(heroLevel>=1)
			{
				heroMod=1.08f + 0.02f * heroLevel;
			}
		}
	}

	foreach mLocalGuard(dcd)
	{
		if(dcd.Creature!=None && dcd.Reserve>0)
		{
			powersToBe.AddItem( dcd.Creature.GetCreaturePower() * dcd.Reserve );
		}
	}

	// sort shit
	for(k=0;k<powersToBe.Length-1;k++)
	{
		for(l=k+1;l<powersToBe.Length;l++)
		{
			if(powersToBe[l]>powersToBe[k])
			{
				tmpVal=powersToBe[k];
				powersToBe[k]=powersToBe[l];
				powersToBe[l]=tmpVal;
			}
		}
	}

	// take top 7 dwarves
	for(k=0;k<min(7,powersToBe.Length);k++)
	{
		strengthValue+=powersToBe[k];
	}

	return strengthValue*heroMod;
}

function ProduceDayUnits()
{
	local H7DwellingCreatureData entry; 
	local int i;

	for(i=0;i<mLocalGuard.Length;++i)
	{
		entry = mLocalGuard[i];

		;
		mLocalGuard[i].Reserve = entry.Reserve + GetGuardIncomeFor(entry);
		if(mLocalGuard[i].Reserve > GetGuardCapacityFor(entry))
		{
			mLocalGuard[i].Reserve = GetGuardCapacityFor(entry);
		}
		;
	}
}

function int GetGuardCapacityFor( H7DwellingCreatureData data )
{
	return data.Capacity;
}

function int GetGuardIncomeFor( H7DwellingCreatureData data )
{
	return data.Income;
}

function UpdateLocalGuardReserve( H7DwellingCreatureData data, int maxReserve )
{
	local int i;

	if( data.Creature == none ) return;

	for( i = 0; i < mLocalGuard.Length; ++i )
	{
		if( mLocalGuard[i].Creature != none 
			&& mLocalGuard[i].Creature == data.Creature )
		{
			if( mLocalGuard[i].Reserve > maxReserve )
			{
				mLocalGuard[i].Reserve = maxReserve;
				data.Reserve = maxReserve;
			}

			return;
		}
	}
}

function UpdateLocalGuardByCreature( H7Creature creature, int diff )
{
	local int i;

	for( i = 0; i < mLocalGuard.Length; ++i )
	{
		if( mLocalGuard[i].Creature == creature )
		{
			mLocalGuard[i].Reserve -= diff;
			return;
		}
	}
}

event array<H7BaseCreatureStack> GetLocalGuardAsBaseCreatureStacks()
{
	local H7DwellingCreatureData data;
	local array<H7BaseCreatureStack> baseStacks;
	local H7BaseCreatureStack stack;
	foreach mLocalGuard( data )
	{
		stack = new class'H7BaseCreatureStack'();
		stack.SetStackSize( data.Reserve );
		stack.SetStackType( data.Creature );
		stack.SetIsLocalGuard( true );
		stack.SetStartingSize( data.Reserve );
		baseStacks.AddItem( stack );
	}
	return baseStacks;
}

function ClearLocalGuardReserve()
{
	local int i;
	for( i = 0; i < mLocalGuard.Length; ++i )
	{
		mLocalGuard[i].Reserve = 0;
	}
}


native function bool HasStandingLocalGuard();



function Hide()
{
	mHiddenBuilding = true;
	SetHidden( mHiddenBuilding );
	SetSiteOwner(PN_NEUTRAL_PLAYER);
	if( GetFlag() != none )
	{
		GetFlag().SetHidden(true);
	}
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureController'.static.GetInstance().UpdateHUD();
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mHiddenBuilding = false;
	SetHidden( mHiddenBuilding );
	if( GetFlag() != none )
	{
		GetFlag().SetHidden(false);
	}
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureController'.static.GetInstance().UpdateHUD();
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
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
		if(class'H7GameUtility'.static.CellsContainIntPoint( points, GetEntranceCell().GetCellPosition())) // OPTIONAL better scouting cell check
		{
			return true;
		}
	}

	return false;
}

event PostSerialize()
{
	super.PostSerialize();
	if( mHiddenBuilding )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
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
 * 
 * */
function array<H7ResourceQuantity> GetUpgradeInfo( bool isVisitingArmy, out int numOfUpgCreatures, H7BaseCreatureStack creature=none,optional int slotID=-1, optional out array<H7ResourceQuantity> singleUpgCost, optional bool lockNum = false )
{
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

