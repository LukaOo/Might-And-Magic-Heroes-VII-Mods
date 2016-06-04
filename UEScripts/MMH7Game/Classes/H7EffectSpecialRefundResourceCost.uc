//=============================================================================
// H7EffectSpecialRefundResourceCost
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialRefundResourceCost extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var() int mPercentage<DisplayName=Amount of refund ( percent )|ClampMin=0|ClampMax=100>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7TownBuilding building;
	local int i;

	effect.GetTargets( targets );

	for( i = 0; i < targets.Length; ++i )
	{
		if( targets[i].IsA('H7TownBuilding') )
		{
			building = H7TownBuilding( targets[i] );
			if( building.GetTown() != none )
			{
				building.GetTown().SetRefundHero(effect.GetSource().GetInitiator());
				building.GetTown().RefundBuildingCost( building, mPercentage, isSimulated );
			}
		}   
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_REFUND_RES_COST","H7TooltipReplacement");
}

