class H7TownRecruitmentPopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GFxTownRecruitmentPopup mRecruitmentPopup;
var protected H7AreaOfControlSite mCurrentLocation, mInitialLocation; // town, fort or dwelling
var protected H7Dwelling mNeutralDwelling;
var protected array<H7Dwelling> mOutsideDwellings;
var protected array<H7Town> towns;
var protected array<H7AreaOfControlSiteLord> lords;
var protected int lordID;
var protected bool mCaravanRecruitment;


function H7GFxTownRecruitmentPopup GetRecruitmentPopup() { return mRecruitmentPopup; }
function bool GetIsCaravanRecruitment(){return mCaravanRecruitment;}

function SetIsCaravanRecruitment(bool val)
{
	mCaravanRecruitment = val;
	UpdateMiddleHudTargetBarHighlight();
}

function bool Initialize()
{
	;
	
	//Super.Start();

	//AdvanceDebug(0);
	
	LinkToTownPopupContainer();
	//LoadComplete();
	
	//Super.Initialize();

	return true;
}

function LoadComplete()
{
	mRecruitmentPopup = H7GFxTownRecruitmentPopup(mRootMC.GetObject("aTownRecruitmentPopup", class'H7GFxTownRecruitmentPopup'));

	mRecruitmentPopup.SetVisibleSave(false);

	lordID = -1;
}

function Update(H7Town town)
{ 
	UpdateFromLord(town);
}

/**
 * the location determines in which lord the player is currently at, NOT from which lord he wants to see the 
 * recruitment data, so only set locationID when you know that the play IS IN that lord
 * @param (H7AreaOfControlSiteLord) lord the lord from which to display the recruitment data
 * @param (H7AreaOfControlSiteLord) location the location where the player currently is at
 */

function UpdateFromLord(H7AreaOfControlSiteLord lord)
{
	if( mInitialLocation == none )
	{
		mInitialLocation = lord;
	}
	mCurrentLocation = lord;

	mRecruitmentPopup.Update(mCurrentLocation, mInitialLocation);
	
	SetTownsAndDwellings();

	OpenPopup();
}

function UpdateFromDwelling(H7Dwelling currentDwelling)
{
	if( mInitialLocation == none )
	{
		mInitialLocation = currentDwelling;
	}
	mCurrentLocation = currentDwelling;

	mRecruitmentPopup.Update(currentDwelling, mInitialLocation);
	mRecruitmentPopup.SetVisibleSave(true);
	SetTownsAndDwellings();

	OpenPopup();

	GetHUD().TriggerKismetNodeOpenPopup(mRecruitmentPopup.GetFlashName());
}

function UpdateFromNeutralDwelling(H7Dwelling dwelling)
{
	mNeutralDwelling = dwelling;
	mCurrentLocation = dwelling;

	mRecruitmentPopup.UpdateFromNeutralDwelling(dwelling);
	mRecruitmentPopup.SetVisibleSave(true);

	OpenPopUp();
}

function bool OpenPopup()
{
	local bool val;

	val = super.OpenPopup();

	UpdateMiddleHudTargetBarHighlight();

	return val;
}

function UpdateAfterModifyingArmy()
{
	;
	if(mNeutralDwelling != none)
	{
		UpdateFromNeutralDwelling(mNeutralDwelling);
	}
    else if(mCurrentLocation.IsA('H7Dwelling'))
	{
		UpdateFromDwelling(H7Dwelling(mCurrentLocation));
	}
	else
	{
		UpdateFromLord(H7AreaOfControlSiteLord( mCurrentLocation ));
	}
}

function GetCaravanDataFromLord(int AocLordID)
{
	local H7Town iteratorTown;
	
	foreach towns(iteratorTown)
	{
		// recruiting from Town
		if(iteratorTown.GetID() == AocLordID)
		{
 			mRecruitmentPopup.UpdateCaravanArmy(iteratorTown.GetCaravanArmy());
			return;
		}
	}
}

function UpdateMiddleHudTargetBarHighlight()
{
	if(mCaravanRecruitment) // caravan order
	{
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().HighlightTargetBar(false);
	}
	else // direct local recruit
	{
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().HighlightTargetBar(true);
	}
}

