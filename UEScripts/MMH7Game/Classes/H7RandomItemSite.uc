/*=============================================================================
* H7RandomItemSite
* =============================================================================
* Provides the Hero with a item and a buff if accepted. 
* =============================================================================
*  Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7RandomItemSite extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

// Specific item to use. Random if set to none.
var(Properties) protected archetype H7HeroItem	    mSpecificReward<DisplayName="Specific Artifact Reward">;
var(Buff) protected H7BaseBuff						mBuff<DisplayName="Buff/Debuff">;
var(Buff) protected int	                            mBuffDuration<DisplayName="Buff duration in battles"|ClampMin=1>;

var protected savegame bool							mIsHidden;
var protected H7HeroItem					        mItemReward;
var protected savegame string                       mItemRewardRef;
var protected savegame bool							mIsChoosen;
var protected savegame array<H7AdventureArmy>		mVisitedHeroes;
var protected savegame bool							mIsVisited;

native function bool IsHiddenX();

event InitAdventureObject()
{
	super.InitAdventureObject();

	DefineItemReward();
}

protected function DefineItemReward()
{
	local H7GameData gameData;
	local int rnd;
	local array<H7HeroItem> localItemList;

	if(!mIsChoosen)
	{
		if(mSpecificReward == none)
		{
			gameData = class'H7GameData'.static.GetInstance();
			rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(3);
		
			localItemList = gameData.GetItemList(ETier(rnd), false);

			rnd = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(localItemList.Length);
			mItemReward = localItemList[rnd];
		}
		else
		{
			mItemReward = mSpecificReward;
		}
		mIsChoosen = true;
	}

}

function OnVisit( out H7AdventureHero hero )
{
	local string popUpMessage;
	local Vector HeroMsgOffset;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	HeroMsgOffset = Vect(0,0,600);

	popUpMessage = "<font size='#TT_TITLE#'>" $ self.GetName() $ "</font>\n";
	popUpMessage = popUpMessage $ "<br></br>";
	popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("PU_RANDOM_ITEM_SITE","H7PopUp") $ "</font>";
	//popUpMessage = Repl(popUpMessage, "%site", self.GetName());
	popUpMessage = Repl(popUpMessage, "%bufftooltip", mBuff.GetTooltip());

	mVisitedHeroes.AddItem(hero.GetAdventureArmy());

	if( hero.GetPlayer().IsControlledByLocalPlayer() )
	{
		if(!mIsVisited)
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ACCEPT","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Accept, Leave );
		}
		else
		{
			if(mVisitingArmy.GetPlayer().IsControlledByLocalPlayer())
			{
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT") , MakeColor(255,255,0,255));
				class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ALREADY_VISITED");
			}
		}
	}

	super.OnVisit(hero);
}

function Accept()
{
	local H7InstantCommandRandomItemSIte command;

	command = new class'H7InstantCommandRandomItemSIte';
	command.Init( self );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function AcceptComplete()
{
	local H7EventContainerStruct eventContainer;
	local H7AdventureHero localHero;
	local H7HeroItem localItem;
	local H7BaseBuff buff;

	localHero = mVisitedHeroes[mVisitedHeroes.Length-1].GetHero();
	localItem = mItemReward;

	localHero.GetInventory().AddItemToInventoryComplete( localItem,, );
	class'H7FCTController'.static.GetInstance().StartFCT(FCT_ITEM_PICKUP, location, localHero.GetPlayer(), "+" $ localItem.GetName(), MakeColor(0,255,0,255) , localItem.GetIcon() );
	eventContainer.EffectContainer = localItem;
	eventContainer.Targetable = localHero;
	localItem.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	localHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );

	mHeroEventParam.mEventHeroTemplate = localHero.GetAdventureArmy().GetHeroTemplateSource();
	mHeroEventParam.mEventPlayerNumber = localHero.GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventSite = self;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_Loot', mHeroEventParam, localHero.GetAdventureArmy());
	
	buff = localHero.GetBuffManager().AddBuff(mBuff, self);

	if(buff != none)
	{
		buff.SetDuration(mBuffDuration);
	}

	mIsVisited = true;
}

function Leave()
{
	mVisitedHeroes.RemoveItem( mVisitedHeroes[mVisitedHeroes.Length-1] );
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
 	local H7TooltipData data;
	local string infoTT;

	data.type = TT_TYPE_STRING;
	data.Title = self.GetName();
	infoTT = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_RANDOM_ITEM_SITE","H7AdvMapObjectToolTip")$"</font>\n";
	infoTT = Repl(infoTT,"%bufftooltip", mBuff.GetTooltip());
	data.Description  = infoTT;
	data.Visited = GetVisitString(mIsVisited);
	
	return data;
}

function Hide()
{
	mIsHidden=true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden=false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	local H7HeroItem itemTemplate;
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}

	itemTemplate = H7HeroItem(DynamicLoadObject(mItemRewardRef, class'H7HeroItem') );
	mItemReward = class'H7HeroItem'.static.CreateItem( itemTemplate );
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

