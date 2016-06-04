//=============================================================================
// H7SeqCon_Objective
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_QuestObjective extends SequenceAction
	implements(H7IAliasable, H7IRandomPropertyOwner)
	perobjectconfig
	native
	savegame;

enum EH7ObjectiveStage
{
	EH7OS_STAGE_1          <DisplayName = Stage 1>,
	EH7OS_STAGE_2          <DisplayName = Stage 2>,
	EH7OS_STAGE_3          <DisplayName = Stage 3>,
	EH7OS_STAGE_4          <DisplayName = Stage 4>,
	EH7OS_STAGE_5          <DisplayName = Stage 5>,
	EH7OS_STAGE_6          <DisplayName = Stage 6>,
	EH7OS_STAGE_7          <DisplayName = Stage 7>,
	EH7OS_STAGE_8          <DisplayName = Stage 8>,
	EH7OS_STAGE_9          <DisplayName = Stage 9>,
};

// Name used in the editor (has no effect in-game)
var(Properties) protected string mName<DisplayName="Editor Title">;
// In-game description
var(Properties) protected localized string mDescription<DisplayName="Description">;
// Note: The display name is directly referenced in H7QuestPropertyExplorerController and should be kept in synch
var(Properties) protected EH7ObjectiveStage mStage<DisplayName="Activation Stage"|ToolTip="The stage on which the objective will be activated.">;
// The objective can be failed but will be considered as achieved.
var(Properties) protected bool mIgnoreFail<DisplayName="Ignore Fail">;
// Enable minimap tracking for this objective.
var(Properties) protected EH7ShowOnMinimap mShowOnMinimap<DisplayName="Show on minimap">;
// Add or remove adventure map objects from the this list to have a marker on their position.
var(Properties) protected savegame array<H7IQuestTarget> mTrackingObjects<DisplayName="Objects for minimap tracking">;

var private savegame bool mObjectiveActivated;
var private savegame bool mAchieved;
var private savegame bool mFailed;
var private int mLastGameStateCounter;
var private savegame EQuestOrObjectiveStatus mObjectiveStatus;
var private array<H7SeqCon_Condition> mWinConditions;
var private array<H7SeqCon_Condition> mLoseConditions;

// When enabled, this objective uses skirmish condition strings
var(Skirmish) protected bool mUseSkirmish<DisplayName="Is Skirmish">;
var(Skirmish) private string mCondDescription<DisplayName="Localized description">;             //the localized string key with possible placeholders
var(Skirmish) private array<Object> mCondRelatedObjects<DisplayName="Objects for localized description">;   //the objects whose name will replace the placeholders

//special data handling
var(Skirmish) private int mCondWeeks;
var(Skirmish) private int mCondAmount;
var(Skirmish) private ECreatureTier mCondTier;
var(Skirmish) private string mCondIcon;

function bool IsAchieved()
{
	return mAchieved && (mObjectiveStatus == QOS_COMPLETED);
}

function bool IsFailed()
{
	return mFailed && (mObjectiveStatus == QOS_FAILED);
}

function private string GetDescriptionName(Object relatedObject)
{
	if (H7Unit(relatedObject) != none)
	{
		return H7Unit(relatedObject).GetName();
	}
	else if (H7HeroItem(relatedObject) != none)
	{
		return H7HeroItem(relatedObject).GetName();
	}
	else if (H7Resource(relatedObject) != none)
	{
		return H7Resource(relatedObject).GetName();
	}
	else if (H7Town(relatedObject) != none)
	{
		return H7Town(relatedObject).GetName();
	}
	return "";
}

function private string GetCreatureTierString()
{
	local string tierKey;	
	switch(mCondTier)
	{
	case CTIER_CORE:
		tierKey = "TIER_CORE";
		break;
	case CTIER_ELITE:
		tierKey = "TIER_ELITE";
		break;
	case CTIER_CHAMPION:
		tierKey = "TIER_CHAMPION";
		break;
	default:
		return "";
	}
	return class'H7Loca'.static.LocalizeSave(tierKey,"H7Creature");
}

function string WinLoseCondDesc()
{
	local string result;
	local Object relatedObject;
	local int i;
	result = "";

	result = class'H7Loca'.static.LocalizeSave(mCondDescription,"H7SeqAct_QuestObjective");
	//replace every '%n' with one object
	foreach mCondRelatedObjects(relatedObject, i)
	{
		result = Repl(result, "%" $ i, GetDescriptionName(relatedObject));
	}
	//replace special placeholders
	result = Repl(result, "%weeks", mCondWeeks);
	result = Repl(result, "%amount", mCondAmount);
	result = Repl(result, "%tier", GetCreatureTierString());

	if (InStr(result, "%icon") != INDEX_NONE)
	{
		result = Repl(result, "%icon", mCondIcon);
		return class'H7Loca'.static.ResolveIconPlaceholders(result);
	}

	return result;
}

