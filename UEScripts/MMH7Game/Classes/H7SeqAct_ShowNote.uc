class H7SeqAct_ShowNote extends H7SeqAct_Narration
	implements(H7IAliasable)
	perobjectconfig
	native;

/** The text to display */
var(Properties) protected localized string mText<DisplayName="Text">;
var(Properties) protected Texture2D mIcon<DisplayName="Icon">;
//var(Properties) protected H7MessageSettings mMessageSettings<DisplayName="Message Settings">;

function Activated()
{
	local H7MessageSettings msettings;
	//msettings = mMessageSettings;
	msettings.icon = mIcon;
	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage( GetLocalizedContent() , MD_NOTE_BAR , msettings);
}

function string GetLocalizedContent()
{
	return class'H7Loca'.static.LocalizeKismetObject(self, "mText", mText);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

