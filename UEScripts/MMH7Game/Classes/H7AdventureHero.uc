//=============================================================================
// H7AdventureHero
//=============================================================================
//
// Hero used in the adventure map
// Serialization called from H7AdventureArmy
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureHero extends H7EditorHero 
	implements(H7ITooltipable,H7IGUIListenable)
	dependson(H7ITooltipable,H7IGUIListenable)
	native;

var protected H7CreatureStackMovementControl   mMoveControl;

var protected array<H7AdventureMapCell>         mCurrentPath;
var protected H7AdventureMapCell	            mLastCellMovement;

var(AdvHero) protected int               	    mScoutingRadius<DisplayName=Scouting Radius>;
var protected float                             mTerrainCostModifier;

var(AdvHero) protected bool                     mCanScout<DisplayName=Can Scout>;
var(AdvHero) protected bool                     mIsAlliedWithEverybody<DisplayName=Is allied with everybody>;

var protected bool                              mHasFinishedCurrentTurn;
var protected bool                              mHasCastedSpellThisTurn;

var protected bool                              mHasTearOfAsha;
 // List of governor abilities
var protected array<H7BaseAbility>				mGovernorAbilities;
var protected H7Town                            mGovernedTown;

var protected H7VisitableSite                   mAiClaimedSite;
var protected H7AiActionBase                    mAiLastScoreAction;
var protected H7AiActionParam                   mAiLastScoreParams;
var protected int                               mAiLastScoreActionCounter;

// Get / Set
// =======

function SetClaimedSite( H7VisitableSite site ) { mAiClaimedSite = site; }
function H7VisitableSite GetClaimedSite( ) { return mAiClaimedSite; }

function SetGovernedTown( H7Town town ) { mGovernedTown = town; }
function H7Town GetGovernedTown( ) { return mGovernedTown; }

function IntPoint                   GetGridPosition()                                   
{ 
	if( GetAdventureArmy().GetCell() == none )
	{
		;
	}
	return GetAdventureArmy().GetCell().GetCellPosition(); 
}
function H7AdventureMapCell			GetCell()											{ return GetAdventureArmy().GetCell(); }
function array<H7AdventureMapCell>  GetCurrentPath()                                    { return mCurrentPath; }
function H7AdventureMapCell         GetLastCellMovement()                               { return mLastCellMovement; }
function	                        SetLastCellMovement( H7AdventureMapCell newCell )   { mLastCellMovement = newCell; }
function                            SetCurrentPath( array<H7AdventureMapCell> newPath ) { mCurrentPath = newPath; }
function                            SetScoutingRadius( int newRadius )                  { mScoutingRadius = newRadius; }
function int                        GetScoutingRadius()                                 { return GetModifiedStatByID( STAT_SIGHT_RADIUS ); }
function int                        GetScoutingRadiusBase()                             { return mScoutingRadius; }
function bool                       IsAttacker()                                        { return GetAdventureArmy().IsAttacker(); }
function float                      GetTerrainCostModifier()                            { return GetModifiedStatByID( STAT_TERRAIN_COST ); }
function float                      GetTerrainCostModifierBase()                        { return mTerrainCostModifier; }
function H7CreatureStackMovementControl GetMoveControl()                                { return mMoveControl; }
function                            SetCanScout(bool val)                               { mCanScout = val; }
function bool                       CanScout()                                          { return mCanScout; }
function                            SetIsAlliedWithEverybody(bool val)                  { mIsAlliedWithEverybody = val; }
function bool                       IsAlliedWithEverybody()                             { return mIsAlliedWithEverybody; } // hide your kids, hide your wife, cause this guy is IsAlliedWithEverybody over here
function bool                       HasFinishedCurrentTurn()                            { return mHasFinishedCurrentTurn; }
function                            SetFinishedCurrentTurn( bool hasFinished )          { mHasFinishedCurrentTurn = hasFinished; }
function bool                       HasCastedSpellThisTurn()                            { return mHasCastedSpellThisTurn; }
function                            SetCastedSpellThisTurn( bool hasCasted )            { mHasCastedSpellThisTurn = hasCasted; }
function H7AiActionBase             GetAiLastScoreAction()                              { return mAiLastScoreAction; }
function                            SetAiLastScoreAction( H7AiActionBase ab )           { mAiLastScoreAction=ab; }
function H7AiActionParam            GetAiLastScoreParam()                               { return mAiLastScoreParams; }
function                            SetAiLastScoreParam( H7AiActionParam ap )           { mAiLastScoreParams=ap; }
function int                        GetAiLastScoreActionCounter()                       { return mAiLastScoreActionCounter; }
function                            SetAiLastScoreActionCounter( int ap )               { mAiLastScoreActionCounter=ap; }

function H7HeroAbility QuerySpellInstantRecall()
{
	local array<H7HeroAbility>      spells;
	local H7HeroAbility             spell;
	GetSpells(spells);
	foreach spells(spell)
	{
		if(spell.GetArchetypeID()=="A_InstantRecall") return spell;
	}
	return None;
}

// methods
// =======

function SetPlayer( H7Player newPlayer )
{
	mOwningPlayer = newPlayer;
	UpdateOutline();

	if( mArmy != none && mArmy.GetPlayer().GetPlayerNumber() != newPlayer.GetPlayerNumber() )
	{
		mArmy.SetPlayer(newPlayer);
	}
	ForceReapplyPlayerChanged(); // lololol
}