function bool CheckFreeSlotOnUnitSlotClick(String unitName)
{	
	//unitName, name of the unit that just has been clicked
	//first check the garrisson
	if( H7IDefendable(mCurrentLocation).GetGarrisonArmy() != none &&( H7IDefendable(mCurrentLocation).GetGarrisonArmy().CheckFreeArmySlot() || H7IDefendable(mCurrentLocation).GetGarrisonArmy().GetStackByName(unitName) != none))
	return true;
	
	// if we would not be able to recruit the unit to the garrisson check the visiting army
	if(mCurrentLocation.GetVisitingArmy()!=none && 
	   ( mCurrentLocation.GetVisitingArmy().GetStackByName(unitName)!=none || mCurrentLocation.GetVisitingArmy().CheckFreeArmySlot() ) 
	  )
		return true;
	else return false;
}

function SetTownsAndDwellings()
{
	local H7Town town;
	local H7Fort fort;
	local H7Dwelling dwelling;
	local array<H7Dwelling> tempDwellings;
	local array<H7Fort> forts; 

	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
	forts = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetForts();
	mOutsideDwellings.Remove(0, mOutsideDwellings.Length);

	foreach towns(town)
	{
		lords.AddItem(town);
		tempDwellings = town.GetOutsideDwellings();
		foreach tempDwellings(dwelling)
		{
			mOutsideDwellings.AddItem(dwelling);
		}
	}

	foreach forts(fort)
	{
		lords.AddItem(fort);
		tempDwellings = fort.GetOutsideDwellings();
		foreach tempDwellings(dwelling)
		{
			mOutsideDwellings.AddItem(dwelling);
		}
	}
}

function UpgradeDwelling(int dwellingToUpgradeID)
{
	local H7Dwelling dwelling;
	foreach mOutsideDwellings(dwelling)
	{
		if(dwelling.GetID() == dwellingToUpgradeID)
		{
			dwelling.Upgrade();
			return;
		}
	}

	if(mInitialLocation != none && mInitialLocation.IsA('H7Dwelling'))
	{
		H7Dwelling(mInitialLocation).Upgrade();
	}
}

function UpgradeDwellingComplete()
{
	if(mCurrentLocation.IsA('H7Dwelling')) 
	{
		UpdateFromDwelling(H7Dwelling(mCurrentLocation));
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromDwelling(H7Dwelling(mCurrentLocation));
	}
	else 
	{
		UpdateFromLord(H7AreaOfControlSiteLord(mCurrentLocation));
	}
}

function int UseFertility(string creatureName, int townID)
{
	local H7Town iteratorTown; 
	local array<H7TownBuildingData> dwellings;	
	local bool isMatch, hasUpgrade;
	local int indexSource, i;
	local array<H7DwellingCreatureData> creaturePool;
	local H7Creature creature;
	local H7InstantCommandUseFertilityIdol command;

	foreach towns(iteratorTown)
	{
		if(iteratorTown.GetID() == townID)
		{
			iteratorTown.GetDwellings( dwellings );
			creaturePool = iteratorTown.GetCreaturePool();
			break;
		}
	}
	
	for( i = 0; i < creaturePool.Length; i++ )
	{
		if( creaturePool[ i ].Creature.GetBaseCreature() != none )  { creature = creaturePool[ i ].Creature.GetBaseCreature(); }
		else                                                        { creature = creaturePool[ i ].Creature; }

		// check if the creature name sent is the base creature itself or any of its upgrades
		do 
		{
			if( creature.GetName() == creatureName )
			{
				isMatch = true;
				indexSource = i;
				break;
			}
			if( creature.GetUpgradedCreature() != none )
			{
				hasUpgrade = true;
				creature = creature.GetUpgradedCreature();
			}
			else
			{
				hasUpgrade = false;
			}
		} 
		until( !hasUpgrade );
		// break the search if we have a match. This means if we have 2 separate entries for the same creature, only the first one will ever be detected.
		if( isMatch ) break;
	}

	if( !isMatch ) { ; return -1; }


	if(H7TownIdolOfFertility( iteratorTown.GetBuildingByType( class'H7TownIdolOfFertility') ).CanBeActivated())
	{
		command = new class'H7InstantCommandUseFertilityIdol';
		command.Init( iteratorTown, indexSource );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	}

	return H7TownDwelling(dwellings[ indexSource ].Building).GetCreaturePool().Reserve;
}

