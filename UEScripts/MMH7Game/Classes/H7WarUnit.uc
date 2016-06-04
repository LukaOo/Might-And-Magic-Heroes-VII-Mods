//=============================================================================
// H7WarUnit
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WarUnit extends H7Unit
	implements(H7IGUIListenable)
	native
	dependson(H7WarUnitAnimControl);

var protected int                               mCurrentHitpoints<DisplayName=Current Hitpoints|ClampMin=0>;
var protected int					            mHitpoints<DisplayName=Hitpoints|ClampMin=0>;
var protected int                               mBaseAttack<DisplayName=Attack>;
var protected int                               mBaseDefense<DisplayName=Defense>;
var protected bool                              mIsHovering;

var protected EWarUnitClass	                    mWarUnitClass<DisplayName=Classification>;

var protected H7CombatMapGridController			mCombatGridController;
var protected H7CombatController				mCombatController;

// visuals 
var protected Array<H7DeathMaterialEffect>	    mDeathMaterialFX;
var protected Array<H7DeathMaterialEffect>	    CurrentDeathMaterialEffects;

var protected H7WarUnitFX					    mFX;
var protected H7WarUnitAnimControl				mAnimControl;
var protected array<H7WarfareEvent>             mAnimControlEvents;
var protected EWarUnitAnimation                 mOrientedAttackAnimId;
var protectedwrite SkeletalMeshComponent		mSkeletalMesh;
var protectedwrite SkeletalMeshComponent		mAimingSkeletalMesh;
var	protectedwrite const SkeletalMeshComponent	mSkeletalMeshAura;
var protected DynamicLightEnvironmentComponent	mDynamicLightEnv;
var protected array<MaterialInstanceConstant>   mWarUnitMaterials;



var protected AkEvent                           mDamageSoundEvent;
var protected AkEvent                           mHitSoundEvent;

/** Important its a Template (Archetype) **/
var protected H7BaseAbility                     mDefaultWarfareAbility;             
/** Important its a Template (Archetype) **/
var protected H7BaseAbility                     mDefaultWarfareSupportAbility;
/** Important its a Template (Archetype) **/
var protected H7BaseAbility                     mSkipAbility;

// aiming variables
var protected Vector	                        mTargetLocation;
var protected Rotator	                        mStartRot;
var protected float		                        mAimingTime;
var protected bool                              mAIControlled;

var protected H7EditorWarUnit                   mTemplate;

function						SetGridPosition( IntPoint gp )					{ mGridPos = gp; }
function IntPoint				GetGridPosition( )								{ return mGridPos; }
function H7CombatMapCell        GetCell()                                       { return mCombatGridController.GetCombatGrid().GetCellByIntPoint( GetGridPosition() ); }

native function EUnitType		GetEntityType();
function                        SetAIControled( bool b )                        { mAIControlled = b; }
function EWarUnitClass          GetWarUnitClass()                               { return mWarUnitClass; }
function                        SetWarUnitClass( EWarUnitClass c )              { mWarUnitClass=c; }
function                        SetFaction( H7Faction faction )                 { mFaction = faction; }
function                        SetIcon( Texture2D icon )                       { mIcon = icon; }
function H7WarUnitAnimControl	GetAnimControl()				                { return mAnimControl; }
function EWarUnitAnimation      GetOrientedAttackAnimId()                       { return mOrientedAttackAnimId; }
function                        SetAnimEvents( array<H7WarfareEvent> e )        { mAnimControlEvents=e; }
function bool                   HasFullAction()                                 { return !mSkipTurn && CanAttack(); }

function H7EditorWarUnit        GetTemplate()                                   { return mTemplate; }
function	                    SetTemplate(H7EditorWarUnit template)	        { mTemplate = template; }

function bool					IsControlledByAI()								{ return GetCombatArmy().GetPlayer().IsControlledByAI() || mAIControlled; }

function Texture2D GetIcon()
{
	if(!class'H7GameUtility'.static.IsArchetype(self) && InStr(string(ObjectArchetype),"Default__") != INDEX_NONE && mTemplate != none) 
	{
		return mTemplate.GetIcon(); // crap instances without real archetype use the manual archetype
	}
	else
	{
		return super.GetIcon();
	}
}

