//=============================================================================
// H7CampaignDefinition
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CampaignDefinition extends Object
	hidecategories(Object)
	perobjectconfig
	native
	savegame;

struct native H7MapEntry
{
	var() string mFileName;
	var() int mYear<DisplayName="Year caption|ClampMin=0|ClampMax=989">;
	var() int mPixel<DisplayName="Pixel in the timeline|ClampMin=0|ClampMax=1270">;
	var() int mMapInfoNumber<DisplayName="The number of the MapInfo object inside the map (needed for loca)">;
	var() string mFallbackName<DisplayName="Fallback name for unlocalized custom maps">;
	var transient string mNameInst;
};

var() localized string mName<DisplayName="Name of the Campaign">;
var() localized string mDescription<DisplayName="Description"|MultilineWithMaxRows=5>;
var() localized string mBonusDescription<DisplayName="Bonus Description">;
var transient string mNameInst;
var transient string mDescriptionInst;
var transient string mBonusDescriptionInst;

var bool mIsCouncilCampaign;
var() H7Faction mFaction<DisplayName="Associated Faction">;
var() H7EditorHero mCouncillor<DisplayName="Councillor (Storyteller)">;
var() int mStartYear<DisplayName="Start Year">;
var() int mEndYear<DisplayName="End Year">;

var() array<H7MapEntry> mCampaignMaps<DisplayName="List of Maps">;

var() string mStartMatineeName<DisplayName="Start Matinee Name (ObjComment)">; // Haven_Intro_longshots_02
var() string mEndMatineeName<DisplayName="End Matinee Name (ObjComment)">; //

var() string mAuthor<DisplayName="Author">;
var() int mRevision<DisplayName="Revision">;

var() bool mIsIvan<DisplayName="Is Ivan Campaign">;

var() array<localized string> mIvanCampaignSelectText;
var() localized string mStartCampaignText;
var() localized string mContinueCampaignText;
var() localized string mRestartCampaignText;

var(LoadScreeen) dynload protected MaterialInterface mLoadScreenBackground<DisplayName="Load Screen Background">;

// This will be filled only for custom campaign
var protected string mFileName;
var string mContainerObjectName;  // Needed for loca lookup
var string mNameFallback;  // Needed for loca lookup
var protected string mDescriptionFallback;  // Needed for loca lookup

function SetFileName(string fileName) { mFileName = fileName; }
function string GetFileName() { return mFileName; }

//              Official        IsCouncilCampaign   RequiresFactionPrivilege  
// basic        yes             yes                 yes
// losttales    no              no                  no
// modders      no              no                  no

function bool IsCouncilCampaign()
{
	return mIsCouncilCampaign;
}

function bool RequiresFactionPrivilege()
{
	return IsCouncilCampaign();
	//if(InStr(string(self),"LostTales",false,true) != INDEX_NONE) return false;
	//else return true;
}

native function Save(string FileName);
native function Load(string FileName);

function string GetAID() { return string(self); }
function string GetAuthor() { return mAuthor; }
function string GetName()
{
	local string section;
	if(Len(mNameInst) == 0)
	{
		if(Len(mContainerObjectName) == 0)
		{
			mNameInst = class'H7Loca'.static.LocalizeContent(self,"mName",mName);
		}
		else
		{
			section = mContainerObjectName@"H7CampaignDataHolder";
			mNameInst = class'H7Loca'.static.LocalizeField(section, mFileName, "mCampaignData_mName", mNameFallback);
		}
	}
	return mNameInst;
}

function string GetDescription()
{
	local string section;
	if(Len(mDescriptionInst) == 0)
	{
		if(Len(mContainerObjectName) == 0)
		{
			mDescriptionInst = class'H7Loca'.static.LocalizeContent(self,"mDescription",mDescription);
		}
		else
		{
			section = mContainerObjectName@"H7CampaignDataHolder";
			mDescriptionInst = class'H7Loca'.static.LocalizeField(section, mFileName, "mCampaignData_mDescription", mDescriptionFallback);
		}
	}
	return mDescriptionInst;
}

