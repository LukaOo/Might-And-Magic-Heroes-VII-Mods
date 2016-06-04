class H7TownWarfarePopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GFxTownWarfarePopup mWarfarePopup;

var protected bool mPendingBuyAttackHybrid;
var protected bool mPendingBuyVisitingArmy;

static function H7TownWarfarePopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownWarfareCntl(); }
function H7GFxUIContainer GetPopup() { return mWarfarePopup; }
function H7GFxTownWarfarePopup GetCaravanPopup() { return mWarfarePopup; }

function bool Initialize()
{
	LinkToTownPopupContainer();

	//Super.Start();
	//AdvanceDebug(0);
	//LoadComplete();
	//Super.Initialize();

	return true;
}

function LoadComplete()
{
	mWarfarePopup = H7GFxTownWarfarePopup(mRootMC.GetObject("aTownWarfarePopup", class'H7GFxTownWarfarePopup'));
	mWarfarePopup.SetVisibleSave(false);
}

function Update(H7Town town)
{
	super.Update(town);

	mWarfarePopup.Update(town);
	OpenPopup();
}

function BuyPendingWarfare()
{
	BuyWarfare(mPendingBuyAttackHybrid,mPendingBuyVisitingArmy,true);
}

function BuyWarfare(bool attackHybrid,bool visitingArmy,bool confirm = false)
{
	local H7AdventureArmy army;
	local H7InstantCommandRecruitWarfare command;
	local array<H7EditorWarUnit> killList;
	local string question;

	;

	if(visitingArmy) army = mTown.GetVisitingArmy();
	else army = mTown.GetGarrisonArmy();

	killList = army.GetWarUnitKillListWhenBuying(attackHybrid,mTown);
	
	if(killList.Length > 0 && !confirm)
	{
		mPendingBuyAttackHybrid = attackHybrid;
		mPendingBuyVisitingArmy = visitingArmy;
		question = class'H7Loca'.static.LocalizeSave("PU_WARFARE_KILL_" $ killList.Length,"H7PopUp");
		question = Repl(question,"%unit1",killList[0].GetName());
		if(killList.Length == 2)
		{
			question = Repl(question,"%unit2",killList[1].GetName());
		}
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(question,"YES","NO",BuyPendingWarfare,none,true);
		return;
	}
	
	command = new class'H7InstantCommandRecruitWarfare';
	command.Init( mTown, attackHybrid, army );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

