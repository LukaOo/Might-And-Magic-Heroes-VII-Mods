//=============================================================================
// H7MapInfo which is shared for both adventure map and combat map
//=============================================================================
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7MapInfoBase extends MapInfo
	native
	perobjectconfig
	dependson(H7StructsAndEnumsNative)
	hidecategories(Object);

var(MapGeneralProperties) private editconst EMapTag mIsOfficial<DisplayName="Tag">;
var(MapGeneralProperties) protected localized string mName<DisplayName="Name">;
var(MapGeneralProperties) protected localized string mDescription<DisplayName="Description">;
var(MapGeneralProperties) protected string mAuthor<DisplayName="Author">;

var(MapGeneralProperties) protected Texture2D mThumbnailTexture<DisplayName="Thumbnail Texture (it must be inside the map package to be streamed from main menu)">;



function bool IsOfficial() { return (mIsOfficial == E_H7_MT_OFFICIAL); }
function string GetNameUnlocalized() { return mName; }
function string GetName() { return class'H7Loca'.static.LocalizeMapInfoObject(self,"mName",mName); }
function string GetDescription() { return class'H7Loca'.static.LocalizeMapInfoObject(self,"mDescription",mDescription); }
function string GetAuthor() { return mAuthor; }




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

