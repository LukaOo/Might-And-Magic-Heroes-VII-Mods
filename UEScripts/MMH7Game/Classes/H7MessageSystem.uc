//=============================================================================
// H7MessageSystem
//
// this class is used to send messages to all different parts of the GUI
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MessageSystem extends Object dependson(H7MessageCallbacks, H7StructsAndEnums);

enum H7MessageDestination
{
	MD_LOG,
	MD_QA_LOG,
	MD_SIDE_BAR, // old star trek online style boxes
	MD_POPUP,
	MD_ERROR_SCREEN, // OPTIONAL
	MD_SLIDE_IN, // deprecated (same as MD_SIDE_BAR?)
	MD_FLOATING,
	MD_FULLSCREEN_FLOATING, // "Turn 3" OPTIONAL (currently in CombatHUd outside of messagesystem)
	MD_TOP_NOTE, // "AI is playing" OPTIONAL (currently in Resourcebar outside of messagesystem)
	MD_NOTE_BAR, // new civ style lines
	MD_CHAT
};

var int mMessageCounter;
var array<H7Message> mMessages;     // all messages ever
var array<H7Message> mMessageQueue; // all still unassigned messages

var H7Log mLog;
var H7Log mQALog;
var H7Log mChat;
var H7SideBar mSideBar;
var H7SideBar mNoteBar;

var array<H7TooltipReplacementEntry> mReplBuffer; // replacements for next messages

function H7Log GetLog()         {	return mLog;}
function H7Log GetChat()        {   return mChat;}
function H7Log GetQALog()       {	return mQALog;}
function H7SideBar GetSideBar() {	return mSideBar;}
function H7SideBar GetNoteBar() {	return mNoteBar;}

static function H7MessageSystem GetInstance()
{
	local H7MessageSystem system;

	if(class'H7PlayerController'.static.GetPlayerController() == none) { ; return system; }

	system = class'H7PlayerController'.static.GetPlayerController().GetMessageSystem();

	return system;
}

function Init()
{
	mLog = new class'H7Log';
	mQALog = new class'H7Log';
	mChat = new class'H7Log';
	mSideBar = new class'H7SideBar';
	mNoteBar = new class'H7SideBar';
}

function AddReplForNextMessage(String placeholder,String value)
{
	local H7TooltipReplacementEntry entry;
	entry.placeholder = placeholder;
	entry.value = value;
	mReplBuffer.AddItem(entry);
}

function CreateAndSendMessage(String messageTextorLocaKey,optional H7MessageDestination destination=MD_LOG,optional H7MessageSettings advancedSettings, optional EPlayerNumber recipient)
{
	local H7Message message;

	message = new class'H7Message';
	message.text = messageTextorLocaKey;
	message.settings = advancedSettings;
	message.destination = destination;
	if(recipient != PN_NEUTRAL_PLAYER && recipient != PN_PLAYER_NONE)
	{
		if(message.mPlayerNumber == PN_NEUTRAL_PLAYER || message.mPlayerNumber == PN_PLAYER_NONE)
		{
			message.mPlayerNumber = recipient;
		}
		else if(message.mPlayerNumber != recipient)
		{
			;
		}
	}
	SendMessage(message);
}

function SendMessage(H7Message message)
{
	local H7TooltipReplacementEntry entry;
	
	if(MessageWasRejected(message)) return;

	foreach mReplBuffer(entry)
	{
		message.AddRepl(entry.placeholder,entry.value);
	}
	mReplBuffer.Remove(0,mReplBuffer.Length);

	if(message.creationContext == MCC_UNKNOWN)
	{
		message.creationContext = GetCurrentContext();
	}
	message.CreationTime = class'H7PlayerController'.static.GetPlayerController().GetHud().GetPlayTime();

	//message.textTemplate = message.text;
	message.text = message.GetFormatedText();

	;

	if(MessageWasAddedByMerging(message,mMessageQueue.Length))
	{
		;
		;
		return;
	}

	mMessageCounter++;
	message.ID = mMessageCounter;

	mMessageQueue.AddItem(message);
	mMessages.AddItem(message);

	//TryToAssignMessages() called only in PostRender (tick) of hud
}

function H7Message GetMessage(int id)
{
	local H7Message message;
	foreach mMessages(message)
	{
		if(message.ID == id)
		{
			return message;
		}
	}
	;
	return none;
}

function H7Message GetMessageByReference(Object ob,optional Object template)
{
	local H7Message message;
	foreach mMessages(message)
	{
		if(message.settings.referenceObject == ob 
			&& (template == none || message.ObjectArchetype == template))
		{
			return message;
		}
	}
	;
	return none;
}

