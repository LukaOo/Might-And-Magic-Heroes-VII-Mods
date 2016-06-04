//=============================================================================
// H7Mouse
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMouse extends GFxObject;

// CURSOR

function LoadCursorTexture(Texture2d cursor, optional Rotator rot,optional float offsetX,optional float offsetY) // size is determined in the .fla
{
	local float rotFloat;
	rotFloat = float(rot.Yaw)/float(65536) * 360;

	LoadCursor("img://" $ Pathname( cursor ) , rotFloat , offsetX, offsetY );
}

function LoadCursor(String cursorPath, float cursorRotation,optional float offsetX,optional float offsetY)
{
	ActionscriptVoid("LoadCursor");
}

function UnLoadCursor()
{
	ActionscriptVoid("UnLoadCursor");
}

// OBJECT (FOR DRAG&DROP)

function LoadObjectTexture(Texture2d object, optional Rotator rot, optional int offsetX, optional int offsetY, optional int sizeX, optional int sizeY)
{
	local float rotFloat;
	
	rotFloat = float(rot.Yaw)/float(65536) * 360;

	LoadObject("img://" $ Pathname( object ) , rotFloat , offsetX , offsetY , sizeX , sizeY);
}

function LoadObject(String cursorPath, float cursorRotation, optional int offsetX, optional int offsetY, optional int sizeX, optional int sizeY)
{
	;
	ActionscriptVoid("LoadObject");
}

function int UnLoadObject()
{
	local int i;
	i = ActionScriptInt("UnLoadObject");
	return i;
}

// Default properties block
