//=============================================================================
// H7EffectWithSpells
//
// - if an effect does somthing with a spell or buff or ability, it is of this type
// - uses data from the H7SpellEffect-struct
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectWithSpells extends H7Effect
	native(Tussi);

var() protected H7EffectContainer	mContainer; // can be anything ( Buff, Spell, Ability )
var() protected H7SpellEffect	    mData;
var() protected bool	            mSuppressesRetaliation;
var protected bool	                mCheckedSuppressesRetaliation;

function H7SpellEffect GetData()	    { return mData; }

event bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }
function bool SuppressesRetaliation()	{ return mSuppressesRetaliation; }

event InitSpecific(H7SpellEffect data,H7EffectContainer source,optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	properties.mConditions = data.mConditions;

	InitEffect(properties, source,registerEffect);
	mData = data;
	if( data.mSpellStruct.mSpell != none )
	{
		mContainer = new data.mSpellStruct.mSpell.Class(data.mSpellStruct.mSpell );
	}

	if( !mCheckedSuppressesRetaliation )
		CheckSuppressesRetaliation();
}

// used for simulation (hover tooltip) and real
function H7CombatResult GenerateCombatAction(optional H7CombatResult baseCombatAction)
{
	local array<H7IEffectTargetable> /*targets,*/defenders;
	local H7IEffectTargetable target;
	local H7CombatResult action;

	GetTargets( mTempTargets );

	if( mTempTargets.Length == 0)
		 ;

	action = super.GenerateCombatAction( baseCombatAction );

	action.SetActionId( ACTION_ABILITY ); // why effectwithspells to ACTION_ABILITY?

	foreach mTempTargets(target)
	{
		action.AddDefender(H7IEffectTargetable(target));
		defenders = action.GetDefenders();
		if(ShowInTooltip() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenEffects())	action.AddEffectToTooltip(self,defenders.Find(target));
		;
	}

	return action;
}

protected event Execute(optional bool isSimulated = false)
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7CombatResult result;

	;

	if( mEffectTarget == TARGET_TARGET )
	{
		UnpackContainer();
	}
	
	GetTargets( targets );

	;
	;
	;

	result = GenerateCombatAction();

	;

	class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().ResolveCombat( result, isSimulated );

	;
	;
	;
	
	targets = result.GetDefenders();

	// no fx on combat begin/tactics phase!
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().IsInNonCombatPhase())
	{
		return;	
	}

	if( GetSource().IsAbility() && H7BaseAbility( GetSource() ).IsPassive() && !H7BaseAbility( GetSource() ).IsAura() )
	{
		H7BaseAbility( GetSource() ).DoParticleFXCaster( GetSource().GetCasterOriginal() );

		CheckUpdateGUI( targets );
	}

	if( isSimulated ) return;

	if( GetData().mFX.mUseCasterPosition ) 
	{
		GetSource().GetCasterOriginal().GetEffectManager().AddToFXQueue( mData.mFX, self );
	}
	else 
	{
		foreach targets(target)
		{
			if( target.GetEffectManager() != none )
			{
				target.GetEffectManager().AddToFXQueue( mData.mFX, self );
			}
		}
	}
}

function CheckUpdateGUI( array<H7IEffectTargetable> targets)
{
	local H7IEffectTargetable target;

	if( H7BaseAbility( GetSource() ).IsAura() &&
		( mData.mSpellStruct.mSpellOperation == ADD_BUFF || mData.mSpellStruct.mSpellOperation == REMOVE_BUFF ) &&
		H7BaseBuff( mData.mSpellStruct.mSpell ) != none &&
		H7BaseBuff( mData.mSpellStruct.mSpell ).IsDisplayed() )
	{
		foreach targets(target)
		{
			if( H7Unit( target ) != none ) { continue; }

			class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateBuffs( H7Unit( target ) );
		}
	}
}

function CheckSuppressesRetaliation()
{
	local H7BaseBuff myBuff;
	local array<H7Effect> buffEff;
	local H7Effect currEff;

	mCheckedSuppressesRetaliation = true;
	
	if( mData.mSpellStruct.mSpellOperation == ADD_BUFF )
	{
		if( mData.mSpellStruct.mSpell.mEventuallySuppressesRetaliation )
		{
			myBuff = H7BaseBuff( mData.mSpellStruct.mSpell );

			if(myBuff == none) { mSuppressesRetaliation = false; return; } // remove this if we have abilities that block retaliation (omfg)

			if( myBuff.IsArchetype() )
			{
				myBuff = new myBuff.Class(myBuff);
				myBuff.Init( ,mSourceOfEffect.GetInitiator(), true);
			}
			myBuff.GetEffects(buffEff, mSourceOfEffect.GetInitiator());

			foreach buffEff( currEff )
			{
				if( H7EffectWithSpells( currEff ) != none
					&& H7EffectWithSpells( currEff ).GetData().mSpellStruct.mSpellOperation == SUPPRESS_ABILITY 
					&& H7EffectWithSpells( currEff ).GetData().mSpellStruct.mDefaultAbility == ED_RETALIATION_ABILITY )
				{
					myBuff.DeleteAllInstanciatedEffects();
					mSuppressesRetaliation = true;
					return;
				}
			}
			myBuff.DeleteAllInstanciatedEffects();
			myBuff = none;
		}
		else
		{
			mSuppressesRetaliation = false;
		}
	}
	else if( mData.mSpellStruct.mSpellOperation == SUPPRESS_ABILITY )
	{
		if( mData.mSpellStruct.mDefaultAbility == ED_RETALIATION_ABILITY ) { mSuppressesRetaliation = true; return; }
	}

	mSuppressesRetaliation = false;
	
}

