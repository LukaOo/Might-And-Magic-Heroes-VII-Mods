/*=============================================================================
* H7PermanentBonusSite
* =============================================================================
* Base class for sites that give visiting heroes a permanent stat bonus. 
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7PermanentBonusSite extends H7NeutralSite
	hideCategories(Defenses)
	implements(H7ITooltipable, H7IHideable)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

/** The permanent stat boni that is granted */
var(Developer) protected array<H7MeModifiesStat> mStatModifiers<DisplayName=Provided Stat Boni>;
var         protected savegame bool     mIsHidden;

var         protected int mPlayerChoice;
var         protected array<int> mChoiceStatMod;
var         protected int mLvDepStatModNum;
var         protected bool mHeroDidReallyVisit;

var         protected array<H7ResourceQuantity> mCosts;

var protected savegame array<H7AdventureArmy> mVisitedHeroes;

native function bool IsHiddenX();

function array<H7MeModifiesStat> GetStatModifiers() { return mStatModifiers; }

event InitAdventureObject()
{
	super.InitAdventureObject();

	class'H7AdventureController'.static.GetInstance().AddPermanentBonusSite( self );
}

function bool HasVisited( H7AdventureHero hero )
{
	return mVisitedHeroes.Find( hero.GetAdventureArmy() ) != INDEX_NONE;
}

function bool CanAffordIt( H7AdventureHero hero )
{
	local Array <H7ResourceQuantity> costDataArray;
	local H7MeModifiesStat statmod;
	local int i;
	local H7Player player;

	if(hero==None) return false;
	player=hero.GetPlayer();
	if(player==None || player.GetPlayerNumber()==PN_NEUTRAL_PLAYER) return false;

	foreach mStatModifiers(statmod,i)
	{
		if(statmod.mCombineOperation==OP_TYPE_BUY_ADD)
		{
			if(statmod.mShirneSeventhDragon)
			{
				costDataArray = CalculateShrineOfSeventhDragonCosts(hero,statmod);
				if(player.GetResourceSet().CanSpendResources(costDataArray)
					&& hero.GetLevel() < class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( hero.GetPlayer().GetPlayerNumber() ))
				{
					return true;
				}
				return false;
			}
			else
			{
				costDataArray = CalculateShrineOfSeventhDragonCosts(hero,statmod);
				if(player.GetResourceSet().CanSpendResources(costDataArray))
				{
					return true;
				}
				return false;
			}
		}
	}
	return true;
}