function int                    GetBaseAttack()                                 { return mBaseAttack; }
function int                    GetBaseDefense()                                { return mBaseDefense; }
function EAbilitySchool GetSchool()                                     
{ 
	if(mWarUnitClass==WCLASS_SUPPORT)
	{
		if(mDefaultWarfareSupportAbility != none) 
		{
			return mDefaultWarfareSupportAbility.GetSchool();
		}
	}
	if(mRangedAttackAbilityTemplate != none)
	{
		return mRangedAttackAbilityTemplate.GetSchool();
	}
	return MIGHT;
}
function EAttackRange           GetAttackRange()                                { return CATTACKRANGE_FULL; }
function EMovementType          GetMovementType()                               { return CMOVEMENT_STATIC; }
function int                    GetStackSize()                                  { return IsDead() ? 0 : 1; }
function int                    GetInitialStackSize()                           { return 1; }

function int        		    GetHitPointsBase()				                { return mHitpoints; }
function         		        SetHitPointsBase(int hp)				        { mHitpoints = hp; }
function int        			GetHitPoints()				                    { return GetModifiedStatByID( STAT_HEALTH ); }
function                        SetCurrentHitPoints(int newValue)               { mCurrentHitpoints = newValue; }
function int                    GetCurrentHitPoints()                           { return mCurrentHitpoints; }
/** Important its a Template (Archetype) **/
function H7BaseAbility          GetSupportAbility()                             { return mDefaultWarfareSupportAbility; }
function H7BaseAbility          GetDefaultAbility()                             { return mDefaultWarfareAbility; }
/** Important its a Template (Archetype) **/
function H7BaseAbility          GetSkipAbility()                                { return mSkipAbility;}

native function ECellSize		GetUnitBaseSize();
function int				    GetUnitBaseSizeInt()	                        { return CELLSIZE_2x2 + 1; }

function int                    GetMovementPoints()                             { return 0; }

function						SetDamage( int minDmg, int maxDmg )				{ mMinimumDamage = minDmg; mMaximumDamage = maxDmg; }
function                        SetDefaultAbility( H7BaseAbility a )            { mDefaultWarfareAbility = a; }
function                        SetSupportAbility(H7BaseAbility a)              { mDefaultWarfareSupportAbility = a;}
function                        SetRangedAttackAbility( H7BaseAbility ability ) { mRangedAttackAbilityTemplate = ability; }
function                        SetSkipAbility( H7BaseAbility ability )         { mSkipAbility = ability; }
function                        SetBaseAttack(int attack )                      { mBaseAttack = attack; }
function                        SetBaseDefense(int defense )                    { mBaseDefense = defense; }
function                        SetDamageSoundEvent(AkEvent sound)              { mDamageSoundEvent = sound; }
function                        SetGetHitSoundEvent(AkEvent sound)              { mHitSoundEvent = sound; }

native function bool IsDead();
native function Vector GetSocketLocation( name socketName );

function string GetName() // for some reason warunit have no real archetype, so we localize instance, which for another unknown reason actually works
{
	if(mNameInst == "") 
	{
		mNameInst = class'H7Loca'.static.LocalizeContent(self, "mName", mName);
	}
	return mNameInst;
}

function Init( optional bool fromSave )
{
	local array<H7BaseAbility> abilities;
	super.Init( fromSave );
	
	mAbilityManager.GetAbilities(abilities);
	mAbilityManager.Init( self, abilities );
	
	if( GetWaitAbility() != none )      	    {   mAbilityManager.LearnAbility( GetWaitAbility() );	            }
	if( GetRangedAttackAbility() != none ) 	    {	mAbilityManager.LearnAbility( GetRangedAttackAbility() );       }
	if( mDefaultWarfareAbility != none )        {   mAbilityManager.LearnAbility( mDefaultWarfareAbility );         }
	if( mDefaultWarfareSupportAbility != none)  {   mAbilityManager.LearnAbility( mDefaultWarfareSupportAbility );  }
	if( GetSkipAbility() != none )              {   mAbilityManager.LearnAbility( mSkipAbility );                   }
	
	mCurrentHitpoints = GetHitPoints();
	mAttack = GetBaseAttack();
	mDefense = GetBaseDefense();
	mCombatController = class'H7CombatController'.static.GetInstance();
	mCombatGridController = class'H7CombatMapGridController'.static.GetInstance();
    mAIControlled = true;
	mDoStatusCheck = true;
	InitFX();
	mSkeletalMesh.SetOutlineColor( GetCombatArmy().GetPlayer().GetColor() );
	mAimingSkeletalMesh.SetOutlineColor( GetCombatArmy().GetPlayer().GetColor() );
}

