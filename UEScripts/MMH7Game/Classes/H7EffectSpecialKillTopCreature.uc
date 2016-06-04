//=============================================================================
// H7EffectSpecialKillTopCreature
//
// Enable scouting for an adventure hero.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialKillTopCreature extends Object implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CreatureStack target;

	if( isSimulated ) 
	{
		return;
	}
	
	target = H7CreatureStack( container.Targetable );

	if( target != none && !target.IsDead() )
	{
		target.SetStackSize( target.GetStackSize() - 1 );
		if( !target.IsDead() )
		{
			target.SetTopCreatureHealth( target.GetHitPoints() );
			target.DataChanged(); // update GUI again in case the thing ignored the first changed data (probably fixes HOMMVII-8536)
		}
		else
		{
			target.SetTopCreatureHealth( 0 );
			target.Kill();
		}
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateStackSize( target );	
		class'H7FCTController'.static.GetInstance().startFCT(FCT_KILL, target.GetLocation(), none, class'H7Loca'.static.LocalizeSave("FCT_KILL_TOP_CREATURE","H7FCT"), MakeColor(255,0,0,255));
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_KILL_TOP_CREATURE","H7TooltipReplacement");
}