function array<H7Message> GetMessagesWithActiveAction(EMessageAction action,optional Object requiredOb)
{
	local H7Message message;
	local int currentTime;
	local array<H7Message> searchMessages,returnMessages;

	currentTime = class'H7PlayerController'.static.GetPlayerController().GetHud().GetPlayTime();

	searchMessages = mMessages;
	foreach mMessageQueue(message)
	{
		searchMessages.AddItem(message);
	}
	foreach searchMessages(message)
	{
		if(message.destination != MD_SIDE_BAR) continue; // OPTIONAL for now only side messages are allowed to block things / have actions

		if(message.settings.action == action)
		{
			if(message.creationTime+message.settings.actionDuration >= currentTime || message.settings.actionDuration == 0)
			{
				if(requiredOb == none || requiredOb == message.settings.referenceObject)
				{
					returnMessages.AddItem(message);
				}
			}
		}
	}
	
	return returnMessages;
}

// to save performance, could also be used to block AI messages, other player messages for myself
function bool MessageWasRejected(H7Message message)
{
	local H7Player humanlocalPlayer;
	//message is none ffs don't even try to check that
	if( message == none )
	{
		return true;
	}
	if(message.destination == MD_QA_LOG && !class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().GetQALogStatus())
	{
		;
		return true;
	}
	
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()) 
	{
		// on the combat map everybody sees everything, no player checks:
		return false;
	}
	
	if( class'H7AdventureController'.static.GetInstance() == none )
	{
		if(message.mPlayerNumber == H7PlayerReplicationInfo( class'H7ReplicationInfo'.static.GetInstance().GetALocalPlayerController().PlayerReplicationInfo ).GetPlayerNumber())
		{
			return false;
		}
		else
		{
			;
			return true;
		}
	}
	else
	{
		humanlocalPlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
	}

	if(message.mPlayerNumber == PN_PLAYER_NONE)
	{
		// auto assign all undefined messages to localplayer
		if(humanlocalPlayer != none)
		{
			message.mPlayerNumber = humanlocalPlayer.GetPlayerNumber();
		}
		else
		{
			// message was fired during hotseat AI turn
			;
			return true;
		}
	}

	if(humanlocalPlayer != none && message.mPlayerNumber != humanlocalPlayer.GetPlayerNumber() && message.destination == MD_QA_LOG)
	{
		return true;
	}

	if(message.mPlayerNumber == PN_NEUTRAL_PLAYER) 
	{
		;
		return true;
	}

	if(humanlocalPlayer != none && message.mPlayerNumber == humanlocalPlayer.GetPlayerNumber())
	{
		return false; // message is ok, belongs to human currently sitting in front of pc
	}
	else if(IsNotYetLocalPlayer(message.mPlayerNumber))
	{
		return false; // message is ok, will be queued until player is local player
	}
	else
	{
		;
		return true; // message is rejected
	}

	return false;
}

function bool CanBecomeLocalPlayer(EPlayerNumber player)
{
	if(class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		if(!class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(player).IsControlledByAI())
		{
			return true;
		}
	}
	else
	{
		if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() == player)
			return true;
	}
	return false;
}

function bool IsNotYetLocalPlayer(EPlayerNumber player)
{
	if(class'H7AdventureController'.static.GetInstance().IsHotSeat())
	{
		if(!class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(player).IsControlledByAI())
		{
			return true;
		}
	}
	return false;
}

// checks if there are duplicate messages in the buffer and combines them to 1, to prevent spamming
// OPTIONAL is this even nedded if the check is done already when a message is sent?
function CheckForDublicateMessages()
{
	local H7Message message;
	local int i;
	
	for(i=mMessageQueue.Length-1;i>=0;i--)
	{
		message = mMessageQueue[i];
		if(!message.mWasAssigned) // aren't all in the queue !assigned?
		{
			if(MessageWasAddedByMerging(message,i))
			{
				mMessageQueue.Remove(i,1);
			}
		}
	}
}

function bool MessageWasAddedByMerging(H7Message message, int endIndex)
{
	local int i;

	for(i=endIndex-1;i>=0;i--)
	{
		if(IsEqual(mMessageQueue[i],message))
		{
			mMessageQueue[i] = GetMergedMessage(mMessageQueue[i],message);
			return true;
		}
	}
	return false;
}

function bool IsEqual(H7Message message1,H7Message message2)
{
	if(message1.destination != message2.destination) return false;
	if(message1.mPlayerNumber != message2.mPlayerNumber) return false;
	if(message1.settings.referenceObject != message2.settings.referenceObject) return false;
	if(message1.textTemplate == "" || message2.textTemplate == "" || message1.textTemplate != message2.textTemplate) return false;
	if(message1.settings.icon != message2.settings.icon) return false;
	if(!message1.CanMergeMapping(message2.GetMapping())) return false;

	return true;
}