function H7BaseAbility GetSkipTurnAbility()
{
	return GetSkipAbility();
}

function DoSkip()
{
	local array<H7Command> commands;

	if( !mSkipTurn )
	{
		commands = class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().GetCmdsForCaster( self );
		if( !GetPreparedAbility().IsEqual( GetSkipTurnAbility() ) && commands.Length == 0 )
		{
			PrepareAbility( mAbilityManager.GetAbility( GetSkipTurnAbility() ) );
			class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( self ); 
		}
	}
}

function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	
}

function GUIAddListener(GFxObject data,optional H7ListenFocus focus) 
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}

function DataChanged(optional String cause) 
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

function int					    GetMinimumDamageBase()							{ return GetMinimumDamage(); }
function int					    GetMaximumDamageBase()							{ return GetMaximumDamage(); }

function float GetMinimumDamage()                              
{ 
	local H7ICaster heroCaster;
	local H7EffectDamage dmg;

	heroCaster = GetCombatArmy().GetHero();
	if( mWarUnitClass == WCLASS_SUPPORT && mDefaultWarfareSupportAbility != none && mRangedAttackAbilityTemplate == none )
	{
		dmg = mAbilityManager.GetAbility( mDefaultWarfareSupportAbility ).GetDamageEffect(heroCaster);
		if( dmg == none ) return 0;
		return dmg.GetDamageRangeFinal(true).MinValue;
	}

	if( mRangedAttackAbilityTemplate != none )
	{
		dmg = mAbilityManager.GetAbility( mRangedAttackAbilityTemplate ).GetDamageEffect(heroCaster);
		if( dmg == none ) return 0;
		return dmg.GetDamageRangeFinal(true).MinValue;
	}

	return GetModifiedStatByID(STAT_MIN_DAMAGE);
}

function float GetMaximumDamage()                              
{
	local H7ICaster heroCaster;
	local H7EffectDamage dmg;

	heroCaster = GetCombatArmy().GetHero();
	if( mWarUnitClass == WCLASS_SUPPORT && mDefaultWarfareSupportAbility != none && mRangedAttackAbilityTemplate == none )
	{
		dmg = mAbilityManager.GetAbility( mDefaultWarfareSupportAbility ).GetDamageEffect(heroCaster);
		if( dmg == none ) return 0;
		return dmg.GetDamageRangeFinal(true).MaxValue;
	}

	if( mRangedAttackAbilityTemplate != none )
	{
		dmg = mAbilityManager.GetAbility( mRangedAttackAbilityTemplate ).GetDamageEffect(heroCaster);
		if( dmg == none ) return 0;
		return dmg.GetDamageRangeFinal(true).MaxValue;
	}

	return GetModifiedStatByID(STAT_MAX_DAMAGE);
}

function ReplaceSupportAbility( H7BaseAbility a )
{
	if( a.IsEqual( mDefaultWarfareSupportAbility ) ) return;

	if( mDefaultWarfareSupportAbility != none )
		mAbilityManager.UnlearnAbility( mDefaultWarfareSupportAbility );

	mDefaultWarfareSupportAbility = a;

	if( mDefaultWarfareSupportAbility != none )
		mAbilityManager.LearnAbility( mDefaultWarfareSupportAbility );
}

function ReplaceDefaultAbility( H7BaseAbility a )
{
	if( a.IsEqual( mDefaultWarfareAbility ) ) return;

	if( mDefaultWarfareAbility != none )
		mAbilityManager.UnlearnAbility( mDefaultWarfareAbility );

	mDefaultWarfareAbility = a;

	if( mDefaultWarfareAbility != none )
		mAbilityManager.LearnAbility( mDefaultWarfareAbility );
}

function ReplaceAttackAbility( H7BaseAbility a )
{
	if( a.IsEqual( mRangedAttackAbilityTemplate ) ) return;

	if( mRangedAttackAbilityTemplate != none )
		mAbilityManager.UnlearnAbility( mRangedAttackAbilityTemplate );

	mRangedAttackAbilityTemplate = a;

	if( mRangedAttackAbilityTemplate != none )
		mAbilityManager.LearnAbility( mRangedAttackAbilityTemplate );
}

/** Override to un-clusterfuck H7Unit's PrepareDefaultAbility.
 *  Do NOT call super.PrepareDefaultAbility() here or you'll get an infinite loop!
 */
