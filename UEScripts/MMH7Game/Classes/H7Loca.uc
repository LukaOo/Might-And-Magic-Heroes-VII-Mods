//=============================================================================
// H7Loca
//=============================================================================
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7Loca extends Object
	native;

static native function string LocalizeContent(object source, string fieldName, string editorName="", string langExt="");
static native function string LocalizeMapObject(object source, string fieldName, string editorName="");

// special case for kismet
static native function string LocalizeKismetObject(SequenceObject source, string fieldName, string editorName="");

// special case for council hub (loca keys from streamed level
static native function string LocalizeCouncilObject(SequenceObject source, string fieldName, string editorName="");

// 6 shades of mapname
// 1) MapFilePath - Adventure\Test\adventuremap.umap
// 2) PackageMapName - pieadventuremap
// 3) MapFileName+Ext - adventuremap.umap
// 4) MapFileName - adventuremap
// 5) MapName (hardcode) - My Cool Map without loca
// 6) MapName (localized) - Mio coolos Mappos

// special case just for everything that hangs on WorldInfo_0 (i.e. H7MapInfo)
static native function string LocalizeMapInfoObject(object source, string fieldName, string editorName="");

// special case just for everything that hangs on WorldInfo_0 (i.e. H7MapInfo)
static native function string LocalizeMapInfoObjectByName(string infoName, string mapFileName, string varName, string fallbackName, bool combatMap=false);

static native function string GetSection(object source);
static native function string GetMapSection(object source);

static native function string GetSectionByInfoName(string infoName,bool combatMap);

static native function string GetSectionByObject(Object infoName);

static native function string GetSectionByInfoNumber(int infoNumber,bool combatMap);

static native function string LocalizeField(string section, string fileName, string key, string editorName="");
static native function string LocalizeFieldInternal(string section, string fileName, string key, out byte wasLocalized, string editorName="", string langExt="");
static native function string LocalizeFieldParams(H7LocaParams params);

// Used when there is no player archetype object at hand
static native function string LocalizePlayerName(EPlayerNumber playerNumber);
static native function bool IsLocaParamsEmpty(H7LocaParams params);

static native function string GetMapFileName(string mapName);
static native function string GetMapName(object source);

static function string GetMapFileNameByPath(string filepath)
{
	local int lastSlashIndex;
	local string slash,mapName;
	slash = Chr(92);
	lastSlashIndex = InStr(filepath,slash,true,true);
	mapName = Mid(filepath,lastSlashIndex+1);
	mapName = Mid(mapName,0,InStr(mapName,"."));
	return mapName;
}

static function string GetArrayFieldName(string arrayFieldName, int arrayFieldIndex)
{
	local string fieldName;
	
	fieldName = arrayFieldName$"["$arrayFieldIndex$"]";

	return fieldName;
}

static function bool LocalizeFailed(string localizedValue)
{
	if(Left(localizedValue,1) == "?") return true;
	if(Left(localizedValue,1) == "[" && Len(localizedValue) > 1) return true; // so that "[" is recognized as a correct localization of KEY_LEFTBRACKET
	return false;
}

static function bool IsLocaKey(string unknown)
{
	return Caps(unknown) == unknown && Len(unknown) > 0;
}

static function string LocalizeSave(string locaKey,string section,string fileName="MMH7Game")
{
	local String localizedString;

	if(class'H7GUIGeneralProperties'.static.GetInstance().GetOptionShowLocaKeys())
	{
		return locaKey;
	}

	localizedString = Localize(section, locaKey, fileName);
	
	if(LocalizeFailed(localizedString)) 
	{
		localizedString = "[" $ locaKey $ "]";
		;
	}

	return localizedString; 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Replacements
///////////////////////////////////////////////////////////////////////////////////////////////////

static function string ResolveIconPlaceholders(string text)
{
	local array<string> placeholders;
	local string placeholder;
	
	placeholders = class'H7EffectContainer'.static.GetPlaceholders(text);
	foreach placeholders(placeholder)
	{
		text = Repl(text,placeholder,class'H7EffectContainer'.static.ResolveIconPlaceholder(placeholder));
	}
	return text;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