function OnVisit( out H7AdventureHero hero )
{
	local Vector HeroMsgOffset;
	local H7MeModifiesStat statmod;
	local int i,c, xpGain;
	local String floatingText, popUpMessage, popUpButton1, popUpButton2, costDataStr;
	local H7ResourceQuantity cost;
	local Array <H7ResourceQuantity> costDataArray;
	local bool enableStatChoice;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	HeroMsgOffset = Vect(0,0,600);

	mHeroDidReallyVisit = true; // assume the dude will be affected by something here
	if( !HasVisited( hero ) )
	{
		foreach mStatModifiers( statmod, i )
		{
			switch( statmod.mCombineOperation )
			{
				case OP_TYPE_ADD:
					if( statmod.mStat == STAT_CURRENT_XP ) floatingText = "+"$int(statmod.mModifierValue * (1 + class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetAddBoniOnStatByID(STAT_XP_RATE)) * class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetMultiBoniOnStatByID(STAT_XP_RATE) );
					else floatingText = "+"$int(statmod.mModifierValue);
					hero.IncreaseBaseStatByID( statmod.mStat, statmod.mModifierValue );
					mVisitedHeroes.AddItem( hero.GetAdventureArmy() );
					break;
				case OP_TYPE_MULTIPLY:
					floatingText = "*"$int(statmod.mModifierValue);
					hero.IncreaseBaseStatByID( statmod.mStat, statmod.mModifierValue * hero.GetBaseStatByID( statmod.mStat ) - hero.GetBaseStatByID( statmod.mStat ) );
					mVisitedHeroes.AddItem( hero.GetAdventureArmy() );
					break;
				case OP_TYPE_ADDPERCENT:
					floatingText = "+"$int(statmod.mModifierValue)$"%";
					hero.IncreaseBaseStatByID( statmod.mStat, statmod.mModifierValue * hero.GetBaseStatByID( statmod.mStat ) / 100 - hero.GetBaseStatByID( statmod.mStat ) );
					mVisitedHeroes.AddItem( hero.GetAdventureArmy() );
					break;
				case OP_TYPE_CHOOSE_ADD:
					mChoiceStatMod[c] = i;
					c++;

					enableStatChoice = true;
	
					if(statmod.mUseLevelScaling)
					{
						mLvDepStatModNum = LevelDependantStatMod(hero, statmod.mStatModLevelScalingValue);
					}

					if( enableStatChoice )
					{
						if( hero.GetPlayer().IsControlledByAI()==true && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled() )
						{
							i=Rand(100);
							if(i<=50 || mChoiceStatMod.Length<=1)
							{
								ChoiceOne();
							}
							else
							{
								ChoiceTwo();
							}
						}
						else if( hero.GetPlayer().IsControlledByLocalPlayer() )
						{
							popUpMessage = "<font size='#TT_TITLE#'>" $ self.GetName() $ "</font>\n";
							popUpMessage = popUpMessage $ "<br></br>";
							popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("PU_CHOOSE_STATMOD","H7PopUp") $ "</font>";
							popUpMessage = popUpMessage $ "<br></br>";
							popUpButton1 = class'H7Loca'.static.LocalizeSave("PU_CHOOSE_FIRST","H7PopUp");
							popUpButton2 = class'H7Loca'.static.LocalizeSave("PU_CHOOSE_SECOND","H7PopUp");
							if( statmod.mUseLevelScaling )
							{
								popUpButton1 = Repl(popUpButton1, "%amount1", int(mStatModifiers[mChoiceStatMod[0]].mStatModLevelScalingValue[mLvDepStatModNum].mAmount) );
								popUpButton2 = Repl(popUpButton2, "%amount2", int(mStatModifiers[mChoiceStatMod[1]].mStatModLevelScalingValue[mLvDepStatModNum].mAmount) );
							}
							else
							{
								popUpButton1 = Repl(popUpButton1, "%amount1", int(mStatModifiers[mChoiceStatMod[0]].mModifierValue) );
								popUpButton2 = Repl(popUpButton2, "%amount2", int(mStatModifiers[mChoiceStatMod[1]].mModifierValue) );
							}
							popUpButton1 = Repl(popUpButton1, "%statmod1", class'H7EffectContainer'.static.GetLocaNameForStat(mStatModifiers[mChoiceStatMod[0]].mStat,true) );
							popUpButton2 = Repl(popUpButton2, "%statmod2", class'H7EffectContainer'.static.GetLocaNameForStat(mStatModifiers[mChoiceStatMod[1]].mStat,true) );
							
							popUpButton1 = Repl(popUpButton1, "%icon", class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(mStatModifiers[mChoiceStatMod[0]].mStat) );
							popUpButton2 = Repl(popUpButton2, "%icon", class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(mStatModifiers[mChoiceStatMod[1]].mStat) );

							class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( popUpMessage, popUpButton1, popUpButton2, ChoiceOne, ChoiceTwo, true, Leave );
						}
					}
					break;
				case OP_TYPE_BUY_ADD:
					
					if( statmod.mShirneSeventhDragon )
					{
						if(hero.GetPlayer().IsControlledByAI()==true && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
						{
							costDataArray = CalculateShrineOfSeventhDragonCosts(hero,statmod);
							if( hero.GetPlayer().GetResourceSet().CanSpendResources(costDataArray)
								&& hero.GetLevel() < class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( hero.GetPlayer().GetPlayerNumber() ) )
							{
								Buy();
							}
							else
							{
								mVisitedHeroes.AddItem( hero.GetAdventureArmy() );
								mHeroDidReallyVisit = false;
							}
						}
						else if( hero.GetPlayer().IsControlledByLocalPlayer() )
						{
							//Calculate XP Gain and Costs
							xpGain = CalculateShrineOfSeventhDragonReward(hero);
							costDataArray = CalculateShrineOfSeventhDragonCosts(hero, statmod);
							mStatModifiers[i].mModifierValue = xpGain;

							if( hero.GetPlayer().GetResourceSet().CanSpendResources( costDataArray )
								&& hero.GetLevel() < class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( hero.GetPlayer().GetPlayerNumber() ) )
							{
								foreach costDataArray( cost )
								{
									costDataStr = costDataStr @ "\n" @ "<font size='#TT_BODY#'>"$cost.Quantity @ cost.Type.GetName()$"</font>";
								}
								popUpMessage = "<font size='#TT_TITLE#'>" $ self.GetName() $ "</font>\n";
								popUpMessage = popUpMessage $ "<br></br>";
								popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>"$ class'H7Loca'.static.LocalizeSave("PU_SHRINE_SEVENTH_DRAGON","H7PopUp") $"\n" $ class'H7Loca'.static.LocalizeSave("PU_BUY_STATMOD","H7PopUp")$"</font>";
								popUpMessage = Repl(popUpMessage, "%resource", class'H7EffectContainer'.static.GetLocaNameForStat(statmod.mStat,true) );
								popUpMessage = Repl(popUpMessage, "%amount", xpGain );

								class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ACCEPT","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Buy, Leave, costDataArray );
							}
							else
							{
								if(hero.GetLevel() == class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( hero.GetPlayer().GetPlayerNumber() ))
								{
									popUpMessage = "<font size='#TT_TITLE#'>" $ self.GetName() $ "</font>\n";
									popUpMessage = popUpMessage $ "<br></br>";
									popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("PU_MAX_LEVEL_REACHED","H7PopUp")$"</font>";
									class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().OKPopup(popUpMessage, "OK", Leave );
									mHeroDidReallyVisit = false;
								}
								else
								{
									foreach costDataArray( cost )
									{
										costDataStr = costDataStr @ "\n" @ "<font size='#TT_BODY#'>"$cost.Quantity @ cost.Type.GetName()$"</font>";
									}
									popUpMessage = "<font size='#TT_TITLE#'>" $ self.GetName() $ "</font>\n";
									popUpMessage = popUpMessage $ "<br></br>";
									popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>"$ class'H7Loca'.static.LocalizeSave("PU_SHRINE_SEVENTH_DRAGON","H7PopUp") $"\n" $ class'H7Loca'.static.LocalizeSave("PU_BUY_STATMOD","H7PopUp")$"</font>";
									popUpMessage = Repl(popUpMessage, "%resource", class'H7EffectContainer'.static.GetLocaNameForStat(statmod.mStat,true) );
									popUpMessage = Repl(popUpMessage, "%amount", xpGain );
									class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup(popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ACCEPT","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Buy, Leave, costDataArray );
								}
							}
						}
					}
					else
					{
						costDataArray = CalculateShrineOfSeventhDragonCosts(hero, statmod);

						if( hero.GetPlayer().GetResourceSet().CanSpendResources( costDataArray ))
						{
							foreach costDataArray( cost )
							{
								costDataStr = costDataStr @ "\n" @ cost.Quantity @ cost.Type.GetName();
							}

							if( hero.GetPlayer().IsControlledByAI() == false )
							{
								popUpMessage = "<font size='#TT_TITLE#'>" $ self.GetName() $ "</font>\n";
								popUpMessage = popUpMessage $ "<br></br>";
								popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("PU_BUY_STATMOD","H7PopUp") $ "</font>";
								popUpMessage = Repl(popUpMessage, "%price", costDataStr );
								popUpMessage = Repl(popUpMessage, "%resource", class'H7EffectContainer'.static.GetLocaNameForStat(statmod.mStat,true) );
								popUpMessage = Repl(popUpMessage, "%amount", class'H7GameUtility'.static.FloatToString(statmod.mModifierValue) );

								class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ACCEPT","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Buy, Leave );
							}
							else if(class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
							{
								Buy();
							}
						}
						else
						{
							if( hero.GetPlayer().IsControlledByAI() == false )
							{
								popUpMessage = "<font size='#TT_TITLE#'>" $ self.GetName() $ "</font>\n";
								popUpMessage = popUpMessage $ "<br></br>";
								popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("PU_NOT_ENOUGH_RES","H7PopUp") $ "</font>";
								popUpMessage = Repl(popUpMessage, "%price", costDataStr );

								class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().OKPopup(popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Leave );
							}
							else
							{
								mHeroDidReallyVisit = false;
							}
						}
					}
				
					break;
			}

			if( statmod.mCombineOperation != OP_TYPE_CHOOSE_ADD && statmod.mCombineOperation != OP_TYPE_BUY_ADD)
			{
				HeroMsgOffset.Z += i*200;
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_STAT_MOD, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), floatingText@class'H7EffectContainer'.static.GetLocaNameForStat(statmod.mStat,true), MakeColor(0,255,0,255), class'H7PlayerController'.static.GetPlayerController().GetHud().GetStatIcons().GetStatIcon(statmod.mStat, hero));
			}
		}

		
	}
	else
	{

		if(mVisitingArmy.GetPlayer().IsControlledByLocalPlayer())
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT") , MakeColor(255,255,0,255));
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ALREADY_VISITED");
		}
	}

	// visit if something happened (else, text might show up)
	if( mHeroDidReallyVisit )
	{
		super.OnVisit( hero );
	}
	
	hero.DataChanged();
}

