/*=============================================================================
* H7Town
* =============================================================================
*  Class for adventure map objects that serve as Towns.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Town extends H7AreaOfControlSiteLord
	implements(H7ITooltipable, H7ILocaParamizable)
	dependson(H7ITooltipable,H7EditorArmy)
	/*hidecategories(Mesh)*/
	placeable
	native
	savegame;


// if left empty will use the default siege map for towns
var(Properties) protected string                    mCombatMapName<DisplayName="Siege Map">;

// predefined stuff
var(Properties) protected array<H7TownBuildingData> mBuildingTemplates<DisplayName="Building Tree"|ToolTip="The town uses this building tree">;
var(Developer) protected int                       mLocalGuardSlots<DisplayName="Local Guard Slots">;

/** The hero that governs this town */
var savegame protected H7AdventureHero                       mGovernor;

/** The adventure army whose hero will govern this town on map start*/
var(Properties) protected H7AdventureArmy           mPredefinedGovernor<DisplayName="Governor">;
/** The starting spells in the Magic Guild */
var(Properties) archetype array<H7HeroAbility>      mPredefinedMagicGuildSpells<DisplayName="Predefined Magic Guild Spells">;

// townscreen
var(Visuals) dynload protected Prefab                                       mFactionTownScreen<DisplayName=Town Screen>;
var(Visuals) protected const H7CameraProperties                             mTownCameraProperties<DisplayName=TownScreen Camera Properties>;
var(Visuals) protected String                                               mGUIconfig<DisplayName=GUI Build Tree Layout (optional override)>;
// gui deco
var(Visuals) dynload protected Texture2D                                    mFactionBannerIcon<DisplayName=Banner Icon>;
var(Visuals) dynload protected Texture2D                                    mFactionBGTownHall<DisplayName=Town hall background>;
var(Visuals) dynload protected Texture2D		                            mFactionWatermark<DisplayName=Watermark (in BuildingSlots)>;
var(Visuals) dynload protected Texture2D                                    mFactionTownPortalFrame<DisplayName=Town Portal Frame>;
// combat map building icons
var(Visuals) dynload protected Texture2D                                    mFactionWallsImage<DisplayName=Walls Image>;
var(Visuals) dynload protected Texture2D                                    mFactionTowerImage<DisplayName=Tower Image>;
var(Visuals) protected Texture2D                                            mFactionGateImage<DisplayName=Gate Image>;

var(Visuals, Upgrades) protected StaticMesh									mTier1Mesh<DisplayName=Tier 1 Mesh>;
var(Visuals, Upgrades) protected StaticMesh									mTier2Mesh<DisplayName=Tier 2 Mesh>;
var(Visuals, Upgrades) protected StaticMesh									mTier3Mesh<DisplayName=Tier 3 Mesh>;
var(Visuals, Upgrades) protected StaticMesh									mTier4Mesh<DisplayName=Tier 4 Mesh>;
var(Visuals, Upgrades) protected ParticleSystem								mTier1FX<DisplayName=Tier 1 FX>;
var(Visuals, Upgrades) protected ParticleSystem								mTier2FX<DisplayName=Tier 2 FX>;
var(Visuals, Upgrades) protected ParticleSystem								mTier3FX<DisplayName=Tier 3 FX>;
var(Visuals, Upgrades) protected ParticleSystem								mTier4FX<DisplayName=Tier 4 FX>;

var(SiegeBuildings) dynload protectedwrite H7CombatMapTower					mSiegeObstacleTower<DisplayName="Siege obstacle Tower">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapWall					mSiegeObstacleWall<DisplayName="Siege obstacle Wall">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapMoat					mSiegeObstacleMoat<DisplayName="Siege obstacle Moat">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapGate					mSiegeObstacleGate<DisplayName="Siege obstacle Gate">;
var(SiegeBuildings) protectedwrite array<H7EditorSiegeDecoration>	        mSiegeDecorationList<DisplayName="List of Siege Decorations">; //TODO: dynload

// === AI ==
var(Ai) protected savegame bool                                             mAiInHibernation<DisplayName="Is in hibernation mode">;
var(Ai) protected savegame bool                                             mAiEnableDevelopTown<DisplayName="Enable develop town logic">;
var(Ai) protected savegame bool                                             mAiEnableRecruitment<DisplayName="Enable creature recruitment logic">;
var(Ai) protected savegame bool                                             mAiEnableTrade<DisplayName="Enable trade logic">;
var(Ai) protected savegame bool                                             mAiEnableHireHeroes<DisplayName="Enable hire heroes logic">;
var(Ai) protected savegame bool                                             mAiIsMain<DisplayName="Main town">;
var(Ai) protected savegame bool                                             mAiIsCrusadeTarget<DisplayName="Crusade Target">;

var protected savegame bool mHasBuilt;
var protected savegame bool mHasDestroyed;
var protected savegame float mReserveMultiplier; // used by Week of Plague (and nothing else)

var protected array<H7TownBuildingData> mDwellings; // built dwellings
var protected savegame array<H7TownBuildingData> mBuildings; // built buildings
var protected savegame array<H7TownBuildingData> mBuildingTreeTemplate; // all buildings
var protected savegame array<H7TownMagicGuild> mMagicGuilds;

// Ref to best guard building for quick checks
var protected savegame H7TownGuardBuilding mBestGuardBuilding;
// @CB1 NIEMIEC - All uses of this variable should be changed to GetGuardGrowthBuildings to support multiple buildings!!
// Use ex. FindBuildingsOfType(class'H7TownGuardGrowthEnhancer' , guardEnhancers); to find a buildings of a given type
var protected savegame H7TownGuardGrowthEnhancer mGuardGrowthEnhancer;

//Magic Guild general properties
var protected savegame bool                 mGuildSpecialized;
// Predefined Magic Guild Specialisation
var (Properties) protected EAbilitySchool   mPredefinedMagicGuildSpec<DisplayName="Predefined Magic Guild Specialisation">;

var protected savegame int					mBuildingsBuiltToday, mMaxBuildingsPerDay;
var protected savegame float				mIncomeModifier,mBuildingCostModifier;

var protected savegame int                  mTownNameIndex;

var protected savegame EAbilitySchool					mGuildSpecialisation;
var protected savegame H7Resource						mIncomeResource;
var protected savegame array<H7ResourceQuantity>		mRefundBuffer;
var protected savegame int								mRefundPercentage;
var protected H7ICaster                                 mRefundHero;
var protected savegame int                              mHasForceReapplyAura;
var protected H7TownBuildingData                        mCurrentlyDestroyingBuilding;

var protected bool                                      mAiDone;

var protected array<H7Town>                             mCurrentCaravanSources;
var protected H7Town                                    mCurrentCaravanTarget;



native function EUnitType  			GetEntityType();
native function                     UpdateMeshes();
native function                     GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType checkForOperation1 = -1, optional EOperationType checkForOperation2 = -1, optional bool nextRound);

function string GetName()
{
	if(mUseCustomName)
	{
		return GetCustomName();
	}
	else
	{
		return GetGenericName();
	}
}

protected function string GetGenericName()
{
	if(mTownNameIndex > -1 && mCustomNameInst == "")
	{
		mCustomNameInst = class'H7GameData'.static.GetInstance().GetGenericTownNameByIndex(GetFaction(), mTownNameIndex);
	}
	else if(mCustomNameInst == "")
	{
		mCustomNameInst = class'H7GameData'.static.GetInstance().GetGenericTownName(GetFaction(), mTownNameIndex);
	}
	return mCustomNameInst;
}

function H7CombatMapTower GetCombatMapTower()
{
	if( mSiegeObstacleTower == none )
	{
		if(H7Town(self.ObjectArchetype).mSiegeObstacleTower == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleTower');
		}
		mSiegeObstacleTower = H7Town(self.ObjectArchetype).mSiegeObstacleTower;
	}

	return mSiegeObstacleTower;
}

function DelCombatMapTowerRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Town(self.ObjectArchetype).mSiegeObstacleTower = none;
	}
	mSiegeObstacleTower = none;
}

function H7CombatMapWall GetCombatMapWall()
{
	if( mSiegeObstacleWall == none ) 
	{
		if(H7Town(self.ObjectArchetype).mSiegeObstacleWall == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleWall');
		}
		mSiegeObstacleWall = H7Town(self.ObjectArchetype).mSiegeObstacleWall;
	}
	return mSiegeObstacleWall;
}

function DelCombatMapWallRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Town(self.ObjectArchetype).mSiegeObstacleWall = none;
	}
	mSiegeObstacleWall = none;
}

function H7CombatMapMoat GetCombatMapMoat()
{
	if( mSiegeObstacleMoat == none )
	{
		if(H7Town(self.ObjectArchetype).mSiegeObstacleMoat == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleMoat');
		}
		mSiegeObstacleMoat = H7Town(self.ObjectArchetype).mSiegeObstacleMoat;
	}
	return mSiegeObstacleMoat;
}

function DelCombatMapMoatRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Town(self.ObjectArchetype).mSiegeObstacleMoat = none;
	}
	mSiegeObstacleMoat = none;
}

function H7CombatMapGate GetCombatMapGate()
{
	if( mSiegeObstacleGate == none )
	{
		if(H7Town(self.ObjectArchetype).mSiegeObstacleGate == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleGate');
		}
		mSiegeObstacleGate = H7Town(self.ObjectArchetype).mSiegeObstacleGate;
	}
	return mSiegeObstacleGate;
}

function DelCombatMapGateRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Town(self.ObjectArchetype).mSiegeObstacleGate = none;
	}
	mSiegeObstacleGate = none;
}

function array<H7EditorSiegeDecoration>  GetCombatMapDecoList()             { /*if( mSiegeDecorationList.Length == 0 )  self.DynLoadObjectProperty('mSiegeDecorationList');*/ return mSiegeDecorationList; } //TODO: dynload
function                            DelCombatMapDecoListRef()               { mSiegeDecorationList.Length = 0; }

function H7Town                     GetArchetype()                          { if(class'H7GameUtility'.static.IsArchetype(self)) return self;else return H7Town(ObjectArchetype); }


function String                     GetFactionBannerIconPath()              { if( GetArchetype().mFactionBannerIcon == none ) GetArchetype().DynLoadObjectProperty('mFactionBannerIcon'); return "img://" $ Pathname( GetArchetype().mFactionBannerIcon ); }
function                            DelFactionBannerIconRef()               { mFactionBannerIcon = none; }
function String                     GetFactionBGTownHallPath()              { if( GetArchetype().mFactionBGTownHall == none ) GetArchetype().DynLoadObjectProperty('mFactionBGTownHall'); return "img://" $ Pathname( GetArchetype().mFactionBGTownHall ); }
function                            DelFactionBGTownHallRef()               { mFactionBGTownHall = none; }
function String                     GetFactionWatermarkPath()               { if( GetArchetype().mFactionWatermark == none ) GetArchetype().DynLoadObjectProperty('mFactionWatermark'); 	return "img://" $ Pathname( GetArchetype().mFactionWatermark ); }
function                            DelFactionWatermarkRef()                { mFactionWatermark = none; }
function String                     GetWallsIconPath()                      { if( GetArchetype().mFactionWallsImage == none ) GetArchetype().DynLoadObjectProperty('mFactionWallsImage'); return "img://" $ Pathname( GetArchetype().mFactionWallsImage ); }
function                            DelFactionWallsImageRef()               { mFactionWallsImage = none; }
function String                     GetGateIconPath()                       { if( GetArchetype().mFactionGateImage == none ) GetArchetype().DynLoadObjectProperty('mFactionGateImage'); return "img://" $ Pathname( GetArchetype().mFactionGateImage ); }
function                            DelFactionGateImageRef()                { mFactionGateImage = none; }
function String                     GetTowerIconPath()                      { if( GetArchetype().mFactionTowerImage == none ) GetArchetype().DynLoadObjectProperty('mFactionTowerImage'); return "img://" $ Pathname( GetArchetype().mFactionTowerImage ); }
function                            DelFactionTowerImageRef()               { mFactionTowerImage = none; }
function String                     GetFactionPortalFramePath()	            { if( GetArchetype().mFactionTownPortalFrame == none ) GetArchetype().DynLoadObjectProperty('mFactionTownPortalFrame'); return "img://" $ Pathname( GetArchetype().mFactionTownPortalFrame ); }
function                            DelFactionTownPortalFrameRef()          { mFactionTownPortalFrame = none; }

