class H7SeqAct_ToggleFlythroughMode extends SequenceAction;

// TODO remove all parameters 
// and merge with real unreal cinematic mode *?*
// all this parametes mean "affect this", and it is affected in the way specified by the input
//                          checked                                 unchecked
// input=enable          gui/fog/view/control to cinematic mode     no change
// input=disable         gui/fog/view/control to normal mode        no change
/** checking this will a) hide the GUI if input=enable b) show the GUI if input=disable */
var(H7Cinematic) bool bToggleHud<DisplayName=Switch GUI according to input>;
/** checking this will a) hide the FOG if input=enable b) show the FOG if input=disable*/
var(H7Cinematic) bool bToggleFog<DisplayName=Switch Fog according to input>;
/** checking this will a) hide the Flags&Decals if input=enable b) show the Flags&Decals if input=disable*/
var(H7Cinematic) bool bToggleCinematicView<DisplayName=Switch View (and Controls) according to input>;


event Activated()
{
	local H7PlayerController playerCntl;
	local H7AdventurePlayerController advPlayerCntl;

	playerCntl = class'H7PlayerController'.static.GetPlayerController();
	advPlayerCntl = H7AdventurePlayerController( playerCntl );


	if( advPlayerCntl != none && class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) 
	{
		if(InputLinks[0].bHasImpulse)	   advPlayerCntl.SetFlythroughRunning( true , bToggleHud, bToggleCinematicView, bToggleFog);
		else if(InputLinks[1].bHasImpulse) advPlayerCntl.SetFlythroughRunning( false, bToggleHud, bToggleCinematicView, bToggleFog);
		else if(InputLinks[2].bHasImpulse) advPlayerCntl.SetFlythroughRunning( !playerCntl.IsFlythroughRunning(), bToggleHud, bToggleCinematicView, bToggleFog );
	}
	else if( playerCntl != none )
	{
		if(InputLinks[0].bHasImpulse)	   playerCntl.SetFlythroughRunning( true, bToggleHud, bToggleCinematicView, false );
		else if(InputLinks[1].bHasImpulse) playerCntl.SetFlythroughRunning( false, bToggleHud, bToggleCinematicView, false);
		else if(InputLinks[2].bHasImpulse) playerCntl.SetFlythroughRunning( !playerCntl.IsFlythroughRunning(), bToggleHud, bToggleCinematicView, false );
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