protected function int CalculateShrineOfSeventhDragonReward(H7AdventureHero advHero)
{
	local int curLvXPRange, nextLvXPRange, prevLvXP, currXP, xpToLvUp, currProgPercentage, nextLevelXPDelta, i, xpGain;
	local H7AdventureHero hero;

	hero = advHero;

	//It calculates the amount of XP which is needed to get to the same progress in percent as at the current hero level
	curLvXPRange = hero.GetLevelXPRange(hero.GetLevel());

	if(hero.GetLevel()+1 < class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( hero.GetPlayer().GetPlayerNumber() ))
	{
		nextLvXPRange = hero.GetLevelXPRange(hero.GetLevel()+1);
	} 

	currXP = hero.GetExperiencePoints(); // the heroes current gathered XP
	
	//Gets all XP needed until the heroes current level
	for(i = 0; i < hero.GetLevel(); i++)
	{
		prevLvXP += hero.GetLevelXPRange(i);
	}

	//Calculate the current heroes XP progess at this level and add the remaining XP to that value
	currXP = currXP - prevLvXP;
	xpToLvUp = curLvXPRange - currXP;

	currProgPercentage = curLvXPRange/100.f;
	currProgPercentage = currXP / currProgPercentage;
	
	nextLevelXPDelta = nextLvXPRange/100.f;
	nextLevelXPDelta = nextLevelXPDelta * currProgPercentage;

	xpGain = xpToLvUp + nextLevelXPDelta;

	return xpGain;
}
	