function Prefab GetTownScreen()
{
	if( mFactionTownScreen == none )
	{
		if(H7Town(self.ObjectArchetype).mFactionTownScreen == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mFactionTownScreen');
		}
		mFactionTownScreen = H7Town(self.ObjectArchetype).mFactionTownScreen;
	}
	return mFactionTownScreen;
}

function DelFactionTownScreenRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Town(self.ObjectArchetype).mFactionTownScreen = none;
	}
	mFactionTownScreen = none;
}

function int						GetLevel()						    	        { return mBuildings.Length; }
function array<H7TownBuildingData>  GetBuildings()				                    { return mBuildings; }
function H7AdventureHero			GetGovernor()					    	        { return mGovernor; }
function bool						HasBuiltToday()					    	        { return class'H7GUIGeneralProperties'.static.GetInstance().IsUnlimitedBuilding() ? false : mHasBuilt; }
function bool                       CouldUpdateAuras()                              { return mHasForceReapplyAura > 0; }
function H7CameraProperties         GetTownCameraProperties()                       { return mTownCameraProperties; }
function int                        GetLocalGuardSlots()                            { return mLocalGuardSlots; }
function String                     GetGUIconfig()                                  { return mGUIconfig; }
function                            SetGUIconfig(String val)                        { mGUIconfig = val; }
function bool						HasDestroyedToday()				    	        { return mHasDestroyed; }
function							SetDestroyedToday( bool boool )                 { if( mHasDestroyed != boool ) { mHasDestroyed = boool; DataChanged(); } }
function float                      GetBuildingCostModifier()                       { return GetModifiedStatByID(STAT_BUILDING_COSTS); }
function                            MulBuildingCostModifier(float modifier)	        { mBuildingCostModifier *= modifier; }
function                            SetMaxBuildingsPerDay(int amount)               { mMaxBuildingsPerDay = amount; if(amount > mBuildingsBuiltToday) { mHasBuilt = false; DataChanged(); } }
function bool                       GetMageGuildSpecialisationStatus()              { return mGuildSpecialized; }
function EAbilitySchool             GetSpecialisation()                             { return mGuildSpecialisation; }
function                            SetMageGuildSpecialisationStatus(bool value)    { mGuildSpecialized=value; }
function                            SetSpecialisation(EAbilitySchool school)        { mGuildSpecialisation = school; }
function EAbilitySchool             GetPredefinedMagicGuildSpecialisation()         { return mPredefinedMagicGuildSpec; }
function string				        GetCombatMapName()		                        { return mCombatMapName; }
function                            CanBuildCaravanThisTurn( bool value )           { mCanCreateCaravanThisTurn = value; }

function bool                       GetAiHibernationState()                         { return mAiInHibernation; }
function                            SetAiHibernationState(bool state)               { mAiInHibernation=state; }
function bool                       GetAiEnableDevelopTown()                        { return mAiEnableDevelopTown; }
function                            SetAiEnableDevelopTown(bool state)              { mAiEnableDevelopTown=state; }
function bool                       GetAiEnableRecruitment()                        { return mAiEnableRecruitment; }
function                            SetAiEnableRecruitment(bool state)              { mAiEnableRecruitment=state; }
function bool                       GetAiEnableTrade()                              { return mAiEnableTrade; }
function                            SetAiEnableTrade(bool state)                    { mAiEnableTrade=state; }
function bool                       GetAiEnableHireHeroes()                         { return mAiEnableHireHeroes; }
function                            SetAiEnableHireHeroes(bool state)               { mAiEnableHireHeroes=state; }
function bool                       GetAiIsMain()                                   { return mAiIsMain; }
function                            SetAiIsMain(bool state)                         { mAiIsMain=state; }
function bool                       GetAiIsCrusadeTarget()                          { return mAiIsCrusadeTarget; }
function                            SetAiIsCrusadeTarget(bool state)                { mAiIsCrusadeTarget=state; }

function                            SetAiDone( bool done )                          { mAiDone = done; }
function bool                       IsAiDone()                                      { return mAiDone; }

function SetBuiltToday( bool bu )
{
	mHasBuilt = bu;
	if(!bu)
	{
		mBuildingsBuiltToday = 0;
	}
	DataChanged();
}

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container)
{
	local H7TownBuildingData buidling;

	if(triggerEvent == ON_BEGIN_OF_DAY)
	{
		OnBeginDay();
	}
	super.TriggerEvents(triggerEvent, forecast, container);

	foreach mBuildings( buidling )
	{
		buidling.Building.TriggerEvents( triggerEvent, forecast, container );
	}
}

function OnBeginDay()
{
	local H7TownBuildingData building;
		
	foreach mBuildings( building )
	{
		building.Building.OnBeginDay();
	}
}

function SetGovernor( H7AdventureHero governor )
{
	local H7InstantCommandSetGovernor command;

	command = new class'H7InstantCommandSetGovernor';
	command.Init( self, governor );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function SetGovernorComplete( H7AdventureHero governor )
{ 	
	local H7EventContainerStruct container;

	container.Targetable = self;

	if( mGovernor != none )
	{
		mGovernor.TriggerEvents( ON_GOVERNOR_UNASSIGN, false, container ); 
		mGovernor.SetGovernedTown( none );
	}
	mGovernor = governor;
	if( mGovernor != none )
	{
		mGovernor.TriggerEvents( ON_GOVERNOR_ASSIGN, false, container );
		mGovernor.SetGovernedTown( self );
	}
	DataChanged(); 
}

// use this to update governor auras
function UpdateGovernorAuras()
{
	local H7EventContainerStruct container;

	if( mGovernor == none ) { return; }

	container.Targetable = self;

	mGovernor.TriggerEvents( ON_GOVERNOR_UNASSIGN, false, container ); 
	mGovernor.TriggerEvents( ON_GOVERNOR_ASSIGN, false, container ); 
}

function int GetCurrencyIncome()
{
	local H7TownBuildingData building, override_building;
	local int currencyIncome;

	foreach mBuildings( building )
	{
		override_building = GetBestBuilding(building);
		if( override_building == building )
		{
			currencyIncome += building.Building.GetIncomeForResource( GetPlayer().GetResourceSet().GetCurrencyResourceType() );
		}
	}

	return currencyIncome;
}

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

//Base Stats
function float GetBaseStatByID(Estat desiredStat)
{
	switch(desiredStat)
	{
		case STAT_PRODUCTION: 
			return GetCurrencyIncome();
		case STAT_LOCAL_GUARD_CORE_MAX_CAPACITY:
			return 0;
		case STAT_LOCAL_GUARD_ELITE_MAX_CAPACITY:
			return 0;
		case STAT_BUILDING_COSTS:
			return 1;
	}
	return 0;
}


event InitAdventureObject()
{
	local H7TownBuildingData data, townEditorEntry;
	local bool townGuardCalculated;
	local int i;
	
	super.InitAdventureObject();
	
	class'H7AdventureController'.static.GetInstance().AddTown( self );
	
	
    if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		// write mBuildingTemplates into mBuildingTreeTemplate (to avoid destruction of editor list?)
		foreach mBuildingTemplates( townEditorEntry, i )
		{
			// invalidate all that have unavailable prerequisites
			if(!townEditorEntry.IsBlocked && !IsAvailable(townEditorEntry.Building)) 
			{
				;
				townEditorEntry.IsBlocked = true;
			}

			if(!townEditorEntry.IsBlocked) mBuildingTreeTemplate.AddItem(townEditorEntry);
			else
			{
				// check if a main-alternate has been killed:
				if(townEditorEntry.Building != none && townEditorEntry.Building.GetAlternate() != none)
				{
					// give the child-alternate the coords of the main-alternate
					SwitchGUICoords(townEditorEntry.Building,townEditorEntry.Building.GetAlternate());
				}
			}
		}
	
	
		mBuildings.Length = 0; // clean up phantoms
		
		//The archetypes predefined magic guild specialisation for this town
		if( mPredefinedMagicGuildSpec != ABILITY_SCHOOL_NONE && 
			mPredefinedMagicGuildSpec != MIGHT && 
			mPredefinedMagicGuildSpec != ALL_MAGIC && 
			mPredefinedMagicGuildSpec != ALL )
		{
			mGuildSpecialisation = mPredefinedMagicGuildSpec;
			mGuildSpecialized = true;
		}

		// initialise mBuildings and additional data with the list consiting of faction_data+editor_data
		foreach mBuildingTreeTemplate( data, i )
		{
			if( data.Building == none ) 
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Building is None. For"@self@"at building template list index"@i@"!",MD_QA_LOG);;
				continue;
			}
			// create magic guild class at the beginning, even if it is not build yet
			if(data.Building.Class == class'H7TownMagicGuild')
			{
				data.Building = new data.Building.Class(data.Building);

				H7TownMagicGuild(data.Building).SetFaction(GetFaction());

				if(data.Building.Class == class'H7TownMagicGuild' && data.IsBuilt)
				{
					H7TownMagicGuild(data.Building).InitSpells(mPredefinedMagicGuildSpells, self);
				}
			
				mMagicGuilds.AddItem(H7TownMagicGuild(data.Building));
			}
						
			if(data.IsBuilt || data.Building.GetPrerequisiteLevel() == 0)
			{
				CreateBuilding(data.Building);
				if(H7TownGuardBuilding(data.Building) != none)
				{
					townGuardCalculated = true;
				}

				if( data.Building.IsA('H7TownGuardGrowthEnhancer' ) )
				{
					data.Building = new data.Building.Class( data.Building );
					H7TownGuardGrowthEnhancer( data.Building ).InitGrowthEnhancer( mLocalGuard );
				}
			}
		}

		if(!townGuardCalculated)
		{
			mLocalGuard.Remove(0,mLocalGuard.Length); // delete whatever the user put into the editor
		}
	}

	// cause the caching of townscreen assets
	if(GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber()
		|| class'H7AdventureController'.static.GetInstance().IsHotSeat()
		|| true) // we always cache all towns on map, because loading onConquer or onEnter is not fast enough
	{
		LoadTownAssets();
	}

	// set the town mesh
	foreach mBuildings( data )
	{
		if( data.Building.IsA( 'H7TownHall' ) )
		{
			mMesh.SetStaticMesh( H7TownHall( GetBestBuilding( data ).Building).GetMesh() );
			break;
		}
	}

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		ModifyPlayerIncome( true );
	}
	
	// Caravan init 
	CanBuildCaravanThisTurn( true );

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		CreateNewCaravan();
	}

	if( mPredefinedGovernor != none && mPredefinedGovernor.GetHero() != none && !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame()  )
	{
		if( !class'H7GameUtility'.static.IsArchetype( mPredefinedGovernor.GetHero() ) )
		{
			if( mSiteOwner == mPredefinedGovernor.GetHero().GetPlayer().GetPlayerNumber() )
			{
				SetGovernorComplete( mPredefinedGovernor.GetHero() );
			}
			else
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Cannot set hero from"@mPredefinedGovernor.GetHero().GetPlayer().GetName()@"to govern town owned by"@class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ).GetName(),MD_QA_LOG);;
			}
		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("A predefined governor can only be an instance!"@self@self.GetName()@"tried to assign"@mPredefinedGovernor.GetHero()@mPredefinedGovernor.GetHero().GetName(),MD_QA_LOG);;
		}
	}

	UpdateMeshes();
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// BUILDINGS ///////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

