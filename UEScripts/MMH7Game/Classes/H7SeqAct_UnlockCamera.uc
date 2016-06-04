class H7SeqAct_UnlockCamera extends SequenceAction;

event Activated()
{
	local H7Camera cam;
	cam = class'H7Camera'.static.GetInstance();
	cam.LockCamera(false);
	cam.LockCameraPreventFocusActor(false);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

