//=============================================================================
// H7APRColorMapping
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7APRColorMapping extends Actor
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	dependson(H7StructsAndEnumsNative);

//from H7FCTMappingProperties
struct H7APRColorMappingEntry
{
	var(FCTProperties)  EAPRLevel   mThreatLEvel<DisplayName=Threat>;
	var(FCTProperties)  Color		mColor<DisplayName=Color>;
};

var() protected array<H7APRColorMappingEntry> mList;

function Color GetColor(EAPRLevel threat)
{
	local H7APRColorMappingEntry entry;
	local Color defaultColor;
	defaultColor = MakeColor(150,150,150,255);

	foreach mList( entry ) 
	{
		if(entry.mThreatLEvel == threat)
		{
			return entry.mColor;
		}
	}
	return defaultColor;
}
