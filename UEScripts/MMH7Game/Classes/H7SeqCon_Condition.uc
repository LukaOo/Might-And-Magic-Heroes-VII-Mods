//=============================================================================
// H7SeqCon_Condition
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_Condition extends SequenceCondition
	implements(H7IAliasable)
	native;

/** Negates the outcome */
var(Condition) protected bool mNot<DisplayName=NOT>;

var transient array<H7IQuestTarget> mOldQuestTargets;

//Override in children, if they have locations
function array<H7IQuestTarget> GetQuestTargets()
{
	local array<H7IQuestTarget> dummyTargets;

	dummyTargets.Length = 0; // to prevent compiler warning

	return dummyTargets; // return empty array = no location
}

function Activated()
{
	if(OutputLinks.Length > 0)
	{
		OutputLinks[0].bHasImpulse = HasOutputImpulse();
	}
	mOldQuestTargets = GetQuestTargets();
}

function protected bool IsConditionFulfilled()
{
	return true;
}

function protected bool HasOutputImpulse()
{
	return mNot ? !IsConditionFulfilled() : IsConditionFulfilled();
}

function UpdateWeek();
function UpdateDay();

protected function bool Eval( ECompareOp op, float valueA, float valueB ) 
{
	switch ( op ) 
	{
		case ECO_EQUAL:
			return valueA == valueB;
		case ECO_LESS_EQUAL:
			return valueA <= valueB;
		case ECO_GREATER_EQUAL:
			return valueA >= valueB;
		case ECO_LESS:
			return valueA < valueB;
		case ECO_GREATER:
			return valueA > valueB;
		default:;
	}

	return false; 
}

event ConditionProgressed(int progressIndex = 0)
{
	// Notifications + Quest Log Update
	local H7IProgressable progressCondition;
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local H7SeqAct_QuestObjective objective;
	local H7SeqAct_Quest_NewNode quest;
	local int i;
	local array<H7IQuestTarget> newQuestTargets;
	local H7IQuestTarget questTarget;
	local array<H7Player> allPlayers;
	local H7Player iPlayer,ownerPlayer;

	// find the player whose condition just updated:
	allPlayers = class'H7AdventureController'.static.GetInstance().GetPlayers();
	foreach allPlayers(iPlayer)
	{
		if(iPlayer.GetQuestController() != none)
		{
			objective = iPlayer.GetQuestController().GetObjectiveForCondition(self);
			if(objective != none)
			{
				ownerPlayer = iPlayer;
				break;
			}	
		}
	}

	if(ownerPlayer != none)
	{
		quest = ownerPlayer.GetQuestController().GetQuestForObjective(objective); 
	
		progressCondition = H7IProgressable(self);
		if(progressCondition != none && progressCondition.HasProgress())
		{
		
			progresses = progressCondition.GetCurrentProgresses();
			foreach progresses(progress,i)
			{
				if(progressIndex == i)
					class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(quest.GetName() $ ":" @ progress.ProgressText,MD_LOG,,ownerPlayer.GetPlayerNumber());
			}
		}

		// minimap
		if(ownerPlayer == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
		{
			if(objective.GetShowOnMinimap() == E_H7_SOM_AUTO) // only case conditions care about
			{
				newQuestTargets = GetQuestTargets();
				foreach mOldQuestTargets(questTarget)
				{
					if(newQuestTargets.Find(questTarget) == INDEX_NONE)
					{
						questTarget.ClearQuestFlag();
						class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().RemoveQuestIcon(questTarget.GetQuestTargetID());
					}
				}
				mOldQuestTargets = newQuestTargets; 
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

