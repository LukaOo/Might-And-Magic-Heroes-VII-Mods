class H7SeqAct_Audio extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

event activated()
{
	//this is play / pause the default music. what about named music ? soundcue ? mp3?
	if ( InputLinks[0].bHasImpulse )
		class'H7SoundController'.static.GetInstance().PlayPauseMusic();
	else if ( InputLinks[1].bHasImpulse )
		class'H7SoundController'.static.GetInstance().PlayPauseMusic();
	else if ( InputLinks[2].bHasImpulse )
		class'H7SoundController'.static.GetInstance().GetSoundManager().StopAmbientLayers();
	else if ( InputLinks[3].bHasImpulse )
		class'H7SoundController'.static.GetInstance().GetSoundManager().StartAmbientLayers();
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
// (cpptext)

