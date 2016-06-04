/**
 * TODO: we will delete the old H7SeqAct_Quest and rename this one to it, when the whole system works.
 * */
class H7SeqAct_Quest_NewNode extends SequenceAction
	implements(H7IAliasable,H7IGUIListenable,H7ITooltipable)
	perobjectconfig
	native
	savegame;

enum EH7QuestRewardType
{
	EH7QRT_None         <DisplayName = "None">,
	EH7QRT_Attribute    <DisplayName = "Attribute">,
	EH7QRT_Artifact     <DisplayName = "Artifact">,
	EH7QRT_Creature     <DisplayName = "Creature">,
	EH7QRT_Expierence   <DisplayName = "Experience">,
	EH7QRT_Resource     <DisplayName = "Resource">
};

enum EH7QuestRewardAttribute
{
	EH7QRT_A_Might          <DisplayName = "Attack">,
	EH7QRT_A_Magic          <DisplayName = "Magic">,
	EH7QRT_A_Defense        <DisplayName = "Defense">,
	EH7QRT_A_Spirit         <DisplayName = "Spirit">,
	EH7QRT_A_Leadership     <DisplayName = "Leadership">,
	EH7QRT_A_Destiny        <DisplayName = "Destiny">
};

struct native H7QuestReward
{
	var transient editconst bool bRewardResource;
	var transient editconst bool bRewardAttribute;
	var transient editconst bool bRewardArtifact;
	var transient editconst bool bRewardCreature;

	var() EH7QuestRewardType RewardType <DisplayName = "Type">;
	var() EH7QuestRewardAttribute RewardAttribute <DisplayName = "Attribute" | EditCondition = bRewardAttribute>; 
	var() archetype H7HeroItem RewardArtifact <DisplayName = "Artifact" | EditCondition = bRewardArtifact>;
	var() archetype H7Creature RewardCreature <DisplayName = "Creature" | EditCondition = bRewardCreature>;
	var() archetype H7Resource RewardResource <DisplayName = "Resource" | EditCondition = bRewardResource>;
	var() int RewardValue <DisplayName = "Value" | EditCondition = !bRewardArtifact>;
};

struct native H7ObjectiveBufferEntry
{
	var EQuestOrObjectiveStatus newStatus;
	var string line;
};

// The player that this quest is assigned to.
var(Properties) protected EPlayerNumber mPlayer<DisplayName="Player">;
// The name of the quest that is shown in the quest log.
var(Properties) protected localized string mTitle<DisplayName="Title">;
// When enabled, this quest uses skirmish title and description
var(Developer) protected bool mUseSkirmish<DisplayName="Is Skirmish">;
var protected string mTitleInst;
// A text describing the quest goal for narrative purposes.
var(Properties) protected localized string mDescription<DisplayName="Description">;
var protected string mDescriptionInst;

// Note: The display name is directly referenced in H7QuestPropertyExplorerController and should be kept in synch
var(Properties) protected bool mActivateAtStart<DisplayName="Active at start"|ToolTip="According to the selection the quest will be active or inactive at start of the map.">;

var(Developer) protected bool mPrimary<DisplayName="Primary">;
var protected savegame bool mTracked;
// Enter a text to be displayed in the reward pop-up for narrative purposes.
var(Properties) protected localized string mRewardText<DisplayName="Reward Text">;
var protected string mRewardTextInst;
// Reward that will be granted at completion of the quest.
var(Properties) protected H7QuestReward mReward1<DisplayName="Reward 1">;
// Reward that will be granted at completion of the quest.
var(Properties) protected H7QuestReward mReward2<DisplayName="Reward 2">;
// Reward that will be granted at completion of the quest.
var(Properties) protected H7QuestReward mReward3<DisplayName="Reward 3">;
var(Developer) protected array<H7QuestReward> mRewards<DisplayName=Rewards>; // for expert editor only
var(Developer) protected bool mShowQuestResultBeforeCompleteActions<DisplayName=Show QuestResult before CompleteActions>; // for expert editor only

