//=============================================================================
// H7GFxCombatPopUp
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxCombatPopUp extends H7GFxUIContainer;

function Update(H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy, bool activePlayerIsAttacker, optional array<H7BaseCreatureStack> localGuardStacks)
{
	local GFxObject object;
	local bool enableQC, enableMC, enableBtnCancel, enableRetreat;
	local H7AdventureController advController;
	local H7ReplicationInfo h7GRI;

	;

	h7GRI = class'H7ReplicationInfo'.static.GetInstance();

	advController = class'H7AdventureController'.static.GetInstance();
	object = CreateObject("Object");
	
	object.SetObject("LeftArmy", CreateArmyObject(attackingArmy));
	object.SetObject("RightArmy", CreateArmyObject(defendingArmy));
	
	if(defendingArmy.IsACaravan())
		object.GetObject("RightArmy").SetString("HeroNameOverride", defendingArmy.GetPlayer().GetName());
	else if(!defendingArmy.GetHero().IsHero() && defendingArmy.GetPlayerNumber() != PN_NEUTRAL_PLAYER)
		object.GetObject("RightArmy").SetString("HeroNameOverride", defendingArmy.GetName());

	//set these right at the .as class
	SetObject("mWarfareUnitsLeft", CreateWarefareUnitsObject(attackingArmy));
	SetObject("mWarfareUnitsRight", CreateWarefareUnitsObject(defendingArmy));
	
	object.SetInt("LeftXP", attackingArmy.GetHero().GetExperiencePoints());
	object.SetInt("RightXP", defendingArmy.GetHero().GetExperiencePoints());
	
	object.SetBool("ActivePlayerIsLeft", activePlayerIsAttacker);
	object.SetBool("Spectator", advController.GetLocalPlayer() != defendingArmy.GetPlayer() && advController.GetLocalPlayer() != attackingArmy.GetPlayer());

	if((defendingArmy.IsGarrisoned() || defendingArmy.IsGarrisonedButOutside()) && H7BattleSite(defendingArmy.GetGarrisonedSite()) == none )
	{
		;
		object.SetBool("IsTownAttack", true);
		object.SetObject("LocalGuard", CreateLocalGuardObject(localGuardStacks, defendingArmy.GetHero()));
		
		object.SetBool("TownIsHaven", false);
		//if defending army is in a town and the alternate to the moat is exsitant then this is a championTower
		//so we have a haven town
		if( defendingArmy.GetGarrisonedSite().IsA('H7Town') && H7Town( defendingArmy.GetGarrisonedSite() ).IsHavenTown() )
		{
			object.SetBool("TownIsHaven", true);
		}

		if(!defendingArmy.GetHero().IsHero())
		{;
			// if town has no hero display player name instead of heroName
			object.GetObject("RightArmy").SetString("HeroNameOverride", defendingArmy.GetPlayer().GetName());
		}
		
		//Icon
		if(localGuardStacks.Length > 0 && object.GetObject("RightArmy").GetString("FactionIcon") == "")
			object.GetObject("RightArmy").SetString("FactionIcon", defendingArmy.GetPlayer().GetFaction().GetFactionSepiaIconPath());

	}
	else{object.SetBool("IsTownAttack", false);}

	if(defendingArmy.IsGarrisoned() && H7BattleSite(defendingArmy.GetGarrisonedSite()) != none)
	{
		object.SetBool("BattleSite", true);
		SetObject("mRewards", GetBattleSiteRewardsObject(attackingArmy.GetHero(), H7BattleSite(defendingArmy.GetGarrisonedSite()))   );
		object.SetString("BattleSiteName", H7BattleSite(defendingArmy.GetGarrisonedSite()).GetName());
		object.SetString("BattleSiteDesc", H7BattleSite(defendingArmy.GetGarrisonedSite()).GetDescription());
	}
	object.SetBool("ShowTimer", h7GRI.IsSimTurns());
	//object.SetBool("ShowTimer", true);

	
	enableBtnCancel = true;

	// editor preview
	if(!class'H7CombatPopUpCntl'.static.GetInstance().CanClose())
		enableBtnCancel = false;

	//if no simTurns && attacker is human && defender is human && i am defender
	if(!h7GRI.IsSimTurns()
	   && !attackingArmy.GetPlayer().IsControlledByAI() && !defendingArmy.GetPlayer().IsControlledByAI()
	   && !activePlayerIsAttacker)
	   enableBtnCancel = false;

	//if simTurns && attacker is humane && defender is human && i am defender && townAttack
	if(h7GRI.IsSimTurns()
	   && !attackingArmy.GetPlayer().IsControlledByAI() && !defendingArmy.GetPlayer().IsControlledByAI()
	   && !activePlayerIsAttacker && object.GetBool("IsTownAttack"))
	   enableBtnCancel = false;

	object.SetBool("EnableBtnCancel", enableBtnCancel);

	enableRetreat = false;
	//if simTurns && attacker is human && defender is human && no townAttack && i am defender
	if(h7GRI.IsSimTurns()
	   && !attackingArmy.GetPlayer().IsControlledByAI() && !defendingArmy.GetPlayer().IsControlledByAI()
	   && !object.GetBool("IsTownAttack")
	   && !activePlayerIsAttacker)
	{
		if(defendingArmy.CanRetreat())
			enableRetreat = true;
	
		object.SetBool("EnableRetreat", enableRetreat);
	}
	
	enableQC = true;
	//if attacking a town && no simTurns && both players are human && QC is not forced-> disable QC
	if(object.GetBool("IsTownAttack") && !attackingArmy.GetPlayer().IsControlledByAI() && !defendingArmy.GetPlayer().IsControlledByAI()
		&& !h7GRI.IsSimTurns()
		&& advController.GetForceQuickCombat() == FQC_NEVER)
 		enableQC = false;

	//if mulitplayer && no simTurns && attacker is human && defender is human && QC is not forced -> disableQC
	// we disable QC here because: actualy both options should be available but we dont have the voting system
	// for combat currently so we disable QC if it is not forced
	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && !h7GRI.IsSimTurns() &&
	   !attackingArmy.GetPlayer().IsControlledByAI() && !defendingArmy.GetPlayer().IsControlledByAI()
	   && advController.GetForceQuickCombat() == FQC_NEVER)
		enableQC = false;

	//if attacking a battleSite and QC is not forced
	if(defendingArmy.IsGarrisoned() && H7BattleSite(defendingArmy.GetGarrisonedSite()) != none 
	   &&  advController.GetForceQuickCombat() == FQC_NEVER)
		enableQC = false;

	//if defender is AI && attacking another hero && QC is not forced
	if(defendingArmy.GetHero().IsHero() && defendingArmy.GetPlayer().IsControlledByAI()
	   && advController.GetForceQuickCombat() == FQC_NEVER)
		enableQC = false;

	//if editor army is set to force manual combat and QC is not forced
	if(defendingArmy.IsForcingManualCombat() && advController.GetForceQuickCombat() == FQC_NEVER)
		enableQC = false;

	//if attacker has no units
	if(!attackingArmy.HasUnits())
		enableQC = false;

	//force enable if play in editor
	if(class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor())
	{
		enableQC = true;
	}

	object.SetBool("EnableQC", enableQC);
	
	enableMC = true;
	//if force qc vs ai or force qc always -> disable MC
	if((advController.GetForceQuickCombat() == FQC_AGAINST_AI &&
		defendingArmy.GetPlayer().IsControlledByAI()) ||
		advController.GetForceQuickCombat() == FQC_ALWAYS )
		enableMC = false;
	
	//if attacker has no units
    if(!attackingArmy.HasUnits())
		enableMC = false;

	//force disable if play in editor
	if(class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor())
	{
		enableMC = false;
	}

	object.SetBool("EnableMC", enableMC);

	
	SetObject("mData", object);

	;


	if((defendingArmy.IsGarrisoned() || defendingArmy.IsGarrisonedButOutside()) && H7BattleSite(defendingArmy.GetGarrisonedSite()) == none)
		ActionScriptVoid("UpdateSiegeCombatPopUp");
	else
		ActionscriptVoid("Update");
}

