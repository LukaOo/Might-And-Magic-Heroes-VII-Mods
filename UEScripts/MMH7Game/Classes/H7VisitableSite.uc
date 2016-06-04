//=============================================================================
// H7VisitableSite
//=============================================================================
// Base class for adventure map objects that can be visited and thus need an
// entrance.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7VisitableSite extends H7AdventureObject implements (H7IEffectTargetable,H7IEditorTerrainScan,H7IGUIListenable,H7ICaster,H7IAliasable)
	native
	perobjectconfig
	notplaceable
	savegame;

var(Developer) protected bool mIsUnblockingEntrance<DisplayName="Is Entrance Unblocked">;
var(Developer) protected Vector2D mEntranceOffset<DisplayName="Entrance Offset">;

var(Developer) protected H7GlobalName mGlobalName<DisplayName="Global Name">;

/** Custom name of this building to use instead of the regular name */
var(Naming) protected localized string mName<DisplayName="Custom Name"|EditCondition=mUseCustomName>;
/** Use custom name of this building instead of the regular name */
var(Naming) protected bool mUseCustomName<DisplayName="Use Custom Name">;

var(Developer) protected string mCustomTooltipKey<DisplayName="Custom Tooltip LocaKey (only permbonusite&pile)">;
var(Developer) protected Texture2D mMinimapIcon<DisplayName="Icon Minimap">;

var(AI) protected float mAiBaseUtility<DisplayName="Base Utility">;
// AI ignores this building
var(AISettings) protected bool mAiOnIgnore<DisplayName="Ignore">;

var protected transient string mCustomNameInst;

var protected editoronly transient SpriteComponent mEntranceSprite;

var protected savegame H7BuffManager			mBuffManager;
var protected H7EventManager		mEventManager;
var protected H7EffectManager		mEffectManager;
var protected savegame H7AbilityManager		mAbilityManager;
var protected H7HeroEventParam		mHeroEventParam;
var protected bool mReachabilityCheckDone;

var protected savegame H7AdventureArmy       mVisitingArmy; // the visiting hero with the visiting units

var protected array<H7Flag> mBuffFlags;
var protected H7Flag mQuestFlag;

var protected MaterialInstanceConstant mCliffMat;

var protected H7AdventureMapCell mEntranceCell;

var protected savegame Vector mSavedLocation;
var protected savegame Rotator mSavedRotation;

var protected bool mInitDone;
var protected bool mInitNameDone;

native function OnTerrainChange(LandscapeLayerInfoObject newLayer, LandscapeProxy newLandscape);

function bool			            GetHasMinimap()					        { return mMinimapIcon != none; }
function Texture2D		            GetMinimapIcon()				        { return mMinimapIcon; }
function String			            GetFlashMinimapPath()			        { return "img://" $ Pathname( mMinimapIcon ); }
function H7AdventureArmy			GetVisitingArmy()                       { return mVisitingArmy; }
function							SetVisitingArmy( H7AdventureArmy army ) { mVisitingArmy = army; }
simulated function Vector2D         GetEntranceOffset()                     { return mEntranceOffset; }
native function int                 GetID();
function float                      GetAiBaseUtility()                      { return mAiBaseUtility; }
function bool                       GetAiOnIgnore()                         { return mAiOnIgnore; }
function bool                       IsUnblockingEntrance()                  { return mIsUnblockingEntrance; }
function                            SetAiUtilityValue( float val )          { mAiBaseUtility = val; }
function                            SetAiOnIgnore( bool val )               { mAiOnIgnore=val; }

function OverrideName(string newName)
{
	mCustomNameInst = newName;
	mUseCustomName = true;
}

// Overridden in children that implement H7INeutralable
function bool IsNeutral() { return false; }

event string	GetName()	     
{
	if(mGlobalName != none && !mUseCustomName)
	{
		return mGlobalName.GetName();
	}
	else
	{
		return GetCustomName();
	}
}

function string GetCustomName()
{
	LocalizeCustomName();
	return mCustomNameInst;
}

function LocalizeCustomName()
{
	if(mCustomNameInst == "")
	{
		mCustomNameInst = class'H7Loca'.static.LocalizeMapObject(self, "mName", mName);
	}
}

function array<H7Flag>              GetBuffFlags()                          { return mBuffFlags; }
function                            PrepareAbility(H7BaseAbility ability)	{ GetAbilityManager().PrepareAbility( ability ); }
function H7BaseAbility              GetPreparedAbility()                    { return GetAbilityManager().GetPreparedAbility(); }
function ECommandTag                GetActionID( H7BaseAbility ability )    { return ACTION_ABILITY; }

