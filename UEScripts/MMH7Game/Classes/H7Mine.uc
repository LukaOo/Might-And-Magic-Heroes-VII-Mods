/*=============================================================================
* H7Mine
* =============================================================================
*  Class for adventure map objects that serve as Mines.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Mine extends H7AreaOfControlSiteVassal
	implements(H7ITooltipable)
	dependson(H7ITooltipable)
	placeable
	native;

/** Type of resource that this mine produces */
var(Resources) protected archetype H7Resource mResource<DisplayName="Resource Type">;
/** Amount of income that this mine provides */
var(Resources) protected int mIncome<DisplayName="Resource Income"|ClampMin=1>;
/** Resource gain when this mine is plundered */
var(Developer) protected int mPlunderGainModifier<DisplayName="Plunder Modifier"|ClampMin=1|ClampMax=50>;
/** Delay after his mine is plundered */
var(Developer) protected int mPlunderingDelay<DisplayName="Delay after plundering"|ClampMin=0|ClampMax=50>;
var protected H7Flag mPlunderFlag;
var protected savegame int mDelay;

var(Audio) protected AkEvent mOnPlunderSound<DisplayName = Plundering sound>;
var(Audio) protected AkEvent mAlreadyVisitedSound<DisplayName = Already visited sound>;

var transient H7AdventureHero mPendingPlunderingHero;
var transient H7Player mPendingPlunderingPlayer;

native function EUnitType GetEntityType();

function bool IsPlundered() { return mDelay > 0; }
function H7Resource GetResource()       { return mResource; }
function SetResource( H7Resource res )  { mResource = res; }
function SetIncome( int income )        { mIncome = income; }

native function bool ProducesResource( H7Resource resource );

function OnVisit(out H7AdventureHero hero)
{
	local Vector HeroMsgOffset;

	HeroMsgOffset = Vect(0,0,600);

	// been there, done that
	if( GetPlayer() == hero.GetPlayer() )
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FTC_ALREADY_CAPTURED","H7FCT") , MakeColor(255,255,0,255));
	}

	super.OnVisit(hero);
}

function AddPlunderFlag()
{
	mFlag.SetSymbol( class'H7AdventureController'.static.GetInstance().GetConfig().mPlunderFlagIconTexture );
}

function RemovePlunderFlag()
{
	mFlag.SetSymbol( class'H7AdventureController'.static.GetInstance().GetConfig().mMineFlagIconTexture );
}

function int GetIncome()
{
	return( GetModifiedStatByID(STAT_PRODUCTION) );
}

function int GetPlunderGainModifier()
{
	return( GetModifiedStatByID(STAT_PLUNDER_GAIN_MOD) );
}

function float GetModifiedStatByID(Estat desiredStat)
{
	local float statBase,statAdd,statMulti;

	statBase = GetBaseStatByID(desiredStat);
	statAdd =  GetAddBoniOnStatByID(desiredStat);
	statMulti = GetMultiBoniOnStatByID(desiredStat);

//	`log_uss(desiredStat @ "(" @ statBase @ "+" @ statAdd @ ") *" @ statMulti);
	return ( statBase + statAdd ) * statMulti;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of additive modifications, coming from abilities, buffs etc.
 */
function float GetAddBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADD);
	foreach applicableMods(currentMod)
	{
		modifierSum += currentMod.mModifierValue;
	}

	return modifierSum;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of percentages in modifications, where 50% extra means 1.5f
 */
function float GetMultiBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;	
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADDPERCENT, OP_TYPE_MULTIPLY);
	modifierSum = 1; 

	foreach applicableMods(currentMod)
	{
		
		if(currentMod.mCombineOperation == OP_TYPE_ADDPERCENT)
		{
			modifierSum += modifierSum * currentMod.mModifierValue * 0.01f;
		} 
		else if(currentMod.mCombineOperation == OP_TYPE_MULTIPLY)
		{
			modifierSum *= currentMod.mModifierValue;
		}
	}
	return modifierSum;
}

