class H7ActionTask extends H7UPlayTask
	dependson(H7StructsAndEnumsNative)
	native
;

var bool mIsSyncing;

var native protected pointer mUPlayActions;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function bool UpdateStatus();

native function bool EarnAction(INT actionUID, optional bool showPopup = true);

// Coz UPlay
native function bool SynchronizeActions();

native function SynchronizeActionsCompleted();



