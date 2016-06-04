class H7PlayerEventParam extends H7EventParam
	native;

var EPlayerNumber mEventPlayerNumber;

// Event location
var int mGridIndex;
var array<H7AdventureMapCell> mGridCoordinates;

// Visited town building
var H7TownBuilding mTownbuilding;

// manipulated popup
var string mPopupName;

// recruited hero
var H7EditorHero mRecruitedHero;
