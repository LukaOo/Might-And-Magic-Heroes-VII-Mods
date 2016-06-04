//=============================================================================
// H7TextColors
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TextColors extends Object
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	dependson(H7StructsAndEnumsNative);

var() public Color mTierColors[ETier.ITIER_MAX];
var() public Color mQuestItemColor;
var() public Color mSetColor;
var() public Color mReplacementColor<DisplayName=Tooltip Data Insert Color>; // FF4C76E7 -> // FF809CFF -> FFB7C4FF
var() public Color mLogReplacementColor<DisplayName=Log/Note Data Insert Color>; // FFFFCC99

static function H7TextColors GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mTextColors; }

function String UnrealColorToHTMLColor(Color unrealColor)
{
	return "#" $ UnrealColorToHex(unrealColor);
}

function String UnrealColorToHex(Color unrealColor)
{
	local String hexStr;
	
	hexStr = ToHex((unrealColor.R * 16**4) + (unrealColor.G * 16**2) + unrealColor.B);
	hexStr = Mid(hexStr,2);

	return hexStr;
}
