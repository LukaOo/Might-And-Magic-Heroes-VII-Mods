//=============================================================================
// H7GFxDataObject
//
// plan: create this in unreal, link up to gameObject, fill with data, use to extend (?) in flash
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxDataObject extends H7GFxListener;

var protected GFxObject mFlashObject;

function ListenUpdate(H7IGUIListenable gameEntity)
{
	if(mFlashObject == none) ;

	;
	gameEntity.GUIWriteInto(mFlashObject);

	mFlashObject.ActionScriptVoid("ListenUpdate");
}

function SetFlashDataObject(GFxObject flashObject)
{
	mFlashObject = flashObject;
}

function GFxObject GetFlashDataObject()
{
	return mFlashObject;
}