private function H7TownBuilding CreateBuilding(H7TownBuilding buildingArchetype, optional bool isForced = false)
{
	local H7TownMagicGuild magicGuild, currentMagicGuild;
	local H7TownBuildingData entry;
	local H7TownDwelling dwelling, upgradeBase;
	local bool aurasUpdated;
	local H7AuraStruct auraData;
	local H7Calendar calendar;
	local H7ScriptingController scriptingController;
	local H7TownDwellingOverride dwellingOverride;
	;

	entry.IsBuilt = true;

	// magic guild was already created at the start
	magicGuild = H7TownMagicGuild(buildingArchetype);
	if(magicGuild != None)
	{
		foreach mMagicGuilds(currentMagicGuild)
		{
			if(magicGuild.GetRank() == currentMagicGuild.GetRank())
			{
				entry.Building = currentMagicGuild;
				break;
			}
		}
	}
	else
	{
		entry.Building = new buildingArchetype.Class(buildingArchetype);
	}
	
	class'H7TownHudCntl'.static.GetInstance().AddToFadeInQueue(entry.Building);

	entry.Building.InitTownBuilding( self );
	
	if(H7TownGuardGrowthEnhancer(entry.Building) != none)
	{
		mGuardGrowthEnhancer = H7TownGuardGrowthEnhancer(entry.Building);

		if( mBestGuardBuilding != none )
		{
			CalculateLocalGuard(mBestGuardBuilding);
			mGuardGrowthEnhancer.InitGrowthEnhancer(mLocalGuard);
		}
	}

	if( entry.Building.GetAbility() != none )
	{
		GetAbilityManager().LearnAbility( entry.Building.GetAbility() );
		GetAbilityManager().GetAbility( entry.Building.GetAbility() ).GetEventManager().Raise( ON_BUILDING_BUILT, false );
		calendar = class'H7AdventureController'.static.GetInstance().GetCalendar();
		calendar.UpdateWeekEvents( ON_BUILDING_BUILT, false );
		calendar.UpdateWeekEvents( ON_OTHER_BUILDING_BUILT, false );
		if( entry.Building.GetAbility().IsAura() )
		{
			auraData = entry.Building.GetAbility().GetAuraData();
			if(auraData.mAuraProperties.mForceReapply) { mHasForceReapplyAura += 1; }
			GetEntranceCell().GetGridOwner().GetAuraManager().UpdateAuras();
			aurasUpdated = true;
		}
	}

	mBuildings.AddItem( entry );
	if( H7TownDwelling( entry.Building ) != none )
	{
		mDwellings.AddItem( entry );
	}

	// notify town about new building (don't use TriggerEvents; else the building will receive event two times)
	super.GetEventManager().Raise(ON_OTHER_BUILDING_BUILT, false);
	super.GetAbilityManager().UpdateAbilityEvents(ON_OTHER_BUILDING_BUILT, false);
	if(mGovernor != none)
	{
		mGovernor.TriggerEvents(ON_OTHER_BUILDING_BUILT, false);
		mGovernor.TriggerEvents(ON_BUILDING_BUILT, false);
		UpdateGovernorAuras();
	}

	// Is this the best guard building in da house?
	if(H7TownGuardBuilding(entry.Building) != none)
	{
		if(mBestGuardBuilding == none)
		{
			mBestGuardBuilding = H7TownGuardBuilding(entry.Building);
		}
		else if(H7TownGuardBuilding(entry.Building).GetLevel() > mBestGuardBuilding.GetLevel() )
		{
			mBestGuardBuilding = H7TownGuardBuilding(entry.Building);
		}
	}

	dwelling = H7TownDwelling(entry.Building);
	if(dwelling != none)
	{
		// carry current reserve to upgraded dwelling
		upgradeBase = H7TownDwelling(GetUpgradeBase(entry.Building, true));
		if(upgradeBase != none)
		{
			dwelling.CarryReserveForUpgrade(upgradeBase.GetCreaturePool().Reserve);
		}

		if(mBestGuardBuilding != none && mGuardGrowthEnhancer != none)
		{
			CalculateLocalGuard(mBestGuardBuilding);
			mGuardGrowthEnhancer.InitGrowthEnhancer(mLocalGuard);
		}

		// apply scripting overrides
		scriptingController = class'H7ScriptingController'.static.GetInstance();
		dwellingOverride = scriptingController.GetTownDwellingOverride(self, H7TownDwelling(dwelling.ObjectArchetype));
		if(scriptingController.IsTownDwellingOverrideValid(dwellingOverride))
		{
			dwelling.SetCreaturePool(dwellingOverride.CreaturePool);
		}
	}
	
	if( magicGuild != none ) 
	{
		LearnSpells(GetGarrisonArmy().GetHero());
		
		if( GetVisitingArmy() != none && GetVisitingArmy().GetHero() != none )
		{
			LearnSpells(GetVisitingArmy().GetHero());
		}
	}
	
	// (Re)Initialize town guard
	if(H7TownGuardBuilding(entry.Building) != none && mBestGuardBuilding != none)
	{
		CalculateLocalGuard(mBestGuardBuilding);

		// Check if LocalGuard Champion Creature can get any starting unit
		if(mGuardGrowthEnhancer != none)
		{
			mGuardGrowthEnhancer.InitGrowthEnhancer(mLocalGuard);
		}
	}

	DumpTownBuildings();

	if(mHasForceReapplyAura > 0 && !aurasUpdated && !isForced)
	{
		GetEntranceCell().GetGridOwner().GetAuraManager().UpdateAuras();
	}

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	if( dwelling != none )
	{
		dwelling.ModifyReserve( mReserveMultiplier );
	}

	return entry.Building;
}

native function bool IsAvailable(H7TownBuilding building);

function SwitchGUICoords(H7TownBuilding from,H7Townbuilding to)
{
	local string guiConfig,slots,arrows;
	local int sep;
	if(GetGUIconfig() == "") guiConfig = GetFaction().GetTownBuildTreeLayout();
	else guiConfig = GetGUIconfig();
	
	// separate slots from arrows:
	sep = InStr(guiConfig,"-");
	slots = Left(guiConfig,sep);
	arrows = Right(guiconfig,Len(guiconfig)-sep); // "-" is in here
	// replace slot
	slots = Repl(slots,String(from),String(to));
	// replace arrows if both building are alternates
	if(from.GetAlternate() == to || to.GetAlternate() == from)
	{
		arrows = Repl(arrows,String(from),String(to));
	}
	// recombine
	guiConfig = slots $ arrows;
	// save
	SetGUIconfig(guiConfig); // now is in override mode
}

function int GetHighestBuildingLevel()
{
	local int i, highestLevel;

	highestLevel = 0;

	for( i = 0; i < mBuildings.Length; ++i )
	{
		if( mBuildings[i].IsBuilt && mBuildings[i].Building.GetPrerequisiteLevel() > highestLevel )
		{
			highestLevel = mBuildings[i].Building.GetPrerequisiteLevel();
		}
	}

	return highestLevel;
}

function bool IsOnlyTownHallBuilt()
{
	return mBuildings.Length <= 1;
}

protected function DestroyBuildingByIndex( int index , optional bool simulate )
{
	local bool updateMesh;
	local H7EventContainerStruct container;
	local H7AuraStruct auraData;
	local H7TownGuardBuilding bestCandidate;
	local bool updateAuras,downgradeTownGuard;
	local int i;

	mHasRequiredDwellingFor.Length = 0;


	if( index >= mBuildings.Length || index < 0 ) return;

	mCurrentlyDestroyingBuilding.Building = none;

	updateMesh = mBuildings[index].Building.IsA('H7TownHall');
	downgradeTownGuard = false;

	container.Targetable = mBuildings[index].Building;
	
	if(!simulate) 
	{
		mCurrentlyDestroyingBuilding = mBuildings[index];
		if( GetAbilityManager().GetAbility( mBuildings[index].Building.GetAbility() ) != none )
		{
			if(mBuildings[index].Building.GetAbility().IsAura())
			{
				updateAuras = true;
				auraData = mBuildings[index].Building.GetAbility().GetAuraData();
				if(auraData.mAuraProperties.mForceReapply)
				{
					mHasForceReapplyAura -= 1;
				}
			}

			GetAbilityManager().GetAbility( mBuildings[index].Building.GetAbility() ).GetEventManager().Raise( ON_BUILDING_DESTROY, false, container );
			GetAbilityManager().UnlearnAbility( mBuildings[index].Building.GetAbility() );
		}
	}

	if( mVisitingArmy != none && (GetRefundHero() == none || GetRefundHero() == mVisitingArmy.GetHero()) )
	{
		mVisitingArmy.GetHero().TriggerEvents( ON_BUILDING_DESTROY, simulate, container );
	}

	if( mGarrisonArmy != none && mGarrisonArmy.GetHero().IsHero() && (GetRefundHero() == none || GetRefundHero() == mGarrisonArmy.GetHero()) )
	{
		mGarrisonArmy.GetHero().TriggerEvents( ON_BUILDING_DESTROY, simulate, container );
	}

	

	if(!simulate)
	{	
		if(mBestGuardBuilding == H7TownGuardBuilding( mBuildings[index].Building ) )
		{
			// Find lower building
			for( i = 0; i < mBuildings.Length; ++i)
			{
				if(H7TownGuardBuilding( mBuildings[i].Building ) != none && H7TownGuardBuilding( mBuildings[i].Building ) != mBestGuardBuilding)
				{
					if(bestCandidate == none)
					{
						bestCandidate = H7TownGuardBuilding(mBuildings[i].Building);
					}
					else if(bestCandidate.GetLevel() < H7TownGuardBuilding(mBuildings[i].Building).GetLevel() )
					{
						bestCandidate = H7TownGuardBuilding(mBuildings[i].Building);
					}
				}
			}

			mBestGuardBuilding = bestCandidate;
			bestCandidate = none;

			downgradeTownGuard = true;
		}

		if( H7TownDwelling( mBuildings[index].Building ) != none )
		{
			mDwellings.RemoveItem( mBuildings[index] );
		}
		mBuildings.Remove( index, 1 );
		GetAbilityManager().UpdateAbilityEvents( ON_BUILDING_DESTROY, false );
		if( updateMesh ) UpdateTownMesh();
		if( downgradeTownGuard )
		{
			// Update local guard data
			DowngradeLocalGuard(mBestGuardBuilding, mGuardGrowthEnhancer );
			
			mGuardGrowthEnhancer.InitGrowthEnhancer(mLocalGuard);
		}
	}

	if(updateAuras)
	{
		GetEntranceCell().GetGridOwner().GetAuraManager().UpdateAuras();
	}

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

function AddToRefundBuffer(H7ResourceQuantity newEntry)
{
	local H7ResourceQuantity entry;
	local int i;

	foreach mRefundBuffer(entry,i)
	{
		if(entry.Type == newEntry.Type)
		{
			mRefundBuffer[i].Quantity += newEntry.Quantity;
			return;
		}
	}
	mRefundBuffer.AddItem(newEntry);
}

function int GetRefundPercentage()
{
	return mRefundPercentage;
}

function array<H7ResourceQuantity> GetRefundBuffer()
{
	return mRefundBuffer;
}

function DeleteRefundBuffer()
{
	mRefundBuffer.Remove(0,mRefundBuffer.Length);
}
function SetRefundHero(H7ICaster hero)
{
	mRefundHero = hero;
}
function H7ICaster GetRefundHero()
{
	return mRefundHero;
}

function RefundBuildingCost( H7TownBuilding building, int percentage, bool isSimulated )
{
	local array<H7ResourceQuantity> resources;
	local H7ResourceQuantity resource;
	local float perc;

	if( building == none || percentage <= 0 ) return;

	resources = building.GetCost();
	perc = percentage * 0.01f;
	mRefundPercentage = percentage;

	foreach resources( resource )
	{
		if(isSimulated)
		{
			resource.Quantity *= perc;
			AddToRefundBuffer(resource);
		}
		else
		{
			if( resource.Type != GetPlayer().GetResourceSet().GetCurrencyResourceType() )
			{
				GetPlayer().GetResourceSet().ModifyResource( resource.Type, FFloor(resource.Quantity * perc) );
			}
			else
			{
				GetPlayer().GetResourceSet().ModifyCurrency( FFloor(resource.Quantity * perc) );
			}
		}
	}
	
	if(!isSimulated)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons(GetPlayer().GetResourceSet().GetAllResourcesAsArray());
	}
}

