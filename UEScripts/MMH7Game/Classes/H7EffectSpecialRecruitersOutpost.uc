//=============================================================================
// H7EffectSpecialRecruitersOutpost
//
// - fake-maps town building growth enhancers to AoC (via buffs)
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialRecruitersOutpost extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var(RecruitersOutpost) array<H7TownBuffToAoCData> mData <DisplayName=Building/Buff map>;

var protected H7Town myOwner;
var protected bool mDidRegisterListener;
var protected bool mIsDestroying;
var protected array<H7IEffectTargetable> myTargets;

function Initialize( H7Effect effect )
{
	local H7ICaster owner;

	mDidRegisterListener = false;
	mIsDestroying = false;

	owner = effect.GetSource().GetInitiator();
	// owner (or at least caster) must be a town
	if(H7Town(owner) == none)
	{
		owner = effect.GetSource().GetCaster();
		if(H7Town(owner) == none) { myOwner = none; return; }
	}

	myOwner = H7Town(owner);
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local array<H7IEffectTargetable> invalidTargets;
	local array<H7TownBuffToAoCData> validData;
	local array<H7TownBuffToAoCData> invalidData;
	local H7IEffectTargetable target;
	local H7TownBuffToAoCData data;
	local H7BaseBuff insta;
	local H7ICaster owner;

	// no simulation, no execution if thingy is already destructing itself (better safe than sorry)
	if( isSimulated || mIsDestroying ) { return; }

	// register for some events (if this is done with the editor, we'll get a lot of different instances with different targets etc)
	if(!mDidRegisterListener)
	{
		mDidRegisterListener = true;
		effect.GetRegistrator().GetEventManager().RegisterListener( effect, ON_BUILDING_BUILT );
		effect.GetRegistrator().GetEventManager().RegisterListener( effect, ON_OTHER_BUILDING_BUILT );
		effect.GetRegistrator().GetEventManager().RegisterListener( effect, ON_BUILDING_DESTROY );
		effect.GetRegistrator().GetEventManager().RegisterListener( effect, ON_BUFF_EXPIRE );
		effect.GetRegistrator().GetEventManager().RegisterListener( effect, ON_AURA_DESTROY );
		effect.GetRegistrator().GetEventManager().RegisterListener( effect, ON_BUILDING_CHANGEOWNER );
	}

	// if owner is none, try again to find it
	if(myOwner == none)
	{
		owner = effect.GetSource().GetInitiator();
		if(owner == none || H7Town( owner ) == none)
		{
			owner = effect.GetSource().GetCaster();
			if(owner == none || H7Town( owner ) == none) { myOwner = none; return; }
		}
	}

	//targets = myTargets;
	if( effect.GetSource().GetEventManager().GetCurrentEvent() == ON_BUILDING_CHANGEOWNER)
	{
		foreach myTargets(target)
		{
			if(effect.ConditionCheck( target, myOwner, true))
			{
				targets.AddItem( target );
			}
			else
			{
				invalidTargets.AddItem( target );
			}
		}

		myTargets = targets;

		RemoveBuffsFromInvalidTargets( invalidTargets );
	}

	if( container.Targetable != none && effect.ConditionCheck(container.Targetable, myOwner, true))
	{
		// add target if valid and not already in the list
		if( myTargets.Find( container.Targetable ) == -1 )
		{
			myTargets.AddItem( container.Targetable );
		}
	}

	if(myTargets.Length == 0) return; // nothing to do here

	// get valid data (aka building required is built)
	foreach mData(data)
	{
		if( myOwner.IsBuildingBuilt( data.mBuilding, true, false) )
		{
			validData.AddItem( data );
		}
		else
		{
			invalidData.AddItem( data );
		}
	}

	// nothing that produces a buff is built? don't bother to continue
	if( validData.Length == 0 && invalidData.Length == 0 ) { return; }


	// expire: clear everything
	if( effect.GetSource().GetEventManager().GetCurrentEvent() == ON_BUFF_EXPIRE 
		|| effect.GetSource().GetEventManager().GetCurrentEvent() == ON_AURA_DESTROY )
	{
		// remove everything from everyone
		mIsDestroying = true;
		invalidData = mData;
		validData.Length = 0;
	}

	foreach myTargets(target)
	{
		// remove old buffs if necessary
		foreach invalidData(data)
		{
			if( target.GetBuffManager().HasBuff( data.mBuff, myOwner, true ) )
			{
				insta = new data.mBuff.Class(data.mBuff);
				insta.Init( target, myOwner, false );
				target.GetBuffManager().RemoveBuff( insta, myOwner );
			}
		}

		// add new buffs
		foreach validData(data)
		{
			if( effect.ConditionCheck(target,myOwner,true) &&
				H7Dwelling(target) != none &&
				( H7Dwelling(target).ProducesUnit(data.mCreature)
				|| ( data.mCreature.GetUpgradedCreature() != none && H7Dwelling(target).ProducesUnit(data.mCreature.GetUpgradedCreature() ) ) 
				|| ( data.mCreature.GetBaseCreature() != none && H7Dwelling(target).ProducesUnit(data.mCreature.GetBaseCreature() ) ) )
				&& !target.GetBuffManager().HasBuff( data.mBuff, myOwner, true ) )
			{
				// instanciate buff, set target/caster/simulated and add it to target's buff manager
				insta = new data.mBuff.Class(data.mBuff);
				insta.Init( target, myOwner, false );
				target.GetBuffManager().AddBuff( insta, myOwner, effect.GetSource() );
			}
		}
	}

	// unregister listener
	if( mIsDestroying )
	{
		effect.GetRegistrator().GetEventManager().UnregisterListener( effect, ON_BUILDING_BUILT );
		effect.GetRegistrator().GetEventManager().UnregisterListener( effect, ON_OTHER_BUILDING_BUILT );
		effect.GetRegistrator().GetEventManager().UnregisterListener( effect, ON_BUILDING_DESTROY );
		effect.GetRegistrator().GetEventManager().UnregisterListener( effect, ON_BUFF_EXPIRE );
		effect.GetRegistrator().GetEventManager().UnregisterListener( effect, ON_AURA_DESTROY );
		effect.GetRegistrator().GetEventManager().UnregisterListener( effect, ON_BUILDING_CHANGEOWNER );
	}
}

function RemoveBuffsFromInvalidTargets(array<H7IEffectTargetable> invalidTargets)
{
	local H7IEffectTargetable target;
	local H7TownBuffToAoCData data;
	local H7BaseBuff insta;

	foreach invalidTargets(target)
	{
		foreach mData(data)
		{
			if(target.GetBuffManager().HasBuff( data.mBuff, myOwner, true))
			{
				insta = new data.mBuff.Class(data.mBuff);
				insta.Init( target, myOwner, false );
				target.GetBuffManager().RemoveBuff( insta, myOwner );
			}
		}
	}

	invalidTargets.Length = 0;
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_TOWN_GROWTH_MAPPER","H7TooltipReplacement");
}