protected function Array <H7ResourceQuantity> CalculateShrineOfSeventhDragonCosts(H7AdventureHero advHero, H7MeModifiesStat statmod)
{
	local H7ResourceQuantity costData;
	local Array <H7ResourceQuantity> costDataArray;
	local int i, lvDepStatNum;
	local H7AdventureHero hero;

	hero = advHero;

	for(i = 0; i<statMod.mStatModCosts.Length; i++)
	{
		if(statMod.mStatModCosts[i].mUseLevelScalingCosts)
		{
			costData.Type = statMod.mStatModCosts[i].mCosts.Type;
			costData.Quantity = statMod.mStatModCosts[i].mCosts.Quantity * advHero.GetLevel();
		
			if(costData.Type != none)
			{
				costDataArray.AddItem(costData);
			}
		}
		else
		{
			lvDepStatNum = LevelDependantStatMod(hero, statMod.mStatModCosts[i].mLevelRanges);

			costData.Type = statMod.mStatModCosts[i].mCosts.Type;
			costData.Quantity = statMod.mStatModCosts[i].mLevelRanges[lvDepStatNum].mAmount;
		
			if(costData.Type != none)
			{
				costDataArray.AddItem(costData);
			}
		}
	}
	return costDataArray;
}

protected function Buy()
{
	local H7InstantCommandIncreaseHeroStat command;
	local H7AdventureHero hero;
	local Vector HeroMsgOffset;
	local H7MeModifiesStat statmod;
	local Array <H7ResourceQuantity> costDataArray;
	local int i, j;

	HeroMsgOffset = Vect(0,0,600);
	mVisitedHeroes.AddItem( mVisitingArmy );
	hero = mVisitedHeroes[mVisitedHeroes.Length-1].GetHero();

	foreach mStatModifiers(statmod, i)
	{
		if(statmod.mCombineOperation == OP_TYPE_BUY_ADD)
		{
			costDataArray = CalculateShrineOfSeventhDragonCosts(hero, statmod);
			mVisitingArmy.GetPlayer().GetResourceSet().SpendResources( costDataArray, true, true );
			for(j = 0; j < costDataArray.Length; j++)
			{
				HeroMsgOffset.Z += i*200;
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_RESOURCE_PICKUP, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), "-"$costDataArray[j].Quantity, MakeColor(255,0,0,255) , costDataArray[j].Type.GetIcon() );
			}

			command = new class'H7InstantCommandIncreaseHeroStat';
			command.Init( hero, mStatModifiers[i].mStat, statmod.mUseLevelScaling ? mStatModifiers[i].mStatModLevelScalingValue[i].mAmount : mStatModifiers[i].mModifierValue );
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
			costDataArray.Length = 0;
		}
	}

	hero.DataChanged();
}

