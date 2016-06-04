//=============================================================================
// H7EffectSpecialGlobalRuler
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialGlobalRuler extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var private H7Effect mEffect;
var private array<H7Town> mTowns;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	if( isSimulated ) return;

	mEffect = effect;

	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && mEffect != none )
	{
		if( mTowns.Length == 0 )
		{
			mTowns = class'H7AdventureController'.static.GetInstance().GetTownList();
		}

		DestroyCurrentGovernorAuras();
		ApplyGovernourAurasOnTowns();
	}
}


function private DestroyCurrentGovernorAuras()
{
	mEffect.GetSource().GetCasterOriginal().TriggerEvents( ON_GOVERNOR_UNASSIGN, false );
}

function private ApplyGovernourAurasOnTowns()
{
	local H7EventContainerStruct container;
	local H7ICaster dasCaster;
	local int i;

	dasCaster = mEffect.GetSource().GetCasterOriginal();

	if( H7AdventureHero( dasCaster ) != none && H7AdventureHero( dasCaster ).GetAdventureArmy().IsDead() ) return;

	for( i = 0; i < mTowns.Length; ++i )
	{
		if( mTowns[i].GetPlayer() == dasCaster.GetPlayer() )
		{
			container.Targetable = mTowns[i];

			dasCaster.TriggerEvents( ON_GOVERNOR_ASSIGN, false, container );
		}
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_RULER","H7TooltipReplacement");
}
