//=============================================================================
// H7EditorWarUnit
//=============================================================================
// ... http://i.imgur.com/bazqF.gif
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorWarUnit extends H7Unit
	perobjectconfig
	native
	dependson(H7WarUnit)
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	savegame;

var(WarUnitProperties) protected localized string			mDesc<DisplayName=Unit Desc>;
var(WarUnitProperties) protected EWarUnitClass				mWarUnitClass<DisplayName=Classification>;
var(WarUnitProperties) protected H7BaseAbility				mDefaultAttackAbility<DisplayName=Attack ability>;
var(WarUnitProperties) protected H7BaseAbility              mDefaultAbility<DisplayName=Warfare base ability>;
var(WarUnitProperties) protected H7BaseAbility              mDefaultWaitAbility<DisplayName=Warfare Wait ability>;
var(WarUnitProperties) protected H7BaseAbility              mDefaultSupportAbility<DisplayName=Warfare support ability>;
var(WarUnitProperties) protected H7BaseAbility              mSkipAbility<DisplayName=Skip turn ability>;

var(WarUnitStats) protected int 				            mHitpoints<DisplayName=Hitpoints>;

var(Visuals) dynload protected H7WarfareVisuals             mVisuals<DisplayName=Warfare Unit Visuals>;
var protected H7EditorWarUnit                               mTemplate;

var(Audio) protected AkEvent                                mGetHitSound<DisplayName=Get Hit sound>;
var(Audio) protected AkEvent                                mGetDamageSound<DisplayName= Get damaged/destroyed sound>;

var	protectedwrite const SkeletalMeshComponent				mSkeletalMeshAura;

function H7BaseAbility              GetDefaultSupportAbility()  { return mDefaultSupportAbility; }
function H7BaseAbility              GetDefaultAttackAbility()   { return mDefaultAttackAbility; }

function String						GetName()               { return class'H7Loca'.static.LocalizeContent(self,"mName", mName); }             
function String						GetDesc()               { return class'H7Loca'.static.LocalizeContent(self,"mDesc", mDesc); }   
function EWarUnitClass				GetWarUnitClass()       { return mWarUnitClass; }
function array<H7ResourceQuantity>  GetUnitCost()           { return mUnitCost; }
function H7Faction					GetFaction()            { return mFaction; }
function int                        GetHitPoints()          { return mHitpoints; }
function EAttackRange               GetAttackRange()        { return CATTACKRANGE_FULL; }
function EMovementType              GetMovementType()       { return CMOVEMENT_STATIC; }
function int                        GetAttack()             { return mAttack; }
function int                        GetDefense()            { return mDefense; }
function int                        GetDestiny()            { return 0; }
function int                        GetLeadership()         { return 0; }
function int                        GetInitiative()         { return mInitiative; }
function int                        GetMovementPoints()     { return 0; }   
function EAbilitySchool		        GetSchool()             { return mDefaultAttackAbility.GetSchool(); }
function float                      GetMinimumDamage()      { return mDefaultAttackAbility == none ? 0 : mDefaultAttackAbility.GetEffectDamage().mDamage.MinValue; }
function float                      GetMaximumDamage()      { return mDefaultAttackAbility == none ? 0 : mDefaultAttackAbility.GetEffectDamage().mDamage.MaxValue; }
function                            UnloadVisuals()         { mVisuals = none ; }

function H7WarfareVisuals GetVisuals()
{
	if( mVisuals == none ) 
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mVisuals');
		}
		else
		{
			// TODO: Investigate
			if(mTemplate == self)
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Warfare Unit"@self@GetName()@"is not an archetype and has its template set to itself",MD_QA_LOG);;
			}
			else
			{
				mVisuals = mTemplate.GetVisuals();
			}
		}
	}
	return mVisuals;
}

function H7WarUnit CreateWarUnit( optional H7EditorArmy unitArmy, optional name unitTag, optional rotator unitRotation, optional H7EditorWarUnit template) 
{
	local H7WarUnit unit;

	mTemplate = template; 

	unit = Spawn( class'H7WarUnit', unitArmy, unitTag,, unitRotation );
	
	unit.SetName(GetName());
	unit.SetInitiative(mInitiative);
	unit.SetHitPointsBase(mHitpoints);
	unit.SetAnimEvents( GetVisuals().GetWUEvents() );
	unit.SetDeathMaterialEffects( GetVisuals().GetDeathMaterialEffects() );
	unit.SetMeshes( GetVisuals().GetSkeletalMesh(), GetVisuals().GetAimingSkeletalMesh() );
	unit.SetWarUnitClass( mWarUnitClass );
	unit.SetFaction( mFaction );
	unit.SetIcon( mIcon );
	unit.SetArmy( unitArmy );
	unit.SetBaseAttack( mAttack );
	unit.SetBaseDefense( mDefense );
	unit.SetUnitCosts( mUnitCost );
	unit.SetRangedAttackAbility( mDefaultAttackAbility );
	unit.SetWaitAbility( mDefaultWaitAbility );
	unit.SetDefaultAbility( mDefaultAbility );
	unit.SetSupportAbility( mDefaultSupportAbility );
	unit.SetSkipAbility( mSkipAbility );
	unit.SetDamageSoundEvent( mGetDamageSound );
	unit.SetGetHitSoundEvent( mGetHitSound );
	unit.SetTemplate( self );
	unit.Init();

	return unit; 
}

function bool CanPlayerAffordWarUnit(H7Player player)
{
	return player.GetResourceSet().CanSpendResources( GetUnitCost() );
}