function RecalculateAggressiveness()
{
	local H7AdventureController advCntl;
	advCntl = class'H7AdventureController'.static.GetInstance();

	if( IsHero() && GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER )
	{
		if( GetPlayer().GetPlayerType() == PLAYER_HUMAN )
		{
			SetAiAggressivness( HAG_BALANCED );
		}
		else
		{
			SetAiAggressivness( advCntl.GetAIAggressivenessFromDifficulty( advCntl.GetPlayerSettingsFromPlayerNumber( GetPlayer().GetPlayerNumber() ).mAIDifficulty ) );
		}
	}
}

/** Update cell auras in case the hero's player spontaneously combusted, eeeeh, changed.
 *  Fixes Anastasya's bullshittery with the Hourglass on Necro 1.
 *  Jesus christ.
 */
function ForceReapplyPlayerChanged()
{
	local array<H7BaseAbility> curAu;
	local int i;
	local H7EventContainerStruct conti;

	if( mBuffManager == none || GetCell() == none ) return;

	mBuffManager.RemoveAllAuraBuffs();

	conti.Targetable = self;
	conti.TargetableTargets.AddItem( self );
	conti.Action = ACTION_ABILITY;

	GetCell().GetGridOwner().GetAuraManager().GetAuraAbilitiesForCell( GetCell(), curAu );
	for( i = 0; i < curAu.Length; ++i )
	{
		conti.EffectContainer = curAu[i];
		curAu[i].GetEventManager().Raise( ON_REMOVE_AURA, false, conti );
		curAu[i].GetEventManager().Raise( ON_APPLY_AURA, false, conti );
	}
}

function Init( optional bool fromSave )
{
	mCanScout = false;

	super.Init( fromSave );

	if(fromSave == false)
	{
		fromSave = fromSave;
	}

	mMoveControl = Spawn(class'H7CreatureStackMovementControl', self);
	mMoveControl.Initialize(self);

	AssignMaterials();

	if( class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None && IsHero() && !GetAdventureArmy().IsGarrisoned() && !GetAdventureArmy().IsDead()
			// TODO only update if I am the owner of this hero
			//&& self.GetPlayer().GetPlayerNumber() == class'H7PlayerController'.static.GetPlayerController().g
		)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddHero( self );
	}

}

function SetDead(optional bool unequipItems = false)
{
	// remove governor auras (this will call ON_GOVERNOR_UNASSIGN for the dude)
	if(mGovernedTown != none && !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		mGovernedTown.SetGovernorComplete( none );
	}

	// unequip all items to remove volatile abilities (if unequipItems)
	if(unequipItems)
	{
		mEquipment.UnequipAll();
	}
}

// Check if hero gives any skill/ability/buff as Governor
function bool HasGovernorEffect()
{
	return mGovernorAbilities.Length > 0;
}

function array<H7BaseAbility> GetGovernorAbilities()
{
	return mGovernorAbilities;
}

function AddGovernorAbility(H7BaseAbility newAbility)
{
	mGovernorAbilities.AddItem(newAbility);
}

function RemoveGovernorAbility(H7BaseAbility ability)
{
	if(mGovernorAbilities.Length > 0)
	{
		mGovernorAbilities.RemoveItem(ability);
	}
	else
	{
		;
		ScriptTrace();
	}
}

function bool HasTearOfAsha()
{
	return mHasTearOfAsha;
}

function SetHasTearOfAsha( bool val )
{
	mHasTearOfAsha = val;
}

function DestroyTearOfAsha()
{
	local array<H7HeroItem> items;
	local H7HeroItem item, tear;

	items = mInventory.GetItems();
	foreach items( item )
	{
		if( H7TearOfAsha( item ) != none )
		{
			tear = item;
			break;
		}
	}
	DataChanged();
	mInventory.RemoveItem( tear );
	tear.MarkForKill(); // :'(
	mHasTearOfAsha = false;
}

event AssignMaterials()
{
	local Color playerColor;
	local LinearColor playerLinearColor;
	local MaterialInstanceConstant MatInst;
	local int i;

	// make sure we have a player, or wait for one
	if (GetPlayer() == None || (mArmy.SkeletalMeshComponent.SkeletalMesh == None && mArmy.mHorseMesh.SkeletalMesh == None))
	{
		if (WorldInfo.TimeSeconds < 5.0f)
		{
			SetTimer(0.5f, false, 'AssignMaterials');
			return;
		}
		else
		{
			return;
		}
	}

	// load and set the materials into memory so we can control them at runtime
	if (mArmy.SkeletalMeshComponent != None && mArmy.SkeletalMeshComponent.SkeletalMesh != None)
	{
		for (i = 0; i < mArmy.SkeletalMeshComponent.SkeletalMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mArmy.SkeletalMeshComponent.GetMaterial(i));
			mArmy.SkeletalMeshComponent.SetMaterial(i, MatInst);
			HeroMaterials.AddItem(MatInst);
		}
	}
	if (mArmy.mHorseMesh != None && mArmy.mHorseMesh.SkeletalMesh != None)
	{
		for (i = 0; i < mArmy.mHorseMesh.SkeletalMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mArmy.mHorseMesh.GetMaterial(i));
			mArmy.mHorseMesh.SetMaterial(i, MatInst);
			HeroMaterials.AddItem(MatInst);
		}
	}
	if (mWeaponMesh != None && mWeaponMesh.StaticMesh != None)
	{
		for (i = 0; i < mWeaponMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mWeaponMesh.GetMaterial(i));
			mWeaponMesh.SetMaterial(i, MatInst);
			HeroMaterials.AddItem(MatInst);
		}
	}

	// apply player color to the hero if needed
	if (class'H7GUIGeneralProperties'.static.GetInstance().IsUsingModelColoring())
	{
		playerColor = GetPlayer().GetColor();
		playerLinearColor.R = float(playerColor.R) / 255;
		playerLinearColor.G = float(playerColor.G) / 255;
		playerLinearColor.B = float(playerColor.B) / 255;
		foreach HeroMaterials(MatInst)
		{
			MatInst.SetScalarParameterValue('bUseFactionColor', 1.0f);
			MatInst.SetVectorParameterValue('FactionColor', playerLinearColor);
		}
	}
}

