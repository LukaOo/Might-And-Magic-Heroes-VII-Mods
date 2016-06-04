//=============================================================================
// H7EffectCommand
//
// - if an effect does somthing with a Command, it is of this type
// - uses data from the H7CommandEffect-struct
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectCommand extends H7Effect
	native(Tussi);

var() protected H7CommandEffect	mData;
var   protected H7CommandQueue	mCommandQueue;

function H7CommandEffect GetData()          { return mData; }
event bool            ShowInTooltip()    { return !mData.mDontShowInTooltip; }

event InitSpecific(H7CommandEffect data,H7EffectContainer source,optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	data.mFX.mSource = self;
	properties.mConditions = data.mConditions;

	InitEffect(properties, source,registerEffect);
	mData = data;
}

function protected AddCommandToQueue( out H7CommandQueue queue, H7IEffectTargetable target, H7FXStruct fx )
{
	local array<H7ICaster> casters;
	local H7ICaster caster;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable tmpTarget;
	local H7Command currentCommand, command;
	local int i;
	
	caster = mSourceOfEffect.GetInitiator();

	GetTargetsByEffectTarget( targets, mData.mCommandRecipient );

	// default case
	if( targets.Length == 0 )
	{
		targets.AddItem( H7IEffectTargetable( caster ) );
	}

	// f*cking moats
	if( H7CombatMapMoat( caster ) != none ||  ( H7CombatObstacleObject( caster ) != none /*&& H7CombatObstacleObject( caster ).mOnlySpawnIfMoats*/ ) )
	{
		targets.AddItem( target );
	}


	ValidateRecipients( targets );

	foreach targets( tmpTarget )
	{
		if( H7ICaster( tmpTarget ) != none )
		{
			casters.AddItem( H7ICaster( tmpTarget ) );
		}
	}

	foreach casters( caster )
	{
		switch( mData.mCommandTag )
		{
			case ACTION_MELEE_ATTACK:
			case ACTION_DOUBLE_MELEE_ATTACK:
			case ACTION_LIGHTNING_REFLEXES_STRIKE:
				if( caster.IsA('H7Unit') )
				{
					caster.PrepareAbility( H7Unit( caster ).GetMeleeAttackAbility() );
				}
				break;
			case ACTION_RETALIATE:
				if( caster.IsA('H7CreatureStack') )
				{
					if( H7CreatureStack( caster ).GetRetaliationOverrideMelee() != none )
					{
						caster.PrepareAbility( H7CreatureStack( caster ).GetRetaliationOverrideMelee() );
					}
					else
					{
						caster.PrepareAbility( H7CreatureStack( caster ).GetMeleeAttackAbility() );
					}
				}
				break;

			case ACTION_RANGE_ATTACK:
			case ACTION_DOUBLE_RANGED_ATTACK:
			
				if( caster.IsA('H7Unit') )
				{
					caster.PrepareAbility( H7Unit( caster ).GetRangedAttackAbility() );
				}
				break;
			case ACTION_RANGED_RETALIATE:
				if( caster.IsA('H7CreatureStack') )
				{
					if( H7CreatureStack( caster ).GetRetaliationOverrideMelee() != none )
					{
						caster.PrepareAbility( H7CreatureStack( caster ).GetRetaliationOverrideRanged() );
					}
					else
					{
						caster.PrepareAbility( H7CreatureStack( caster ).GetRangedAttackAbility() );
					}
				}
				break;
			case ACTION_ABILITY:
				caster.PrepareAbility( caster.GetAbilityManager().GetAbility( mData.mAbility ) );
				break;
			
			case ACTION_REPEAT:
				currentCommand = class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().GetCurrentCommand();
				if( currentCommand != none && currentCommand.GetCommandTag() != ACTION_REPEAT)
				{
					caster.PrepareAbility( currentCommand.GetAbility() );
					target = currentCommand.GetAbilityTarget();
				}
				else if( H7Unit( caster ) != none )
				{
					H7Unit( caster ).PrepareDefaultAbility();
				}
				else
				{
					caster.PrepareAbility( none );
				}
				break;
		}

		if(mData.mIgnoreAllegiance && H7Unit(caster) != none)
		{
			H7Unit(caster).SetIgnoreAllegiances(true);
		}

		if( mData.mCommandTag == ACTION_INTERRUPT || caster.GetPreparedAbility() != none )
		{
			for( i = 0; i < mData.mAmount; ++i )
			{
				if( mData.mCommandTag == ACTION_INTERRUPT || caster.GetPreparedAbility().CanCastOnTargetActor(target) ) // to be sure that we dont do smth stupid
				{
					command = class'H7Command'.static.CreateCommand( caster, UC_ABILITY, mData.mCommandTag, caster.GetPreparedAbility(), target,, false,, true, mData.mInsertHead );
					command.SetFX( fx );
					queue.Enqueue( command );
				}
			}
		}
	}
}

protected function ValidateRecipients( out array<H7IEffectTargetable> targets )
{
	local int i;

	for( i = targets.Length - 1; i >= 0; --i )
	{
		if( !TargetConditionCheck( targets[i], mData.mRecipientConditions, GetSource().GetInitiator(), GetSource().GetCasterOriginal() ) )
		{
			targets.RemoveItem( targets[i] );
		}
	}
}

// only for simulation/tooltips
// everything here is FAKE HACK and wrong and not used
// commandeffect can not be used to attack somebody with (for now, if design accepts it)
function H7CombatResult GenerateCombatAction( optional H7CombatResult baseCombatAction )
{
	local array<H7IEffectTargetable> /*targets,*/defenders;
	local H7IEffectTargetable target;
	local H7CombatResult action;

	if(baseCombatAction != none) action = baseCombatAction;
	else action = new class'H7CombatResult';

	if( mEffectTarget == TARGET_TARGET || mEffectTarget == TARGET_DEFAULT )
	{
		UnpackContainer();
	}

	action.SetCurrentEffect( self );
	GetTargets( mTempTargets );
	
	// attacker is the hero
	//action.SetAttacker( mSourceOfEffect.GetInitiator() );

	foreach mTempTargets( target )
	{
		;
		action.AddDefender( target );
		defenders = action.GetDefenders();
		if(ShowInTooltip() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenEffects()) action.AddEffectToTooltip(self,defenders.Find(target));
		;
	}

	return action;
}

protected event Execute(optional bool isSimulated = false)
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;

	if(isSimulated) 
	{
		return; // can not simulate commands
	}

	if( mEffectTarget == TARGET_TARGET || mEffectTarget == TARGET_DEFAULT )
	{
		UnpackContainer();
	}

	mCommandQueue = class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue();

	if( mCommandQueue == none )
	{
		;
		return;
	}

	GetTargets( targets );
	;

	if( targets.Length == 0 ) return;

	/** passives could use caster particles */
	if( GetSource().IsAbility() && H7BaseAbility( GetSource() ).IsPassive() ) 
	{
		H7BaseAbility( GetSource() ).DoParticleFXCaster( GetSource().GetCasterOriginal() );
	}

	foreach targets(target)
	{
		;
		mData.mFX.mSource = self;
		AddCommandToQueue(mCommandQueue, target, mData.mFX);
	}

}