var private savegame int mCurrentStage;
var private savegame bool mQuestStarted;
var private savegame EQuestOrObjectiveStatus mQuestStatus;

// tooltip/gui
var private array<H7ObjectiveBufferEntry> mTooltipBuffer;
var private EQuestOrObjectiveStatus mQuestStateNewThisFrame;

var protected H7SeqAct_ObjectiveAndGate mObjectiveGate;	// Stored reference for the Advanced GUI

function string GetName() { return GetTitle(); }
function bool IsPrimary() { return mPrimary; }
function bool IsTracked() { return mTracked; }
function SetTracked(bool val) { mTracked = val; }
function EQuestOrObjectiveStatus GetQuestStatus() { return mQuestStatus; }
function bool IsStarted() { return mQuestStarted; }
function EPlayerNumber GetPlayerNumber(){ return mPlayer; }

function string GetTitle()
{
	if(mTitleInst == "") 
	{
		if (mUseSkirmish)
		{
			mTitleInst = class'H7Loca'.static.LocalizeSave("SKIRMISH_QUEST_TITLE","H7General");
		}
		else
		{
			mTitleInst = class'H7Loca'.static.LocalizeKismetObject(self, "mTitle", mTitle);
		}
	}
	return mTitleInst;
}

function string GetDescription()
{
	if(mDescriptionInst == "") 
	{
		if (mUseSkirmish)
		{
			mDescriptionInst = class'H7Loca'.static.LocalizeSave("SKIRMISH_QUEST_DESCRIPTION","H7General");
		}
		else
		{
			mDescriptionInst = class'H7Loca'.static.LocalizeKismetObject(self, "mDescription", mDescription);
		}
	}
	return mDescriptionInst;
}

function string GetRewardText()
{
	if(mRewardTextInst == "") 
	{
		if(Len(mRewardText) > 0)
		{
			mRewardTextInst = class'H7Loca'.static.LocalizeKismetObject(self, "mRewardText", mRewardText);
		}
		else
		{
			mRewardTextInst = "";
		}
	}
	return mRewardTextInst;
}

function array<H7QuestReward> GetRewards()
{
	local array<H7QuestReward> rewards;
	local H7QuestReward reward;
	if(mReward1.RewardType != EH7QRT_None)
	{
		rewards.AddItem(mReward1);
	}
	if(mReward2.RewardType != EH7QRT_None)
	{
		rewards.AddItem(mReward2);
	}
	if(mReward3.RewardType != EH7QRT_None)
	{
		rewards.AddItem(mReward3);
	}
	foreach mRewards(reward)
	{
		if(reward.RewardType != EH7QRT_None)
		{
			rewards.AddItem(reward);
		}
	}
	return rewards;
}

native function string GetID();
native function H7SeqAct_QuestGroup GetGroup();
native function array<H7SeqAct_QuestObjective> GetCurrentObjectives();
native function bool IsSkirmish();
native function AcceptCompleteResult();