// TODO: add a seperate Recuit all command
function RecruitUnits(string unitName, int amount, int townOrDwellingID, bool recruitToCaravan, bool doUpdate = true)
{
	local H7Dwelling iteratorDwelling;
	local H7Town iteratorTown;

	;

	if(mNeutralDwelling != none)
	{
		;
		mNeutralDwelling.RecruitDirect(unitName, amount);
		return;
	}
	
	foreach towns(iteratorTown)
	{
		// recruiting from Town
		if(iteratorTown.GetID() == townOrDwellingID)
		{
			;
 			iteratorTown.Recruit(unitName, amount, false, , recruitToCaravan, , mInitialLocation, doUpdate);
			return;
		}
	}
	
	// dwellings from lord, or dwelling on it's own is in here:
	foreach mOutsideDwellings(iteratorDwelling)
	{
		//`log_gui("checking dwelling id"@iteratorDwelling.GetID());
		if(iteratorDwelling.GetID() == townOrDwellingID)
		{
			iteratorDwelling.GetLord().Recruit(unitName, amount, true, iteratorDwelling, recruitToCaravan, mCurrentLocation.IsA('H7Dwelling'), mInitialLocation);
			return;
		}
	}

	;
	H7Dwelling(class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetVisitableSite()).RecruitDirect(unitName, amount);
}

function RecruitUnitsComplete(H7AreaOfControlSiteLord lord, int slotIndex, EArmyNumber enforcedArmy, bool recruitToCaravan)
{
	// Ok Bob, you can go.
	if(recruitToCaravan && lord.GetCaravanArmy().GetFreeSlotCount() == 0)
	{
		;

		startCaravan(lord);
	}

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("RECRUIT_ARMY");
	
	if(mNeutralDwelling != none)
	{
		UpdateFromNeutralDwelling(mNeutralDwelling);
	}
    else if(mCurrentLocation.IsA('H7Dwelling'))
	{
		UpdateFromDwelling(H7Dwelling(mCurrentLocation));
	}
	else
	{
		;
		UpdateFromLord(lord);
		mRecruitmentPopup.UpdateCaravanArmy(lord.GetCaravanArmy());
	}
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().UpdateResourceAmounts();
				
	if(mCurrentLocation.IsA('H7Town') && !recruitToCaravan) 
	{
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromTown(H7Town(mCurrentLocation));
	}
	if(mCurrentLocation.IsA('H7Fort') && !recruitToCaravan) 
	{
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromFort(H7Fort(mCurrentLocation));
	}
	if(mCurrentLocation.IsA('H7Dwelling') && !recruitToCaravan) 
	{
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromDwelling(H7Dwelling(mCurrentLocation));
	}
				
	if(lord == mCurrentLocation || enforcedArmy == ARMY_NUMBER_VISIT) 
	{
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().RecruitSlotGlow(slotIndex, enforcedArmy);
	}
}

function startCaravan(H7AreaOfControlSiteLord lord)
{
	local H7CaravanArmy caravan;
	
	caravan = lord.GetCaravanArmy();
	caravan.StartCaravan( lord );
	;
}