function UpdateNegotiationPopUp(H7AdventureArmy heroArmy, H7AdventureArmy creatureArmy, bool join, array<H7ResourceQuantity> costs, optional bool force = false)
{
	local GFxObject object;

	;

	object = CreateObject("Object");	
	object.SetObject("LeftArmy", CreateArmyObject(heroArmy));
	object.SetObject("RightArmy", CreateArmyObject(creatureArmy));
	object.SetBool("Join", join);
	object.SetObject("Cost", CreateCostArray(costs));
	object.SetBool("CanMerge", heroArmy.CanMergeArmy(creatureArmy));
	object.SetBool("ForceJoin", force);

	object.SetBool("ShowTimer", class'H7ReplicationInfo'.static.GetInstance().IsSimTurns());
	//object.SetBool("ShowTimer", true);

	SetObject("mData", object);
	ActionScriptVoid("UpdateNegotiationPopUp");
}

function OnEndQuickCombatUpdate(array<H7BaseCreatureStack> attackerLoses, array<H7BaseCreatureStack> defenderLoses
							    , bool leftArmyVictory, H7CombatHero attackerHero, H7CombatHero defenderHero, bool activePlayerIsAttacker
								, bool isSiege )
{
	local GFxObject object, leftLossesObj, rightLossesObj, propsObj;
	local H7BaseCreatureStack props;
	local int i, xpGainLeft, xpGainRight;

	;

	object = CreateObject("Object");	

	leftLossesObj = CreateArray();
	rightLossesObj = CreateArray();

	ForEach attackerLoses(props, i)
	{
		propsObj = CreateObject("Object");
		propsObj.SetString("Name", props.GetStackType().GetName());
		propsObj.SetInt("Lost", props.GetStackSize());
		propsObj.SetBool("IsLocalGuard", props.IsLocalGuard());
		xpGainRight += props.GetStackType().GetExperiencePoints() * props.GetStackSize();
		leftLossesObj.SetElementObject(i, propsObj);
	}

	;
	ForEach defenderLoses(props, i)
	{
		;
		propsObj = CreateObject("Object");
		propsObj.SetString("Name", props.GetStackType().GetName());
		propsObj.SetInt("Lost", props.GetStackSize());
		propsObj.SetBool("IsLocalGuard", props.IsLocalGuard());
		xpGainLeft += props.GetStackType().GetExperiencePoints() * props.GetStackSize();
		rightLossesObj.SetElementObject(i, propsObj);
	}
	
	if(attackerHero.IsHero())
	{
		object.setInt("XPForLevelUpLeft", attackerHero.GetNextLevelXp());
		//if(attackerHero.GetLevel() == 30) object.setInt("XPForLevelUpLeft", attackerHero.GetLvl30XPNeeded());
	}
	if(defenderHero.IsHero())
	{
		object.setInt("XPForLevelUpRight", defenderHero.GetNextLevelXp());
		//if(defenderHero.GetLevel() == 30) object.setInt("XPForLevelUpRight", defenderHero.GetLvl30XPNeeded());
	}
	attackerHero.TriggerEvents( ON_BATTLE_XP_GAIN, false );
	defenderHero.TriggerEvents( ON_BATTLE_XP_GAIN, false );

	// AddBoni are used for accomulated multiplier boni, f. e. paragon 20% + Enlightened Leader 50% =  * 1.7, not * 1.2 * 1.5
	xpGainLeft =  xpGainLeft * (1 + attackerHero.GetAddBoniOnStatByID(STAT_XP_RATE)) * attackerHero.GetMultiBoniOnStatByID(STAT_XP_RATE);
	xpGainRight = xpGainRight * (1 + defenderHero.GetAddBoniOnStatByID(STAT_XP_RATE)) * defenderHero.GetMultiBoniOnStatByID(STAT_XP_RATE);

	object.setInt("XPGainLeft", xpGainLeft);
	object.setInt("XPGainRight", xpGainRight);

	if(leftArmyVictory)
	{
		object.setInt("OldXPLeft", attackerHero.GetExperiencePoints() - attackerHero.GetPrevLevelXp());
		object.setInt("OldXPRight", defenderHero.GetExperiencePoints() - defenderHero.GetPrevLevelXp());
		if(attackerHero.IsHero() && defenderHero.IsHero())
			SetObject("mRewards", GetCombatRewardsObject(defenderHero, attackerHero));
	}
	else
	{
		object.setInt("OldXPLeft", attackerHero.GetExperiencePoints() - attackerHero.GetPrevLevelXp());
		object.setInt("OldXPRight", defenderHero.GetExperiencePoints() - defenderHero.GetPrevLevelXp());
		if(attackerHero.IsHero() && defenderHero.IsHero())
			SetObject("mRewards", GetCombatRewardsObject(attackerHero, defenderHero));
	}

	if(attackerHero.IsHero() && attackerHero.GetLevel() == class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( attackerHero.GetPlayer().GetPlayerNumber() ))
		object.setInt("OldXPLeft", attackerHero.GetLvl30XPNeeded());

	if(defenderHero.IsHero() && defenderHero.GetLevel() == class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( defenderHero.GetPlayer().GetPlayerNumber() ))
		object.setInt("OldXPRight", defenderHero.GetLvl30XPNeeded());

	object.SetBool("LeftArmyVictory", leftArmyVictory);
	
	object.SetBool("ActivePlayerIsLeft", activePlayerIsAttacker);

	object.SetObject("LeftLosses", leftLossesObj);
	object.SetObject("RightLosses", rightLossesObj);

	//SetObject("mWarfareUnitsLeft", CreateWarefareUnitsObject(attackingArmy));
	//SetObject("mWarfareUnitsRight", CreateWarefareUnitsObject(defendingArmy));

	// to show the warning timer
	;
	object.SetBool("IsMultiplayerGame", class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame());
	SetObject("mLosses", object);

	//BattleSite rewards (for debug purposes only)
	if(leftArmyVictory && class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite() != none)
		SetObject("mRewards", GetBattleSiteRewardsObject());

	AddMergeArmy(object);

	if(isSiege)
		ActionScriptVoid("OnEndQuickCombatUpdateSiege");
	else
		ActionscriptVoid("OnEndQuickCombatUpdate");
}