//Base Stats
function float GetBaseStatByID(Estat desiredStat)
{
	switch(desiredStat)
	{
		case STAT_PRODUCTION: 
			return mIncome;
		case STAT_PLUNDER_GAIN_MOD:
			return mPlunderGainModifier;
	}
	return 0;
}

native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType checkForOperation1 = -1, optional EOperationType checkForOperation2 = -1, optional bool nextRound);

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local String incomestr;

	data.type = TT_TYPE_BUILDING_BUFFABLE; // displays rightmouseicon if there are buffs, and buffs in extended tooltip // TT_MINE=Provides income of %income %resource per day
	data.Title = "<font size='#TT_TITLE#'>" $ GetName() $ "</font>\n";
	
	incomestr = class'H7Loca'.static.LocalizeSave("TT_INCOME","H7Mine");
	incomestr = Repl(incomestr,"%amount",GetIncome());
	incomestr = Repl(incomestr,"%resource",mResource.GetName());
	incomestr = Repl(incomestr,"%icon","<img width='#TT_BODY#' height='#TT_BODY#' src='" $ mResource.GetIconPath() $ "'>");
	data.Description = "<font size='#TT_BODY#'>" $ incomestr $ "</font>";
	
	if(mDelay > 0)
	{
		data.strData = data.strData $ "<font size='#TT_POINT#'>" $ Repl(class'H7Loca'.static.LocalizeSave("TT_PLUNDERED","H7Mine"),"%i",mDelay) $ "</font>";
	}
	else if(CanBePlunderedByPlayer(class'H7AdventureController'.static.GetInstance().GetLocalPlayer()))
	{
		data.strData = data.strData $ "<font size='#TT_POINT#'>" $ class'H7Loca'.static.LocalizeSave("TT_PLUNDER","H7Mine") $ "</font>";
	}

	return data;
}

function bool CanBePlunderedByPlayer(H7Player player)
{
	if(mDelay > 0) return false;
	if(!GetPlayer().IsPlayerHostile(player)) return false;  // don't plunder allied mines
	if(GetLord() == none)
	{
		return false; // lordless mines can always be taken over, so not plundered
	}
	else
	{
		if(GetLord().GetPlayerNumber() == PN_NEUTRAL_PLAYER) return false;      // don't plunder neutral mine with neutral lord
		else if(!GetLord().GetPlayer().IsPlayerHostile(player)) return false;   // don't plunder neutral mine with allied lord
	}
	// hostile mine/neutral mine with hostile lord -> go get stuff
	return true;
}

event InitAdventureObject()
{
	local H7Player player;
	super.InitAdventureObject();
	class'H7AdventureController'.static.GetInstance().AddMine( self );
	
	player = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner );
	if( player == none || player.GetResourceSet() == none ) return;
	;
	player.GetResourceSet().ModifyIncome( mResource, mIncome );
	;
}

// Update player's resource pool income with current building's production
function ProduceResource()
{
	local H7Player player;
	player = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner );
	if( player == none || player.GetResourceSet() == none ) return;
	player.GetResourceSet().ModifyIncome( mResource, GetIncome() );

	;
}

function Plunder( H7AdventureHero plunderingHero )
{
	if( mDelay > 0 ) 
	{ 
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,Location, plunderingHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_PLUNDERED","H7FCT") );
		;
		if(mAlreadyVisitedSound!=None)
		{
			class'H7SoundManager'.static.PlayAkEventOnActor(self,mAlreadyVisitedSound,true,true,self.Location);
		}
		return; 
	}
	//OnVisit
	mPendingPlunderingHero = plunderingHero;
	mPendingPlunderingPlayer = plunderingHero.GetPlayer();

	if( plunderingHero.GetPlayer().IsControlledByAI() && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled() )
	{
		PlunderConfirm();
	}
	else
	{
		if( plunderingHero.GetPlayer().IsControlledByLocalPlayer() )
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup(
				Localize("H7Mine","PLUNDER_QUESTION","MMH7Game"),
				Localize("H7Mine","PLUNDER_CONFIRM","MMH7Game"),
				Localize("H7Mine","PLUNDER_CANCEL","MMH7Game"),
				PlunderConfirm,
				none,
				true
			);
		}
	}
}

