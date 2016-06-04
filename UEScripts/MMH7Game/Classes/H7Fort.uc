/*=============================================================================
* H7Fort
* =============================================================================
*  Class for adventure map objects that serve as Forts.
* =============================================================================
*  Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Fort extends H7AreaOfControlSiteLord
	implements (H7ITooltipable)
	dependson (H7ITooltipable)
	placeable
	native;

// if left empty will use the default siege map for forts
var(Properties) protected string mCombatMapName<DisplayName=Siege combat map>;

var(Visuals, Destruction) protected StaticMesh mMeshRuined<DisplayName=Mesh Ruined>;
var(Visuals, Destruction) protected Vector mMeshRuinedScale<DisplayName=Mesh Ruined Scale>;
var(Visuals, Destruction) protected ParticleSystem mFXRuined<DisplayName=FX Ruined>;
var(Visuals, Destruction) protected MaterialInstanceConstant mMaterialRuined<DisplayName=Material Ruined>;
var(Visuals, Destruction) protected Vector mFXRuinedScale<DisplayName=FX Ruined Scale>;
var(Properties) protected savegame bool mIsFractured<DisplayName="Is destroyed">;

var(Visuals, Rebuilding) ParticleSystem mRebuildEffect<DisplayName=Rebuild Particle Effect>;
var(Visuals, Destruction) ParticleSystem mDestroyEffect<DisplayName=Destroy Particle Effect>;
/** Resources needed to rebuild this fort */
var(Resources) protected array<H7ResourceQuantity> mRebuildCost<DisplayName=Rebuild Cost>;

/** The speed factor for destruction, multiplied by the regular destruction time of 1 second */
var(Visuals, Destruction) protected float mDestroySpeed;
/** The amount of rotation the destruction animation will blend to */
var(Visuals, Destruction) protected Rotator mDestroyRotation;
/** How much time (percent) it takes to do the destruction rotation */
var(Visuals, Destruction) protected float mDestroyRotationTimePct;
/** The speed factor for rebuilding, multiplied by the regular rebuilding time of 1 second */
var(Visuals, Rebuilding) protected float mRebuildSpeed;
/** How much time after rebuild is done to spawn the regular particles */
var(Visuals, Destruction) protected float mFXRebuildTime;

var(SiegeBuildings) dynload protectedwrite H7CombatMapTower					mSiegeObstacleTower<DisplayName="Siege obstacle Tower">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapWall					mSiegeObstacleWall<DisplayName="Siege obstacle Wall">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapMoat					mSiegeObstacleMoat<DisplayName="Siege obstacle Moat">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapGate					mSiegeObstacleGate<DisplayName="Siege obstacle Gate">;
var(SiegeBuildings) protectedwrite array<H7EditorSiegeDecoration>	        mSiegeDecorationList<DisplayName="List of Siege Decorations">; //TODO: dynload

var protected StaticMesh mOriginalMesh;
var protected Vector mOriginalMeshScale, mOriginalMeshTranslation, mOriginalFXScale, mOriginalFXTranslation;
var protected Rotator mOriginalMeshRotation, mOriginalFXRotation;
var protected ParticleSystem mOriginalFX;
var array<MaterialInstanceConstant> mRebuildMats;

var protected bool mIsDestroying, mIsRebuilding;
var protected float mDestroyedPercent, mRebuildPercent, mOriginalFloatScale, mOriginalFXFloatScale;

var protected H7AdventureHero mVisitingHero;

native function EUnitType GetEntityType();

function StaticMesh GetMeshRuined() { return mMeshRuined; }
function Vector GetMeshRuinedScale() { return mMeshRuinedScale; }
function ParticleSystem	GetFXRuined() { return mFXRuined; }
function MaterialInstanceConstant GetMaterialRuined() { return mMaterialRuined; }
function Vector GetFXRuinedScale() { return mFXRuinedScale; }
function ParticleSystem GetRebuildFX() { return mRebuildEffect; }
function ParticleSYstem GetDestroyFX() { return mDestroyEffect; }
function array<H7ResourceQuantity> GetRebuildCost() { return mRebuildCost; }
function float GetDestroySpeed() { return mDestroySpeed; }
function Rotator GetDestroyRotation() { return mDestroyRotation; }
function float GetDestroyRotationTime() { return mDestroyRotationTimePct; }
function float GetRebuildSpeed() { return mRebuildSpeed; }
function float GetFXRebuildTime() { return mFXRebuildTime; }