function UpdateFromCombatMap(int XPWinner, int XPLoser, H7CombatArmy myArmy, bool activePlayerIsAttacker, 
							 bool fled, bool surrendered, int paidGold)
{
	local GFxObject object, losses, leftLossesObj, rightLossesObj, propsObj;
	local array<H7CreatureStack> stacks;
	local H7CreatureStack stack;
	local int i;
	local H7CombatArmy attackingArmy, defendingArmy;
	local bool isSiege;
	local H7AreaOfControlSite aocSite;

	;

	i = 0;
	object = CreateObject("Object");
	losses = CreateObject("Object");
	
	object.SetBool("IsDuel", class'H7AdventureController'.static.GetInstance() == none);	

	if( class'H7CombatController'.static.GetInstance().GetArmyAttacker() == myArmy)
	{
		attackingArmy = myArmy;
		defendingArmy = class'H7CombatController'.static.GetInstance().GetOpponentArmy( myArmy );
	}
	else
	{
		attackingArmy = class'H7CombatController'.static.GetInstance().GetOpponentArmy( myArmy );
		defendingArmy = myArmy;
	}
	;
	
	// is SIEGE?
	if( attackingArmy.GetAdventureHero().GetAdventureArmy().GetGarrisonedSite() != none ||
		defendingArmy.GetAdventureHero().GetAdventureArmy().GetGarrisonedSite() != none )
		isSiege = true;

	SetObject("mWarfareUnitsLeft", CreateWarefareUnitsObject(attackingArmy));
	SetObject("mWarfareUnitsRight", CreateWarefareUnitsObject(defendingArmy));
	
	object.SetBool("Spectator", class'H7AdventureController'.static.GetInstance().GetLocalPlayer() != defendingArmy.GetPlayer() && class'H7AdventureController'.static.GetInstance().GetLocalPlayer() != attackingArmy.GetPlayer());

	object.SetBool("Hotseat", false);
	
	if(!attackingArmy.GetPlayer().IsControlledByAI() && !defendingArmy.GetPlayer().IsControlledByAI() && 
		defendingArmy.GetPlayerNumber() != PN_NEUTRAL_PLAYER)
		object.SetBool("Hotseat", true);
	
	object.SetBool("EnableMC", true);

	object.SetObject("LeftArmy", CreateCombatArmyObject(attackingArmy));
	object.SetObject("RightArmy", CreateCombatArmyObject(defendingArmy));
	
	if((defendingArmy.GetAdventureHero().GetAdventureArmy().GetGarrisonedSite() != none || 
		defendingArmy.GetAdventureHero().GetAdventureArmy().IsGarrisonedButOutside()) 
		&& H7BattleSite(defendingArmy.GetAdventureHero().GetAdventureArmy().GetGarrisonedSite()) == none )
	{
		;
		aocSite = H7AreaOfControlSite(defendingArmy.GetAdventureHero().GetAdventureArmy().GetGarrisonedSite());
		object.SetObject("LocalGuard", CreateLocalGuardObject(  aocSite.GetLocalGuardAsBaseCreatureStacks(), defendingArmy.GetHero()));
	}

	if(!defendingArmy.GetHero().IsHero() && defendingArmy.GetPlayerNumber() != PN_NEUTRAL_PLAYER)
		object.GetObject("RightArmy").SetString("HeroNameOverride", defendingArmy.GetAdventureHero().GetAdventureArmy().GetName());

	if(!attackingArmy.GetHero().IsHero() && attackingArmy.GetPlayerNumber() != PN_NEUTRAL_PLAYER)
		object.GetObject("LeftArmy").SetString("HeroNameOverride", attackingArmy.GetAdventureHero().GetAdventureArmy().GetName());

	if(attackingArmy.GetHero().IsHero())
	{
		losses.setInt("XPForLevelUpLeft", attackingArmy.GetHero().GetNextLevelXp());
		if(attackingArmy.GetHero().GetLevel() == class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( attackingArmy.GetHero().GetPlayer().GetPlayerNumber() ))
			losses.setInt("XPForLevelUpLeft", attackingArmy.GetHero().GetLvl30XPNeeded());
	}
	if(defendingArmy.GetHero().IsHero())
	{
		losses.setInt("XPForLevelUpRight", defendingArmy.GetHero().GetNextLevelXp());
		if(defendingArmy.GetHero().GetLevel() == class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( defendingArmy.GetHero().GetPlayer().GetPlayerNumber() ))
			losses.setInt("XPForLevelUpRight", defendingArmy.GetHero().GetLvl30XPNeeded());
	}
	
	leftLossesObj = CreateArray();
	rightLossesObj = CreateArray();

	// My Lost creatures 
    if(myArmy != none)   
    {
    	attackingArmy.GetKilledCreatureStacks( stacks );
    }
	ForEach stacks(stack)
	{
		propsObj = CreateObject("Object");
		propsObj.SetString("Name", stack.GetName());
		propsObj.SetInt("Lost", stack.GetInitialStackSize());
		propsObj.SetBool("IsLocalGuard", stack.GetBaseCreatureStack().IsLocalGuard());

		leftLossesObj.SetElementObject(i, propsObj);
		i++;
	}

	if(attackingArmy != none)   
    {
    	attackingArmy.GetSurvivingCreatureStacks( stacks );
    }
	ForEach stacks(stack)
	{
		propsObj = CreateObject("Object");
		propsObj.SetString("Name", stack.GetName());
		propsObj.SetInt("Lost", stack.CountDeadCreatures());
		propsObj.SetBool("IsLocalGuard", stack.GetBaseCreatureStack().IsLocalGuard());

		leftLossesObj.SetElementObject(i, propsObj);
		i++;
	}

	// Enemy lost creatures
	stacks.Remove(0, stacks.Length);
	i=0;
	
	defendingArmy.GetKilledCreatureStacks(stacks);
	ForEach stacks(stack)
	{
		propsObj = CreateObject("Object");
		propsObj.SetString("Name", stack.GetName());
		propsObj.SetInt("Lost", stack.GetInitialStackSize());
		propsObj.SetBool("IsLocalGuard", stack.GetBaseCreatureStack().IsLocalGuard());
;
		rightLossesObj.SetElementObject(i, propsObj);
		i++;
	}
	
	defendingArmy.GetSurvivingCreatureStacks(stacks);
	ForEach stacks(stack)
	{
		propsObj = CreateObject("Object");
		propsObj.SetString("Name", stack.GetName());
		propsObj.SetInt("Lost", stack.CountDeadCreatures());
		propsObj.SetBool("IsLocalGuard", stack.GetBaseCreatureStack().IsLocalGuard());

		rightLossesObj.SetElementObject(i, propsObj);
		i++;
	}

	losses.SetObject("LeftLosses", leftLossesObj);
	losses.SetObject("RightLosses", rightLossesObj);
	
	;

	object.SetBool("ActivePlayerIsLeft", activePlayerIsAttacker);

	if(attackingArmy.WonBattle())
	{
		losses.SetBool("LeftArmyVictory", true);
		losses.SetInt("XPGainLeft", XPWinner);
		losses.SetInt("XPGainRight", XPLoser);
		losses.setInt("OldXPLeft", attackingArmy.GetHero().GetExperiencePoints() - attackingArmy.GetHero().GetPrevLevelXp() - XPWinner);
		losses.setInt("OldXPRight", defendingArmy.GetHero().GetExperiencePoints() - defendingArmy.GetHero().GetPrevLevelXp() - XPLoser);
		if(attackingArmy.GetHero().IsHero() && defendingArmy.GetHero().IsHero() && !fled && !surrendered)
			SetObject("mRewards", GetCombatRewardsObject(defendingArmy.GetHero(), attackingArmy.GetHero()));
	}
	else
	{
		object.SetBool("LeftArmyVictory", false);
		losses.SetInt("XPGainLeft", XPLoser);
		losses.SetInt("XPGainRight", XPWinner);
		losses.setInt("OldXPLeft", attackingArmy.GetHero().GetExperiencePoints() - attackingArmy.GetHero().GetPrevLevelXp() - XPLoser);
		losses.setInt("OldXPRight", defendingArmy.GetHero().GetExperiencePoints() - defendingArmy.GetHero().GetPrevLevelXp() - XPWinner);
		if(attackingArmy.GetHero().IsHero() && defendingArmy.GetHero().IsHero() && !fled && !surrendered)
			SetObject("mRewards", GetCombatRewardsObject(attackingArmy.GetHero(), defendingArmy.GetHero()));
	}

	if(!attackingArmy.WonBattle() && !defendingArmy.WonBattle())
		losses.SetBool("Draw", true);
	else
		losses.SetBool("Draw", false);

	if(attackingArmy.GetHero().IsHero() && attackingArmy.GetHero().GetLevel() == class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( attackingArmy.GetHero().GetPlayer().GetPlayerNumber() ))
		losses.setInt("OldXPLeft", attackingArmy.GetHero().GetLvl30XPNeeded());

	if(defendingArmy.GetHero().IsHero() && defendingArmy.GetHero().GetLevel() == class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( defendingArmy.GetHero().GetPlayer().GetPlayerNumber() ))
		losses.setInt("OldXPRight", defendingArmy.GetHero().GetLvl30XPNeeded());

	losses.Setbool("Fled", fled);
	losses.SetBool("Surrendered", Surrendered);
	losses.SetInt("PaidGold", paidGold);

	// warnig timer
	;
	losses.SetBool("IsMultiplayerGame", class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame());
	
	SetObject("mData", object);
	SetObject("mLosses", losses);
	 
	//is BATTLESITE? -> isSiege = false
	if(class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite() != none)
		isSiege = false;
	
	if(attackingArmy.WonBattle() && class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite() != none)
		SetObject("mRewards", GetBattleSiteRewardsObject(myArmy.GetHero()));
	
	
	;
	if(isSiege)
		ActionScriptVoid("UpdateFromSiegeCombatMap");
	else
		ActionscriptVoid("UpdateFromCombatMap");

	AddMergeArmy(object);
}
 
