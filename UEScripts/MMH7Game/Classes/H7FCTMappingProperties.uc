//=============================================================================
// H7FCTMappingProperties
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FCTMappingProperties extends Actor
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	dependson(H7FCTController, H7StructsAndEnumsNative);

var(FCT) protected array<FCTMappingEntry> mTypes;


function String	 GetFlashIconPath( EFCTType eType )
{
	local FCTMappingEntry entry ;
	entry = GetType( etype ) ;
	
	if(entry.mIcon == none)
	{
		return "img://None";
	}
	return "img://" $ Pathname( entry.mIcon ); 
}


function FCTMappingEntry GetType( EFCTType eType ) 
{
	local FCTMappingEntry entry;
	local FCTMappingEntry emptyEntry;

	foreach mTypes( entry ) 
	{
		if( entry.mType == eType )
			return entry;
	}
	
	// no mapping entry found, just return empty one and don't use an icon
	return emptyEntry;
}
