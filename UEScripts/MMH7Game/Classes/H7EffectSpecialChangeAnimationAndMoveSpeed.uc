//=============================================================================
// H7EffectSpecialChangeAnimationAndMoveSpeed
//
// - Resets creatures movement and animation speed after buff/debuff expires
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialChangeAnimationAndMoveSpeed extends Object
	implements(H7IEffectDelegate)
	hidecategories( Object )
	native(Tussi);

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local Array <H7IEffectTargetable> targets;
	local int i;
	local H7CreatureStack stack;
	local H7Creature creature;


	effect.GetTargets( targets );
	
	for(i=0; i< targets.Length; ++i)
	{
		if(targets[i].isa('H7CreatureStack'))
		{
			stack = H7CreatureStack(targets[i]);
			stack.ChangeLocomotionSpeed(effect.GetFx());

			creature = stack.GetCreature();
			creature.ChangeAnimationSpeedFX(effect.GetFx());
		}
	}

}

function String GetTooltipReplacement() 
{
}