function H7Message GetMergedMessage(H7Message message1,H7Message message2)
{
	message1.MergeMapping(message2.GetMapping());
	return message1;
}

// called every frame
function TryToAssignMessages()
{
	local H7Message message;
	local array<H7Message> newQueue;

	//CheckForDublicateMessages();

	if(class'H7PlayerController'.static.GetPlayerController().GetHud() != none 
		&& class'H7PlayerController'.static.GetPlayerController().GetHud().GetTickEnabled())
	{
		// check if unassigned messages can go to their respective systems
		foreach mMessageQueue(message)
		{
			if(!message.mWasAssigned && !IsMessageObsolete(message))
			{
				if(CanBeAssigned(message))
				{
					AssignMessage(message);
				}
				else
				{
					newQueue.AddItem(message);
				}
			}
		}

		mMessageQueue = newQueue;
	}
}

function bool CanBeAssigned(H7Message message)
{
	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
	{
		if(class'H7PlayerController'.static.GetPlayerController().GetHud().GetHUDMode() == HM_IN_BETWEEN_TURNS_FOR_HOTSEAT)
		{
			return false;
		}
		if(class'H7AdventureController'.static.GetInstance() == none) // no AdventureController, emergency mode
		{
			if(message.mPlayerNumber == H7PlayerReplicationInfo( class'H7ReplicationInfo'.static.GetInstance().GetALocalPlayerController().PlayerReplicationInfo ).GetPlayerNumber())
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer()==None)
			{
				return false;
			}

			if(class'H7PlayerController'.static.GetPlayerController().IsCaravanTurn() 
				|| message.mPlayerNumber != class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
			{
				if(!message.mWaitingForOtherLocalPlayer)
				{
					;
					message.mWaitingForOtherLocalPlayer = true;
				}
				return false;
			}
		}
	}
	
	if(message.creationContext != GetCurrentContext())
	{
		return false;
	}
	
	switch(message.destination)
	{
		case MD_POPUP:
			if(!H7FlashMoviePopupCntl(message.settings.referenceWindowCntl).CanOpenPopup())
			{
				return false;
			}
			else
			{
				return true;
			}
			break;
		case MD_FLOATING:
			return true;
			break;
		case MD_SIDE_BAR:
			// only 1 buffer entry at once, so it can propagate to flash and checked there
			if(mSideBar.GetBufferCount() < 1 && class'H7GUIOverlaySystemCntl'.static.GetInstance().GetSideBar().CanAddMessage() == 1)
			{
				return true;
			}
			else if(message.settings.action != MA_NONE) // even though there is no room, we have to display important messages
			{
				return true;
			}
			else
			{
				// everytime a message fails to go to the side bar, we need to mark it as changed, so that listener processes messages until we can assign it
				mSideBar.DataChanged();
				return false;
			}
			break;
		case MD_NOTE_BAR: // only allowed on adventuremap (some code triggers adventure-node-bar messages while on combatmap, those have to wait until we are back)
			if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap()
				&& !class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().IsVisible()) // also no notification while requestpopups are open (would break chinese font rendering but makes sense any way)
			{
				return true;
			}
			else
			{
				return false;
			}
			break;
		default:
			return true;
	}
}

function bool IsMessageObsolete(H7Message message)
{
	local H7CreatureStack refStack;

	// no buff messages for dead creature stacks!
	if(message.settings.floatingType == FCT_BUFF && message.settings.referenceObject != none && message.settings.referenceObject.IsA('H7CreatureStack'))
	{
		refStack = H7CreatureStack(message.settings.referenceObject);
		if(refStack.IsDead()) return true;
	}

	return false;
}

