// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7GeneralLoreEntry extends Object
	perobjectconfig;

var(Properties) localized String mName<DisplayName="Name">;
var(Properties) localized String mText<DisplayName="Text">;
var(Properties) Texture2D mIcon<DisplyName="Icon">;

var private transient string mTextInst;
var private transient string mNameInst;

function String	GetFlashIconPath() { return "img://" $ Pathname( mIcon ); }

function string GetText()
{
	if(Len(mTextInst) == 0)
	{
		mTextInst = class'H7Loca'.static.LocalizeContent(self, "mText", mText);
	}
	return mTextInst;
}

function string GetName()
{
	if(Len(mNameInst) == 0)
	{
		mNameInst = class'H7Loca'.static.LocalizeContent(self, "mName", mName);
	}
	return mNameInst;
}
