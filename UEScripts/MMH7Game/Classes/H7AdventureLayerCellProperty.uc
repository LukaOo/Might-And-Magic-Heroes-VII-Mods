class H7AdventureLayerCellProperty extends H7LandscapeGameLayerInfoData
	native(Core)
	hideCategories(Object);

var() string DisplayName;
var() Color GridColor;
var() float MovementCost; // A movement cost of 0 is costless moving for the army on it. A movement cost < 0 is impassable. A movement cost of 1 is normal movement points spend.
var() float DeepWaterThreshold;
var() array<string> mCombatMapList<DisplayName=Combat Maps>;
var() array<string> mWetCombatMapList<DisplayName=Shallow Water Combat Maps>; // If left empty, then it fallback to Combat Map array instead
/**Add Play AkEvents here (Music / Basic Ambience)*/
var() AkEvent mPlayAkEvents<DisplayName=Play AK Event>;
var() AkEvent mPlayAmbientAkEvents<DisplayName=Play Basic Ambient AK Event>;
var() AkEvent mPlayFoWAmbientAkEvents<DisplayName=Play Basic Fog of War Ambient AK Event>;
/**Add Resume AkEvent here (Music)*/
var() AkEvent mResumeAkEvents<DisplayName=Resume AK Event>;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