protected function Leave()
{
	mHeroDidReallyVisit = false;
	mVisitedHeroes.RemoveItem( mVisitedHeroes[mVisitedHeroes.Length-1] );
}

protected function ChoiceOne()
{
	local H7InstantCommandIncreaseHeroStat command;
	
	mVisitedHeroes.AddItem( mVisitingArmy );
	command = new class'H7InstantCommandIncreaseHeroStat';
	if( mStatModifiers[mChoiceStatMod[0]].mUseLevelScaling )
		command.Init( mVisitedHeroes[mVisitedHeroes.Length-1].GetHero(), mStatModifiers[mChoiceStatMod[0]].mStat, mStatModifiers[mChoiceStatMod[0]].mStatModLevelScalingValue[mLvDepStatModNum].mAmount );
	else
		command.Init( mVisitedHeroes[mVisitedHeroes.Length-1].GetHero(), mStatModifiers[mChoiceStatMod[0]].mStat, mStatModifiers[mChoiceStatMod[0]].mModifierValue );

	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

protected function ChoiceTwo()
{
	local H7InstantCommandIncreaseHeroStat command;
	
	mVisitedHeroes.AddItem( mVisitingArmy );
	command = new class'H7InstantCommandIncreaseHeroStat';
	if( mStatModifiers[mChoiceStatMod[1]].mUseLevelScaling )
		command.Init( mVisitedHeroes[mVisitedHeroes.Length-1].GetHero(), mStatModifiers[mChoiceStatMod[1]].mStat, mStatModifiers[mChoiceStatMod[1]].mStatModLevelScalingValue[mLvDepStatModNum].mAmount );
	else
		command.Init( mVisitedHeroes[mVisitedHeroes.Length-1].GetHero(), mStatModifiers[mChoiceStatMod[1]].mStat, mStatModifiers[mChoiceStatMod[1]].mModifierValue );

	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

protected function int LevelDependantStatMod ( H7AdventureHero Hero, Array<H7LevelScalingRange> LevelScalingStatModArray)
{
	local int heroLevel;
	local int levelRangeNumber;
	local int i;
	local bool levelRangeFound;
	heroLevel = Hero.GetLevel();

	for(i =0; i < LevelScalingStatModArray.Length; i++)
	{
		if(LevelScalingStatModArray[i].mMin <= heroLevel && LevelScalingStatModArray[i].mMax >= heroLevel )
		{
			levelRangeNumber = i;
			levelRangeFound = true;
		}
	}

	if(!levelRangeFound)
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("PermanentBonusSite level scaling properties not found" @ self.GetName(),MD_QA_LOG);;
	}

	return levelRangeNumber;
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7MeModifiesStat stats;
	local H7TooltipData data;
	local string visited, bonusInfo;
	local bool chooseTextSet;
	local float displayvalue;


	if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none )
	{
		if(	HasVisited( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero() ) )
		{
			visited = GetVisitString(true);
		}
		else
		{
			visited = GetVisitString(false);
		}
	}

	foreach mStatModifiers( stats )
	{
		if(stats.mCombineOperation == OP_TYPE_CHOOSE_ADD && !chooseTextSet)
		{
			bonusInfo = bonusInfo $ class'H7Loca'.static.LocalizeSave("TT_CHOOSE","H7PermanentBonusSite") $ "\n";
			chooseTextSet = true;
		}

		if(stats.mStat == STAT_CURRENT_XP )
		{
			displayvalue = stats.mModifierValue * (1 + class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetAddBoniOnStatByID(STAT_XP_RATE)) * class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetMultiBoniOnStatByID(STAT_XP_RATE);
		}
		else 
		{
			displayvalue = stats.mModifierValue;
		}

		if(!stats.mUseLevelScaling)
		{
			if(stats.mShirneSeventhDragon)
			{
				bonusInfo = bonusInfo $ class'H7Loca'.static.LocalizeSave("TT_SHRINE_7TH_DRAGON","H7AdvMapObjectToolTip") $"\n";
			}
			else
			{
				 
				bonusInfo = bonusInfo 
					$ "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ class'H7EffectContainer'.static.GetStringForOperation(stats.mCombineOperation,displayvalue) $ "</font>"
					@ class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(stats.mStat,class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero()) 
					@ class'H7EffectContainer'.static.GetLocaNameForStat(stats.mStat,true)$"\n";
			}
		}
		else
		{
			if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none)
			{
				mLvDepStatModNum = LevelDependantStatMod(class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero(), stats.mStatModLevelScalingValue);
				if(stats.mStat == STAT_CURRENT_XP )
				{
					displayvalue = int(stats.mStatModLevelScalingValue[mLvDepStatModNum].mAmount) * (1 + class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetAddBoniOnStatByID(STAT_XP_RATE)) * class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetMultiBoniOnStatByID(STAT_XP_RATE);
				}
				else 
				{
					displayvalue = int(stats.mStatModLevelScalingValue[mLvDepStatModNum].mAmount);
				}
				
				bonusInfo = bonusInfo 
					$ "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ class'H7EffectContainer'.static.GetStringForOperation(stats.mCombineOperation,displayvalue) $ "</font>"
					@ class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(stats.mStat,class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero()) 
					@ class'H7EffectContainer'.static.GetLocaNameForStat(stats.mStat,true)$"\n";
			}
		}
	}
		
	data.type = TT_TYPE_STRING;
	data.Title = GetName();

	if(mCustomTooltipKey != "")
	{
		data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave(mCustomTooltipKey,"H7AdvMapObjectToolTip") $ "</font>\n";
	}
	else
	{
		data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_PERMANENT_BONUS","H7PermanentBonusSite") $ "</font>\n";
	}
	
	data.Description = data.Description $ "<font size='#TT_BODY#'>" $ bonusInfo $ "</font>";
	data.Visited = visited;

	return data;
}

function Color GetColor()
{
	if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none && HasVisited( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero() ) )
	{
		return GetVisitedColor();
	}
	else
	{
		return GetNotVisitedColor();
	}
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