function bool IsMoving()
{
	if( mMoveControl != none )
	{
		return mMoveControl.IsMoving();
	}
	else
	{
		ScriptTrace();
		;
		return false;
	}
}

function EndMoving( optional bool ignoreTargetNotReachedMessage = true  )
{
	GetAnimControl().PlayAnim( HA_IDLE );
	if (!class'H7Camera'.static.GetInstance().IsFollowing())
	{
		class'H7Camera'.static.GetInstance().SetFocusActor( none, GetPlayer().GetPlayerNumber() );	
	}
	// enable again the input that was disabled at the start of the movment
	class'H7AdventureController'.static.GetInstance().CalculateInputAllowed( GetPlayer() );

	if( GetLastCellMovement() != None && !ignoreTargetNotReachedMessage && GetCell() != GetLastCellMovement() && IsMoving() )
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, Location, GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_TARGET_NOT_REACHED","H7FCT"));
	}

	ClearScriptedBehaviour();
	if( GetAdventureArmy().IsChilling() )
	{
		SetCurrentMovementPoints( 0 );
		GetAdventureArmy().SetChilling( false );
	}
}

function StopMoving()
{
	local array<H7AdventureMapCell> path;
	path = GetCurrentPath();
	if (mMoveControl.GetCurrentMover() != None)
	{
		mMoveControl.GetCurrentMover().ClearPath();
	}
	if( path.Length > 0 )
	{
		path.Length = 0;
	}
}

function bool IsGovernourOfTown()
{
	local array<H7Town> townList;
	local int i;

	if( !class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) return false;

	townList = class'H7AdventureController'.static.GetInstance().GetTownList();
	
	for( i = 0; i < townList.Length; ++i )
	{
		if( townList[i].GetGovernor() == self )
		{
			return true;
		}
	}

	return false;
}

function Select( bool doSelect, optional bool doFocus = true )
{
	local array<float> pathCosts;
	local int numOfWalkableCells;

	pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( mCurrentPath, H7AdventureArmy( mArmy ).GetCell(), GetCurrentMovementPoints(), numOfWalkableCells );
	if( !mOwningPlayer.IsControlledByAI() )
	{
		class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().ShowPreview( mCurrentPath, numOfWalkableCells, GetCurrentMovementPoints(), GetMovementPoints(), pathCosts );	
	}
	else
	{
		class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().HidePreview();
	}
	if( doFocus )
	{
		class'H7Camera'.static.GetInstance().SetFocusActor( self, GetPlayer().GetPlayerNumber(), false );
	}
	doSelect = doSelect && !GetPlayer().IsControlledByAI();
	if(doSelect && class'H7AdventureHudCntl'.static.GetInstance() != None)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetHeroHUD().SelectHeroByHero( self );
	}
}

function H7HeroFX GetSelectionFX()
{
	return mFX;
}

function UpdateSelectionFX()
{
	if( mFX == none )
	{
		InitFX();
	}

	if( !GetAdventureArmy().IsGarrisoned() && !GetAdventureArmy().IsDead() )
	{
		mFX.UpdateFXPosition();
	}
}



// start the move action, focus camera on moving hero
function MoveHero( array<H7BaseCell> path, optional H7Unit targetUnit, optional bool followCam = true )
{
	local array<H7AdventureMapCell> advPath;
	local H7BaseCell currentCell;
	local H7FOWController fowController;
	local H7AdventureController advCntl;
	local int i, cutoffIndex;
	local array<float> pathCosts;

	advCntl = class'H7AdventureController'.static.GetInstance();

	if(followCam)
	{
		class'H7Camera'.static.GetInstance().SetFocusActor( self, GetPlayer().GetPlayerNumber(), true, false, true );
	}
	else if(advCntl.GetSelectedArmy() != none && self == class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero())
	{
		class'H7Camera'.static.GetInstance().ClearFocusActor();
	}

	foreach path(currentCell)
	{
		advPath.AddItem( H7AdventureMapCell(currentCell) );
	}

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && !GetPlayer().IsControlledByLocalPlayer() )
	{
		SetCurrentPath( advPath );
	}

	if(IsControlledByAI())
	{
		i = INDEX_NONE;
		foreach path(currentCell,i)
		{
			fowController = H7AdventureMapCell(currentCell).GetGridOwner().GetFOWController();

			if( fowController.CheckExploredTile( advCntl.GetLocalPlayer().GetPlayerNumber(), currentCell.mPosition ) )
			{	
				break;
			}
			cutoffIndex = i;
		}

		if( class'H7AdventureController'.static.GetInstance().ShouldSkipMove() )
		{
			cutoffIndex = path.Length-1;
		}

		pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( advPath, GetCell(), GetCurrentMovementPoints() );
		if( cutoffIndex != INDEX_NONE && advPath.Length != 0 && cutoffIndex != 0 )
		{
			for( i = 0; i <= cutoffIndex; ++i )
			{
				GetAdventureArmy().SetCell( advPath[i], true, true, false );
				UseMovementPoints( pathCosts[i] );
			}
		}

		path.Remove( 0, cutoffIndex );
	}

	if( path.Length != 0 )
	{
		mMoveControl.MoveStack( path, targetUnit );
	}
	else
	{
		StopMoving();
	}
}