function string GetBonusDescription()
{
	if(Len(mBonusDescriptionInst) == 0)
	{
		mBonusDescriptionInst = class'H7Loca'.static.LocalizeContent(self,"mBonusDescription",mBonusDescription);
	}
	if(mBonusDescriptionInst == "mBonusDescription")
	{
		mBonusDescriptionInst = "-";
	}
	return mBonusDescriptionInst;
}

// Check if we are the same campaign (same campaign might be in to different objects due to Custom Campaign recreation)
native function bool IsSameCampaign(H7CampaignDefinition otherCampaign);

function H7EditorHero GetCouncillor() { return mCouncillor; }
function H7Faction GetFaction() { return mFaction; }
function String GetFirstMap() { return mCampaignMaps[0].mFileName; }
function string GetLastMap() { return mCampaignMaps[mCampaignMaps.Length-1].mFileName; }
function int GetMaxMaps() { return mCampaignMaps.Length; }
function string GetMapByNumber(int number) { return mCampaignMaps[number-1].mFileName; }
function string GetMapByIndex(int index) { return mCampaignMaps[index].mFileName; } 
function bool IsIvanCampaign() { return mIsIvan; }

function MaterialInterface GetLoadscreenBackground() { return mLoadScreenBackground; }

function H7MapEntry GetMapEntry(string mapFileName) 
{
	local H7MapEntry entry,empty;
	empty = empty;
	foreach mCampaignMaps(entry)
	{
		if(Caps(entry.mFileName) == Caps(mapFileName))
		{
			return entry;
		}
	}
	;
	return empty;
}
function int GetMapIndex(string mapFileName) 
{
	local H7MapEntry entry;
	local int i;
	foreach mCampaignMaps(entry,i)
	{
		if(Caps(entry.mFileName) == Caps(mapFileName))
		{
			return i;
		}
	}
	;
	return INDEX_NONE;
}

function array<string> GetMaps() 
{
	local array<string> maps;
	local H7MapEntry entry;
	foreach mCampaignMaps(entry)
	{
		maps.AddItem(entry.mFileName);
	}
	return maps; 
}

function int GetMapsNum() { return mCampaignMaps.Length; } 

function string GetCurrentCharacterText() 
{
	//local CouncillorData data;
	local int completed;
	local string locaKey;
	
	if(!mIsIvan)
	{
		if(!class'H7PlayerProfile'.static.GetInstance().IsCampaignEverStarted(self))
		{
			return class'H7Loca'.static.LocalizeContent(self,"mStartCampaignText",mStartCampaignText);
		}

		if(class'H7PlayerProfile'.static.GetInstance().IsCampaignComplete(self))
		{
			return class'H7Loca'.static.LocalizeContent(self,"mRestartCampaignText",mRestartCampaignText);
		}

		return class'H7Loca'.static.LocalizeContent(self,"mContinueCampaignText",mContinueCampaignText);
	}
	else
	{
		if(class'H7PlayerProfile'.static.GetInstance() != none)
		{
			completed = class'H7PlayerProfile'.static.GetInstance().GetNumCompletedCampaigns();
		}
	
		locaKey = (class'H7Loca'.static.GetArrayFieldName("mIvanCampaignSelectText", completed));
		return class'H7Loca'.static.LocalizeContent(self, locaKey, mIvanCampaignSelectText[completed]);
	}
}

function String GetNextMap(string mapFileName)
{
	local int i;

	i = GetMapIndex(mapFileName);
	if(i != INDEX_NONE && i+1 < mCampaignMaps.Length)
	{
		return mCampaignMaps[i+1].mFileName;
	}

	return "";
}

function String GetPrevMap(string mapFileName)
{
	local int i;

	i = GetMapIndex(mapFileName);

	if(i < 1)
	{
		return "";
	}
	else
	{
		return GetMapByIndex(i - 1);
	}
}