function bool       IsRuined()                              { return mIsFractured; }
function SetRuined( ) 
{ 
	mIsFractured = true;
	SetSiteOwner(PN_NEUTRAL_PLAYER, false); 
}
function string				GetCombatMapName()		{ return mCombatMapName; }

function array<H7EditorSiegeDecoration>  GetCombatMapDecoList()
{ 
	if( mFaction != none && self != mFaction.GetStartFort() )
	{
		return mFaction.GetStartFort().GetCombatMapDecoList();
	}
	/*if( mSiegeDecorationList.Length == 0 )  self.DynLoadObjectProperty('mSiegeDecorationList');*/ 
	return mSiegeDecorationList;
} //TODO: dynload

function H7CombatMapTower GetCombatMapTower()
{
	if( mFaction != none && self != mFaction.GetStartFort() )
	{
		return mFaction.GetStartFort().GetCombatMapTower();
	}
	if( mSiegeObstacleTower == none )
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mSiegeObstacleTower');
		}
		else
		{
			if(H7Fort(self.ObjectArchetype).mSiegeObstacleTower == none)
			{
				self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleTower');
			}
			mSiegeObstacleTower = H7Fort(self.ObjectArchetype).mSiegeObstacleTower;
		}
		
	}
	return mSiegeObstacleTower;
}

function DelCombatMapTowerRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Fort(self.ObjectArchetype).mSiegeObstacleTower = none;
	}
	mSiegeObstacleTower = none;
}

function H7CombatMapWall GetCombatMapWall()
{
	if( mFaction != none && self != mFaction.GetStartFort() )
	{
		return mFaction.GetStartFort().GetCombatMapWall();
	}
	if( mSiegeObstacleWall == none ) 
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mSiegeObstacleWall');
		}
		else
		{
			if(H7Fort(self.ObjectArchetype).mSiegeObstacleWall == none)
			{
				self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleWall');
			}
			mSiegeObstacleWall = H7Fort(self.ObjectArchetype).mSiegeObstacleWall;
		}
	}
	return mSiegeObstacleWall;
}

function DelCombatMapWallRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Fort(self.ObjectArchetype).mSiegeObstacleWall = none;
	}
	mSiegeObstacleWall = none;
}

function H7CombatMapMoat GetCombatMapMoat()
{
	if( mFaction != none && self != mFaction.GetStartFort() )
	{
		return mFaction.GetStartFort().GetCombatMapMoat();
	}
	if( mSiegeObstacleMoat == none )
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mSiegeObstacleMoat');
		}
		else
		{
			if(H7Fort(self.ObjectArchetype).mSiegeObstacleMoat == none)
			{
				self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleMoat');
			}
			mSiegeObstacleMoat = H7Fort(self.ObjectArchetype).mSiegeObstacleMoat;
		}
	}
	return mSiegeObstacleMoat;
}

function DelCombatMapMoatRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Fort(self.ObjectArchetype).mSiegeObstacleMoat = none;
	}
	mSiegeObstacleMoat = none;
}

function H7CombatMapGate GetCombatMapGate()
{
	if( mFaction != none && self != mFaction.GetStartFort() )
	{
		return mFaction.GetStartFort().GetCombatMapGate();
	}
	if( mSiegeObstacleGate == none )
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mSiegeObstacleGate');
		}
		else
		{
			if(H7Fort(self.ObjectArchetype).mSiegeObstacleGate == none)
			{
				self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleGate');
			}
			mSiegeObstacleGate = H7Fort(self.ObjectArchetype).mSiegeObstacleGate;
		}
	}
	return mSiegeObstacleGate;
}

function DelCombatMapGateRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Fort(self.ObjectArchetype).mSiegeObstacleMoat = none;
	}
	mSiegeObstacleMoat = none;
}

event InitAdventureObject()
{
	local int i;
	local MaterialInstanceConstant RebuildMat;
	local H7Faction newFaction;
	local StaticMeshComponent meshComp;
	local ParticleSystemComponent psComp;
	local H7Fort factionStartFort;

	super.InitAdventureObject();

	mInInit = true;

	if (IsRuined())
	{
		SetRuined();
	}

	if(class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() && GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER)
	{
		newFaction = GetPlayer().GetFaction();
		SetFaction( newFaction );
		SetNewName(newFaction );
		factionStartFort = newFaction.GetStartFort();
		meshComp = factionStartFort.GetMeshComp();
		psComp = factionStartFort.GetFX();

		mOriginalMesh = meshComp.StaticMesh;
		mOriginalMeshScale = meshComp.Scale3D;
		mOriginalFloatScale = meshComp.Scale;
		mOriginalMeshTranslation = meshComp.Translation;
		mOriginalMeshRotation = meshComp.Rotation;

		mOriginalFX = psComp.Template;
		mOriginalFXScale = psComp.Scale3D;
		mOriginalFXFloatScale = psComp.Scale;
		mOriginalFXTranslation = psComp.Translation;
		mOriginalFXRotation = psComp.Rotation;

		// if left empty will use the default siege map for forts
		mCombatMapName = factionStartFort.GetCombatMapName();

		mMeshRuined = factionStartFort.GetMeshRuined();
		mMeshRuinedScale = factionStartFort.GetMeshRuinedScale();
		mFXRuined = factionStartFort.GetFXRuined();
		mFXRuinedScale = factionStartFort.GetFXRuinedScale();

		mRebuildEffect = factionStartFort.GetRebuildFX();
		mDestroyEffect = factionStartFort.GetDestroyFX();

		mRebuildCost = factionStartFort.GetRebuildCost();

		mDestroySpeed = factionStartFort.GetDestroySpeed();
		mDestroyRotation = factionStartFort.GetDestroyRotation();
		mDestroyRotationTimePct = factionStartFort.GetDestroyRotationTime();
		mRebuildSpeed = factionStartFort.GetRebuildSpeed();
		mFXRebuildTime = factionStartFort.GetFXRebuildTime();

		mSiegeObstacleTower = factionStartFort.mSiegeObstacleTower;
		mSiegeObstacleWall = factionStartFort.mSiegeObstacleWall;
		mSiegeObstacleMoat = factionStartFort.mSiegeObstacleMoat;
		mSiegeObstacleGate = factionStartFort.mSiegeObstacleGate;
		mSiegeDecorationList = factionStartFort.mSiegeDecorationList;

		for (i = 0; i < mMesh.Materials.Length; i++)
		{
			mMesh.SetMaterial(i, none);
		}

		mMesh.SetStaticMesh(mOriginalMesh, true);

		mMesh.SetScale3D(mOriginalMeshScale);
		mMesh.SetScale( mOriginalFloatScale );

		mFX.SetTemplate(mOriginalFX);
		mFX.SetScale3D(mOriginalFXScale);
		mFX.SetScale(mOriginalFXFloatScale);
		mFX.ActivateSystem(true);

		if (IsRuined())
		{
			SimpleDestruction();
		}
	}
	else if( class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mOriginalMesh = mMesh.StaticMesh;
		mOriginalMeshScale = mMesh.Scale3D;
		mOriginalFloatScale = mMesh.Scale;
		mOriginalMeshTranslation = mMesh.Translation;
		mOriginalMeshRotation = mMesh.Rotation;

		mOriginalFX = mFX.Template;
		mOriginalFXScale = mFX.Scale3D;
		mOriginalFXFloatScale = mFX.Scale;
		mOriginalFXTranslation = mFX.Translation;
		mOriginalFXRotation = mFX.Rotation;

		i = 0;
		while (mMesh.GetMaterial(i) != None)
		{
			RebuildMat = new(self) class'MaterialInstanceConstant';
			RebuildMat.SetParent(mMesh.GetMaterial(i));
			mMesh.SetMaterial(i, RebuildMat);
			mRebuildMats.AddItem(RebuildMat);
			++i;
		}

		if (IsRuined())
		{
			SimpleDestruction();
		}
		
	}
	else
	{
		mOriginalMesh = mMesh.StaticMesh;
		mOriginalMeshScale = mMesh.Scale3D;
		mOriginalFloatScale = mMesh.Scale;
		mOriginalMeshTranslation = mMesh.Translation;
		mOriginalMeshRotation = mMesh.Rotation;

		mOriginalFX = mFX.Template;
		mOriginalFXScale = mFX.Scale3D;
		mOriginalFXFloatScale = mFX.Scale;
		mOriginalFXTranslation = mFX.Translation;
		mOriginalFXRotation = mFX.Rotation;

		i = 0;
		while (mMesh.GetMaterial(i) != None)
		{
			RebuildMat = new(self) class'MaterialInstanceConstant';
			RebuildMat.SetParent(mMesh.GetMaterial(i));
			mMesh.SetMaterial(i, RebuildMat);
			mRebuildMats.AddItem(RebuildMat);
			++i;
		}

		if (IsRuined())
		{
			SimpleDestruction();
			ClearLocalGuardReserve();
		}
	}

	class'H7AdventureController'.static.GetInstance().AddFort( self );

	mInInit = false;
}