function PrepareDefaultAbility()
{
	// 1. try to attack
	// 2. try to support
	// 3. do nothing and fail at life
	if( GetRangedAttackAbility() != none && GetAbilityManager().GetAbility( GetRangedAttackAbility() ).CanCast() )
	{
		PrepareAbility( GetRangedAttackAbility() );
		if( !IsControlledByAI() )
			class'H7CombatHudCntl'.static.GetInstance().GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);
	}
	else if( GetSupportAbility() != none && GetAbilityManager().GetAbility( GetSupportAbility() ).CanCast() )
	{
		// this will prepare the support ability AND highlight the button
		// if this is not done automatically, the player will be stuck with no prepared ability
		// which drives the combat map cursor mad (and the player too)
		if( GetPreparedAbility().IsEqual( GetSkipAbility() ) )
		{
			// apparently the user has other ideas? (like skip turn)
			PrepareAbility( GetRangedAttackAbility() );
			if( !IsControlledByAI() )
				class'H7CombatHudCntl'.static.GetInstance().GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);
		}
		else
		{
			if( !IsControlledByAI() )
			{
				if( mIsWaitTurn ) PrepareAbility( none ); // clear prepared ability, else the button highlight will crap out a lot
				class'H7CombatHudCntl'.static.GetInstance().HighlightButtonFor( GetSupportAbility(), true );
			}
			else
			{
				PrepareAbility( GetSupportAbility() );
			}
		}
	}
	else
	{
		GetAbilityManager().PrepareAbility( none );
	}
}

function RecalculatePostAnimInput()
{
	local bool allow;
	super.RecalculatePostAnimInput();

	allow = class'H7PlayerController'.static.GetPlayerController().IsUnrealAllowsInput();
	class'H7CombatHud'.static.GetInstance().GetCombatHudCntl().SetMyTurn( allow );
	PrepareDefaultAbility();
}


// called every frame for every stack on the map, but has internal check, only runs when mDoStatusCheck was set to true in this frame
function UpdateSlotFX()
{
	local H7Unit activeUnit;
	local H7CombatMapCell myCell;
	
	if( mDoStatusCheck )
	{
		if( !mCombatController.IsInTacticsPhase() )
		{
			activeUnit = mCombatController.GetActiveUnit();
			myCell = mCombatGridController.GetCombatGrid().GetCellByIntPoint( GetGridPosition() );

			if( !mCombatController.AllAnimationsDone() || !MPIsYourTurn() || mCombatController.IsEndOfCombat()
				|| class'H7CombatPlayerController'.static.GetCombatPlayerController().IsInCinematicView() || mCombatController.GetActiveUnit().GetPlayer().GetPlayerType() == PLAYER_AI )
			{
				HideSlotFX( myCell );	//	We are busy and don't want our slots to be highlighted
			}
			else if( activeUnit == self )
			{
				ShowSlotFXActive( myCell );	// I am the active unit
			}
			else if( activeUnit.HasPreparedAbility() )
			{
				UpdateAbilitySlotFX( myCell, activeUnit.GetPreparedAbility());	//	The active unit could cast a spell on me
			}
			else
			{
				HideSlotFX( myCell );	//	The active unit cannot touch me. Better luck next time, active unit!
			}
		}
		mDoStatusCheck = false; // I am done, until somebody tells me to recheck
	}
}

protected function UpdateAbilitySlotFX(H7CombatMapCell myCell, H7BaseAbility preparedAbility)
{
	local array<H7CombatMapCell> validPositions, dummyArray;
	local H7ICaster caster;
	local H7IEffectTargetable targetOnCell;
	local H7Unit unit;
	dummyArray.Length = 0;
	caster = preparedAbility.GetCaster().GetOriginal();
	targetOnCell = myCell.GetTargetable();
	unit = H7Unit( targetOnCell );
	if( preparedAbility.GetCaster().GetOriginal().IsA( 'H7CreatureStack' ) )
	{
		if( !H7Unit( caster ).CanAttack() )
		{
			HideSlotFX( myCell );
			return;
		}
		if( !preparedAbility.IsRanged() )
		{
			mCombatGridController.GetCombatGrid().GetAllAttackPositionsAgainst( self, H7Unit( caster ), validPositions );
			if( validPositions.Length == 0 )
			{
				HideSlotFX( myCell );
				return;
			}
		}
		else if( mCombatGridController.GetCombatGrid().HasAdjacentCreature( H7Unit( caster ), none, true, dummyArray ) )
		{
			HideSlotFX( myCell );
			return;
		}
	}
	else if( preparedAbility.GetCaster().GetOriginal().IsA( 'H7WarUnit' ) )
	{
		if( !H7Unit( caster ).CanAttack() )
		{
			HideSlotFX( myCell );
			return;
		}
	}
	if( preparedAbility.CanCastOnTargetActor( self ) )
	{
		if( unit != none && preparedAbility.CanAffectAlly() )
		{
			if( unit.GetCombatArmy() == mCombatController.GetActiveArmy() )
			{
				if( IsDead() )
				{
					ShowSlotFXDeadAlly( myCell );
				}
				else
				{
					ShowSlotFXAlly( myCell );
				}
			}
		}
		else
		{
			ShowSlotFXEnemy( myCell );
		}
	}
	else
	{
		HideSlotFX( myCell );
	}
}