function RotateHero( int targetYaw )
{
	local rotator targetRotation;
	targetRotation = self.Rotation;
	targetRotation.Yaw = targetYaw;
	mMoveControl.RotateStack(targetRotation);
}

/**
 * Helper function to subtract movement points from hero and path cells from path step by step
 * 
 * */
function bool UpdatePath()
{
	local array<float> pathCosts;
	local int numOfWalkableCells;
	local bool canStillMove;
	local array<H7VisitableSite> sites;
	local array<H7AdventureArmy> armies;
	local array<float> sitesDistances;
	local array<float> armiesDistances;

	pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( mCurrentPath, H7AdventureArmy( mArmy ).GetCell(), GetCurrentMovementPoints(), numOfWalkableCells );

	canStillMove = true;
	if( mCurrentPath.Length != 0 )
	{
		if( mCurrentPath[0].HasAuras() )
		{
			//mCurrentPath[0].GetGridOwner().GetAuraManager().UpdateAuras( false, mCurrentPath[0].GetAuras(), mCurrentPath[0], self );
		}

		if( mCurrentPath.Length > 1 )
		{
			class'H7Teleporter'.static.EnterTeleporterCheck( mCurrentPath[0], mCurrentPath[1],, GetAdventureArmy() );
		}

		canStillMove = UseMovementPoints( pathCosts[0] );

		if( mCurrentPath[0].GetTeleporter() != none && 
			mCurrentPath[0].GetTeleporter().GetEntranceCell() == mCurrentPath[0] && 
			GetModifiedStatByID( STAT_PICKUP_COST ) > GetCurrentMovementPoints() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, mCurrentPath[0].GetLocation(), GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_MOVEPOINTS_LEFT","H7FCT") );
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("NOT_ENOUGH_MOVE_POINTS");
		}

		if(!canStillMove)
		{
			
			if( GetPlayer().GetPlayerType() != PLAYER_AI )
			{
				if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero() == self )
				{
					class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().ShowPreview(mCurrentPath,0,GetCurrentMovementPoints(),GetMovementPoints(), pathCosts);
				}
			}
			else
			{
				class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().HidePreview();
			}
			if( !GetAdventureArmy().IsGarrisoned() )
			{
				class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetReachableSitesAndArmies( GetCell(), GetPlayer(), GetAdventureArmy().HasShip(), sites, armies, sitesDistances, armiesDistances, IsControlledByAI() );
				GetAdventureArmy().SetReachableArmies( armies );
				GetAdventureArmy().SetReachableSites( sites );
				GetAdventureArmy().SetReachableArmiesDistances( armiesDistances );
				GetAdventureArmy().SetReachableSitesDistances( sitesDistances );
			}
		}
		pathCosts.Remove( 0, 1 );
		mCurrentPath.Remove( 0, 1 );
	}

	if( mCurrentPath.Length == 0 )
	{
		if( !GetAdventureArmy().IsGarrisoned() )
		{
			class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetReachableSitesAndArmies( GetCell(), GetPlayer(), GetAdventureArmy().HasShip(), sites, armies, sitesDistances, armiesDistances, false );
			GetAdventureArmy().SetReachableArmies( armies );
			GetAdventureArmy().SetReachableSites( sites );
			GetAdventureArmy().SetReachableArmiesDistances( armiesDistances );
			GetAdventureArmy().SetReachableSitesDistances( sitesDistances );
		}
	}
	
	if( !mOwningPlayer.IsControlledByAI() && mOwningPlayer.IsControlledByLocalPlayer() && class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero() == self )
	{
		class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().UpdatePreview();
	}

	return canStillMove;
}



function UpdateSpells()
{
	local array<H7HeroAbility> abilities;
	local H7HeroAbility ability;

	mAbilityManager.GetHeroAbilities( abilities );

	foreach abilities(ability)
	{
//		`log_uss("Update Ability:" @ ability.GetName() @ "TIMER:" @ ability.GetCooldownTimerCurrent()  @ "Ref" @ ability );
		if(ability.IsOnCooldown()==true) 
		{
			ability.UpdateCooldownTimer();
		}
	}
}

