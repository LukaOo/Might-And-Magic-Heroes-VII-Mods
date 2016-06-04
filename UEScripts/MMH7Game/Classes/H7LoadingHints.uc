class H7LoadingHints extends Object
	perobjectconfig;

var() protected localized array<String> mHints;
var protected transient array<String> mUsedHints;

function array<string> GetHints()
{
	return mUsedHints;
}

function InitHints()
{
	local int i;
	local string locaKey, contentText;

	for (i=0; i<mHints.Length; i++)
	{
		locaKey = (class'H7Loca'.static.GetArrayFieldName("mHints", i));
		contentText = class'H7Loca'.static.LocalizeContent(self, locaKey, mHints[i]);

		mUsedHints.AddItem(contentText);
	}
}