function TurnChanged()
{
	StatusChanged(); // next frame expensive calculations and checks are redone
}

protected function ShowSlotFXActive( H7CombatMapCell myCell )
{
	mFX.UpdateTargetColor( mFX.GetProperties().ActiveTargetColor );

	if( myCell != None )
	{
		myCell.SetSelectedMerged( true );
	}
}

protected function ShowSlotFXEnemy( H7CombatMapCell myCell )
{
	mFX.UpdateTargetColor( mFX.GetProperties().EnemyTargetColor );

	if( myCell != None )
	{
		myCell.SetSelectedMergedEnemy( true );
	}
}

protected function ShowSlotFXAlly( H7CombatMapCell myCell )
{
	mFX.UpdateTargetColor( mFX.GetProperties().AllyTargetColor );

	if( myCell != None )
	{
		myCell.SetSelectedMergedAlly( true );
	}
}

protected function ShowSlotFXDeadAlly( H7CombatMapCell myCell )
{
	mFX.UpdateTargetColor( mFX.GetProperties().AllyTargetColor );

	if( myCell != None )
	{
		myCell.SetSelectedMergedDeadAlly( true );
	}
}

protected function HideSlotFX( H7CombatMapCell myCell )
{
	mFX.DestroyFX();
	if( myCell != none )
	{
		myCell.SetSelectedMerged( false );
		
		// deselect 2nd layer for dead units 
		myCell.SetSelectedMerged( false, SELECTED_DEAD_ALLY );
	}
}


function HighlightWarfareUnit()
{
	if( !mIsHovering ) 
	{	
		mFX.SetIsHovering( true );
		mIsHovering = true;
		class'H7CombatHudCntl'.static.GetInstance().HightlightSlots( GetID() );
	}
}

function DeHighlightWarfareUnit()
{
	mFX.SetIsHovering( false );
	mIsHovering = false;
	class'H7CombatHudCntl'.static.GetInstance().DehighlightSlots( GetID() );
}


