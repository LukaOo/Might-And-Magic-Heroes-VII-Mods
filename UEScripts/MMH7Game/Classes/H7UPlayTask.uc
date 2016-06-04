class H7UPlayTask extends Object
	dependson(H7StructsAndEnumsNative)
	native
;

var protected int mUID;
var protected bool mTaskSucceeded;

var native protected pointer mUPlayOverlapOperation;

function SetUID(int newUID) { mUID = newUID; }
function int GetUID() { return mUID; }

native function bool UpdateStatus();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