function DestroyBuildingsOfLevel( int level )
{
	local H7InstantCommandDestroyTownBuildings command;

	command = new class'H7InstantCommandDestroyTownBuildings';
	command.Init( self, level );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function DestroyBuildingsOfLevelComplete( int level, bool simulate )
{
	local int i;

	if( IsOnlyTownHallBuilt() || HasDestroyedToday() ) return;

	for( i = mBuildings.Length - 1; i >= 0; --i )
	{
		if( mBuildings[i].Building.GetPrerequisiteLevel() == level )
		{
			if( level <= 1 && mBuildings[i].Building.IsA('H7TownHall') )
			{
				continue;
			}
			DestroyBuildingByIndex( i, simulate );
		}
	}

	if(!simulate)
	{
		SetDestroyedToday( true );
		mCurrentlyDestroyingBuilding.Building = none;

		DumpTownBuildings();
	}
}

function UpdateTownMesh()
{
	local int i;

	for( i = 0; i < mBuildings.Length; ++i )
	{
		if( mBuildings[i].Building.IsA('H7TownHall') )
		{
			SetMesh( H7TownHall( GetBestBuilding( mBuildings[i] ).Building ).GetMesh() );
			return;
		}
	}
}

function DumpTownBuildings()
{
	local int i;
	
	;
	;
	for( i = 0; i < mBuildings.Length; ++i )
	{
		;
	}
	;
	;
	;
}

function int GetGuardCapacityFor( H7DwellingCreatureData data )
{
	local array<H7TownGuardGrowthEnhancer> enhancer;
	local H7TownGuardGrowthEnhancer dasEnhancer;
	local int value;
	local int valueFromStats;
	local int isSet;

	if(data.Creature==None)
		valueFromStats = 0;
	else if(data.Creature.GetTier() == CTIER_CORE)
		valueFromStats = GetModifiedStatByID(STAT_LOCAL_GUARD_CORE_MAX_CAPACITY);
	else if(data.Creature.GetTier() == CTIER_ELITE)
		valueFromStats = GetModifiedStatByID(STAT_LOCAL_GUARD_ELITE_MAX_CAPACITY);
	else
		valueFromStats = 0;

	enhancer = GetGuardGrowthBuildings();
	if( enhancer.Length == 0 )
	{
		UpdateLocalGuardReserve( data, data.Capacity + valueFromStats );
		return data.Capacity + valueFromStats;
	}

	foreach enhancer( dasEnhancer )
	{
		value = dasEnhancer.GetModifiedCapacityFor( data, HasRequiredDwellingTier( CTIER_CHAMPION ), isSet );
		if( isSet > 0 )
		{
			UpdateLocalGuardReserve( data, value + valueFromStats );
			return value + valueFromStats;
		}
	}

	UpdateLocalGuardReserve( data, value + valueFromStats );
	return value + valueFromStats;
}

function int GetGuardIncomeFor( H7DwellingCreatureData data )
{
	local array<H7TownGuardGrowthEnhancer> enhancer;
	local H7TownGuardGrowthEnhancer dasEnhancer;
	local int value;
	local int isSet;

	enhancer = GetGuardGrowthBuildings();
	if( enhancer.Length == 0 )
	{
		return data.Income;
	}

	foreach enhancer( dasEnhancer )
	{
		value = dasEnhancer.GetModifiedIncomeFor( data, HasRequiredDwellingTier( CTIER_CHAMPION ), isSet );
		if( isSet > 0 )
		{
			return value;
		}
	}
	return value;
}

function bool HasChampionDwellingBuilt()
{
	return true; // TODO
}

function bool HasOutSideDwellings()
{
	local array<H7Dwelling> dwellings;
	dwellings = GetOutsideDwellings();
	return dwellings.Length > 0;
}

function bool HasOutSideDwellingsBelongingToOwner()
{
	local array<H7Dwelling> dwellings;
	local H7Dwelling dwelling;
	dwellings = GetOutsideDwellings();

	ForEach dwellings(dwelling)
	{
		if(dwelling.GetPlayerNumber() == GetPlayerNumber()) return true;
	}

	return false;
}

native function array<H7TownBuildingData> GetBuildingTree();

/**
 * Returns the first building of the specified type, if no building is found, the return value is none
 * Checks ONLY built buildings!
 */
function H7TownBuilding GetBuildingByType(class c)
{
	local H7TownBuildingData building;
	foreach mBuildings(building)
	{
		if(building.Building == none) 
		{
			;
		}
		else
		{
			if(building.Building.Class == c) return building.Building;
		}
	}
	return none;
}

function H7TownUtilityUnitDwelling GetBuildingWarfare(bool attackHybrid) 
{
	local H7TownBuildingData building;
	local EWarUnitClass warUnitType;
	foreach mBuildings(building)
	{
		if(building.Building != none && building.Building.class == class'H7TownUtilityUnitDwelling') 
		{
			if(H7TownUtilityUnitDwelling(building.Building).GetWarunitTemplate() != none)
			{
				warUnitType = H7TownUtilityUnitDwelling(building.Building).GetWarunitTemplate().GetWarUnitClass();
				if((attackHybrid && (warUnitType == WCLASS_ATTACK || warUnitType == WCLASS_HYBRID))
					|| (!attackHybrid && warUnitType == WCLASS_SUPPORT))
				{
					return H7TownUtilityUnitDwelling(building.Building);
				}
			}
		}
	}
	return none;
}

function H7TownBuildingData GetBuildingTemplateByType(class c)
{
	local H7TownBuildingData building;
	foreach mBuildingTreeTemplate(building)
	{
		if(IsBuildingBuilt(building.Building,true,false)) building.IsBuilt = true; // OPTIONAL check if neccessary
		if(building.Building.class == c ) return building;
	}
	building.Building = none;
	return building;
}

function bool IsHavenTown()
{
	local H7TownBuildingData building;
	local H7TownBuilding moat;

	moat = GetBuildingTemplateByType(class'H7TownMoat').Building;

	foreach mBuildingTreeTemplate(building)
	{
		if(building.Building.GetAlternate() == moat)
			return true;
	}
	return false;
}   

function array<H7TownBuildingData> GetBuildingTemplatesByType(class c)
{
	local H7TownBuildingData building;
	local array<H7TownBuildingData> buildings;
	foreach mBuildingTreeTemplate(building)
	{
		if(IsBuildingBuilt(building.Building,true,false)) building.IsBuilt = true; // OPTIONAL check if neccessary
		if(building.Building.class == c ) buildings.AddItem(building);
	}
	return buildings;
}

function DisableBuilding( H7TownBuilding building )
{
	local int i;
	local array<H7TownBuildingData> dataToRemove;
	i = mBuildingTreeTemplate.Find( 'Building', building );

	if( i != INDEX_NONE )
	{
		mBuildingTreeTemplate[i].IsBlocked = true;
		if(mBuildingTreeTemplate[i].Building != none && mBuildingTreeTemplate[i].Building.GetAlternate() != none)
		{
			// give the child-alternate the coords of the main-alternate
			SwitchGUICoords(mBuildingTreeTemplate[i].Building,mBuildingTreeTemplate[i].Building.GetAlternate());
		}
		//mBuildingTreeTemplate.Remove( i, 1 );
	}
	for( i = mBuildingTreeTemplate.Length - 1; i >= 0; --i )
	{
		if( !IsAvailable( mBuildingTreeTemplate[i].Building ) )
		{
			dataToRemove.AddItem( mBuildingTreeTemplate[i] );
		}
	}
	for( i = 0; i < dataToRemove.Length; ++i )
	{
		mBuildingTreeTemplate.RemoveItem( dataToRemove[i] );
	}
}

// checks only build buildings!
// returns first random hit it finds!
function H7TownBuildingData GetBuildingDataByType(class c)
{
	local H7TownBuildingData building;

	foreach mBuildings(building)
	{
		if(building.Building.class == c ) return building;
	}
	building.Building = None;
	building.IsBuilt = false;
	return building;
}

// checks only build buildings!
// returns all hits it finds!
function array<H7TownBuildingData> GetBuildingsByType(class c)
{
	local H7TownBuildingData building;
	local array<H7TownBuildingData> buildings;
	foreach mBuildings(building)
	{
		if(building.Building.class == c ) buildings.AddItem(building);
	}
	return buildings;
}


// returns 0 if the building doesnt exist
function int GetBuildingLevelByType(class buildingType)
{
	local H7TownBuildingData building;
	local int buildingLevel;

	foreach mBuildings( building )
	{
		if( building.Building.class == buildingType )
		{
			++buildingLevel;
		}
	}

	return buildingLevel;
}

function H7TownBuildingData GetBestBuildingByBuilding(H7TownBuilding building)
{
	local H7TownBuildingData bdata;
	bdata.Building = building;
	bdata.IsBuilt = true;
	return GetBestBuilding(bdata);
}

// only returns build buildings
// returns any random first match
function H7Townbuilding GetBuildingByPrefabAsset(H7TownAsset prefabAsset)
{
	local H7TownBuildingData building;
	local array<H7TownAsset> assets;
	local int i;
	foreach mBuildings(building)
	{
		//`log_dui("searching for" @ prefabAsset.ObjectArchetype @ "; checking over:" @ building.Building.GetTownAsset() @ "in" @ building.Building.GetName());
			
		if(building.Building.GetTownAsset() == prefabAsset.ObjectArchetype)
		{
			return building.Building;
		}
		// emergeny compare in case town hall is in prefab but only village hall is build
		if(building.Building.GetTownAsset().GetType() == prefabAsset.GetType())
		{
			return building.Building;
		}
		assets = building.Building.GetTownAssets();
		for(i=0;i<assets.Length;i++)
		{
			//`log_dui("searching for" @ prefabAsset.ObjectArchetype @ "; found:" @ assets[i] @ "in" @ building.Building.GetName());
			if(assets[i] == prefabAsset.ObjectArchetype) return building.Building;
		}
	}
	return none;
}

// the building that has the asset exactly matched in secondary or typematched in primary
function H7TownAsset GetBestAssetForSlot(H7TownBuilding building,H7TownAsset asset)
{
	local H7TownBuildingData bestBuilding,currentBuilding;
	local array<H7TownAsset> assets;
	local int i;

	;

	bestBuilding = GetBestBuildingByBuilding(building);

	;

	if(bestBuilding.Building.GetTownAsset().GetType() == asset.GetType()) // primary asset
	{
		return bestBuilding.Building.GetTownAsset();
	}
	else // secondary asset
	{
		// now it could be that the best building does not have this type in his secondaries
		// we need to step down step by step to base versions until we find the building that has this asset-type in his secondaries
		currentBuilding = bestBuilding;
		while(currentBuilding.Building != none) // TODO this causes crash and endless loop if some buildings are deleted from the list (haven,moat,artillery?)
		{
			assets = currentBuilding.Building.GetTownAssets();
			for(i=0;i<assets.Length;i++)
			{
				if(assets[i].GetType() == asset.GetType())
				{
					return assets[i];
				}
			}
			currentBuilding.Building = GetBaseBuilding(currentBuilding.Building);
		}

		;
		return asset;
	}
	return none;
}

// get the building one step down, the one that has upgradeBuilding as upgrade
function H7TownBuilding GetBaseBuilding(H7TownBuilding upgradeBuilding)
{
	local H7TownBuildingData iBuilding;
	foreach mBuildingTreeTemplate(iBuilding)
	{
		if(IsBuildingEqual(iBuilding.Building.GetUpgrade(),upgradeBuilding))
		{
			return iBuilding.Building;
		}
	}
	;
	return none;
}


// !!! does not work, because assetInstance is not actually spawned based on an Archetype (link is lost through prefab)
function H7TownBuilding GetBuildingByAsset_BROKEN(H7TownAsset assetInstance)
{
	local H7TownBuildingData building;
	foreach mBuildings(building)
	{
		if(building.Building.GetTownAsset() == assetInstance.ObjectArchetype)
		{
			return building.Building;
		}
	}
	return none;
}

// returns first match
function H7TownBuilding GetBuildingByAssetType(String assetType)
{
	local H7TownBuildingData building;
	local array<H7TownAsset> assets;
	local int i;
	
	foreach mBuildings(building)
	{
		if( building.Building.GetTownAsset() != none && building.Building.GetTownAsset().GetType() == assetType) // first one to match gets returned
		{
			return GetBestBuilding(building).Building;
		}
		assets = building.Building.GetTownAssets();
		for(i=0;i<assets.Length;i++)
		{
			if(assets[i].GetType() == assetType) return GetBestBuilding(building).Building;
		}
	}
	return none;
}

// returns all match
function array<H7TownBuilding> GetBuildingsByAssetType(String assetType)
{
	local H7TownBuildingData building;
	local array<H7TownBuilding> foundBuildings;

	foreach mBuildings(building)
	{
		if( building.Building.GetTownAsset() != none && building.Building.GetTownAsset().GetType() == assetType)
		{
			foundBuildings.AddItem(building.Building);
		}
	}
	return foundBuildings;
}

native function FindBuildingsOfType(Class comparisonClass, out array<H7TownBuilding> resultList);

function bool CanAffordBuilding( H7TownBuilding building )
{
	local H7Player thePlayer;

	thePlayer = GetPlayer();

	return thePlayer.GetResourceSet().CanSpendResources( building.GetCost(Self) );
}

native function bool IsBuildingEqual(H7TownBuilding building1 , H7TownBuilding building2);

native function bool IsCapitolBuilt();
native function H7TownHall GetCapitol();
native function bool IsTownPortalBuilt();

// checks level,prerequisites,upgrade and alternate
native function bool CheckBuildingRequirements( H7TownBuilding building );

/**
 * Checks if a building is built in the town,
 * optionally can also get the building data
 * associated with the building by parameter.
 * 
 * @param building                      The building to be checked wheter if it's built or not
 * @param returnTrueIfUpgradeIsBuilt    If upgrade is build, the base is considered build automatically
 * @param data                          The building data of the built building
 * 
 * */
native function bool IsBuildingBuilt( H7TownBuilding Building, optional bool returnTrueIfUpgradeIsBuilt=false, optional bool returnTrueIfAlternateIsBuilt=false, optional out H7TownBuildingData data );
native function bool IsDwellingBuilt( H7TownBuilding Building, optional bool returnTrueIfUpgradeIsBuilt=false, optional bool returnTrueIfAlternateIsBuilt=false, optional out H7TownBuildingData data );


function bool IsBuildingBuiltByName( String buildingName, optional out H7TownBuildingData data )
{
	local H7TownBuildingData b;

	if( buildingName == "" )
	{
		;
		return false;
	}

	foreach mBuildings( b )
	{
		if( b.Building.GetName() == buildingName )
		{
			if( b.IsBuilt )
			{
				data = b;
				return true;
			}
		}
	}

	return false;
}

function bool IsBuildingBuiltByClass( class dasClass )
{
	local H7TownBuildingData b;

	if( dasClass == none )
	{
		;
		return false;
	}

	foreach mBuildings( b )
	{
		if( b.Building.Class == dasClass && b.IsBuilt )
		{
			return true;
		}
	}

	return false;
}

function H7TownBuilding GetUpgradeBase(H7TownBuilding building, optional bool useExistingBuildingList = false)
{
	local H7TownBuildingData data;
	local array<H7TownBuildingData> buildingList;
	
	buildingList = useExistingBuildingList ? mBuildings : mBuildingTreeTemplate;

	foreach buildingList( data )
	{
		if( data.Building.GetUpgrade() != none && data.Building.GetUpgrade().GetIDString() == building.GetIDString() )
		{
			return data.Building;
		}
	}

	return none;
}

function bool BuildBuildingForced( string buildingName )
{
	local H7TownBuildingData data, builtBuilding;
	local H7TownBuilding building;

	foreach mBuildingTreeTemplate( data )
	{
		if( data.Building.GetName() == buildingName )
		{
			building =  data.Building;
		}
	}

	if( building == none )
	{
		;
		return false;
	}

	foreach mBuildingTreeTemplate( data )
	{
		if( data.Building.GetName() == buildingName )
		{
			BuildBuildingComplete(data.Building.GetIDString(), false);

			if( data.Building.Class == class'H7TownMagicGuild' && H7TownMagicGuild(data.Building).GetRank() == SR_UNSKILLED && mGuildSpecialisation == ABILITY_SCHOOL_NONE )
			{
				foreach mBuildings(builtBuilding)
				{
					if(builtBuilding.Building.GetName() == buildingName)
					{
						//for a forced build the specialisation is choosen randomly
						H7TownMagicGuild(builtBuilding.Building).SelectRandomGuildSpecialisation(self);
						InitMagicGuilds();
						break;
					}
				}
			}

			return true;
		}
	}
	return false;
}

function SetReserveMultiplier( float m )
{
	local int i;
	local array<H7TownBuildingData> dwe;

	if( mReserveMultiplier == m ) return; // same? do nothing

	mReserveMultiplier = m;
	
	GetDwellings( dwe );
	
	for( i = 0; i < dwe.Length; ++i )
	{
		H7TownDwelling( dwe[i].Building ).ModifyReserve( m );
	}
}


function bool BuildBuilding( string buildingID )
{
	local H7TownBuildingData data;
	local H7TownBuilding building;
	local H7Player thePlayer;
	local H7InstantCommandBuildBuilding command;
	
	foreach mBuildingTreeTemplate( data )
	{
		if( data.Building.GetIDString() == buildingID )
		{
			building =  data.Building;
		}
	}

	if( building == none )
	{
		;
		return false;
	}

	thePlayer = GetPlayer();

	if( !CheckBuildingRequirements(building) ) 
	{
		;
		return false;
	}
	if( HasBuiltToday() )
	{
		;
		return false;
	}
	foreach mBuildingTreeTemplate( data )
	{
		if(data.Building.GetUpgrade() != none)
		{
			if( data.Building.GetUpgrade().GetIDString() == buildingID )
			{
				if( !IsBuildingBuilt( data.Building ) )
				{
					;
					return false;
				}
			}
		}
	}
	if( IsBuildingBuilt( building ) )
	{
		;
		return false;
	}
	if( !CanAffordBuilding( building ) )
	{
		;
		return false;
	}

	foreach mBuildingTreeTemplate( data )
	{
		if( data.Building.GetIDString() == buildingID )
		{
			if( thePlayer.GetResourceSet().CanSpendResources( data.Building.GetCost(self) ) )
			{
				command = new class'H7InstantCommandBuildBuilding';
				command.Init( self, buildingID );
				class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );

				return true;
			}
			return false;
		}
	}

	;
	return false;
}

