class H7SeqAct_InterruptAction extends SeqAct_AIMoveToActor
	native;

var(Interrupt) protected H7AdventureArmy mTargetArmy<DisplayName="Target Army">;

event Activated()
{
	local H7AdventureArmy army;
	army = (mTargetArmy == none) ? class'H7AdventureController'.static.GetInstance().GetSelectedArmy() : mTargetArmy;
	if(army != none)
	{
		Targets.Remove(0, Targets.Length);
		Targets.AddItem(army);
	}

	// If we don't have a target, action will be deactivated, but still fire the finish output
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