event Tick(float DeltaTime)
{
	local Vector SunkPos;
	local MaterialInstanceConstant RebuildMat;

	Super.Tick(DeltaTime);

	if (mIsDestroying)
	{
		mDestroyedPercent += DeltaTime * mDestroySpeed;
		mDestroyedPercent = FMin(1.0f, mDestroyedPercent);
		class'H7AdventureController'.static.GetInstance().GetAI().DeferExecution( 1.0f );

		SunkPos.Z = -mMesh.Bounds.SphereRadius * 2.0f;

		if( mDestroyRotationTimePct==0.0f ) mDestroyRotationTimePct=0.5f;

		mMesh.SetRotation(RLerp(mOriginalMeshRotation, mOriginalMeshRotation + mDestroyRotation, FMin(1.0f, mDestroyedPercent / mDestroyRotationTimePct) ** 0.5, true));
		mMesh.SetTranslation(VLerp(mOriginalMeshTranslation, mOriginalMeshTranslation + SunkPos, FMin(1.0f, mDestroyedPercent) ** 3));

		foreach mRebuildMats(RebuildMat)
		{
			RebuildMat.SetScalarParameterValue('BuiltPercent', 1 - mDestroyedPercent);
		}

		if (mDestroyedPercent >= 1.0f)
		{
			FinishDestruction();
		}
	}
	else if (mIsRebuilding)
	{
		mRebuildPercent += DeltaTime * mRebuildSpeed;
		mRebuildPercent = FMin(1.0f, mRebuildPercent);
		class'H7AdventureController'.static.GetInstance().GetAI().DeferExecution( 1.0f );

		foreach mRebuildMats(RebuildMat)
		{
			RebuildMat.SetScalarParameterValue('BuiltPercent', mRebuildPercent);
		}

		if (mRebuildPercent >= 1.0f)
		{
			FinishRebuilding();
		}
	}
}

function bool CanAffordRebuild( H7Player player )
{
	if(player!=None)
	{
		if( player.GetResourceSet().CanSpendResources( mRebuildCost ) == true )
		{
			return true;
		}
	}
	return false;
}