function GFxObject GetCombatRewardsObject(H7EditorHero losingHero, H7EditorHero winningHero)
{
	local GFxObject obj, itemRewardsObj, itemObj;
	local array<H7HeroItem> itemRewards;
	local H7HeroItem item;
	local int i;

	
	obj = CreateObject("Object");
	itemRewardsObj = CreateArray();
	
	
	itemRewards = losingHero.GetInventory().GetItems();
	i = 0;
	ForEach itemRewards(item)
	{
		if(!item.IsExchangeable()) continue;
		itemObj = CreateObject("Object");
		itemObj = CreateItemObject(item, winningHero);
		itemRewardsObj.SetElementObject(i, itemObj);
		i++;
	}

	losingHero.GetEquipment().GetItemsAsArray(itemRewards);
	ForEach itemRewards(item)
	{
		if(!item.IsExchangeable()) continue;
		itemObj = CreateObject("Object");
		itemObj = CreateItemObject(item, winningHero);
		itemRewardsObj.SetElementObject(i, itemObj);
		i++;
	}

	obj.SetObject("ItemRewards", itemRewardsObj);
		

	return obj;
}

function ClickBtnQuickCombatFromUnreal(bool isSiege)
{
	ActionScriptVoid("ClickBtnQuickCombatFromUnreal");
}

function AddMergeArmy(GFxObject object)
{
	;
}
