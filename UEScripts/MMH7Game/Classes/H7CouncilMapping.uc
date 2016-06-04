//=============================================================================
// H7CouncilMapping
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilMapping extends Actor
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	dependson(H7StructsAndEnumsNative);

struct H7CouncilMappingEntry
{
	var() ESpeaker councilorEnum;
	var() H7EditorHero councilorHero;
};

var() protected array<H7CouncilMappingEntry> mList;

function String	GetFlashIconPath( ESpeaker etype )
{
	local H7CouncilMappingEntry entry ;
	entry = GetEntry( etype ) ;
	
	if(entry.councilorEnum == SPEAKER_CUSTOM || entry.councilorHero == none)
	{
		return "img://None";
	}
	return entry.councilorHero.GetFlashIconPath(); 
}

function String GetName( ESpeaker etype )
{
	local H7CouncilMappingEntry entry ;
	entry = GetEntry( etype ) ;
	
	if(entry.councilorEnum == SPEAKER_CUSTOM)
	{
		return string(GetEnum(Enum'ESpeaker',etype));
	}

	if(entry.councilorHero == none)
	{
		return "";
	}
	return entry.councilorHero.GetName(); 
}

function H7CouncilMappingEntry GetEntry( ESpeaker eType ) 
{
	local H7CouncilMappingEntry entry;
	local H7CouncilMappingEntry emptyEntry;

	foreach mList( entry ) 
	{
		if( entry.councilorEnum == eType )
			return entry;
	}
	
	// no mapping entry found, just return empty one and don't use an icon
	return emptyEntry;
}