function OnVisit( out H7AdventureHero hero )
{
	local string message, confirm, cancel;

	;

	if(IsRuined())
	{
		// ruined fort can be rebuild
		mVisitingHero = hero;
		
		if( hero.GetPlayer().IsControlledByAI() && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled() )
		{
			ConfirmRebuild();
		}
		else if( hero.GetPlayer().IsControlledByLocalPlayer() )
		{
			message = class'H7Loca'.static.LocalizeSave("REQ_REBUILD_FORT","H7Adventure");
			confirm = class'H7Loca'.static.LocalizeSave("REQ_REBUILD_CONFIRM","H7Adventure");
			cancel = class'H7Loca'.static.LocalizeSave("REQ_REBUILD_CANCEL","H7Adventure");

			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( message, confirm, cancel, ConfirmRebuild, CancelRebuild, mRebuildCost );
		}
	}
	else if( GetPlayer().IsPlayerHostile( hero.GetPlayer() ) )
	{
		// visiting an fort of another player will ruin it
		if( !mGarrisonArmy.HasUnits() )
		{
			;
			Conquer(hero);
		}
	}
	else
	{
		Visit(hero);
	}
}

function Conquer( H7AdventureHero conqueror )
{
	local H7Message message;

	// send message to old owner
	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mFortlost.CreateMessageBasedOnMe();
	message.mPlayerNumber = mSiteOwner;
	message.AddRepl("%fort",GetName());
	message.AddRepl("%player",conqueror.GetPlayer().GetName());
	message.settings.referenceObject = self;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	// show log for conqueror
	if(conqueror.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
	{
		message = new class'H7Message';
		message.text = "MSG_FORT_DESTROYED";
		message.AddRepl("%name",GetName());
		message.destination = MD_LOG;
		message.settings.referenceObject = self;
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}

	ClearLocalGuardReserve();
	SetRuined();

	TriggerGlobalEventClass(class'H7SeqEvent_StartsDestruction', self);

	WorldInfo.MyEmitterPool.SpawnEmitter(mDestroyEffect, Location, Rotation);

	TriggerGlobalEventClass(class'H7SeqEvent_CompletesDestruction', self);
	
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

private function ConfirmRebuild()
{
	local H7InstantCommandRebuildFort command;

	command = new class'H7InstantCommandRebuildFort';
	command.Init( self, mVisitingHero );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function ConfirmRebuildComplete()
{
	local H7Message message;
	local ParticleSystemComponent rebuildParticle;

	mIsFractured = false;

	mVisitingHero.GetPlayer().GetResourceSet().SpendResources(mRebuildCost);
	/*
	message = new class'H7Message';
	message.text = "MSG_FORT_REBUILT";
	message.AddRepl("%name",GetName());
	message.destination = MD_SIDE_BAR;
	message.settings.referenceObject = self;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	*/

	if(mVisitingHero.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
	{
	message = new class'H7Message';
		message.mPlayerNumber = mVisitingHero.GetPlayer().GetPlayerNumber();
	message.text = "MSG_FORT_REBUILT";
	message.AddRepl("%name",GetName());
	message.destination = MD_LOG;
	message.settings.referenceObject = self;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}
	
	TriggerGlobalEventClass(class'H7SeqEvent_StartsReparation', self);

	Visit(mVisitingHero);
	rebuildParticle = WorldInfo.MyEmitterPool.SpawnEmitter(mRebuildEffect, Location, Rotation);
	rebuildParticle.SetDepthPriorityGroup(SDPG_Foreground);

	TriggerGlobalEventClass(class'H7SeqEvent_CompletesReparation', self);

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	mVisitingHero = none;
}

private function CancelRebuild()
{
	mVisitingHero = none;
}

private function Visit( out H7AdventureHero hero )
{
	local bool openTownscreen;

	openTownscreen = ( !hero.GetPlayer().IsPlayerHostile( GetPlayer() ) && !hero.GetPlayer().IsPlayerAllied( GetPlayer() ) );

	super.OnVisit( hero );
	
	if( hero.GetPlayer().IsPlayerAllied( GetPlayer() ) )
	{
		class'H7MessageSystem'.static.GetInstance().CreateFloat(FCT_ERROR, self.Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("MSG_FORT_CANNOT_VISIT","H7Message") );
	}

	if( !openTownscreen ) return;
	
	if( class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == hero.GetPlayer() && hero.GetPlayer().GetPlayerType() != PLAYER_AI )
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GoToFortScreen(self);
	}
}

function SetSiteOwner( EPlayerNumber newOwner, optional bool showPopup = true  ) 
{
	if(newOwner != PN_NEUTRAL_PLAYER && mSiteOwner == newOwner)
	{
		return; // Already owned
	}

	super.SetSiteOwner(newOwner, showPopup );

	if(newOwner == PN_NEUTRAL_PLAYER)
	{
		ClearLocalGuardReserve();
	}
	UpdateMesh();
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local array<H7ResourceQuantity> costs;
	local H7ResourceQuantity cost;

	if(!extendedVersion || IsRuined())
	{
		data.type = TT_TYPE_STRING;

		data.Title =  GetName();
		if(IsRuined() ) 
		{
			data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_FORT_RUINS","H7Fort");
			costs = GetRebuildCost();
			costs.Sort( class'H7Resource'.static.CostResourceCompareGUI );
			ForEach costs(cost)
			{
				data.Description = data.Description $ "\n" $ class'H7GUIGeneralProperties'.static.GetIconHTMLByIcon(cost.Type.GetIcon()) @ String(cost.Quantity) @ cost.Type.GetName();
			}
			data.Description = data.Description $ "</font>";
		}
		else
		{
			data.type = TT_TYPE_TOWN;
			data.addRightMouseIcon = true;
		}
	}
	else
	{
		data.type = TT_TYPE_TOWN;
	}
	return data;
}

function UpdateMesh()
{
	if(IsRuined())
	{
		StartDestruction();
	}
	else
	{
		StartRebuilding();
	}
}


// Used for save/load so there is no animation playing
function SimpleDestruction()
{
	mIsDestroying = true;
	mIsFractured = true;
	mFX.DeactivateSystem();
	mDestroyedPercent = 1.0f;
	mMesh.SetTraceBlocking(false, false);
}

function StartDestruction()
{
	if(!mInInit)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnTakeOverSound,true, true, self.Location);
	}

	mIsDestroying = true;
	mIsFractured = true;
	mFX.DeactivateSystem();
	mDestroyedPercent = 0.0f;
	mMesh.SetTraceBlocking(false, false);
}

function FinishDestruction()
{
	local int i;

	mIsDestroying = false;
	mMesh.SetTraceBlocking(true, true);

	for (i = 0; i < mMesh.Materials.Length; i++)
	{
		mMesh.SetMaterial(i, None);
	}

	mMesh.SetStaticMesh(mMeshRuined, true);
	mMesh.SetScale3D(mMeshRuinedScale);
	mMesh.SetRotation(Rot(0,0,0));
	mMesh.SetTranslation(Vect(0,0,0));

	mFX.SetTemplate(mFXRuined);
	mFX.SetScale3D(mFXRuinedScale);
	mFX.SetRotation(Rot(0,0,0));
	mFX.SetTranslation(Vect(0,0,0));
	mFX.ActivateSystem(true);
}

function StartRebuilding()
{
	local int i;
	local MaterialInstanceConstant RebuildMat;
	local H7Faction newFaction;
	local StaticMeshComponent meshComp;
	local ParticleSystemComponent psComp;
	local H7Fort factionStartFort;

	if( GetPlayer().GetPlayerNumber() == PN_NEUTRAL_PLAYER )
	{
		return;
	}

	if(!mInInit)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnRepairSound,true, true, self.Location);
	}

	newFaction = GetPlayer().GetFaction();
	SetFaction( newFaction );
	SetNewName(newFaction );
	factionStartFort = newFaction.GetStartFort();
	meshComp = factionStartFort.GetMeshComp();
	psComp = factionStartFort.GetFX();
	mIcon = factionStartFort.GetIcon();

	mOriginalMesh = meshComp.StaticMesh;
	mOriginalMeshScale = meshComp.Scale3D;
	mOriginalFloatScale = meshComp.Scale;
	mOriginalMeshTranslation = meshComp.Translation;
	mOriginalMeshRotation = meshComp.Rotation;

	mOriginalFX = psComp.Template;
	mOriginalFXScale = psComp.Scale3D;
	mOriginalFXFloatScale = psComp.Scale;
	mOriginalFXTranslation = psComp.Translation;
	mOriginalFXRotation = psComp.Rotation;
	
	// if left empty will use the default siege map for forts
	mCombatMapName = factionStartFort.GetCombatMapName();

	mMeshRuined = factionStartFort.GetMeshRuined();
	mMeshRuinedScale = factionStartFort.GetMeshRuinedScale();
	mFXRuined = factionStartFort.GetFXRuined();
	mFXRuinedScale = factionStartFort.GetFXRuinedScale();

	mRebuildEffect = factionStartFort.GetRebuildFX();
	mDestroyEffect = factionStartFort.GetDestroyFX();

	mRebuildCost = factionStartFort.GetRebuildCost();

	mDestroySpeed = factionStartFort.GetDestroySpeed();
	mDestroyRotation = factionStartFort.GetDestroyRotation();
	mDestroyRotationTimePct = factionStartFort.GetDestroyRotationTime();
	mRebuildSpeed = factionStartFort.GetRebuildSpeed();
	mFXRebuildTime = factionStartFort.GetFXRebuildTime();

	//mSiegeObstacleTower = factionStartFort.GetCombatMapTower();
	//mSiegeObstacleWall = factionStartFort.GetCombatMapWall();
	//mSiegeObstacleMoat = factionStartFort.GetCombatMapMoat();
	//mSiegeObstacleGate = factionStartFort.GetCombatMapGate();
	//mSiegeDecorationList = factionStartFort.GetCombatMapDecoList();

	mLocalGuard = factionStartFort.GetLocalGuard();

	for (i = 0; i < mLocalGuard.Length; i++)
	{
		mLocalGuard[i].Reserve = mLocalGuard[i].Income;
	}

	mMesh.SetHidden(true);
	for (i = 0; i < mMesh.Materials.Length; i++)
	{
		mMesh.SetMaterial(i, none);
	}
	mMesh.SetStaticMesh(mOriginalMesh, true);

	i = 0;
	mRebuildMats.Length = 0;
	while (mMesh.GetMaterial(i) != None)
	{
		RebuildMat = new(self) class'MaterialInstanceConstant';
		if (factionStartFort.GetMaterialRuined() != None)
		{
			RebuildMat.SetParent(factionStartFort.GetMaterialRuined());
		}
		else
		{
			RebuildMat.SetParent(mMesh.GetMaterial(i));
		}
		mMesh.SetMaterial(i, RebuildMat);
		mRebuildMats.AddItem(RebuildMat);
		++i;
	}
	mIsRebuilding = true;
	
	mMesh.SetScale3D(mOriginalMeshScale);
	mMesh.SetScale(mOriginalFloatScale);
	mMesh.SetRotation(mOriginalMeshRotation);
	mFX.DeactivateSystem();

	foreach mRebuildMats(RebuildMat)
	{
		RebuildMat.SetScalarParameterValue('BuiltPercent', 0.0f);
	}
	mMesh.SetHidden(false);

	mIsFractured = false;
}

function FinishRebuilding()
{
	local int i;

	mIsRebuilding = false;

	for (i = 0; i < mMesh.Materials.Length; i++)
	{
		mMesh.SetMaterial(i, none);
	}

	mFX.SetTemplate(mOriginalFX);
	mFX.SetScale3D(mOriginalFXScale);
	mFX.SetScale(mOriginalFXFloatScale);
	mFX.SetRotation(mOriginalFXRotation);
	mFX.ActivateSystem(true);

	ProduceDayUnits();
}

function SetNewName(H7Faction newFaction )
{
	if(!mUseCustomName)
	{
		OverrideName(newFaction.GetDefaultFortName());
	}
}

function ProduceDayUnits()
{
	if( !IsRuined() )
	{
		super.ProduceDayUnits();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

