//=============================================================================
// H7EffectSpecialResetIdolOfFertility
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialResetIdolOfFertility extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);




function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7Town town;
	local H7TownIdolOfFertility building;

	effect.GetTargets( targets );

	if(targets.Length == 0)
	{
		return;
	}

	foreach targets(target)
	{
		town = H7Town(target);

		if(town == none)
		{
			continue;
		}

		building = H7TownIdolOfFertility( town.GetBuildingByType(class'H7TownIdolOfFertility') );
		building.ResetTimer();
	}
}


function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TOWN_IDOL_OF_FERTILITY","H7TooltipReplacement");
}