function bool ConsumeTearOfAsha()
{
	if( mVisitingArmy != none && mVisitingArmy.GetHero().HasTearOfAsha() )
	{
		mVisitingArmy.GetHero().DestroyTearOfAsha();
		return true;
	}
	else if( mGarrisonArmy != none && mGarrisonArmy.GetHero().HasTearOfAsha() )
	{
		mGarrisonArmy.GetHero().DestroyTearOfAsha();
		return true;
	}
	else
	{
		return false;
	}
}

function BuildBuildingComplete( string buildingID, optional bool spendResources = true )
{
	local H7TownBuildingData data;
	local H7Player thePlayer;
	local bool wasTearConsumptionSuccessful;
	local JsonObject obj;

	thePlayer = GetPlayer();

	foreach mBuildingTreeTemplate( data )
	{
		if( data.Building.GetIDString() == buildingID )
		{
			// EVENT 

			if( thePlayer.GetResourceSet().CanSpendResources( data.Building.GetCost( self ) ) )
			{
				if( H7TownTearOfAsha( data.Building ) != none )
				{
					wasTearConsumptionSuccessful = ConsumeTearOfAsha();
					if( !wasTearConsumptionSuccessful )
					{
						;
						return;
					}
				}
				if( H7TownDwelling( data.Building ) != none )
				{
					CalculateLocalGuard( mBestGuardBuilding );
				}
				// subtract the player income right now, not from his actual resources, but from income array
				ModifyPlayerIncome( false );
				CreateBuilding(data.Building);
				if( spendResources )
				{
					thePlayer.GetResourceSet().SpendResources( data.Building.GetCost( self ) );
				}
				mHasBuilt = true;
				mBuildingsBuiltToday++;
				if(mBuildingsBuiltToday < mMaxBuildingsPerDay)
				{
					mHasBuilt = false;
				}

				/** TRACKING */
				if( !thePlayer.IsControlledByAI() && thePlayer.IsControlledByLocalPlayer())
				{
					obj = new class'JsonObject'();
					obj.SetIntValue("mapOrderId",class'H7PlayerProfile'.static.GetInstance().GetNumOfMapStarts() );
					obj.SetStringValue("mapID",  class'H7AdventureController'.static.GetInstance().GetMapSettings().mMapFileName );
					obj.SetStringValue("playerFaction", string(thePlayer.GetFaction().Name ));
					obj.SetIntValue("nbTurns", class'H7AdventureController'.static.GetInstance().GetCalendar().GetDaysPassed()); 
					obj.SetStringValue("buildingName",  data.Building.GetIDString()  );
					obj.SetIntValue("playerPosition", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() );
					//obj.SetStringValue("buildingType", string( data.Building.Type( GetSkillInstance(skillID).Name ));
					//obj.SetStringValue("buildingLevel", string( jrank ) );
					obj.SetIntValue("townlevel", GetLevel() );
					
					OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_CASTLE_BUILD","castle.build", obj );
				}
				// increase the player income with potentially new values
				ModifyPlayerIncome( true );

				if( data.Building.IsA( 'H7TownHall' ) ) // change the visual representation if we are upgrading our town hall
				{
					mMesh.SetStaticMesh( H7TownHall( data.Building ).GetMesh() );
				}

				if( data.Building.IsA('H7TownGuardGrowthEnhancer' ) )
				{
					H7TownGuardGrowthEnhancer( data.Building ).InitGrowthEnhancer( mLocalGuard );
				}

				DataChanged();

				if( data.Building.Class == class'H7TownMagicGuild' )
				{
					// InitMagicGuilds also adds spells to heroes
					InitMagicGuilds();
				}
				
				if( data.Building.Class == class'H7TownPortal')
				{
					// teach townportal spell to heros in the town
					if(GetVisitingArmy() != none && GetVisitingArmy().GetHero() != none)
						LearnSpells( mVisitingArmy.GetHero() );
					if(GetGarrisonArmy() != none && GetGarrisonArmy().GetHero() != none)
						LearnSpells( mGarrisonArmy.GetHero() );
				}
			}
			else
			{
				;
			}
		}
	}
}

function InitMagicGuilds()
{
	local int i;
				
	for(i = 0; i < mMagicGuilds.Length; i++)
	{
		if(!mMagicGuilds[i].GetSpellSetStatus() && mGuildSpecialisation != ABILITY_SCHOOL_NONE)
		{
			mMagicGuilds[i].InitSpells(mPredefinedMagicGuildSpells,self);
		}
	}

	UpdateMagicGuildMessage();

	//The new spells are added immediately to the player heroes spellbook
	if(GetVisitingArmy() != none && GetVisitingArmy().GetHero() != none)
		LearnSpells( mVisitingArmy.GetHero() );
	if(GetGarrisonArmy() != none && GetGarrisonArmy().GetHero() != none)
		LearnSpells( mGarrisonArmy.GetHero() );
}