function PlunderFromMission( H7Player plunderingPlayer )
{
	if( mDelay > 0 ) 
	{ 
		;
		return; 
	}
	//OnVisit
	mPendingPlunderingHero = none;
	mPendingPlunderingPlayer = plunderingPlayer;

	PlunderConfirm();
}

function PlunderConfirm()
{
	local H7InstantCommandPlunder command;

	command = new class'H7InstantCommandPlunder';
	command.Init( self, mPendingPlunderingHero, mPendingPlunderingPlayer );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ENGAGE_QUICK_COMBAT");

	// Scripting
	mHeroEventParam.mEventHeroTemplate = mPendingPlunderingHero.GetAdventureArmy().GetHeroTemplateSource();
	mHeroEventParam.mEventPlayerNumber = mPendingPlunderingHero.GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventSite = self;
	class'H7ScriptingController'.static.GetInstance().UpdateMinePlunder(self, mHeroEventParam.mEventPlayerNumber);
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlunderedMine', mHeroEventParam, mPendingPlunderingHero.GetAdventureArmy());
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

function PlunderComplete( H7AdventureHero hero, H7Player plunderingPlayer )
{
	local int income,plundermod;
	local H7AdventureHero plunderHero;
	local H7Message message;
	local H7ResourceSet resourceSet;

	mPendingPlunderingHero = hero;
	plunderHero = mPendingPlunderingHero;
	if( plunderHero != none )
	{
		plunderHero.SetCurrentMovementPoints(0);
	}

	if( hero != none )
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT,Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_PLUNDERING","H7FCT") );
	}

	;

	income = GetIncome();
	plundermod = GetPlunderGainModifier();

	if( mResource == plunderingPlayer.GetResourceSet().GetCurrencyResourceType() )
	{
		;
		plunderingPlayer.GetResourceSet().ModifyCurrency( income * plundermod );
		if(mOnPlunderSound!=None)
		{
			class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnPlunderSound,true,true,self.Location);
		}
	}
	else
	{
		;
		plunderingPlayer.GetResourceSet().ModifyResource( mResource, income * plundermod );
		if(mOnPlunderSound!=None)
		{
			class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnPlunderSound,true,true,self.Location);
		}
	}

	// FCT resources
	if( hero != none )
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_RESOURCE_PICKUP, Location, hero.GetPlayer(), "+" $ (income * plundermod) , MakeColor(0,255,0,255) , mResource.GetIcon() );
	}
	
	if( plunderingPlayer.IsControlledByLocalPlayer() )
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons(plunderingPlayer.GetResourceSet().GetAllResourcesAsArray());
	}

	if( mPlunderingDelay != 0 )
	{
		;
		
		resourceSet = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ).GetResourceSet();
		if( resourceSet != None )
		{
			resourceSet.ModifyIncome( mResource, -income );
		}
		else
		{
			;
		}
	}
	
	mDelay = mPlunderingDelay;
	AddPlunderFlag();
	AddPlunderBuff();

	// send plunder message to site owner
	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mMinePlunder.CreateMessageBasedOnMe();
	message.mPlayerNumber = mSiteOwner;
	message.AddRepl("%mine",GetName());
	message.AddRepl("%player",plunderingPlayer.GetName());
	message.settings.referenceObject = self;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);


	if(!plunderingPlayer.IsControlledByAI())
	{
		message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mMinePlunderPlunderer.CreateMessageBasedOnMe();
		message.mPlayerNumber = plunderingPlayer.GetPlayerNumber();
		message.AddRepl("%mine",GetName());
		message.AddRepl("%player", class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ).GetName());
		message.settings.referenceObject = self;
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}
}

