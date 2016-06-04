//=============================================================================
// H7EffectSpecialCreaturePoolModify
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialCreaturePoolModify extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() float mCreaturePoolMultiplier <DsiplayName=CreaturePoolMultiplier>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7Town> towns; 
	local array<H7VisitableSite> sites;
	//local array<H7TownBuildingData> dwellings;
	local int i,j;
	//local H7DwellingCreatureData CreaturePool;
	local array<H7DwellingCreatureData> CreaturePools;

	towns = class'H7AdventureController'.static.GetInstance().GetTownList();

	for( i=0;i<towns.Length;++i)
	{
		towns[i].SetReserveMultiplier( mCreaturePoolMultiplier );
	}	

	 sites = class'H7AdventureController'.static.GetInstance().GetGridController().GetVisitableSites();

	for( i=0;i<sites.Length;++i)
	{
		if( sites[i].IsA('H7Dwelling') )
		{
			CreaturePools = H7Dwelling(sites[i]).GetCreaturePool();
			for (j=0;j<CreaturePools.Length;++j)
			{
				CreaturePools[j].Reserve *= mCreaturePoolMultiplier;
			}
			H7Dwelling(sites[i]).SetCreaturePool( CreaturePools );
		}	
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_CREATURE_POOL_MOD","H7TooltipReplacement");
}
