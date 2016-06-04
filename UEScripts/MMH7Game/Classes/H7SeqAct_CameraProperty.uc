class H7SeqAct_CameraProperty extends SequenceAction;

var() H7CameraProperties mNewProperty<Displayname="Camera property archetype">;

event Activated()
{
	local H7Camera cam;
	cam = class'H7Camera'.static.GetInstance();
	cam.SetActiveProperties(mNewProperty);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