native function EUnitType  			GetEntityType();
native function float               GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);
native function H7CombatArmy        GetCombatArmy();
native function H7AbilityManager	GetAbilityManager();
native function bool                IsDefaultAttackActive();
native function Vector              GetLocation();
native function IntPoint            GetGridPosition();
native function H7Player            GetPlayer();
native function H7ICaster           GetOriginal();

native function Vector              GetWorldEntranceNative();

function                            UsePreparedAbility(H7IEffectTargetable target) 
{ 
	local H7BaseGameController bgController;

	if(!class'H7AdventureController'.static.GetInstance().CanQueueCommand())
	{
		return;
	}

	bgController = class'H7BaseGameController'.static.GetBaseInstance();
	bgController.GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( self, UC_ABILITY, ACTION_ABILITY, GetPreparedAbility(), target ) );
}

function float GetMinimumDamage()     {   return 0;   }
function float GetMaximumDamage()     {	return 0;   }
function int GetAttack()            {	return 0;   }
native function int GetLuckDestiny();
function int GetMagic()             {   return 0;   }
function int GetStackSize()         {   return 1;   }
function EAbilitySchool GetSchool() { return ABILITY_SCHOOL_NONE; }
function int GetHitPoints()  {}

// Implementation of H7IQuestTarget
function H7AdventureMapCell GetCurrentPosition() { return class'H7AdventureGridManager'.static.GetInstance().GetClosestGridToPosition( GetLocation() ).GetCellByWorldLocation( GetLocation() ); }
function bool               IsHidden()           { return bHidden;   }
function bool               IsMovable()          { return false;     }

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}

function bool SpendPickupCostsOnVisit(H7AdventureHero visitingHero) { return false; }

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container)
{
	GetEventManager().Raise(triggerEvent, forecast, container);
	mBuffManager.UpdateBuffEvents(triggerEvent, forecast, container);
	mAbilityManager.UpdateAbilityEvents( triggerEvent, forecast, container );
}

event InitAdventureObject()
{
	super.InitAdventureObject();
	
	class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self );

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mBuffManager = new(self) class 'H7BuffManager';
		mAbilityManager = new(self) class 'H7AbilityManager';
	}
	mEventManager = new(self) class 'H7EventManager';
	mEffectManager = new(self) class 'H7EffectManager';
	mHeroEventParam = new(self) class'H7HeroEventParam';

	mAbilityManager.SetOwner( self );
	mEffectManager.Init( self );
	mBuffManager.Init( self );
	mInitDone = true;

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddVisitableSite( self );
}

simulated event Destroyed()
{
	super.Destroyed();

	UnregisterEventManageable();
}

simulated function UnregisterEventManageable()
{
	class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( self );
}

event vector GetHeightAsVector( float offset )
{
	return Vect( 0.f, 0.f, 1.f ) * (mMesh.Bounds.BoxExtent.Z + offset);
}

function ReorderBuffFlags( H7BaseBuff buff )
{
	local int i;
	local Vector flagLocation;

	for( i = 0; i < mBuffFlags.Length; ++i )
	{
		if( mBuffFlags[ i ].GetBuff() == buff )
		{
			mBuffFlags[ i ].Destroy();
			mBuffFlags[ i ] = none;
			break;
		}
	}
		
	mBuffFlags.Remove( i, 1 );
	for( i = 0; i < mBuffFlags.Length; ++i )
	{
		flagLocation.Y += ( i + 1 ) * 50;
		mBuffFlags[ i ].InitLocation( flagLocation );
	}

	if( H7AreaOfControlSite( self ) == none && mBuffFlags.Length > 0 )
	{
		mBuffFlags[ 0 ].SetMainFlag( true );
	}
}

