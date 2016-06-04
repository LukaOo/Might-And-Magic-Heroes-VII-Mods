class H7CinematicGameInfo extends GameInfo;

function PlayerController SpawnPlayerController(vector SpawnLocation, rotator SpawnRotation)
{
	local PlayerController newPC;

	newPC = Spawn(PlayerControllerClass,,, SpawnLocation, SpawnRotation);

	// fix the postprocess
	RestartPlayer(newPC);

	return newPC;
}

// Restart Player and SpawnDefaultPawnFor are overriden to avoid a Pawn to be spawned. We cleary don't need one for Heroes.
function RestartPlayer(Controller NewPlayer) //override
{
	local PlayerController PC;
	local LocalPlayer LP;

	// To fix custom post processing chain when not running in editor or PIE.
	PC = PlayerController(NewPlayer);
	if (PC != none)
	{
		LP = class'Engine'.static.GetEngine().GameViewport.GetPlayerOwner(0);
		if(LP != None) 
		{ 
			LP.RemoveAllPostProcessingChains(); 
			LP.InsertPostProcessingChain(LP.Outer.GetWorldPostProcessChain(),INDEX_NONE,true); 
			if(PC.myHUD != None)
			{
				PC.myHUD.NotifyBindPostProcessEffects();
			}
		} 
	}

	return;
}

