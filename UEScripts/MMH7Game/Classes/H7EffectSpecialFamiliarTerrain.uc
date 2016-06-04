//=============================================================================
// H7EffectSpecialFamiliarTerrain
//
// - adds ability to all friendly towns
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialFamiliarTerrain extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var(FamiliarTerrain) protected H7BaseAbility mAbility<DisplayName=Ability to Give to All Friendly Towns|Tooltip=Ability won't be added again if the Town already has it, but will be removed if it gets conquered by another player>;

var protected array<H7Town> mOldTownList;
var protected H7Player mPlayer;

function Initialize( H7Effect effect )
{
	if( effect.GetSource() != none && effect.GetSource().GetInitiator() != none )
	{
		mPlayer = effect.GetSource().GetInitiator().GetPlayer();
	}
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7Town> newTownList;
	local array<H7Town> removeThese;
	local int i;

	if( isSimulated ) return; // no simulations! seriously!

	if( mPlayer == none )
	{
		mPlayer = effect.GetSource().GetInitiator().GetPlayer();
	}

	newTownList = mPlayer.GetTowns();

	for( i = 0; i < mOldTownList.Length; ++i )
	{
		if( newTownList.Find( mOldTownList[i] ) == INDEX_NONE )
		{
			removeThese.AddItem( mOldTownList[i] );
		}
	}

	if( removeThese.Length == 0 && mOldTownList.Length == newTownList.Length ) return; // no changes!

	for( i = 0; i < removeThese.Length; ++i )
	{
		removeThese[i].GetAbilityManager().UnlearnAbility( mAbility );
	}

	mOldTownList = newTownList;

	for( i = 0; i < mOldTownList.Length; ++i )
	{
		if( mOldTownList[i].GetAbilityManager().HasAbility( mAbility ) ) continue;

		mOldTownList[i].GetAbilityManager().LearnAbility( mAbility, effect.GetSource() );
	}
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_FAMILIAR_TERRAIN","H7TooltipReplacement");
}

function string GetDefaultString()
{
	return mAbility.GetName();
}
