//=============================================================================
// H7GFxNarrationDialog
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxNarrationDialog extends H7GFxUIContainer;

function Update(String text, H7EditorHero speaker, bool hasPrev, bool hasNext, optional bool subTitleHack)
{
	local GFxObject mData;

	;

	mData = CreateDataObject();

	mData.SetString("Text",text);
	mData.SetString("Icon",speaker.GetFlashIconPath());
	mData.SetString("Name",speaker.GetName());
	
	mData.SetBool("HasPrev",hasPrev);
	mData.SetBool("HasNext",hasNext);
	
	mData.SetBool("SubTitle",subTitleHack);
	
	SetObject("mData",mData);

	ActionscriptVoid("Update");
	
	GetHud().GetDialogCntl().OpenPopupSpecific(self,false,true);
}