// Adventure -> Combat fromadventure tocombat
// other way see: H7AdventureArmy.UpdateAfterCombat
function H7CombatHero Convert(optional H7CombatArmy army, optional name herotag, optional vector heroLocation, optional rotator heroRotation)
{
	local H7CombatHero hero;
	// copy bullshit
	hero = Spawn( class'H7CombatHero', army, herotag, heroLocation, heroRotation );

	if(army != none)
	{
		army.SetStarterHero(GetAdventureArmy().IsStarterHero());
	}

	hero.SetArmy( army );

	hero.Init();
	hero.SetIsHero( army.GetHeroTemplate().IsHero() );

	hero.SetInitiative(mInitiative);
	hero.SetVisuals( GetVisuals() );
	hero.IsHero() ? hero.SetMeshes( GetVisuals().GetHorseSkeletalMesh(), GetVisuals().GetHeroSkeletalMesh() ) : hero.SetMeshes( none, none  );
	hero.SetAttack( mAttack );
	hero.SetMinimumDamage( mMinimumDamage );
	hero.SetMaximumDamage( mMaximumDamage );
	hero.SetDefense( mDefense );
	hero.SetTransientName( GetName() );
	hero.SetClass( GetHeroClass() );
	hero.OverrideSkillManager( mSkillManager );
	hero.SetOriginArchetype( mOriginArchetype );
	hero.SetCampaignTransitionHeroArchetype( mCampaignTransitionHeroArchetype );
	hero.OverrideAbilityManager( mAbilityManager ) ;
	hero.OverrideBuffManager( mBuffManager, self );
	hero.SetLeadership( mLeadership );
	hero.SetDestiny( mDestiny );
	hero.SetLevel( mLevel );
	hero.SetSchoolType( mSchoolType );
	hero.SetXp( mXp );
	hero.SetIcon( GetIcon() );
	hero.SetCurrentMana( mCurrentMana );
	hero.SetSpirit( mSpirit );
	hero.SetMagic( mMagic );
	hero.SetCurrentMovementPoints( mCurrentMovementPoints );
	hero.SetMaxMovementPoints( mMovementPoints );
	hero.SetQuickBarSpells( mQuickBarCombat , true);
	hero.SetFaction( GetFaction() );
	hero.SetEquipment( GetEquipment() );
	hero.SetMeleeAttackAbility( mMeleeAttackAbilityTemplate );
	hero.SetRangedAttackAbility( mRangedAttackAbilityTemplate );
	hero.SetWaitAbility( mWaitAbility );
	hero.SetPreLearnedSkills( mPreLearnedSkills );
	hero.SetInventory( mInventory );

	if(mHeropediaOverwrite != none) hero.SetHeropediaOverwrite( mHeropediaOverwrite );

	return hero;
}

protected function DebugLogSelf()
{
	;
}

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function JSonObject Serialize()
{
	local JSonObject JSonObject;
	local int i;

	JSonObject = super.Serialize();

	JSonObject.SetIntValue( "ScoutingRadius", mScoutingRadius );
	JSonObject.SetBoolValue( "CanScout", mCanScout );
	JSonObject.SetBoolValue( "IsAlliedWithEverybody", mIsAlliedWithEverybody );
	JSonObject.SetFloatValue( "TerrainCostMod", mTerrainCostModifier );

	JSonObject.SetIntValue( "CurrentPathLength", mCurrentPath.Length );
	for( i=0; i<mCurrentPath.Length; ++i )
	{
		JSonObject.SetIntValue( "CurrentPathX"$i, mCurrentPath[i].GetCellPosition().X );
		JSonObject.SetIntValue( "CurrentPathY"$i, mCurrentPath[i].GetCellPosition().Y );
		JSonObject.SetIntValue( "CurrentPathGridIndex"$i, mCurrentPath[i].GetGridOwner().GetIndex() );
	}

	JSonObject.SetBoolValue( "HasLastCellMovent", mLastCellMovement != none );
	if( mLastCellMovement != none )
	{
		JSonObject.SetIntValue( "LastCellMovementX", mLastCellMovement.GetCellPosition().X );
		JSonObject.SetIntValue( "LastCellMovementY", mLastCellMovement.GetCellPosition().Y );
		JSonObject.SetIntValue( "LastCellMovementGridIndex", mLastCellMovement.GetGridOwner().GetIndex() );
	}

	// Send the encoded JSonObject
	return JSonObject;
}