function bool IsLastMap(string mapFileName)
{
	local int i;

	i = GetMapIndex(mapFileName);
	if(i+1 == mCampaignMaps.Length)
	{
		return true;
	}
	
	return false;
}

function int GetYearOfMap(string mapName)
{
	return GetMapEntry(mapName).mYear;
}

function int GetPixelOfMap(string mapName)
{
	return GetMapEntry(mapName).mPixel;
}

function int GetMapInfoNumberOfMap(string mapName)
{
	return GetMapEntry(mapName).mMapInfoNumber;
}

function SetMapPixel(string mapName,int pixel)
{
	mCampaignMaps[GetMapIndex(mapName)].mPixel = pixel;
}

function string GetMapLocaName(string mapFileName)
{
	local H7MapEntry mapEntry;
	local string fallbackName;
	mapEntry = GetMapEntry(mapFileName);
	if(Len(mapEntry.mNameInst) == 0)
	{
		fallbackName = (Len(mapEntry.mFallbackName) == 0) ? mapFileName : mapEntry.mFallbackName;
		mapEntry.mNameInst = class'H7Loca'.static.LocalizeMapInfoObjectByName("H7MapInfo_"$mapEntry.mMapInfoNumber,mapFileName,"mName",fallbackName);
	}
	return mapEntry.mNameInst;
}

function InitFromRawData(H7RawCampaignData rawData)
{
	InitFromCampaignDataParams( rawData.mRevision,
								rawData.mName,
								rawData.mFileName,
								rawData.mAuthor,
								rawData.mDescription,
								rawData.mCampaignMaps,
								rawData.mCampaignMapNames,
								rawData.mCampaignMapInfoNumbers,
								rawData.mContainerObjectName);
}

function InitFromCampaignData(H7CampaignData data)
{
	InitFromCampaignDataParams( data.mRevision,
								data.mName,
								data.mFileName,
								data.mAuthor,
								data.mDescription,
								data.mCampaignMaps,
								data.mCampaignMapNames,
								data.mCampaignMapInfoNumbers,
								data.mContainerObjectName);
}

function InitFromCampaignDataParams(int revision,
									string campaignName,
									string fileName,
									string author,
									string description,
									array<string> inCampaignMaps,
									array<string> inCampaignMapNames,
									array<string> inCampaignMapInfoNumbers,
									string containerObjectName)
{
	local int i;
	local H7MapEntry mapEntry;
	local array<string> campaignMaps;
	local array<string> campaignMapNames;
	local array<string> campaignMapInfoNumbers;

	campaignMaps = inCampaignMaps;
	campaignMapNames = inCampaignMapNames;
	campaignMapInfoNumbers = inCampaignMapInfoNumbers;

	self.mAuthor = author;
	self.mRevision = revision;
	self.mFileName = fileName;
	self.mContainerObjectName = containerObjectName;

	if(Len(containerObjectName) == 0)
	{
		self.mNameInst = campaignName;
		self.mDescriptionInst = description;
	}
	else
	{
		self.mNameFallback = campaignName;
		self.mDescriptionFallback = description;
		self.mContainerObjectName = containerObjectName;
	}

	LogUserCampaign();

	for(i = 0; i <campaignMaps.Length; ++i)
	{
		mapEntry.mFileName = campaignMaps[i];
		if(i < campaignMapNames.Length)
		{
			if(i < campaignMapInfoNumbers.Length)
			{
				mapEntry.mMapInfoNumber = int(campaignMapInfoNumbers[i]);
			}
			else // backwards compatibility
			{
				mapEntry.mNameInst = campaignMapNames[i];
			}

			mapEntry.mFallbackName = campaignMapNames[i];
		}
		mCampaignMaps.AddItem(mapEntry);

		;
	}

	// TODO: Thumbnail
}

function LogUserCampaign()
{
	;
	;
	;
	;
	;
}