function UpdateMagicGuildMessage()
{
	local H7Message message;
	local H7TownBuilding magicGuild;

	magicGuild = GetBuildingByType(class'H7TownMagicGuild');

	if(GetSpecialisation() == ABILITY_SCHOOL_NONE && magicGuild != none)
	{
		// already a message?
		message = class'H7MessageSystem'.static.GetInstance().GetMessageByReference(self,class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mMagicGuildSpec);
		if(message == none)
		{
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mMagicGuildSpec.CreateMessageBasedOnMe();
			message.mPlayerNumber = GetPlayerNumber();
			message.AddRepl("%town",GetName());
			message.settings.referenceObject = self;
			message.settings.referenceWindowCntl = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMagicGuildCntl(); 
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}
	else
	{
		// already a message?
		message = class'H7MessageSystem'.static.GetInstance().GetMessageByReference(self,class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mMagicGuildSpec);
		if(message != none)
		{
			class'H7MessageSystem'.static.GetInstance().DeleteMessage(message);
		}
	}
}



/**
 * Gets the best version of the building
 * that is currently built.
 * 
 * @param baseBuilding      The building from which to get the best version of
 * 
 * */
native function H7TownBuildingData GetBestBuilding( H7TownBuildingData baseBuilding );
native function H7TownBuildingData GetBestDwelling( H7TownBuildingData baseBuilding );




///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// GENERAL /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

function array<H7HeroAbility> GetAvailableSpells()
{
	local array<H7HeroAbility> availableSpells, currentSpells;
	local H7TownBuildingData data;
	local H7TownMagicGuild magicGuild;
	local int maxSpellCount, i;
	local bool arcaneLibraryBuild, hasTownPortalSpell;

	arcaneLibraryBuild = false;
	foreach mBuildings(data)
	{
		if(data.IsBuilt && data.Building.Class == class'H7TownArcaneLibrary')
		{
			arcaneLibraryBuild = true;
			break;
		}
	}

	hasTownPortalSpell = false;
	availableSpells.Length = 0;
	foreach mBuildings(data)
	{
		magicGuild = H7TownMagicGuild(data.Building);
		if(data.IsBuilt && magicGuild != None)
		{
			maxSpellCount = magicGuild.GetMaxSpellCount();

			if(magicGuild.GetRank() <= 2 && !arcaneLibraryBuild)
			{
				maxSpellCount -=2;
			}

			if(magicGuild.GetRank() > 2 && !arcaneLibraryBuild)
			{
				maxSpellCount--;
			}

			currentSpells = magicGuild.GetSpells();

			for(i=0; i<maxSpellCount; ++i)
			{
				if(i < currentSpells.Length)
				{
					if(availableSpells.Length == 0 || !AlreadyHasSpell(currentSpells[i], availableSpells))
					{
						availableSpells.AddItem(currentSpells[i]);
					}
				}
			}
		}
		else if(data.IsBuilt && H7TownPortal(data.Building) != none && !hasTownPortalSpell)
		{
			// TODO add Portal of Asha (do this more elegantly) #aftergamescom
			if( H7TownPortal(data.Building).mAbilitiyToLearn != none )
			{
				availableSpells.AddItem(H7TownPortal(data.Building).mAbilitiyToLearn);
				hasTownPortalSpell = true;
			}
		}
	}

	return availableSpells;
}

// checks if a spell (archetype) is already in the list provided
function bool AlreadyHasSpell(H7HeroAbility spell, array<H7HeroAbility> existing)
{
	local H7HeroAbility currentSpell;

	foreach existing(currentSpell)
	{
		if(currentSpell.IsEqual(spell))
			return true;
	}

	return false;
}

function H7Resource GetIncomeResource()
{
	return mIncomeResource;	// OPTIONAL moddable // per faction? // per map?
}

function String GetIncomeIcon()
{
	return GetIncomeResource().GetIconPath();
}

/**
 * Apply the town's income (from buildings) into the
 * resource set of the player who owns the town.
 * 
 * @param   addIncome       True if we want to ADD income, False if we want to SUBTRACT income
 * */
function ModifyPlayerIncome( bool addIncome )
{
	local H7TownBuildingData building;
	local H7ResourceQuantity buildingResource;
	local array<H7ResourceQuantity> buildingResources;
	local H7ResourceSet resourceSet;
	local array<H7TownBuildingData> checkedBuildings;

	if( mSiteOwner == PN_NEUTRAL_PLAYER ) return;

	resourceSet = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ).GetResourceSet();

	if( resourceSet == none ) return;

	foreach mBuildings( building )
	{
		// Get the best currently built building
		building = GetBestBuilding( building );
		if( building.IsBuilt && checkedBuildings.Find( 'Building', building.Building ) == INDEX_NONE && building.Building.ShouldDisplayIncome() )
		{
			// Do not allow duplicates! E.g. we have Village and Town hall: both would yield Town Hall, so we would get income from Town Hall twice! 
			// Avoid this using the checkedBuildings array
			checkedBuildings.AddItem( building );
			buildingResources = building.Building.GetIncome();
			// TODO apply modifiers!
			foreach buildingResources( buildingResource )
			{
				if( buildingResource.Type == none )
				{
					;
					continue;
				}
				if( addIncome ) { resourceSet.ModifyIncome( buildingResource.Type, buildingResource.Quantity ); }
				else            { resourceSet.ModifyIncome( buildingResource.Type, -buildingResource.Quantity ); }
			}
		}
	}
}

native function int GetIncomeByResource( H7Resource resourceType );

function int AiGetAmountMarketPlaces()
{
	local array<H7Town> towns;
	local H7Town town;
	local int numMaketPlaces;
	local array<H7TownBuildingData> buildings;
	local H7TownBuildingData building;

	towns = GetPlayer().GetTowns();

	foreach towns(town)
	{
		if(town!=None)
		{
			buildings = town.GetBuildings();
			foreach buildings(building)
			{
				if(building.Building.IsA('H7TownMarketplace')) numMaketPlaces++;
			}
		}
	}
	return numMaketPlaces;
}

function float AiCalculateTradeRateFactor( bool tradingPostBuff )
{
	local H7AdventureHero hero;
	local int numMarketPlaces, heroesAddRate;
	local float heroesMultRate;
	local array<H7AdventureHero> heroes;
	local float globalTradeModifier;
	globalTradeModifier = class'H7AdventureController'.static.GetInstance().GetGlobalTradeModifier();
	heroes = GetPlayer().GetHeroes();
	heroesAddRate   = 0.0f;
	heroesMultRate  = 1.0f;
	foreach heroes( hero )
	{
		if(hero!=None && hero.IsHero() && hero.IsDead()==false)
		{
			heroesAddRate  += hero.GetAddBoniOnStatByID(STAT_TRADE_RATE_BONUS);
			heroesMultRate *= hero.GetMultiBoniOnStatByID(STAT_TRADE_RATE_BONUS);
		}
	}
	numMarketPlaces = AiGetAmountMarketPlaces() + tradingPostBuff ? 2 : 0;
	return FClamp( ( ( 2.0f / ( numMarketPlaces + heroesAddRate + 1.0f ) ) - ( heroesMultRate - 1.0f ) ) * globalTradeModifier , 0.29f, 10.0f );
}

function AiDoTrade( string resourceToSell, int amountToSell, string resourceToBuy, int amountToBuy )
{
	local H7InstantCommandTransferResource command;
	command = new class'H7InstantCommandTransferResource';
	command.Init(GetPlayer(),GetPlayer(), resourceToSell, resourceToBuy, amountToSell, amountToBuy);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function bool AiAutotradeResources( H7Resource needResource )
{
	local H7Player                  thisPlayer;
	local H7TownMarketplace         marketPlace;
	local H7TradingTable            tradingTable;
	local H7ResourceSet             resourceSet;
	local array<ResourceStockpile>  resources;
	local ResourceStockpile         resource;
	local int                       resNeed, resBuy, resSell;
	local int                       resGreed, resGreedMin;
	local H7Resource                resNeedItem;
	local H7Resource                resGreedItem;
	local float                     tradeRateFactor;
	local float                     tradeRate;
	local int                       notionalSell;
	local array<H7Town>             towns;
	local H7Town                    tmpTown;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	thisPlayer=GetPlayer();
	if(thisPlayer==None) // hmmmm ?
	{
		return false;
	}
	if(thisPlayer.IsControlledByAI()==false || thisPlayer.GetPlayerNumber()==PN_NEUTRAL_PLAYER) // exclusive Ai function. go away humans!
	{
		return false;
	}

	// check if there is a marketplace

	// check if there is a marketplace
	towns = GetPlayer().GetTowns();
	foreach towns( tmpTown )
	{
		marketPlace = H7TownMarketPlace(tmpTown.GetBuildingByType(class'H7TownMarketplace'));
		if( marketPlace != none )
		{
			break;
		}
	}

	if(marketPlace==None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return false;
	}

	
	tradeRateFactor=AiCalculateTradeRateFactor(true);
	tradingTable=marketPlace.GetTradingTable();
	
	// now we get the current stock of the player
	resourceSet=thisPlayer.GetResourceSet();
	resources=resourceSet.GetAllResourcesAsArray();

	//if(needResource==resourceSet.GetCurrencyResourceType())
	//{
		//`LOG_AI("  We never trade for gold. Aborting..." );
		//return false;
	//}

	// get the need for resource directly from the need pools
	resNeedItem=needResource;
	resNeed=thisPlayer.GetAiNeedTownDev().GetResource(needResource) + thisPlayer.GetAiNeedRecruitment().GetResource(needResource);
	// false alarm. just return
	if(resNeed==0) return false;

	// determine, what we do trade away
	resGreedMin         = 0;
	resGreedItem        = None;
	foreach resources(resource)
	{
		if( resource.Type!=needResource ) // do not trade the same for the same, as it would corrupt the world of Ashan
		{
			if( resource.Quantity<=resource.Type.GetTradeThreshold(false) ) // below greed, we don't touch it
			{
				resGreed    = 0;
			}
			else // above greed
			{
				// TODO: we could factor in trade rates to improve it?
				resGreed    = resource.Quantity - resource.Type.GetTradeThreshold(false);
			}
			if( resGreed > resGreedMin )
			{
				resGreedMin     = resGreed;
				resGreedItem    = resource.Type;
			}
		}
	}

	// extra handling for gold as its not part of the above deal

/* we don't trade away gold ...
	if( resourceSet.GetCurrency() <= resourceSet.GetCurrencyResourceType().GetTradeThreshold(true) )
	{
		resGreed        = 0;
		resGreedStress  = 911.0f;
	}
	else if( resourceSet.GetCurrency() <= resourceSet.GetCurrencyResourceType().GetTradeThreshold(false) )
	{
		resGreed        = resourceSet.GetCurrency() -  resourceSet.GetCurrencyResourceType().GetTradeThreshold(true);
		resGreedStress  = float(resGreed) / float(resourceSet.GetCurrencyResourceType().GetTradeThreshold(false) - resourceSet.GetCurrencyResourceType().GetTradeThreshold(true));
	}
	else
	{
		resGreed        = resourceSet.GetCurrency() - resourceSet.GetCurrencyResourceType().GetTradeThreshold(true);
		resGreedStress  = 0.0f;
	}

	if( resGreedStress < resGreedStressMin )
	{
		resGreedStressMin   = resGreedStress;
		resGreedMin         = resGreed;
		resGreedItem        = resource.Type;
	}
*/

	if( resNeedItem!=None && resGreedItem!=None && resGreedMin>0 )
	{
		// check the stock market for pricing
		if( resNeedItem == resourceSet.GetCurrencyResourceType() )
		{
			tradeRate = 1 / tradingTable.GetSellValue( resGreedItem, tradeRateFactor );
		}
		else
		{
			tradeRate = tradingTable.GetRate( resGreedItem, resNeedItem, tradeRateFactor );
		}
		if(tradeRate==0)
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return false;
		}
		// calculate how much we can afford
		
		notionalSell = resGreedMin / tradeRate;

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ; 
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		if( notionalSell >= resNeed ) // limit deal to need
		{
			if( resNeedItem == resourceSet.GetCurrencyResourceType() )
			{
				resBuy = FCeil( resNeed * tradeRate ) / tradeRate;
			}
			else
			{
				resBuy = resNeed;
			}

			resSell = resBuy * tradeRate;
		}
		else if( notionalSell > 0 )
		{
			resBuy  = notionalSell;
			resSell = resBuy * tradeRate;
		}
		else
		{
			// no deal :(
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return false;
		}

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		AiDoTrade( resGreedItem.GetName(), resSell, resNeedItem.GetName(), resBuy );

		return true;
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	
	return false;
}

function String GetInfoIconPath(optional out String tooltip) 
{
	local Texture2d icon;

	if(HasBuiltToday())
	{
		icon = Texture2D'H7ButtonIcons.ICO_blocks_gray';
		tooltip = "TT_TOWN_HAS_BUILT";
	}
	else
	{
		if(IsFullyBuilt())
		{
			icon = Texture2D'H7ButtonIcons.ICO_bocks_gold';
			tooltip = "TT_TOWN_IS_COMPLETE";
		}
		else if(HasResourcesToBuild())
		{
			icon = Texture2D'H7ButtonIcons.ICO_blocks_green';
			tooltip = "TT_TOWN_HAS_RESOURCE";
		}
		else
		{
			icon = Texture2D'H7ButtonIcons.ICO_blocks_red';
			tooltip = "TT_TOWN_HAS_NO_RESOURCE";
		}
	}

	return "img://" $ PathName(icon);
}

function bool IsFullyBuilt()
{
	local int i;

	for( i = 0; i < mBuildingTreeTemplate.Length; ++i )
	{
		if( !IsBuildingBuilt( mBuildingTreeTemplate[i].Building, true, true ) )
		{
			return false;
		}
	}

	return true;
}

function bool HasResourcesToBuild() // have resources for at least one _available_ building
{
	local int i;

	for( i = 0; i < mBuildingTreeTemplate.Length; ++i )
	{
		// building is not yet built but the requirements are there
		if( !IsBuildingBuilt(mBuildingTreeTemplate[i].Building, true, true ) && CheckBuildingRequirements( mBuildingTreeTemplate[i].Building ) )
		{
			// could the player buy it?
			if( GetPlayer().GetResourceSet().CanSpendResources( mBuildingTreeTemplate[i].Building.GetCost() ) )
			{
				return true;
			}
		}
	}

	// nope, player's poor and can't build anything
	return false;
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	if(!extendedVersion)
	{
		//data.type = TT_TYPE_STRING;
		//data.strData = "<font size='#TT_TITLE#'>" $ GetName() @ "</font>\n<font size='#TT_SUBTITLE#'>" $ class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(GetPlayerNumber()).GetName()@"</font>";
		data.type = TT_TYPE_TOWN;
		data.addRightMouseIcon = true;
	}
	else
	{
		data.type = TT_TYPE_TOWN;
	}
		
	return data;
}

function UpdateLocalGuardGUI()
{
	if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != none 
		&& class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetSite() == self)
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetMiddleHUD().SetDataFromTown(self);
}