event PostSerialize()
{
	local int i;
	local array<H7SeqAct_QuestObjective> currentObjectives;
	local array<H7IQuestTarget> questTargets;
	local H7IQuestTarget questTarget;

	if(mQuestStarted && mQuestStatus == QOS_ONGOING)
	{
		currentObjectives = GetCurrentObjectives();
		
		for( i = 0; i < currentObjectives.Length; ++i )
		{
			// If quest objective was achieved (completed) or failed -> we do not care
			if(currentObjectives[i].IsAchieved() || currentObjectives[i].IsFailed())
			{
				continue;
			}

			questTargets = currentObjectives[i].GetMinimapQuestTargets();

			foreach questTargets(questTarget)
			{
				if(questTarget == none || H7IHideable(questTarget) != none && H7IHideable(questTarget).IsHiddenX())
				{
					continue;
				}

				class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddQuestTracker(self, currentObjectives[i], questTarget);

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 7;
}

// Gameplay hooks

event QuestActivated()
{
	local H7Message message;
	local H7SeqAct_Quest_NewNode questAtLocalPlayer;

	questAtLocalPlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetQuestController().GetQuestByID(self.GetID());

	if(questAtLocalPlayer != none)
	{
		message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mQuestNew.CreateMessageBasedOnMe();
		message.mPlayerNumber = self.GetPlayerNumber();
		message.AddRepl("%quest", GetTitle());
		message.settings.referenceObject = self;
		message.settings.referenceWindowCntl = class'H7AdventureHud'.static.GetAdventureHud().GetQuestLogCntl();
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);

		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("QUEST_RECIEVED");

		BufferNewQuestState(QOS_ACTIVATED);
	}
}

// if 2 triggered at the same time, popup is put in queue
event QuestStateChanged(EQuestOrObjectiveStatus oldStatus, EQuestOrObjectiveStatus newStatus)
{
	local H7Message message;

	// Quest state changed logic/GUI
	switch(newStatus)
	{
		case QOS_ONGOING:
			break;
		case QOS_COMPLETED:
			QuestCompleted();
			break;
		case QOS_FAILED:
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mQuestFailed.CreateMessageBasedOnMe();
			message.mPlayerNumber = self.GetPlayerNumber();
			message.AddRepl("%quest", GetTitle());
			message.settings.referenceObject = self;
			message.settings.referenceWindowCntl = class'H7AdventureHud'.static.GetAdventureHud().GetQuestLogCntl();
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			break;
	}

	BufferNewQuestState(newStatus);
}

function QuestCompleted()
{
	local H7Message message;

	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mQuestCompleted.CreateMessageBasedOnMe();
	message.mPlayerNumber = self.GetPlayerNumber();
	message.AddRepl("%quest", GetTitle());
	message.settings.referenceObject = self;
	message.settings.referenceWindowCntl = class'H7AdventureHud'.static.GetAdventureHud().GetQuestLogCntl();
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetQuestCompleteCntl().OpenPopupForQuest(self);

	BufferNewQuestState(QOS_COMPLETED);
}

function BufferNewQuestState(EQuestOrObjectiveStatus newStatus)
{
	mQuestStateNewThisFrame = newStatus;
	DeleteFromBuffer(mQuestStateNewThisFrame); // in case objective updates already arrived this frame, delete them
	class'H7AdventureController'.static.GetInstance().SetTimer(0.1f,false,nameof(ResetNewQuestState),self);
}
function ResetNewQuestState()
{
	mQuestStateNewThisFrame = QOS_MAX; // meaning INVALID or NONE
}

function DeleteFromBuffer(EQuestOrObjectiveStatus status)
{
	local int i;
	for(i=mTooltipBuffer.Length-1;i>=0;i--)
	{
		if(mTooltipBuffer[i].newStatus == status)
		{
			mTooltipBuffer.Remove(i,1);
		}
	}
}

// adds a objective update to the buffer
function BufferObjectiveChange(H7SeqAct_QuestObjective objective,EQuestOrObjectiveStatus oldStatus,EQuestOrObjectiveStatus newStatus)
{
	local string newLine;
	local H7ObjectiveBufferEntry entry;
	
	if(mQuestStateNewThisFrame == newStatus) // objective got the same status change as quest -> discard
	{
		return;
	}

	if(newStatus == QOS_COMPLETED)
	{
		newLine = "MSG_QUEST_UPDATE_OBJECTIVE_DONE";
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("RADIO_BUTTON");
	}
	else if(newStatus == QOS_FAILED)
	{
		newLine = "MSG_QUEST_UPDATE_OBJECTIVE_FAIL";
	}
	else if(newStatus == QOS_ACTIVATED)
	{
		newLine = "MSG_QUEST_UPDATE_OBJECTIVE_NEW";
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("RADIO_BUTTON");
	}

	newLine = class'H7Loca'.static.LocalizeSave(newLine,"H7Message");
	newLine = Repl(newLine,"%objective",objective.GetDescription());

	entry.newStatus = newStatus;
	entry.line = newLine;
	mTooltipBuffer.AddItem(entry);

	// wait for buffer to fill, then trigger message
	class'H7AdventureController'.static.GetInstance().SetTimer(0.1f,false,nameof(ExecuteObjectiveBufferUpdate),self);
}

// creates a notification for all objective-updates that are in the buffer
function ExecuteObjectiveBufferUpdate()
{
	local H7Message message;
	local H7ObjectiveBufferEntry entry;

	if(mTooltipBuffer.Length == 0) return; // nothing to do, updates in the buffer were deleted in the meantime
	
	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mQuestUpdated.CreateMessageBasedOnMe();
	message.mPlayerNumber = self.GetPlayerNumber();
	message.AddRepl("%quest", GetTitle());
	message.settings.referenceObject = self;
	message.settings.referenceWindowCntl = class'H7AdventureHud'.static.GetAdventureHud().GetQuestLogCntl();
	message.mTooltip = message.GetFormatedText();
	foreach mTooltipBuffer(entry)
	{
		 message.mTooltip = message.mTooltip $ "\n" $ entry.line;
	}
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	mTooltipBuffer.Length = 0;
}

event QuestStageChanged() 
{
	// nothing needed here // see ObjectiveStateChanged
}

// reward handling

function OnRewardAccepted() // called when popup closed
{
	if(GiveOutRewardsToPlayer(class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(GetPlayerNumber())))
	{
		AcceptCompleteResult();
	}
}

// Returns true when finished, false if a popup was opened
function bool GiveOutRewardsToPlayer(H7player player)
{
	local H7QuestReward reward;
	local array<H7QuestReward> rewards;
	local H7AdventureHero rewardedHero;
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local array<H7AdventureHero> rewardedArmyCandidates;
	local H7AdventureArmy rewardedArmy;
	local H7AdventureController adventureController;

	if( player==None )
	{
		return true;
	}

	adventureController = class'H7AdventureController'.static.GetInstance();

	// Probably not multiplayer compatible, should it be?
	rewardedArmy = adventureController.GetSelectedArmy();
	if(rewardedArmy == none)
	{
		rewardedArmyCandidates = adventureController.GetCurrentPlayerHeroes();
		if(rewardedArmyCandidates.Length > 0)
		{
			rewardedArmy = rewardedArmyCandidates[0].GetAdventureArmy();
		}
	}

	rewardedHero = rewardedArmy.GetHero();

	rewards = GetRewards();
	foreach rewards(reward)
	{
		switch(reward.RewardType)
		{
			case EH7QRT_Attribute:
				rewardedHero.IncreaseBaseStatByID(GetStatOfAttribute(reward.RewardAttribute),reward.RewardValue);
				// optional log message

				// gui
				class'H7FCTController'.static.GetInstance().StartFCT(
					FCT_TEXT,rewardedHero.Location, rewardedHero.GetPlayer(),
					"+"$reward.RewardValue @ class'H7EffectContainer'.static.GetLocaNameForStat(GetStatOfAttribute(reward.RewardAttribute),true),
					MakeColor(0,255,0),
					class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().mStatIcons.GetStatIcon(
						GetStatOfAttribute(reward.RewardAttribute)
					)
				);

				break;
			case EH7QRT_Artifact:
				rewardedHero.GetInventory().AddItemToInventory( reward.RewardArtifact );
				
				// gui
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_RESOURCE_PICKUP, rewardedHero.Location, rewardedHero.GetPlayer(), "+"$reward.RewardArtifact.GetName() , MakeColor(0,255,0,255) , reward.RewardArtifact.GetIcon() );

				break;
			case EH7QRT_Creature:
				// build creature reward pool and reward all at once at the end
				stack = new class'H7BaseCreatureStack';
				stack.SetStackSize(reward.RewardValue);
				stack.SetStackType(reward.RewardCreature);
				stacks.AddItem(stack);
				break;
			case EH7QRT_Expierence:
				rewardedHero.AddXp( reward.RewardValue );

				// gui // OPTIONAL move inside hero function
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_XP, rewardedHero.Location, rewardedHero.GetPlayer(), "+"$reward.RewardValue );

				break;
			case EH7QRT_Resource:
				player.GetResourceSet().ModifyResource(reward.RewardResource,reward.RewardValue);
				break;
		}
	}

	if(stacks.Length > 0)
	{		
		if(rewardedArmy.CanMergeStacks(stacks))
		{	
			rewardedArmy.MergeStacks(stacks);
		}
		else
		{
			foreach stacks(stack)
			{
				rewardedArmy.AddStackToMergePool(stack, "MERGE_POOL_QUEST_REWARD");
			}
			
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetCombatPopUpCntl().StartQuestMerger( 
				rewardedArmy , stacks , OnMergeCompleted 
			);
			return false; // still something to do
		}		
	}

	return true;
}