function AddBuffFlag( H7BaseBuff newBuff )
{
	local H7Flag newFlag;
	local Vector flagLocation;
	local H7Player siteOwner;

	if( H7AreaOfControlSite( self ) != none )
	{
		// creating the flag
		newFlag = Spawn( class'H7Flag', H7AreaOfControlSite( self ).GetFlag() ,,, Rotation );
		newFlag.SetScale( 5.0f );
		newFlag.SetBase( H7AreaOfControlSite( self ).GetFlag() );
		flagLocation.Y += ( mBuffFlags.Length + 1 ) * 50;
		newFlag.InitLocation( flagLocation );
		
		newFlag.InitAsBuffIcon( newBuff );
		newFlag.SetFaction( H7AreaOfControlSite( self ).GetFaction() );

		siteOwner = H7AreaOfControlSite( self ).GetPlayer();
		if( siteOwner != none )
		{
			newFlag.SetColor( siteOwner.GetColor() );
		}
		mBuffFlags.AddItem( newFlag );
	}
	else
	{
		// creating the flag
		flagLocation = GetHeightAsVector( 0.f ) * 3;
		newFlag = Spawn( class'H7Flag', self ,,, Rotation );
		newFlag.SetScale( 5.0f );
		newFlag.SetBase( self );
		flagLocation.Y += ( mBuffFlags.Length + 1 ) * 50;
		newFlag.InitLocation( flagLocation );
	
		newFlag.InitAsBuffIcon( newBuff );
		newFlag.SetFaction( none );
		if( mBuffFlags.Length == 0 )
		{
			newFlag.SetMainFlag( true );
		}
		mBuffFlags.AddItem( newFlag );
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

	// creating the flag
	if( mMesh != none )
	{
		flagLocation = GetHeightAsVector( 0.f ) * 3;
	}
	else
	{
		flagLocation = location;
		flagLocation.Z += 1000;
	}

	flagLocation.Z += 300.0f;
	

	if( mQuestFlag == none )
	{
		mQuestFlag = Spawn( class'H7Flag', self );
	}

	mQuestFlag.SetScale( 5.0f );
	mQuestFlag.SetColor( class'H7AdventureController'.static.GetInstance().GetNeutralPlayer().GetColor() );
	mQuestFlag.SetBase( self );
	
	mQuestFlag.InitAsQuestTargetFlag();

	mQuestFlag.InitLocation( flagLocation );
	mQuestFlag.SetHidden( bHidden );
}

native function H7AdventureMapCell GetEntranceCell();

function OnVisit( out H7AdventureHero hero )
{
	local H7EventContainerStruct container;

	super.OnVisit( hero );
	if( GetPlayer() == none || GetPlayer() == hero.GetPlayer() )
	{
		mVisitingArmy = hero.GetAdventureArmy();
		mVisitingArmy.SetVisitableSite( self );
	}

	container.Targetable = hero;

	if( H7BuffSite( self ) != none )
	{
		if( !H7BuffSite( self ).HasAllBuffsFromHere( hero ) )
		{
			TriggerEvents( ON_VISIT, false, container );
			TriggerEvents( ON_POST_VISIT, false, container );
		}
	}
	else
	{
		TriggerEvents( ON_VISIT, false, container );
		TriggerEvents( ON_POST_VISIT, false, container );
	}

	if(IsNeutral())
	{
		class'H7ScriptingController'.static.GetInstance().UpdateSiteVisit(self, hero.GetPlayer().GetPlayerNumber());

		mHeroEventParam.mEventHeroTemplate = hero.GetAdventureArmy().GetHeroTemplateSource();
		mHeroEventParam.mEventPlayerNumber = hero.GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventSite = self;

		if(!class'H7TreasureHuntCntl'.static.GetInstance().GetTreasureHuntPopup().IsVisible()) // only trigger when no popup is there
		{
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_VisitNeutralBuilding', mHeroEventParam, hero.GetAdventureArmy());
		}
		else
		{
			class'H7TreasureHuntCntl'.static.GetInstance().TriggerWhenClosed(mHeroEventParam,hero.GetAdventureArmy());
		}
	}
}

function Color GetColor()
{
	// override in children
	return class'H7AdventureController'.static.GetInstance().GetNeutralPlayer().GetColor();
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
// (cpptext)
// (cpptext)
// (cpptext)

// ===================================
// H7IEffectTargetable implementations
// ===================================
native function H7BuffManager GetBuffManager();

native function H7EventManager GetEventManager();

function H7EffectManager GetEffectManager()
{
	return mEffectManager;
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
	;
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

function string GetVisitString(bool visited)
{
	if(visited)
	{
		return "<font size='22' color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_VISITED","H7General") $ "</font>";
	}
	else
	{
		return "<font size='22' color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_NOT_VISITED","H7General") $ "</font>";
	}
}

event PostSerialize()
{
	GetEntranceCell().SetVisitableSite( self );
	GetEntranceCell().GetGridOwner().AddVisitableSiteToList( self );

	//mAbilityManager.PostSerialize();
}

