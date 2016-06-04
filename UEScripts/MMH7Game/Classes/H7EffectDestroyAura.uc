//=============================================================================
// H7EffectDestroyAura
//
//
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectDestroyAura extends H7Effect;

var H7EffectProperties mData;

event bool ShowInTooltip() { return !mData.mDontShowInTooltip; }

event InitSpecific(H7EffectProperties data,H7EffectContainer source,optional bool registerEffect=true)
{
	InitEffect(data, source,registerEffect);
	mData = data;
}

protected event Execute(optional bool isSimulated = false)
{
	local array<H7AdventureMapGridController> gridController;
	local H7AdventureMapGridController currentController;
	local H7ICaster caster;
	local H7EventContainerStruct container;

	if(isSimulated) return;

	caster = H7BaseAbility(GetSource()).GetCaster().GetOriginal();

	if( !H7BaseAbility(GetSource()).GetAuraProperties().mUpdateOnStep && H7Unit( caster ) != none && H7Unit( caster ).IsMoving() ) 
	{
		return;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatController'.static.GetInstance().GetGridController().GetAuraManager().RemoveAuraFromSource( GetSource() );
		
		if( caster.IsA('H7CombatMapTrap') )
		{
			H7CombatMapTrap( caster ).TriggerTrap();
		}
	}
	else
	{
		gridController = class'H7AdventureGridManager'.static.GetInstance().GetAllGrids();

		foreach gridController( currentController )
		{
			currentController.GetAuraManager().RemoveAuraFromSource( GetSource() );
		}
	}


	GetTagsPlusBaseTags( container.ActionTag );
	container.EffectContainer = GetSource();
	container.Targetable = GetSource().GetTarget();

	GetSource().GetEventManager().Raise( ON_AURA_DESTROY, false, container );
}
