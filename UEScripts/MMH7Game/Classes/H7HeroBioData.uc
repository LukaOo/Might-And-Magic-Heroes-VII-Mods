// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7HeroBioData extends Object
	perobjectconfig;

var(Properties) localized String mText<DisplayName="Text">;
var(Properties) String mCondition<DisplayName="Condition map">;
var(Properties) bool mStarted<DisplayName="Map started">;

var private transient string mTextInst;

function string GetCondition() { return mCondition; }
function bool GetStartedCondition() {return mStarted; }

function string GetText()
{
	if(Len(mTextInst) == 0)
	{
		mTextInst = class'H7Loca'.static.LocalizeContent(self, "mText", mText);
	}
	return mTextInst;
}
