class H7SeqAct_SetListenerCinematic extends SequenceAction
	implements(H7IAliasable)
	native;

var (Cinematic_Mode) protected bool mEnableCinematicMode <DisplayName=Enable Listener Cinematic Mode>;

event activated()
{
	class'H7Camera'.static.GetInstance().SetCinematicListenerEnabled(mEnableCinematicMode);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

