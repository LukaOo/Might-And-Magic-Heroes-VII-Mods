// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7GenericTownNames extends Object
	perobjectconfig;

// The faction that will use the generic names for their town.
var(Properties) protected H7Faction mFaction<DisplayName="Faction">;
// The generic names that are randomly assigned to towns.
var(Properties) protected localized array<string> mTownNames<DisplayName="Town Names">;

function H7Faction GetFaction() { return mFaction; }
function array<string> GetTownNames() { return mTownNames; }
function string GetLocalizedTownName(int index)
{
	local string locaKey;

	if(index < mTownNames.Length)
	{
		locaKey = (class'H7Loca'.static.GetArrayFieldName("mTownNames", index));
		return class'H7Loca'.static.LocalizeContent(self, locaKey, mTownNames[index]);
	}
	else
	{
		return "";
	}
}