// redirects messages to their destination (to the systems that handle them)
function AssignMessage(H7Message message)
{
	;

	message.mWasAssigned = true;

	switch(message.destination)
	{
		case MD_POPUP:
			if(message.settings.referenceWindowCntl.IsA('H7FlashMoviePopupCntl'))
			{
				H7FlashMoviePopupCntl(message.settings.referenceWindowCntl).QueueFinished(message);
			}
			else
			{
				;
			}
			break;
		case MD_FLOATING:
			class'H7FCTController'.static.GetInstance().StartFCT(
				message.settings.floatingType,
				message.settings.floatingLocation,
				class'H7ReplicationInfo'.static.GetInstance().GetPlayerByNumber(message.mPlayerNumber),
				message.text,
				message.settings.color,
				message.settings.icon
			);
			break;
		case MD_LOG:
			mLog.AddMessage(message);
			break;
		case MD_QA_LOG:
			mQALog.AddMessage(message);
			break;
		case MD_SIDE_BAR:
			mSideBar.AddMessage(message);
			break;
		case MD_NOTE_BAR:
			mNoteBar.AddMessage(message);
			break;
		default:
			;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// ACTIONS ON SPECIFIC MESSAGES (blink,delete)
///////////////////////////////////////////////////////////////////////////////////////////////////

function BlinkMessages(array<H7Message> messages)
{
	local H7Message mes;
	foreach messages(mes)
	{
		switch(mes.destination)
		{
			case MD_SIDE_BAR:
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl().GetSideBar().BlinkMessage(mes.ID);
				break;
			default:
				;
		}
	}
}

// master delete function, always use this
function DeleteMessage(H7Message message)
{
	;
	switch(message.destination)
	{
		case MD_SIDE_BAR:
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl().GetSideBar().DeleteMessage(message.ID);
			// OPTIONAL delete message in mSideBar.mList?
			mSideBar.DeleteMessage(message);
			break;
		case MD_NOTE_BAR:
			class'H7AdventureHudCntl'.static.GetInstance().GetNoteBar().DeleteMessage(message.ID);
			mNoteBar.DeleteMessage(message);
			break;
		default:
			;
	}
	mMessageQueue.RemoveItem(message);
	mMessages.RemoveItem(message);
}

function DeleteMessagesByAction(EMessageAction action)
{
	local H7Message mes;
	local int i;

	;

	for(i=mMessages.Length-1;i>=0;i--)
	{
		mes = mMessages[i];
		if(mes.settings.action == action)
		{
			DeleteMessage(mes);
		}
	}
}

function DeleteMessagesFrom(Object initiator,H7MessageDestination destination)
{
	local H7Message mes;
	local int i;

	//`log_dui("DeleteMessagesFrom" @ initiator @ destination);

	for(i=mMessages.Length-1;i>=0;i--)
	{
		mes = mMessages[i];
		if(mes.settings.referenceObject == initiator && mes.destination == destination )
		{
			DeleteMessage(mes);
		}
	}
}

function DeleteAllMessagesFromSideBar()
{
	local H7Message mes;
	local int i;

	;

	for(i=mMessages.Length-1;i>=0;i--)
	{
		mes = mMessages[i];
		if(mes.destination == MD_SIDE_BAR)
		{
			DeleteMessage(mes);
		}
	}
}

function DeleteAllMessagesFromNoteBar() // because he ended his turn
{
	local H7Message mes;
	local int i;
	
	;

	for(i=mMessages.Length-1;i>=0;i--)
	{
		mes = mMessages[i];
		if(mes.mWasAssigned && mes.destination == MD_NOTE_BAR) // not yet assigned messages are kept, they might appear for the next player (hotseat)
		{
			DeleteMessage(mes);
		}
	}
}

// shortcuts/helper/wrapper/redirecter:
///////////////////////////////////////////////////////////////////////////////////////

function CreatePopup(String messageText,optional String yesCaption="OK",optional delegate<H7MessageCallbacks.OnYes> yesDelegate,optional String noCaption,optional delegate<H7MessageCallbacks.OnNo> noDelegate)
{
	local H7MessageSettings msettings;
	local H7MessageCallbacks callbacks;

	callbacks = new class'H7MessageCallbacks';
	callbacks.OnYes = yesDelegate;
	callbacks.OnNo = noDelegate;
	callbacks.YesCaption = yesCaption;
	callbacks.NoCaption = noCaption;

	msettings.callbacks = callbacks;

	CreateAndSendMessage(messageText,MD_POPUP,msettings);
}

function CreateFloat(EFCTType type, Vector startPosition, H7Player initiator, optional String text = "", optional Color textColor = MakeColor(255,255,255,255) , optional Texture2d icon)
{
	local H7MessageSettings msettings;
	msettings.floatingLocation = startPosition;
	msettings.color = textColor;
	msettings.icon = icon;
	msettings.floatingType = type;
	CreateAndSendMessage(text,MD_FLOATING,msettings, initiator.GetPlayerNumber());
}

function H7MessageMapping GetMessageTemplates()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mMessageMapping;
}

function EMessageCreationContext GetCurrentContext()
{
	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
	{
		return MCC_ADV_MAP;
	}
	else if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		return MCC_CBT_MAP;
	}
	else if(class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud() != none)
	{
		return MCC_MAIN_MENU;
	}
	else
	{
		return MCC_UNKNOWN;
	}
}