native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType exclusiveFirstOT = -1, optional EOperationType exclusiveSecondOT = -1, optional bool nextRound);

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true  )
{
	local EAbilitySchool attackSchool;
	local H7Message message;
	local H7EffectContainer container;
	local H7ICaster caster;
	local int currentHealth, healthMin, healthMax;

	local H7EventContainerStruct eventStruct;
	
	
	;

	if(isForecast)
	{
		GetDamageResult(result.GetDamageLow(resultIdx), healthMin );
		GetDamageResult(result.GetDamageHigh(resultIdx), healthMax );
		result.SetKillRange( ( healthMin <= 0 ? 1 : 0 ), ( healthMax <= 0 ? 1 : 0 ), resultIdx);
	}

	// find the damage to apply (or rather the state after damage)
	GetDamageResult(result.GetDamage(resultIdx), currentHealth ); // GET
	result.SetKills( currentHealth <= 0 ? 1 : 0 ,resultIdx);

	if(!isForecast)
	{
		// SET actually changing health&stacksize here:
		caster = result.GetAttacker().GetOriginal();
		if( H7Unit( caster ) != none )
		{
			H7Unit( caster ).SetKillsOnCurrentTurn( result.GetKills( resultIdx ) );
		}

		mCurrentHitpoints = currentHealth;

		container = result.GetCurrentEffect().GetSource();
		attackSchool = result.GetDamageSchool(resultIdx);

		TriggerGlobalEventClass( class'SeqEvent_TakeDamage', self, 0 );

		if(result.GetDamage(resultIdx) == 0)
		{
			class'H7FCTController'.static.GetInstance().startFCT(FCT_ERROR, GetFloatingTextLocation(), GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_IMMUNE","H7FCT"), MakeColor(200,200,200,255));

			message = new class'H7Message';
			message.text = "MSG_TARGET_IMMUNE";
			message.AddRepl("%target",GetName());
			message.AddRepl("%ability",container.GetName());
		}
		else
		{
			class'H7FCTController'.static.GetInstance().startFCT(FCT_DAMAGE, GetFloatingTextLocation(), GetPlayer(), string(result.GetDamage(resultIdx)), MakeColor(255,0,0,255));

			message = new class'H7Message';
			message.text = "MSG_TARGET_DAMAGE";
			message.AddRepl("%target",GetName());
			message.AddRepl("%value",string(result.GetDamage(resultIdx)) @ "<img width='#TT_POINT#' height='#TT_POINT#' src='" $ container.GetSchoolFlashPath(attackSchool) $ "'>" @ container.GetSchoolName(attackSchool));
			message.AddRepl("%amount",string(result.GetKills(resultIdx)));
		}

		message.destination = MD_LOG;
		message.settings.referenceObject = self;
		
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);

		;
		
		if(result.GetKills(resultIdx) > 0) 
		{
			class'H7FCTController'.static.GetInstance().startFCT(FCT_KILL, GetFloatingTextLocation(), GetPlayer(), string(result.GetKills(resultIdx)), MakeColor(255,0,0,255));	
		}

	
		// Killing the Warfare
		if( mCurrentHitpoints <= 0 )
		{
			SetDestroyed();
		}
		else
		{
			mAnimControl.PlayAnim(WA_HIT);
		}
		

		DataChanged("ApplyDamage");
	}
	
	if( raiseEvent )
	{
		eventStruct.Result = result;
		result.GetCurrentEffect().GetTagsPlusBaseTags( eventStruct.ActionTag );
		eventStruct.ActionSchool = result.GetCurrentEffect().GetSource().GetSchool();
		eventStruct.EffectContainer = result.GetCurrentEffect().GetSource();
		result.GetAttacker().GetOriginal().TriggerEvents( ON_DO_DAMAGE, isForecast, eventStruct );
		TriggerEvents(ON_GET_DAMAGE, isForecast, eventStruct );
	}

	if( !isForecast && result.GetKills() > 0 )
	{
		eventStruct.Amount = result.GetKills();
		result.GetCurrentEffect().GetTagsPlusBaseTags( eventStruct.ActionTag );
		eventStruct.ActionSchool = result.GetCurrentEffect().GetSource().GetSchool();
		eventStruct.EffectContainer = result.GetCurrentEffect().GetSource();
		result.GetAttacker().GetOriginal().TriggerEvents( ON_KILL_CREATURE, false, eventStruct );
	}
}

function PlayDeathEffect()
{
	local int i;
	local H7DeathMaterialEffect NewEffect;

	if ( mDeathMaterialFX.Length > 0)
	{
		SetTimer(0.05f, true, 'PlayDeathMaterialEffects');
		for (i = 0; i < mDeathMaterialFX.Length; i++)
		{
			// copy the effects into the duplicate list
			NewEffect = mDeathMaterialFX[i];
			NewEffect.EffectStartingTime = WorldInfo.TimeSeconds;
			CurrentDeathMaterialEffects.AddItem(NewEffect);
		}
	}
}

function PlayDeathMaterialEffects(optional bool undo = false)
{
	// call H7Unit function with correct arrays
	DoDeathMaterialEffectFading(CurrentDeathMaterialEffects, mWarUnitMaterials);
}

function SetDestroyed()
{
	mCurrentHitpoints = 0;
	mCombatController.SetSomeoneDying( true );

	// cause Designers (Macrus) wanted it that way 
	TriggerEvents( ON_CREATURE_DIE, false );
	mCombatController.GetGridController().GetAuraManager().TriggerEvents( ON_CREATURE_DIE, false, , self );
	mCombatController.RaiseEvent(ON_ANY_CREATURE_DIE,false);

	mAnimControl.PlayAnim( WA_DYING );

	mCombatController.GetCommandQueue().RemoveCmdsForCaster( self );
	mCombatController.GetCommandQueue().RemoveCmdsForTarget( self );

	GetCell().RemoveWarfareUnit();
	
	// dead creatures can't have buffs
	
	// not remove the creature if has the current turn, it will remove itself at the end of the turn
	if( self != H7WarUnit(mCombatController.GetActiveUnit()) )
	{
		mCombatController.GetInitiativeQueue().RemoveUnit( self );
	}
	else
	{
		ClearTurns();
	}

	mCombatController.GetArmyAttacker().UpdatedAlliesAndEnemies();
	mCombatController.GetArmyDefender().UpdatedAlliesAndEnemies();
	
	TriggerGlobalEventClass( class'SeqEvent_Death', self, 0 );

	;

	PlayDeathEffect();
}

