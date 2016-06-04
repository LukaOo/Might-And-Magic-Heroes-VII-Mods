//=============================================================================
// H7EffectSpecialReappearCreatureOnGrid
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialReappearCreatureOnGrid extends Object implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var(ReappearCreatureOnGridEffect) float mSpeed <DisplayName=Flying Speed>;
var(ReappearCreatureOnGridEffect) int mFlyForwardUnits<DisplayName=Fly Forward Units While Descending>;
var(ReappearCreatureOnGridEffect) int mDescendFrom;
var(ReappearCreatureOnGridEffect) float mDescendSpeed <DisplayName=Descend Speed>;

var protected H7CreatureStack mOwner;

function Initialize( H7Effect effect )
{
	local H7ICaster initiator;

	initiator = effect.GetSource().GetInitiator();
	mOwner = H7CreatureStack( initiator );
	if(mOwner == none) { return; }
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster initiator;

	if( isSimulated ) return;

	initiator = effect.GetSource().GetInitiator();
	mOwner = H7CreatureStack( initiator );
	if( mOwner != none )
	{
		mOwner.ExecuteDivingAttackReappear( effect, container, mSpeed, mDescendSpeed, mDescendFrom, mFlyForwardUnits );
	}
}

function String GetDefaultString()
{
	return "";
}

function String GetTooltipReplacement() 
{
	return "Diving Attack";
}


