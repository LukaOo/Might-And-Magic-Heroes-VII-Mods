//=============================================================================
// H7MessageMapping.uc
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7MessageMapping extends Object
	hideCategories(Object);

// non-design, sidebar
var() H7Message mLastHeroChance<DisplayName=Last chance to act with Hero>;
var() H7Message mOtherPlayerTurn<DisplayName=Other Player Turn>; // Other player is playing
var() H7Message mAITurn<DisplayName=AI Turn>;

// official design, notebar
var() H7Message mHeroSpellLearned<DisplayName=Hero Spell Learned>;
var() H7Message mHeroLevelUp<DisplayName=Hero Level Up>;
var() H7Message mHeroSkillpoints<DisplayName=Hero Skill Points>;
var() H7Message mHeroSkillpointsRandom<DisplayName=Hero Skill Points Random>; // TODO
var() H7Message mHeroSkillIncrease<DisplayName=Hero Skill Increase>; // TODO


// quest TODO
var() H7Message mQuestNew<DisplayName=New Quest>;
var() H7Message mQuestCompleted<DisplayName=Quest Completed>;
var() H7Message mQuestFailed<DisplayName=Quest Failed>;
var() H7Message mQuestUpdated<DisplayName=Quest Updated>;

// caravan
var() H7Message mCaravanArrived<DisplayName=Caravan Arrived>;
var() H7Message mCaravanUnload<DisplayName=Caravan Not Unloaded>;
var() H7Message mCaravanBlocked<DisplayName=Caravan Blocked>;
var() H7Message mCaravanReturn<DisplayName=Caravan Returned>;
var() H7Message mCaravanContinue<DisplayName=Caravan Continued>;
var() H7Message mHeroReceivedCreatures<DisplayerName=Hero received creatures>;
var() H7Message mHeroReceivedItems<DisplayName=Hero received itmes>;

// realm
var() H7Message mMinePlunder;
var() H7Message mMinePlunderPlunderer;
var() H7Message mSabotage;
var() H7Message mSabotageSuccess;
var() H7Message mSabotageFail;
var() H7Message mTownlost<DisplayerName=Site lost>;
var() H7Message mFortlost<DisplayerName=Fort lost>;
var() H7Message mMagicGuildSpec;

var() H7Message mTGUpdated;// TODO
var() H7Message mPlunderSuccess;// TODO
var() H7Message mPlunderFail;// TODO

// player
var() H7Message mTearFound;
var() H7Message mPlayerDefeated;
var() H7Message mPlayerSentResources;
var() H7Message mPlayerDisconnected;

var() H7Message mHeropedia;// TODO
var() H7Message mGameSaved;

var(Special) H7Message mStarvation;
var(Special) H7Message mCyclopsBuff;

 
