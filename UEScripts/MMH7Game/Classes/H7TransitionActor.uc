class H7TransitionActor extends Actor
	placeable;

event PostBeginPlay()
{
	// reset the postprocess settings of the adventure map
	class'H7AdventureController'.static.GetInstance().ResetAdventurePostProcess();
}