function OnRightClick() 
{
	
}

function OnDoubleClick()
{
	OpenTownScreenForMe();
}

function array<H7TownDwelling> DoSabotage()
{
	local array<H7TownBuildingData> dwellings;
	local array<H7TownDwelling> sabotagedDwellings;
	local int i, rand;

	GetDwellings( dwellings );

	for( i = dwellings.Length - 1; i >= 0; --i )
	{
		if( dwellings[i].Building == none ) { continue; }
		// no sabotage for Champions or already sabotaged buildings
		if( H7TownDwelling( dwellings[i].Building ).GetCreaturePool().Creature.GetTier() == CTIER_CHAMPION || H7TownDwelling( dwellings[i].Building ).IsSabotaged() )
		{
			dwellings.Remove( i, 1 );
		}
	}

	if( dwellings.Length > 0 )
	{
		rand = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( dwellings.Length );
		H7TownDwelling( dwellings[ rand ].Building ).SetSabotaged( true );
		sabotagedDwellings.AddItem(H7TownDwelling( dwellings[ rand ].Building ));
	}
	
	return sabotagedDwellings;
}

function AiSelectSchool()
{
	local H7InstantCommandSelectSpecialisation command;
	local H7Faction satisfaction;
	local EAbilitySchool forbidden, preferred;
	local array<EAbilitySchool> allSchools;
	

	// what can I pick, that is the question ...
	satisfaction=GetFaction();
	forbidden=satisfaction.GetForbiddenAbilitySchool();
	preferred=satisfaction.GetPreferredAbilitySchool();
	
	if( forbidden!=AIR_MAGIC && preferred!=AIR_MAGIC ) allSchools.AddItem(AIR_MAGIC);
	if( forbidden!=DARK_MAGIC && preferred!=DARK_MAGIC ) allSchools.AddItem(DARK_MAGIC);
	if( forbidden!=EARTH_MAGIC && preferred!=EARTH_MAGIC ) allSchools.AddItem(EARTH_MAGIC);
	if( forbidden!=FIRE_MAGIC && preferred!=FIRE_MAGIC ) allSchools.AddItem(FIRE_MAGIC);
	if( forbidden!=LIGHT_MAGIC && preferred!=LIGHT_MAGIC ) allSchools.AddItem(LIGHT_MAGIC);
	if( forbidden!=PRIME_MAGIC && preferred!=PRIME_MAGIC ) allSchools.AddItem(PRIME_MAGIC);
	if( forbidden!=WATER_MAGIC && preferred!=WATER_MAGIC ) allSchools.AddItem(WATER_MAGIC);

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	command = new class'H7InstantCommandSelectSpecialisation';
	command.Init(self, allSchools[ Rand(allSchools.Length) ]);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);	
}

function OnVisit( out H7AdventureHero hero )
{
	local bool openTownScreen;

	if( hero.IsA('H7Caravan') || hero.GetCell() != GetEntranceCell() && hero.GetPlayer() == GetPlayer() )
		return;
	
	openTownScreen = !hero.GetPlayer().IsPlayerHostile( GetPlayer() ) && !hero.GetPlayer().IsPlayerAllied( GetPlayer() );
	if( openTownScreen )
	{
		OpenTownScreenForMe();
	}

	super.OnVisit( hero );

	;

	if(self.mSiteOwner == hero.GetPlayer().GetPlayerNumber())
	{
		LearnSpells( hero );
	}

	if( hero.GetPlayer().IsControlledByAI() )
	{
		if( class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled() )
		{
			if(mGuildSpecialized==true)
			{
				return;
			}
			if( IsBuildingBuiltByClass(class'H7TownMagicGuild')==true )
			{
				AiSelectSchool();
			}
		}
		return;
	}
	
	else if( hero.GetPlayer().IsPlayerAllied( GetPlayer() ) ) // allied visit
	{
		class'H7MessageSystem'.static.GetInstance().CreateFloat(FCT_ERROR, self.Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("MSG_TOWN_ALLIED_VISIT","H7Message") );
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
	}
	else if( hero.GetPlayer().IsPlayerHostile( GetPlayer() ) ) // enemy visit 
	{
		class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnTakeOverSound,true,true, self.Location);
	}
}

// Called when visiting army is exiting the town
function OnLeave()
{
	local H7EventContainerStruct container;

	if(mVisitingArmy != none && mVisitingArmy.GetHero() != none)
	{
		container.Targetable = mVisitingArmy.GetHero();

		TriggerEvents(ON_LEAVE, false, container);
	}

}

function LearnSpells(H7AdventureHero hero)
{
	local array<H7HeroAbility> availableSpells;
	local H7HeroAbility currentSpell;
	local H7Message message;
	local string tooltip;
	local bool learnCurrentSpell,learnAnySpell;
	local H7HeroEventParam eventParam;

	if(hero == None || !hero.IsHero())
	{
		return;
	}

	availableSpells = GetAvailableSpells();
	foreach availableSpells(currentSpell)
	{
		learnCurrentSpell = false;
		if( !hero.GetAbilityManager().HasAbility(currentSpell) &&
			currentSpell.GetRank() <= hero.GetArcaneKnowledge() &&
			hero.GetFaction().GetForbiddenAbilitySchool() != currentSpell.GetSchool() )
		{
			learnCurrentSpell = true;
		}

		if(learnCurrentSpell)
		{
			learnAnySpell = true;
			hero.GetAbilityManager().LearnAbility(currentSpell);
			tooltip = tooltip $ "\n" $ "<img src='" $ currentSpell.GetFlashIconPath() $ "' width='#TT_BODY#' height='#TT_BODY#'>" @ currentSpell.GetName();

			//trigger hero learn spell event
			eventParam = new class'H7HeroEventParam';
			eventParam.mEventHeroTemplate = hero.GetSourceArchetype();
			eventParam.mEventPlayerNumber = hero.GetPlayer().GetPlayerNumber();
			eventParam.mEventLearnedAbility = currentSpell;
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnSpell', eventParam, hero);
		}
	}

	if(learnAnySpell)
	{
		message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroSpellLearned.CreateMessageBasedOnMe();
		message.mPlayerNumber = hero.GetPlayer().GetPlayerNumber();
		message.AddRepl("%hero",hero.GetName());
		message.settings.referenceObject = hero;
		message.settings.referenceWindowCntl = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetSpellbookCntl(); 
		tooltip = message.GetFormatedText() $ tooltip;
		message.mTooltip = tooltip;
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}
}

function SetSiteOwner( EPlayerNumber newOwner, optional bool showPopup = true  )
{
	local H7TownHall capitol;
	local int i;

	if(mSiteOwner == newOwner)
	{
		return; // Already owned
	}

	// kill the capitol if the player already has one built
	if( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( newOwner ).HasCapitol() && IsCapitolBuilt() )
	{
		capitol = GetCapitol();
		i = mBuildings.Find( 'Building', capitol );
		DestroyBuildingByIndex( i, false );
	}

	ModifyPlayerIncome( false );
	SetGovernorComplete(none);
	super.SetSiteOwner( newOwner, showPopup );
	ModifyPlayerIncome( true );
	mHasUncheckedCaravans = false;
}

function OpenTownScreenForMe()
{
	if(!GetPlayer().IsControlledByLocalPlayer())
	{
		return;
	}

	if( self.GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() && !GetPlayer().IsControlledByAI() )
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GotoTownScreen( self );
	}
	else if( GetPlayer().IsPlayerHostile( class'H7AdventureController'.static.GetInstance().GetLocalPlayer() ) && !GetPlayer().IsControlledByAI() )
	{
		class'H7MessageSystem'.static.GetInstance().CreateFloat(FCT_ERROR, self.Location, class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), "Cannot open town screen for enemy town!" );
	}
	else if( !GetPlayer().IsControlledByAI() )
	{
		class'H7MessageSystem'.static.GetInstance().CreateFloat(FCT_ERROR, self.Location, class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), "Cannot open town screen for allied town!" );
	}
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// UNITS ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

function ProduceUnits()
{
	local array<H7TownBuildingData> dwellings;
	local H7TownBuildingData dwelling;

	GetDwellings( dwellings );

	foreach dwellings( dwelling )
	{
		H7TownDwelling( dwelling.Building ).ProduceUnits( GetGrowthBonus( H7TownDwelling( dwelling.Building ).GetCreaturePool().Creature,,H7TownDwelling( dwelling.Building )  ) );
	}
}

native function bool ProducesUnit(H7Creature creature);
native function bool ProducesTier(ECreatureTier tier);

/**
 * Gets all built dwellings. If any are upgraded, gets the best version of them.
 * 
 * */
native function GetDwellings( out array<H7TownBuildingData> dwellings );

/**
 * Gets all built growth buildings
 * 
 * */
function array<H7TownBuildingData> GetGrowthBuildings()
{
	local H7TownBuildingData building;
	local array<H7TownBuildingData> growthBuildings;

	foreach mBuildings( building )
	{
		if( building.Building.IsA( 'H7TownGrowthEnhancer' ) && building.IsBuilt )
		{
			growthBuildings.AddItem( building );
		}
	}

	return growthBuildings;
}

/**
 * Gets all Local Guard growth buildiungs
 */

native function array<H7TownGuardGrowthEnhancer> GetGuardGrowthBuildings();

/**
 * Gets the growth bonus for the specified creature in the town.
 * Can optionally store modifier data into an out array, which
 * holds the value, category and original source of the bonus.
 * 
 * @param creature      The creature for which the growth bonus needs to be found
 * @param modifiers     An array of structs which hold the Value, Category and Source of a bonus
 * @param townDwelling  Town dwelling for which we calculate the growth bonus with effect modifier
 * 
 * */