function GetDamageResult( int dmg, out int currentHealth )
{
	currentHealth = mCurrentHitpoints;
	
	if(dmg < currentHealth)
	{
		currentHealth -= dmg;
		class'H7SoundManager'.static.PlayAkEventOnActor(self, mHitSoundEvent,true,true,self.Location);
	}
	else
	{
		currentHealth = 0;
		class'H7SoundManager'.static.PlayAkEventOnActor(self, mDamageSoundEvent,true,true,self.Location);
	}
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree( SkelComp );

	if( mAnimControl == none )
	{
		mAnimControl = Spawn( class'H7WarUnitAnimControl', self );
	}
	mAnimControl.Init( self, mSkeletalMesh, mAimingSkeletalMesh, mAnimControlEvents );

	SkeletalMeshComponent = mSkeletalMesh;
}

function SetDeathMaterialEffects( array<H7DeathMaterialEffect> deathFX )
{
	mDeathMaterialFX = deathFX;
}

function SetMeshes( SkeletalMeshComponent SkelMesh, SkeletalMeshComponent AimingSkelMesh )
{
	local MaterialInstanceConstant MatInst;
	local int i;
	mSkeletalMesh = new class'SkeletalMeshComponent'(SkelMesh);
	mSkeletalMesh.SetLightEnvironment( LightEnvironment );
	mSkeletalMesh.SetActorCollision( true, true, true );
	mSkeletalMesh.SetTraceBlocking( true, true );
	AttachComponent( mSkeletalMesh );
	CollisionComponent = mSkeletalMesh;

	if( AimingSkelMesh != none )
	{
		mAimingSkeletalMesh = new class'SkeletalMeshComponent'(AimingSkelMesh);
		mAimingSkeletalMesh.SetLightEnvironment( LightEnvironment );
		mAimingSkeletalMesh.SetActorCollision( true, true, true );
		mAimingSkeletalMesh.SetTraceBlocking( true, true );
		AttachComponent( mAimingSkeletalMesh );
	}

	if(mSkeletalMesh != none && mSkeletalMesh.SkeletalMesh != none)
	{
		for (i = 0; i < SkelMesh.SkeletalMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mSkeletalMesh.GetMaterial(i));
			mSkeletalMesh.SetMaterial(i, MatInst);
			mWarUnitMaterials.AddItem(MatInst);
		}
	}

	if(mAimingSkeletalMesh != none && mAimingSkeletalMesh.SkeletalMesh != none)
	{
		for (i = 0; i < SkelMesh.SkeletalMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mAimingSkeletalMesh.GetMaterial(i));
			mAimingSkeletalMesh.SetMaterial(i, MatInst);
			mWarUnitMaterials.AddItem(MatInst);
		}
	}
}

native function vector GetMeshCenter();

function float GetOrientationToTarget( H7IEffectTargetable target )
{
	local vector    vecAim, meshCenter;
	local float     degAim;

	if( target.IsA( 'H7CombatObstacleObject' ) )
	{
		meshCenter = H7CombatObstacleObject( target ).GetMeshCenter();
	}
	else if( target.IsA( 'H7CreatureStack' ) )
	{
		meshCenter = H7CreatureStack( target ).GetMeshCenter();
	}
	else
	{
		meshCenter = mCombatGridController.GetCellLocation( target.GetGridPosition() );
	}

	vecAim = Normal( meshCenter - GetMeshCenter() );
	degAim = ATan2(vecAim.y,vecAim.x) * class'Object'.const.RadToDeg;

	return degAim;
}

