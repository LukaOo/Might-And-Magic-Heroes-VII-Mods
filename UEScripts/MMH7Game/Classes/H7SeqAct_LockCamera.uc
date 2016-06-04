class H7SeqAct_LockCamera extends SequenceAction;

event Activated()
{
	local H7Camera cam;
	cam = class'H7Camera'.static.GetInstance();
	cam.LockCamera(true);
	cam.LockCameraPreventFocusActor(true);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

