class H7RewardTask extends H7UPlayTask
	dependson(H7StructsAndEnumsNative)
	native
;

var protected array<string> mUnlockedRewards;

var native protected pointer mUPlayRewards;

native function bool UpdateStatus();

native function bool PullUnlockedRewards();

native function PullUnlockedRewardsCompleted();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