function EWarUnitAnimation GetOrientedAttackAnimFromAim( float aim )
{
	if( IsAttacker() )
	{
			 if( aim <= -25.0f ) return WA_ATTACK_LEFT_WIDE;
		else if( aim <= -10.0f ) return WA_ATTACK_LEFT;
		else if( aim <   10.0f ) return WA_ATTACK_CENTER;
		else if( aim <   25.0f ) return WA_ATTACK_RIGHT;
		return WA_ATTACK_RIGHT_WIDE;
	}
	else
	{
			 if( aim >= -180.0f && aim <= -170.0f ) return WA_ATTACK_CENTER;
		else if( aim <= 180.0f && aim >= 170.0f ) return WA_ATTACK_CENTER;
		else if( aim > -170.0f && aim <= -155.0f ) return WA_ATTACK_RIGHT;
		else if( aim < 170.0f && aim >= 155.0f ) return WA_ATTACK_LEFT;
		else if( aim >   0.0f ) return WA_ATTACK_LEFT_WIDE;
		return WA_ATTACK_RIGHT_WIDE;
	}
}

delegate OnFaceTargetObstacleFinishedFunc(){}
function FaceTargetObstacle( H7IEffectTargetable target, delegate<OnFaceTargetObstacleFinishedFunc> onFaceTargetObstacleFinished )
{
	OnFaceTargetObstacleFinishedFunc = onFaceTargetObstacleFinished;

	// our siege engine has its rotation in its attack anim :P
	// for the other types we may have to actually turn/rotate them
	mOrientedAttackAnimId = GetOrientedAttackAnimFromAim( GetOrientationToTarget(target) );

	if( mAimingSkeletalMesh == none )
	{
		mOrientedAttackAnimId = WA_ABILITY;
		OnFaceTargetObstacleFinishedFunc();
	}
	else
	{
		mTargetLocation = Actor( target ).Location;
		GotoState('Aiming');
	}
}

// the function is called to end the last turn for this unit and start with the new
function bool BeginTurn()
{
	super.BeginTurn();

	DebugLogSelf();

	mFX.ShowFX();

	return true;
}

function EndTurn()
{
	super.EndTurn();

	mFX.HideFX();
}

protected function InitFX()
{
	// slot FX
	mFX = Spawn(class'H7WarUnitFX', self );
	mFX.InitFX(self);
}


protected function DebugLogSelf()
{
	;
}

event Tick( float deltaTime )
{
	super.Tick( deltaTime );
	
	UpdateSlotFX();
	
	//	Disable highlight effect when an action is executed
	if( mIsHovering && !class'H7PlayerController'.static.GetPlayerController().IsUnrealAllowsInput() )
	{
		DeHighlightWarfareUnit();
	}
}

auto state Waiting
{
}

state Aiming
{
	event BeginState(name previousStateName)
	{
		mStartRot = mAimingSkeletalMesh.Rotation;
		mAimingTime = 0;
	}

	event Tick(float deltaTime)
	{
		local Rotator lerpRot, targetRot;
		local float oldRot;

		oldRot = mAimingSkeletalMesh.Rotation.Yaw;

		targetRot = GetOptimalTargetRotation( Location, mTargetLocation );
		mAimingTime += deltaTime;

		lerpRot = mStartRot;
		lerpRot.Yaw = Lerp( mStartRot.Yaw, targetRot.Yaw, mAimingTime );

		mAimingSkeletalMesh.SetRotation( lerpRot );
		if( Abs( oldRot - targetRot.Yaw ) <= Abs( mAimingSkeletalMesh.Rotation.Yaw - targetRot.Yaw ) )
		{
			lerpRot = mStartRot;
			lerpRot.Yaw = targetRot.Yaw;
			mAimingSkeletalMesh.SetRotation( lerpRot );

			GotoState('Waiting');
			OnFaceTargetObstacleFinishedFunc();
		}
	}

	protected function Rotator GetOptimalTargetRotation(Vector from, Vector to)
	{
		local Rotator lTargetRot1, lTargetRot2;

		lTargetRot1 = rotator(to - from);
		lTargetRot2 = lTargetRot1;
	
		if(lTargetRot1.Yaw < 0)
		{
			lTargetRot2.Yaw += 65540;
		}
		else
		{
			lTargetRot2.Yaw -= 65540;
		}

		// Check which of the two rotation possibilities is optimal
		if(abs(mStartRot.Yaw - lTargetRot1.Yaw) < abs(mStartRot.Yaw - lTargetRot2.Yaw))
		{
			return lTargetRot1;
		}
		else
		{
			return lTargetRot2;
		}
	}
}

function float GetHeight()
{
	return mSkeletalMesh.Bounds.BoxExtent.Z * 2.f;
}


function Vector GetFloatingTextLocation()
{
	local Vector loc;

	loc = Location;
	loc.Z += GetHeight();
	return loc;
}