function RecruitAll()
{
	;
	mRecruitmentPopup.RecruitAll();
	
	/*local H7Dwelling iteratorDwelling;
	local H7AreaOfControlSiteLord lord;
	local array<int> recruitmentSlotIndixes; 
	local array<EArmyNumber> reenforcedArmies;
	local int i;
	

	if(town!=none) lord = town;
	if(fort!=none) lord = fort;

	if(dwelling != none)
	{
		dwelling.RecruitAll(recruitmentSlotIndixes);
		UpdateFromDwelling(dwelling);
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromDwelling(dwelling);
		
		for(i=0; i<recruitmentSlotIndixes.Length; i++)
		{ reenforcedArmies[i] = ARMY_NUMBER_VISIT; }

		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().RecruitAllSlotGlow(recruitmentSlotIndixes, reenforcedArmies);
		return;
	}
	
	if(town!=none && currentDwellingID == town.GetID())
	{
		town.RecruitAll(false, recruitmentSlotIndixes, reenforcedArmies);
		H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().UpdateResourceAmounts();
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetData(town);
		H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().RecruitAllSlotGlow(recruitmentSlotIndixes, reenforcedArmies);
		Update(town);
	}
	else
	{
		foreach mOutsideDwellings(iteratorDwelling)
		{
			if(iteratorDwelling.GetID() == currentDwellingID)
			{
				iteratorDwelling.SetVisitingArmy(lord.GetGarrisonArmy());
				iteratorDwelling.RecruitAll(recruitmentSlotIndixes);
				iteratorDwelling.SetVisitingArmy(none);
	
				for(i=0; i<recruitmentSlotIndixes.Length; i++)
				{ reenforcedArmies[i] = ARMY_NUMBER_GARRISON; }

				if(lord.isA('H7Town'))
				{ 
					UpdateFromLord(town);
					H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetData(town);
				}
				else
				{
					UpdateFromFort(fort);
					H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().SetDataFromFort(fort);
				}

				H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().UpdateResourceAmounts();
				H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().RecruitAllSlotGlow(recruitmentSlotIndixes, reenforcedArmies);	

				return;
			}
		}
		`warn("ERROR: didnt find dwelling with ID " $ currentDwellingID);
	}*/
}

function SetLordID(int id)
{
	local H7Dwelling tempDwell;
	local H7Town     tempTown;
	local bool       foundIt;
	local H7GFxMinimap minimap;

	if( H7Dwelling( mCurrentLocation ) != none )
	{
		// prevent change of lord by flash
		return;
	}

	minimap = class'H7AdventureHudCntl'.static.GetInstance().GetMinimap();

	minimap.DeletePath();
	minimap.UnHighlightAoC();
	if(id != -1)
	{
		foreach mOutsideDwellings(tempDwell)
		{
			if(tempDwell.GetID() == id) 
			{
				minimap.HighlightAoC(tempDwell.GetLord().GetAreaOfControlID() );
				minimap.ShowPathAoC2AoC(mCurrentLocation, tempDwell);
				
				mCurrentLocation = tempDwell.GetLord();
				foundIt = true;
				break;
			}
		}

		if(!foundIt)
		{
			foreach towns(tempTown)
			{
				if(tempTown.GetID() == id) 
				{
					minimap.HighlightAoC(tempTown.GetAreaOfControlID() );
					minimap.ShowPathAoC2AoC(mCurrentLocation, tempTown);
					
					mCurrentLocation = tempTown;
					break;
				}
			}

		}
	}

	lordID = id;
}

// by flash or by unreal
function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	local H7AreaOfControlSiteLord lord;

	super.ClosePopup();

	//start all caravans
	foreach lords(lord)
	{
		// Start only full caravans
		if(lord.GetCaravanArmy() != none && lord.GetCaravanArmy().GetFreeSlotCount() == 0) 
		{
			startCaravan(lord);
		}
	}

	lords.Remove(0, lords.Length);
	
	if(H7AreaOfControlSiteLord(mCurrentLocation) == none)
	{
		//multiplayer gui
		if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || class'H7AdventureController'.static.GetInstance().IsHotSeat())
		{
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SwitchToHUD();
		}
	}

	mCurrentLocation = none;
	mInitialLocation = none;
	mNeutralDwelling = none;
	SetLordID(-1);
	mOutsideDwellings.Remove(0, mOutsideDwellings.Length);
	mRecruitmentPopup.SetVisibleSave(false);
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetMiddleHUD().HighlightTargetBar(false);
	mRecruitmentPopup.Reset();

	if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInDwellingScreen() /*|| 
	   class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInCaravanOutpost()*/ )
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().Leave();
	}

	if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInFortScreen())
	{
		GetHUD().BlockUnreal();
	}
}

function H7GFxUIContainer GetPopup()
{
	return mRecruitmentPopup;
}