function int GetGrowthBonus( H7Creature creature, optional out array<H7TooltipModifierInfo> modifiers, optional H7TownDwelling townDwelling )
{
	local H7TownBuildingData growthBuilding;
	local array<H7TownBuildingData> growthBuildings;
	local int growthBonus;
	local H7TooltipModifierInfo modifier;
	local H7TownGrowthEnhancer growthBooster;
	local H7Creature growthCreature;
	local int modifiedBonus;

	growthBuildings = GetGrowthBuildings();

	// building bonuses
	foreach growthBuildings( growthBuilding )
	{
		growthBooster = H7TownGrowthEnhancer( growthBuilding.Building );
		// if we don't have the base creature, get the base creature
		if( creature.GetBaseCreature() != none ) creature = creature.GetBaseCreature();

		// the base creature should be set in the editor correctly!
		if( growthBooster.GetCreatureType().GetBaseCreature() != none )
		{
			growthCreature = growthBooster.GetCreatureType().GetBaseCreature();
		}
		else                                                           
		{ 
			growthCreature = growthBooster.GetCreatureType(); 
		}

		if( growthCreature.GetName() == creature.GetName() )
		{
			if( townDwelling != none )
			{
				// Take into account the modifier from Effect (ex. Week of Plague)
				modifiedBonus = growthBooster.GetBonus() * townDwelling.GetModifiedStatByID(STAT_GROWTH_BONUS_PRODUCTION);
			}
			else
			{
				modifiedBonus = growthBooster.GetBonus();
			}

			
			growthBonus += modifiedBonus ;
			modifier.Value = modifiedBonus;
			// hardcoded for now
			modifier.Category = "Buildings";
			modifier.Source = growthBooster.GetName();
			
			modifiers.AddItem( modifier );
		}
	}

	return growthBonus;
}

/**
 * Gets the creature pool for this town from its dwellings
 * 
 * */
function array<H7DwellingCreatureData> GetCreaturePool()
{
	local array<H7DwellingCreatureData> creaturePool;
	local array<H7TownBuildingData> dwellings;
	local H7TownBuildingData dwelling;

	GetDwellings( dwellings );

	foreach dwellings( dwelling )
	{
		creaturePool.AddItem( H7TownDwelling( dwelling.Building ).GetCreaturePool() );
	}

	return creaturePool;
}

function bool HasRequiredDwelling( H7Creature upgradedCreature )
{
	local array<H7TownBuildingData> dwellings;
	local H7TownBuildingData dwelling;
	local array <H7Creature> creatures;
	local H7Creature creature;

	if( mHasRequiredDwellingFor.Find( upgradedCreature ) != INDEX_NONE ) { return true; }

	GetDwellings( dwellings );
	foreach dwellings( dwelling )
	{
		creatures = H7TownDwelling( dwelling.Building ).GetRecruitableCreatures();
		foreach creatures( creature )
		{
			if(creature == upgradedCreature) 
			{
				mHasRequiredDwellingFor.AddItem( upgradedCreature );
				return true;
			}
		}
	}
	return false;
}

function bool CanRecruitHero(H7EditorArmy armyToRecruit)
{
	if(GetGarrisonArmy().CanMergeArmy(H7AdventureArmy(armyToRecruit)))
		return true;

	if(GetVisitingArmy() == none)
		return true;
	else if(GetVisitingArmy().CanMergeArmy(H7AdventureArmy(armyToRecruit)))
		return true;
	
	// garrison is full and there is a visiting army or the entrance cell is occupied
	/*if( GetGarrisonArmy().GetHero().IsHero() && ( GetVisitingArmy() != none || GetEntranceCell().GetArmy() != none ) )
	{
		return false;
	}*/
	return false;
}

function bool RecruitHero( int heroId )
{
	local H7InstantCommandRecruitHero   command;
	local array<RecruitHeroData>        heroData;
	local int                           k;
	local array<int>                    heroIdPool;

	// if called by Ai to pick any hero randomly from the pool
	if( heroId==-1 )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		heroData = class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( GetPlayer(), self );
		for(k=0;k<heroData.Length;k++)
		{
			if( heroData[k].IsAvailable==true && heroData[k].Cost<=GetPlayer().GetResourceSet().GetCurrency()
				&& CanRecruitHero(heroData[k].Army))
			{
				heroIdPool.AddItem( heroData[k].Army.GetHero().GetID() );
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
		}
		if(heroIdPool.Length<=0) { return false; }
		k = Rand(heroIdPool.Length);
		heroId=heroIdPool[k];
	}

	command = new class'H7InstantCommandRecruitHero';
	command.Init( self, heroId );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	return true;
}

function bool RecruitHeroComplete( int heroId )
{
	local H7EventContainerStruct container;
	local H7AdventureArmy recruitedArmy; // the hero form part of an army
	local H7AdventureController advCntl;

	advCntl = class'H7AdventureController'.static.GetInstance();

	if( GetGarrisonArmy() != none && GetGarrisonArmy().GetHero().IsHero() && GetVisitingArmy() != none && GetVisitingArmy().GetHero().IsHero() )
	{
		;
		return false;
	}

	recruitedArmy = advCntl.GetHallOfHeroesManager().RecruitHero( GetPlayer(), self, heroId );
	class'H7ReplicationInfo'.static.PrintLogMessage("RecruitHeroComplete:"@heroId@recruitedArmy@"Player:"@GetPlayer(), 0);;
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMinimap().AddHero(recruitedArmy.GetHero());
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMinimap().UpdateVisibility();

	LearnSpells(recruitedArmy.GetHero());

	if( recruitedArmy != none )
	{
		if( recruitedArmy.CanMergeArmy( GetGarrisonArmy() ) )
		{
			recruitedArmy.MergeArmy( GetGarrisonArmy() );
			SetGarrisonArmy( recruitedArmy );
		}
		else
		{
			if( recruitedArmy.GetPlayer().IsControlledByAI() && 
				!GetGarrisonArmy().GetHero().IsHero() && 
				recruitedArmy.GetStrengthValue( false ) * 2 < GetGarrisonArmy().GetStrengthValue( false ) )
			{
				recruitedArmy.ClearCreatureStackProperties(); // make way for better troops!

				if( recruitedArmy.CanMergeArmy( GetGarrisonArmy() ) ) // try again
				{
					recruitedArmy.MergeArmy( GetGarrisonArmy() );
					SetGarrisonArmy( recruitedArmy );
				}
				else
				{
					SetVisitingArmy( recruitedArmy );
					recruitedArmy.SetCell( GetEntranceCell() );
					recruitedArmy.ShowArmy();
				}
			}
			else
			{
				SetVisitingArmy( recruitedArmy );
				recruitedArmy.SetCell( GetEntranceCell() );
				recruitedArmy.ShowArmy();
			}
		}
		// in case the hero was dead once, attach his/her army again (else it'll be invisible)
		recruitedArmy.SetLocation(recruitedArmy.GetHero().Location);
		recruitedArmy.SetHardAttach(true);
		recruitedArmy.SetBase(recruitedArmy.GetHero());
		advCntl.AddArmy( recruitedArmy );
		container.Targetable = recruitedArmy.GetHero();
		// inform calendar about new hero (in case of special weeks)
		advCntl.GetCalendar().UpdateWeekEvents( ON_HERO_RECRUIT, false, container );
		// inform everything else about the new hero
		advCntl.UpdateEvents(ON_HERO_RECRUIT, GetPlayerNumber(), container);

		return true;
	}
	else
	{
		;
		return false;
	}
}

function array<H7Town> GetCurrentCaravanSources()
{
	return mCurrentCaravanSources;
}

function AddCaravanSource( H7Town town )
{
	mCurrentCaravanSources.AddItem( town );
}

function ClearCaravanSources()
{
	mCurrentCaravanSources.Length = 0;
}

function H7Town GetCurrentCaravanTarget()
{
	return mCurrentCaravanTarget;
}

function SetCurrentCaravanTarget( H7Town town )
{
	mCurrentCaravanTarget = town;
}

function Conquer( H7AdventureHero conqueror )
{
	local H7Player losingPlayer,winningPlayer;
	local H7Town lastTown;
	local array<H7Town> towns;

	losingPlayer = GetPlayer();

	super.Conquer( conqueror );
	ClearLocalGuardReserve();

	winningPlayer = GetPlayer();

	// assets handling
	if(losingPlayer == class'H7AdventureController'.static.GetInstance().GetLocalPlayer()
		&& !losingPlayer.HasTownsOfFaction(mFaction)
		&& !class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		UnLoadTownAssets();
	}
	if(winningPlayer == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
	{
		LoadTownAssets(true);
	}
	conqueror.GetPlayer().SetLastConqueredTown( self );
	if( losingPlayer.GetLastConqueredTown() == self )
	{
		towns = losingPlayer.GetTowns();
		if( towns.Length > 0 )
		{
			lastTown = towns[0];
		}
		losingPlayer.SetLastConqueredTown( lastTown );
	}
}

// delayed false = load all (on map start) + townscreen
// delayed true = load over the next frames (on conquer) - townscreen (will be loaded on first enter, like it was released)
function LoadTownAssets(optional bool delayed=false)
{
	local H7TownBuildingData data;

	if(!delayed)
	{
		GetTownScreen();
		foreach mBuildings( data )
		{
			data.Building.GetTownAsset();
			data.Building.GetTownAssets();
		}
	}
	else
	{
		foreach mBuildings( data )
		{
			class'H7TownAssetLoader'.static.GetInstance().AddToLoadingQueue(data.Building);
		}
		class'H7PlayerController'.static.GetPlayerController().GetTownAssetLoader().ProcessQueueNextFrame();
	}
}

function UnLoadTownAssets()
{
	local H7TownBuildingData data;
	DelFactionTownScreenRef();
	foreach mBuildings( data )
	{
		data.Building.DelTownAsset();
		data.Building.DelTownAssets();
	}
}

function Hide()
{
	super.Hide();
	// Visiting hero is not visiting anymore
}

function Reveal()
{
	super.Reveal();
}

function String GetIconPath()
{
	local H7TownBuildingData tmpData;
	tmpData.Building = GetBuildingByType(class'H7TownHall');
	return GetBestBuilding(tmpData).Building.GetFlashIconPath();
}

// Game Object needs to know how to write its data into GFx format
function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	local String infoIconTT;

	data.SetInt("TownID",GetID());
	data.SetString("TownName",GetName());
	data.SetInt("TownLevel",GetLevel());
	data.SetString("TownTooltip",GetName() $ "\n" $ Repl(class'H7Loca'.static.LocalizeSave("LEVEL_X","H7General"),"%level",GetLevel()) @ "-" @ GetFaction().GetName());
	data.SetString("TownFactionIcon",GetIconPath());
	data.SetString("TownInfoIcon",GetInfoIconPath(infoIconTT));
	data.SetString("TownInfoIconTooltip",infoIconTT);
	
	data.SetInt( "TownIncome", GetIncomeByResource( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ).GetResourceSet().GetCurrencyResourceType() ) );
	data.SetString("TownIncomeIcon",GetIncomeIcon());
	data.SetBool("TownHasMarket",GetBuildingByType(class'H7TownMarketplace') != none);

	// TODO waiting for town lore texts
	data.SetString("TownLore","blabla");
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

event PostSerialize()
{
	local H7TownBuildingData data;
	super.PostSerialize();

	foreach mBuildings( data )
	{
		if( H7TownDwelling( data.Building ) != none )
		{
			mDwellings.AddItem( data ); // reinit dwellings
		}
	}

	if( GetPlayerNumber() != PN_NEUTRAL_PLAYER && GetPlayer().GetStatus() == PLAYERSTATUS_ACTIVE )
	{
		ModifyPlayerIncome( true );
	}
}

/* Logs current game state for OOS */
function DumpCurrentState()
{
	local int i;
	class'H7ReplicationInfo'.static.PrintLogMessage("   "@GetName()@"ID:"@GetID()@"Location"@GetEntranceCell().GetCellPosition().X@GetEntranceCell().GetCellPosition().Y@"Level:"@GetLevel(), 0);;
	class'H7ReplicationInfo'.static.PrintLogMessage("    Buildings:", 0);;

	for( i = 0; i < mBuildings.Length; ++i )
	{
		if(mBuildings[i].IsBuilt)
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("     "@mBuildings[i].Building.GetName(), 0);;
		}
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