function string GetDescription() 
{ 
	if (mUseSkirmish)
	{
		return WinLoseCondDesc();
	}
	else
	{
		return class'H7Loca'.static.LocalizeKismetObject(self, "mDescription", mDescription); 
	}
}
function EQuestOrObjectiveStatus GetObjectiveStatus() { return mObjectiveStatus; }
function EH7ShowOnMinimap GetShowOnMinimap() { return mShowOnMinimap; }
function array<H7IQuestTarget> GetQuestTargets()
{
	local array<H7IQuestTarget> trackingObjects;
	local Object target;

	trackingObjects = mTrackingObjects;

	foreach Targets(target)
	{
		if(target != none && target.IsA('H7IQuestTarget'))
		{
			trackingObjects.AddItem(H7IQuestTarget(target));
		}
	}
	return trackingObjects;
}

function bool IsActive()
{
	return (mObjectiveStatus == QOS_ONGOING || mObjectiveStatus == QOS_ACTIVATED);
}

function RemoveMinimapTrackingObject(H7IQuestTarget questTarget)
{
	mTrackingObjects.RemoveItem(questTarget);
	questTarget.ClearQuestFlag();
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().RemoveQuestIcon(questTarget.GetQuestTargetID());
}

event bool ShouldFireConditionCheck()
{
	local int currentGameStateCounter;
	currentGameStateCounter = class'H7ReplicationInfo'.static.GetInstance().GetGameStateCounter();
	if ( mLastGameStateCounter != currentGameStateCounter )
	{
		//Special handling: when combat popup is present, don't check / update game state counter.
		if (class'H7CombatPopUpCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			return false;
		}
		mLastGameStateCounter = currentGameStateCounter;
		return true;
	}
	return false;
}

event ObjectiveActivated()
{
	ObjectiveStateChanged(QOS_FAILED,QOS_ACTIVATED);
}

event ObjectiveStateChanged(EQuestOrObjectiveStatus oldStatus, EQuestOrObjectiveStatus newStatus)
{
	local H7SeqAct_Quest_NewNode questAtLocalPlayer;
	local array<H7IQuestTarget> questTargets;
	local H7IQuestTarget questTarget;
	local H7SeqCon_Condition cond;

	questAtLocalPlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetQuestForObjective(self);

	if(questAtLocalPlayer != none)
	{
		if(newStatus == QOS_ACTIVATED)
		{
			questTargets = GetMinimapQuestTargets();
			foreach questTargets(questTarget)
			{
				if(questTarget != none)
				{
					if(H7IHideable(questTarget) != none && H7IHideable(questTarget).IsHiddenX())
					{
						continue;
					}

					class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddQuestTracker(questAtLocalPlayer, self, questTarget);
						
					if(class'H7GameUtility'.static.IsArchetype(questTarget))
					{
						;
					}
					else
					{
						questTarget.AddQuestFlag();
					}
				}
			}
		}
	}
	
	if(newStatus == QOS_COMPLETED || newStatus == QOS_FAILED) // && GetShowOnMinimap() == E_H7_SOM_CUSTOM)
	{
		if(questAtLocalPlayer != none)
		{
			// hide all minimap icons
			questTargets = GetMinimapQuestTargets();
			foreach questTargets(questTarget)
			{
				questTarget.ClearQuestFlag();
				class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().RemoveQuestIcon(questTarget.GetQuestTargetID());
			}
		}
		foreach mWinConditions( cond )
		{
			if( H7SeqCon_GatherResources( cond ) != none )
			{
				if( newStatus == QOS_COMPLETED )
				{
					H7SeqCon_GatherResources( cond ).SetCompleted( true );
				}
				else
				{
					H7SeqCon_GatherResources( cond ).SetFailed( true );
				}
			}
		}
		foreach mLoseConditions( cond )
		{
			if( H7SeqCon_GatherResources( cond ) != none )
			{
				if( newStatus == QOS_COMPLETED )
				{
					H7SeqCon_GatherResources( cond ).SetCompleted( true );
				}
				else
				{
					H7SeqCon_GatherResources( cond ).SetFailed( true );
				}
			}
		}
	}

	if(questAtLocalPlayer != none)
	{
		questAtLocalPlayer.BufferObjectiveChange(self,oldStatus,newStatus);
	}
}

function array<H7IQuestTarget> GetMinimapQuestTargets()
{
	local array<H7IQuestTarget> miniMapQuestTargets;
	local array<H7IQuestTarget> questTargets;
	local H7IQuestTarget questTarget;
	local array<H7SeqCon_Condition> conditions;
	local H7SeqCon_Condition currentCondition;

	if(GetShowOnMinimap() == E_H7_SOM_CUSTOM)
	{
		return GetQuestTargets();
	}
	else if(GetShowOnMinimap() == E_H7_SOM_AUTO)
	{
		conditions = GetWinConditions();
		foreach conditions(currentCondition)
		{
			questTargets = currentCondition.GetQuestTargets();

			foreach questTargets(questTarget)
			{
				if(questTarget != none)
				{
					miniMapQuestTargets.AddItem(questTarget);
				}
			}
		}
	}

	return miniMapQuestTargets;
}

native function array<H7SeqCon_Condition> GetWinConditions();
native function array<H7SeqCon_Condition> GetLoseConditions();

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

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	local int i;

	for(i = 0; i < mTrackingObjects.Length; ++i)
	{
		if(mTrackingObjects[i] == randomObject)
		{
			mTrackingObjects[i] = hatchedObject;
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 5;
}