/**
 * Deserializes the actor from the data given
 *
 * @param    Data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data)
{
	local int currentPathLength, i;

	super.Deserialize( Data );

	mScoutingRadius = Data.GetIntValue("ScoutingRadius");
	mTerrainCostModifier = Data.GetFloatValue("TerrainCostMod");

	mCanScout = Data.GetBoolValue( "CanScout" );
	mIsAlliedWithEverybody = Data.GetBoolValue( "IsAlliedWithEverybody" );

	currentPathLength = Data.GetIntValue( "CurrentPathLength" );
	mCurrentPath.Add( currentPathLength );
	for( i=0; i<currentPathLength; ++i )
	{
		mCurrentPath[i] = class'H7AdventureGridManager'.static.GetInstance().GetCell( Data.GetIntValue("CurrentPathX"$i), Data.GetIntValue("CurrentPathY"$i), Data.GetIntValue("CurrentPathGridIndex"$i) );
	}

	if( Data.GetBoolValue( "HasLastCellMovent" ) )
	{
		mLastCellMovement = class'H7AdventureGridManager'.static.GetInstance().GetCell( Data.GetIntValue("LastCellMovementX"), Data.GetIntValue("LastCellMovementY"), Data.GetIntValue("LastCellMovementGridIndex") );
	}
}

function RestoreState( SavegameHeroStruct saveGameData )
{
	local array<H7Skill> skills;
	local H7Skill skill;
	local int i, j;
	local H7HeroAbility ability;
	local H7RndSkillManager rndSkillManager;
	local array<H7HeroAbility> quickBarTemp;

	mIsHero = saveGameData.IsHero;
	mID = saveGameData.ID;
	class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self ); // register him after he got the ID

	
	if( mIsHero )
	{
		mLevel = saveGameData.Level;
		mXp = saveGameData.XP;
		mSpirit =  saveGameData.Spirit;
		mMagic = saveGameData.Magic;
		mAttack = saveGameData.AttackBase;
		mDefense = saveGameData.DefenseBase;
		mArcaneKnowledgeBase = saveGameData.ArcaneKnowledgeBase;
		mCurrentMovementPoints = saveGameData.CurrentMovementPoints;
		mSaveMovementPoints = saveGameData.CurrentMovementPoints;
		mCurrentMana = saveGameData.CurrentMana;
		mMaxManaBonus = saveGameData.MaxManaBonus;
		mManaRegenBase = saveGameData.ManaRegenBase;
		mSkillPoints = saveGameData.SkillPoints;
		mHasFinishedCurrentTurn = saveGameData.HasFinishedTurn;
		mHasCastedSpellThisTurn = saveGameData.HasCastedSpellThisTurn;
		mHasTearOfAsha = saveGameData.HasTearOfAsha;
		mScriptedBehaviour = saveGameData.ScriptedBehaviour;
		mAiControlType = saveGameData.ControlType;
		mAiRole = saveGameData.HeroAiRole;
		mAiHomeSite = saveGameData.HomeSite;
	
		//`LOG_MP("SkillTrack :  AdventureHero"@self@"of archetype"@class'H7GameUtility'.static.GetArchetypePath(mOriginArchetype)@"is requesting to load AbilityManger"@saveGameData.AbilityManager@"!");

		mAbilityManager = saveGameData.AbilityManager;
		mAbilityManager.SetOwner( self );

		// Grab data from HeroStruct
		i = 0;
		if(mAbilityManager.mHeroSpellArchetypeReferences.Length <= 0)
		{
			mAbilityManager.mHeroSpellArchetypeReferences.Length = 0;
		
			for(i = 0; i < saveGameData.HeroSpellArchetypeReferences.Length; ++i)
			{
				mAbilityManager.mHeroSpellArchetypeReferences.AddItem( saveGameData.HeroSpellArchetypeReferences[i] );
			}
		}
		if(i > 0)
		{
			//`LOG_MP("SkillTrack : "@i@" SpellRefs were used from HeroStruct to override AbilityManager!");
		}
		if(mAbilityManager.mHeroSpellIDs.Length <= 0)
		{
			mAbilityManager.mHeroSpellIDs.Length = 0;
		
			for(i = 0; i < saveGameData.HeroSpellIDs.Length; ++i)
			{
				mAbilityManager.mHeroSpellIDs.AddItem( saveGameData.HeroSpellIDs[i] );
			}
		}
		
		i = 0;
		if(mAbilityManager.mHeroVolatileSpellArchetypeReferences.Length <= 0)
		{
			mAbilityManager.mHeroVolatileSpellArchetypeReferences.Length = 0;

			for(i = 0; i < saveGameData.HeroVolatileSpellArchetypeReferences.Length; ++i)
			{
				mAbilityManager.mHeroVolatileSpellArchetypeReferences.AddItem( saveGameData.HeroVolatileSpellArchetypeReferences[i] );
			}
		}
		if(i > 0)
		{
			//`LOG_MP("SkillTrack : "@i@" VolatileSpellRefs were used from HeroStruct to override AbilityManager!");
		}
		if(mAbilityManager.mHeroVolatileSpellIDs.Length <= 0)
		{
			mAbilityManager.mHeroVolatileSpellIDs.Length = 0;
		
			for(i = 0; i < saveGameData.HeroVolatileSpellIDs.Length; ++i)
			{
				mAbilityManager.mHeroVolatileSpellIDs.AddItem( saveGameData.HeroVolatileSpellIDs[i] );
			}
		}

		i = 0;
		if(mAbilityManager.mHeroAbilityArchetypeReferences.Length <= 0)
		{
			mAbilityManager.mHeroAbilityArchetypeReferences.Length = 0;
		
			for(i = 0; i < saveGameData.HeroAbilityArchetypeReferences.Length; ++i)
			{
				mAbilityManager.mHeroAbilityArchetypeReferences.AddItem( saveGameData.HeroAbilityArchetypeReferences[i] );
			}
		}
		if(i > 0)
		{
			//`LOG_MP("SkillTrack : "@i@" AbilityRefs were used from HeroStruct to override AbilityManager!");
		}
		if(mAbilityManager.mHeroAbilityIDs.Length <= 0)
		{
			mAbilityManager.mHeroAbilityIDs.Length = 0;
		
			for(i = 0; i < saveGameData.HeroAbilityIDs.Length; ++i)
			{
				mAbilityManager.mHeroAbilityIDs.AddItem( saveGameData.HeroAbilityIDs[i] );
			}
		}
		mAbilityManager.RestoreAbilitiesFromRefs();

		mSkillManager.SetSkillPointsSpend( saveGameData.SkillPointsSpend );


		skills = mSkillManager.GetAllSkills();
		for( i = 0; i < saveGameData.SkillRefs.Length; ++i )
		{
			for(j = 0; j < skills.Length; ++j)
			{
				if(Pathname( skills[j].ObjectArchetype ) == saveGameData.SkillRefs[i].SkillArchRef )
				{
					skills[j].SetCurrentSkillRank(ESkillRank(saveGameData.SkillRefs[i].SkillRank) );
					skills[j].SetUltimateRequirment(saveGameData.SkillRefs[i].UltimateRequirment);
					if(saveGameData.SkillRefs[i].SkillID != 0)
					{
						skills[j].SetSkillID(saveGameData.SkillRefs[i].SkillID);
					}
				}
			} 
		}

		for(j = 0; j < skills.Length; ++j)
		{
			mSkillManager.AddLearnableAbilities( skills[j] );
		}

		mEquipment = saveGameData.Equipment;
		mEquipment.Init(true);
		mEquipment.SetEquipmentOwner( self );
	}

	if(saveGameData.Inventory != none)
	{
		mInventory = saveGameData.Inventory;
		mInventory.Init( self , true);
	}
	else if(mIsHero && saveGameData.Inventory == none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("RestoreState -> Inventory is none for a Hero! Can't Init!", 1);;
	}
	

	if(!mIsHero)
	{
		return;
	}
	
	
	for( i = 0; i < saveGameData.LearnedAbilityRefs.Length; ++i )
	{
		ability = H7HeroAbility(DynamicLoadObject(saveGameData.LearnedAbilityRefs[i], class'H7HeroAbility') );
		ability = H7HeroAbility( mAbilityManager.GetAbility( ability ) );
		mSkillManager.AddToLearnedAbilities( ability );
	}

	rndSkillManager = mSkillManager.GetRndSkillManager();

	if( class'H7AdventureController'.static.GetInstance().GetRandomSkilling() )
	{
		rndSkillManager.ClearPickedAbilitiesAndSkills();
		rndSkillManager.SetIsReset( saveGameData.RandomIsReset );

		for( i = 0; i < saveGameData.RandomPickedSkillRefs.Length; ++i )
		{
			skill = mSkillManager.GetSkillInstance(,H7Skill(DynamicLoadObject(saveGameData.RandomPickedSkillRefs[i], class'H7Skill') ));
			if(skill == none) continue;
			rndSkillManager.AddPickedSkill( skill );
		}

		for( i = 0; i < saveGameData.RandomPickedAbilityRefs.Length; ++i )
		{
			ability = H7HeroAbility(DynamicLoadObject(saveGameData.RandomPickedAbilityRefs[i], class'H7HeroAbility') );
			if(ability == none) continue;
			rndSkillManager.AddPickedAbility( ability );
		}

		for( i = 0; i < saveGameData.PickableSkillPoolRefs.Length; ++i)
		{
			skill = mSkillManager.GetSkillInstance(,H7Skill(DynamicLoadObject(saveGameData.PickableSkillPoolRefs[i], class'H7Skill') ));
			if(skill == none) continue;
			rndSkillManager.AddSkillToPool(skill, saveGameData.WeightForSkills[i]);
		}

		for( i = 0; i < saveGameData.PickableAbilityPoolRefs.Length; ++i)
		{
			ability = H7HeroAbility(DynamicLoadObject(saveGameData.PickableAbilityPoolRefs[i], class'H7HeroAbility') );
			if(ability == none) continue;
			rndSkillManager.AddAbilityToPool(ability, saveGameData.WeightForAbilities[i]);
		}
	}

	// Restore quickbar spells
	mAbilityManager.GetHeroAbilities(quickBarTemp);
	for(i = 0; i < saveGameData.QuickBarCombatRefs.Length; ++i)
	{   
		for(j = 0; j < quickBarTemp.Length; ++j)
		{
			if(Pathname(quickBarTemp[j].ObjectArchetype) == saveGameData.QuickBarCombatRefs[i])
			{   
				mQuickBarCombat.AddItem(quickBarTemp[j]);
				break;
			}
		}
	}

	for(i = 0; i < saveGameData.QuickBarAdventureRefs.Length; ++i)
	{   
		for(j = 0; j < quickBarTemp.Length; ++j)
		{
			if(Pathname(quickBarTemp[j].ObjectArchetype) == saveGameData.QuickBarAdventureRefs[i])
			{   
				mQuickBarAdventure.AddItem(quickBarTemp[j]);
				break;
			}
		}
	}
	

	mBuffManager = saveGameData.BuffManager;
	mBuffManager.SetOwner( self );

	if( saveGameData.GovernedTown != none )
	{
		mGovernedTown = saveGameData.GovernedTown;
		mGovernedTown.SetGovernorComplete( self );
	}
	
	
	mAiInHibernation = saveGameData.AiHibernation;
	mAiAggressiveness = saveGameData.AiAggressiveness;
	mScoutingRadius = saveGameData.ScoutingRadius;
	mCanScout = saveGameData.CanScout;
	mIsAlliedWithEverybody = saveGameData.IsAlliedWithEverybody;
	mTerrainCostModifier = saveGameData.TerrainCostModifier;
	mIsPendingLevelUp = saveGameData.IsPendingLevel;
}

function RestoreSavedPath(SavegameHeroStruct saveGameData)
{
	local array<float> pathCosts;
	local int numOfWalkableCells;

	if(saveGameData.LastCellMovement.GridIndex != -1 && saveGameData.LastCellMovement.Coordinates.X != -1 && saveGameData.LastCellMovement.Coordinates.Y != -1 && GetPlayer().GetPlayerType() != PLAYER_AI)
	{
		mLastCellMovement = class'H7AdventureGridManager'.static.GetInstance().GetCell( saveGameData.LastCellMovement.Coordinates.X, 
																						saveGameData.LastCellMovement.Coordinates.Y, 
																						saveGameData.LastCellMovement.GridIndex );							

		if(mLastCellMovement != none )
		{

			SetCurrentPath( class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPath( GetAdventureArmy().GetCell(), mLastCellMovement, GetPlayer(), GetAdventureArmy().HasShip(), true, false ) );
		
			pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( mCurrentPath, 
																									GetAdventureArmy().GetCell(), 
																									GetCurrentMovementPoints(), 
																									numOfWalkableCells );	

			class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().ShowPreview(mCurrentPath,0,GetCurrentMovementPoints(),GetMovementPoints(), pathCosts);
		}
	}
}

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame) { super.DeserializeReferences( Data, saveGame ); }

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	data.type = TT_TYPE_HERO_ARMY;
	data.strData = "<font size='#TT_BODY#'>"$self.GetName()$"</font>";
	data.addRightMouseIcon = true;
	return data;
}

function GUIAddListener(GFxObject data,optional H7ListenFocus focus)
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data,focus);
}

function DataChanged(optional String cause)
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

function float IncreaseBaseStatByID( Estat desiredStat, optional int amount = 1 )
{
	switch(desiredStat)
	{
	case STAT_SIGHT_RADIUS:
		mScoutingRadius += amount;
		return amount;
		break;
	case STAT_TERRAIN_COST:
		mTerrainCostModifier += amount;
		return amount;
		break;
	default:
		return super.IncreaseBaseStatByID(desiredStat, amount);
	}
}

function DecreaseBaseStatByID( Estat desiredStat, optional int amount = 1 )
{
	switch(desiredStat)
	{
	case STAT_SIGHT_RADIUS:
		mScoutingRadius =  FClamp(mScoutingRadius - amount, 0, MaxInt);
		break;
	case STAT_TERRAIN_COST:
		mTerrainCostModifier = FClamp(mTerrainCostModifier - amount, 0, MaxInt);
		break;
	default:
		super.DecreaseBaseStatByID(desiredStat, amount);
	}
}

function SetBaseStatByID( Estat desiredStat, int newValue )
{
	switch(desiredStat)
	{
	case STAT_SIGHT_RADIUS:
		mScoutingRadius = newValue;
		break;
	case STAT_TERRAIN_COST:
		mTerrainCostModifier = newValue;
		break;
	default:
		super.SetBaseStatByID(desiredStat, newValue);
	}
}

function DelayedTearOfAshaRevealMessageSuccess()
{
	local H7HeroItem tearTemplate;
	local string fctMessage;
	local H7Message message;
	local array<H7Player> players;
	local int i;

	tearTemplate = class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate;

	fctMessage = class'H7Loca'.static.LocalizeSave("FCT_RETRIEVE_TEAR_OF_ASHA","H7FCT");
	fctMessage = Repl( fctMessage, "%item", tearTemplate.GetName() );
	class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, GetLocation(), GetPlayer(), fctMessage, MakeColor( 255, 255, 0, 255 ) );

	

	if(GetPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
	{
		message = class'H7GUIGeneralProperties'.static.GetInstance().mMessageMapping.mTearFound.CreateMessageBasedOnMe();
		message.AddRepl("%hero",GetName());
		message.AddRepl("%player",GetPlayer().GetName());
		message.AddRepl("%item",tearTemplate.GetName());
		message.mPlayerNumber = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber();
		//"%hero of player %player has found %item."
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}

	if(class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		players = class'H7AdventureController'.static.GetInstance().GetPlayers();
		for(i=0;i<players.Length;i++)
		{
			if(players[i].GetPlayerNumber() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
			{
				message = class'H7GUIGeneralProperties'.static.GetInstance().mMessageMapping.mTearFound.CreateMessageBasedOnMe();
				message.AddRepl("%hero",GetName());
				message.AddRepl("%player",GetPlayer().GetName());
				message.AddRepl("%item",tearTemplate.GetName());
				message.mPlayerNumber = players[i].GetPlayerNumber();
				class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			}
		}
	}
}

function DelayedTearOfAshaRevealMessageFail()
{
	local H7HeroItem tearTemplate;
	local string fctMessage;

	tearTemplate = class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate;

	fctMessage = class'H7Loca'.static.LocalizeSave("FCT_RETRIEVE_TEAR_OF_ASHA_FAIL","H7FCT");
	fctMessage = Repl( fctMessage, "%item", tearTemplate.GetName() );
	class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, GetLocation(), GetPlayer(), fctMessage, MakeColor( 255, 0, 0, 255 ) );
}

/* Logs current game state for OOS */
function DumpCurrentState()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("    Hero:"@GetName()@GetFaction().GetName(), 0);;
	mSkillManager.DumpCurrentState();
	mEquipment.DumpCurrentState();
}

simulated event Destroyed()
{
	mMoveControl.Destroy();
	
	super.Destroyed();
}