function OnMergeCompleted(bool success)
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetCombatPopUpCntl().ClosePopupHard();
	AcceptCompleteResult();
	class'H7AdventureController'.static.GetInstance().GetSelectedArmy().DeleteMergePool("MERGE_POOL_QUEST_REWARD");
}

// GUI hooks

// Game Object needs to know how to write its data into GFx format
function GUIWriteInto(GFxObject questData,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	local GFxObject obList,obData,rewardList,rewardData,progressList;
	local int j,i;
	local array<H7SeqAct_QuestObjective> objectives;
	local H7SeqAct_QuestObjective objective;
	local array<H7SeqCon_Condition> loseConditions,winConditions,allConditions;
	local H7SeqCon_Condition condition;
	local array<H7QuestReward> rewards;
	local H7QuestReward reward;
	local H7IProgressable progressCondition;
	local H7ConditionProgress progress;
	local array<H7ConditionProgress> conditionProgresses,objectiveProgresses;
	local H7EditorHero lookingHero;

	questData.SetString("ID",GetID());
	questData.SetString("Name",GetTitle()); // @ (mQuestStarted?"S":"!S") @ mPlayer);
	questData.SetString("Desc",GetDescription());
	questData.SetString("RewardText",GetRewardText());
		
	questData.SetBool("Primary",IsPrimary());	
	questData.SetBool("Completed",GetQuestStatus() == QOS_COMPLETED);	
	questData.SetBool("Failed",GetQuestStatus() == QOS_FAILED);	
	questData.SetBool("Tracked",IsTracked());	
	questData.SetBool("Active",mQuestStarted);
		
		
	questData.SetString("TrackIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestTracked));
	questData.SetString("NoTrackIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestUntracked));
	questData.SetString("PrimaryIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestPrimary));
	questData.SetString("SecondaryIcon","img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestSecondary));

	objectives = GetCurrentObjectives();
	obList = flashFactory.GetNewArray();
	j = 0;
	foreach objectives(objective)
	{
		obData = flashFactory.CreateDataObject();
		obData.SetString("Name",objective.GetDescription());
		obData.SetBool("Completed",objective.GetObjectiveStatus() == QOS_COMPLETED);
		obData.SetBool("Failed",objective.GetObjectiveStatus() == QOS_FAILED);

		allConditions.Length = 0;
		objectiveProgresses.Length = 0;
		winConditions = objective.GetWinConditions();
		loseConditions = objective.GetLoseConditions();
		foreach winConditions(condition) allConditions.AddItem(condition);
		foreach loseConditions(condition) allConditions.AddItem(condition);
		
		foreach allConditions(condition)
		{
			progressCondition = H7IProgressable(condition);
			if(progressCondition != none)
			{
				if(progressCondition.HasProgress())
				{
					conditionProgresses = progressCondition.GetCurrentProgresses();
					foreach conditionProgresses(progress)
					{
						if(progress.MaximumProgress != 1.0f) objectiveProgresses.AddItem(progress);
					}
				}
			}
		}

		progressList = flashFactory.GetNewArray();
		foreach objectiveProgresses(progress,i)
		{
			progressList.SetElementString(i,progress.ProgressText); // @ progress.CurrentProgress $ "/" $ progress.MaximumProgress);
		}		
		obData.SetObject("Progresses",progressList);

		obList.SetElementObject(j,obData);
		j++;
	}
	questData.SetObject("Objectives",obList);

	if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none
		&& class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero() != none
		&& class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().IsHero()
		&& class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetPlayer().IsControlledByLocalPlayer()
	)
	{
		lookingHero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	}

	rewards = GetRewards();
	rewardList = flashFactory.GetNewArray();
	j = 0;
	foreach rewards(reward)
	{
		rewardData = flashFactory.CreateDataObject();
		rewardData.SetString("Name",GetNameOfReward(reward));
		rewardData.SetString("Icon",GetIconOfReward(reward));

		if(reward.RewardType == EH7QRT_Artifact) // reward.bRewardArtifact)
		{
			//tooltip = reward.RewardArtifact.GetTooltipForOwner( lookingHero );
			rewardData.SetObject("ItemData", flashFactory.CreateItemObject( reward.RewardArtifact , lookingHero ) );
		}

		rewardList.SetElementObject(j,rewardData);
		j++;
	}
	questData.SetObject("Rewards",rewardList);
}

// WriteInto this GFxObject if DataChanged
function GUIAddListener(GFxObject data,optional H7ListenFocus focus) 
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}

// Game Object needs to know what to do when its data changes (usually they just call ListeningManager)
function DataChanged(optional String cause) 
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

function String GetNameOfReward(H7QuestReward reward)
{
	switch(reward.RewardType)
	{
		case EH7QRT_Attribute:
			return reward.RewardValue @ class'H7EffectContainer'.static.GetLocaNameForStat(GetStatOfAttribute(reward.RewardAttribute),true);
		case EH7QRT_Artifact:
			return reward.RewardArtifact.GetName();
		case EH7QRT_Creature:
			return reward.RewardValue $ "x" @ reward.RewardCreature.GetName();
		case EH7QRT_Expierence:
			return reward.RewardValue @ class'H7Loca'.static.LocalizeSave("XP","H7General");
		case EH7QRT_Resource:
			return reward.RewardValue @ reward.RewardResource.GetName();
	}
	;
	return String(GetEnum(Enum'EH7QuestRewardType',reward.RewardType));
}

function String GetIconOfReward(H7QuestReward reward)
{
	switch(reward.RewardType)
	{
		case EH7QRT_Attribute:
			return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIcons.GetStatIconPath(GetStatOfAttribute(reward.RewardAttribute));
		case EH7QRT_Artifact:
			return reward.RewardArtifact.GetFlashIconPath();
		case EH7QRT_Creature:
			return reward.RewardCreature.GetFlashIconPath();
		case EH7QRT_Expierence:
			return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIcons.GetStatIconPath(STAT_CURRENT_XP);
		case EH7QRT_Resource:
			return reward.RewardResource.GetIconPath();
	}
	;
	return "none";
}

function EStat GetStatOfAttribute(EH7QuestRewardAttribute attribute)
{
	switch(attribute)
	{
		case EH7QRT_A_Might:return STAT_ATTACK;
		case EH7QRT_A_Magic:return STAT_MAGIC;
		case EH7QRT_A_Defense:return STAT_DEFENSE;
		case EH7QRT_A_Spirit:return STAT_SPIRIT;
		case EH7QRT_A_Leadership:return STAT_MORALE_LEADERSHIP;
		case EH7QRT_A_Destiny:return STAT_LUCK_DESTINY;
	}
	;
	return STAT_MAX;
}

// for minimap icon
function H7TooltipData GetTooltipData(optional bool extendedVersion) 
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = Repl(class'H7Loca'.static.LocalizeSave("QUEST_MINIMAP_ICON","H7General"),"%quest",GetTitle());
	data.Description = "<font size='#TT_BODY#'>" $ GetTitle() $ "</font>";

	return data;
}