function AddPlunderBuff(optional bool fromSave)
{
	local H7BaseBuff plunderBuff;
	local array<H7StatEffect> mods;
	local H7StatEffect mod;
	local array<H7DurationModifierEffect> durMods;
	local H7DurationModifierEffect durMod;

	// add "plundered" buff so production is 0 for mPlunderingDelay days
	plunderBuff = new class'H7BaseBuff';
	plunderBuff.SetCaster(self);
	plunderBuff.SetOwner(self);
	plunderBuff.SetDisplayed(false);

	// duration
	durMod.mCombineOperation = OP_TYPE_ADD;
	durMod.mModifierValue = -1;
	durMod.mTrigger.mTriggerType = ON_END_OF_DAY;
	durMods.AddItem(durMod);

	if(fromSave)
	{
		plunderBuff.SetDuration(mDelay);
		plunderBuff.SetCurrentDuration(mDelay, false); // don't update GUI if buff is not displayed anyway
	}
	else
	{
		plunderBuff.SetDuration(mPlunderingDelay);
		plunderBuff.SetCurrentDuration(mPlunderingDelay, false); // don't update GUI if buff is not displayed anyway
	}
	
	plunderBuff.SetDurationModifierEffects(durMods);

	// production stat
	mod.mTrigger.mTriggerType = PERSISTENT;
	mod.mStatMod.mCombineOperation = OP_TYPE_MULTIPLY;
	mod.mStatMod.mModifierValue = 0.0f;
	mod.mStatMod.mStat = STAT_PRODUCTION;
	mods.AddItem(mod);

	plunderBuff.SetStatModEffects(mods);

	// initialize everything and apply buff
	plunderBuff.Init(self,self);
	GetBuffManager().AddBuff(plunderBuff,self);
}

function UpdatePlunderDelay()
{
	local int income;

	if( mDelay <= 0 ) { return; }
	
	income = GetIncome();

	mDelay--;
	;
	
	if( mDelay == 0 )
	{
		;
		class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ).GetResourceSet().ModifyIncome( mResource, income );
		RemovePlunderFlag();
	}
}

function protected ChangeFlag()
{
	local H7AdventureController advCon;

	if( !mHiddenBuilding )
	{
		advCon = class'H7AdventureController'.static.GetInstance();

		if( mFlag != none )
		{
			mFlag.ShowAnim();
			mFlag.SetColor( advCon.GetPlayerByNumber( mSiteOwner ).GetColor() );
			mFlag.SetFaction( GetPlayer().GetFaction() );
		}
	}
}

function SetSiteOwner( EPlayerNumber newOwner, optional bool showPopup = true  )   
{
	local H7Player tmpPlayer;

	if(mSiteOwner == newOwner)
	{
		return; // Already owned
	}

	if(mOnTakeOverSound!=None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnTakeOverSound,true,true,self.Location);
	}

	;

	// Decrease income for old 
	if( mSiteOwner != PN_NEUTRAL_PLAYER )
	{
		tmpPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner );
		tmpPlayer.GetResourceSet().ModifyIncome( mResource, -mIncome );
	}
	
	// --------
	super.SetSiteOwner(newOwner,showPopup);
	// --------

	// Increase income for new owner
	tmpPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( newOwner );
	tmpPlayer.GetResourceSet().ModifyIncome( mResource, mIncome );

	if( mPlunderFlag != none )
	{
		mPlunderFlag.SetFaction( GetPlayer().GetFaction() );
		mPlunderFlag.SetColor( GetPlayer().GetColor() );
		mPlunderFlag.SetSymbol( mResource.GetIcon() );
	}
	//mDelay = 0;
}

event PostSerialize()
{
	super.PostSerialize();

	if(mDelay > 0)
	{
		AddPlunderFlag();
		AddPlunderBuff(true);
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

