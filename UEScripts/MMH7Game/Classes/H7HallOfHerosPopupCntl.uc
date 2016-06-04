//=============================================================================
// H7HallOfHerosPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HallOfHerosPopupCntl extends H7FlashMovieTownPopupCntl 
	dependson (H7HallOfHeroesManager);

var protected H7GFxHallOfHerosPopup mHallOfHerosPopup;
var protected H7GFxHeroEquip mHeroEquip;
var protected H7GFxInventory mInventory;
var protected H7GFxArmyRow mArmyRow;
var protected H7GFxWarfareUnitRow mWarfareUnitRow;
var protected H7GFxUIContainer mHeroInfo;

var protected array<RecruitHeroData> currentHeroPool;
var protected bool mOpenedSkillwheel;

var private int mCurrentHeroID;

function H7GFxHallOfHerosPopup GetHallOfHerosPopup() {return mHallOfHerosPopup;}

function bool Initialize()
{
	;
	
	LinkToTownPopupContainer();

	//Super.Start();
	//AdvanceDebug(0);
	//LoadComplete();
	//Super.Initialize();

	return true;
}


// only used when this is in the townPopUp container
function LoadComplete()
{
	mHallOfHerosPopup = H7GFxHallOfHerosPopup(mRootMC.GetObject("aHallOfHerosPopup", class'H7GFxHallOfHerosPopup'));
	mHeroInfo = H7GFxUIContainer(mHallOfHerosPopup.getObject("aHeroInfoSpecial", class'H7GFxUIContainer'));
	mInventory = H7GFxInventory(mHallOfHerosPopup.GetObject("aArmyAndInventory", class'H7GFxInventory'));
	mHeroEquip = H7GFxHeroEquip(mHallOfHerosPopup.GetObject("aHeroEquip", class'H7GFxHeroEquip'));
	mArmyRow = H7GFxArmyRow(mHallOfHerosPopup.GetObject("aArmyAndInventory", class'H7GfxUIContainer').GetObject("aArmyRow", class'H7GFxArmyRow'));
	mWarfareUnitRow = H7GFxWarfareUnitRow(mHallOfHerosPopup.GetObject("aArmyAndInventory", class'H7GfxUIContainer').GetObject("aWarfareRow", class'H7GFxWarfareUnitRow'));
	mHallOfHerosPopup.SetVisibleSave(false);
}

function Update(H7Town town)
{
	local H7HeroItem ring1;
	local H7EditorHero hero;
	local array<H7HeroItem> items;

	mTown = town;

	currentHeroPool = class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), mTown );
	hero = currentHeroPool[0].Army.GetHero();
	;
	if(hero.GetEquipment().GetRing1() != none) ring1 = hero.GetEquipment().GetRing1();
	hero.GetEquipment().GetItemsAsArray(items);
	mHeroEquip.Update(items, ring1, hero);
	
	mInventory.Update(hero.GetInventory().GetItems(), hero);
	if(currentHeroPool[0].Army != none) 
	{
		mArmyRow.Update(currentHeroPool[0].Army);
		mWarfareUnitRow.Update(currentHeroPool[0].Army);
	}
	
	// need to be called last, because the corresponding AS method removes mouse listeners from slots
	mHallOfHerosPopup.Update(currentHeroPool);
	mHallOfHerosPopup.UpdateHeroInfo(hero, currentHeroPool[0] , town);

	mCurrentHeroID = hero.GetID();

	OpenPopup();
}

function UpdateBackFromSkillwheel()
{
	mOpenedSkillwheel = false;
	OpenPopup();
}

public function UnitClick(int unrealID)
{
	local H7AdventureArmy army;
	local H7HeroItem ring1;
	local array<RecruitHeroData> recruitDatas;
	local RecruitHeroData currentRecruitData;
	local array<H7HeroItem> items;

	recruitDatas = class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), mTown );

	foreach recruitDatas( currentRecruitData )
	{
		if( currentRecruitData.Army.GetHero().GetID() == unrealID )
		{
			mHallOfHerosPopup.ResetWithoutHeroCircle();
			army = currentRecruitData.Army;
			if(army.GetHero().GetEquipment().GetRing1() != none) ring1 = army.GetHero().GetEquipment().GetRing1();
			army.GetHero().GetEquipment().GetItemsAsArray(items);
			mHeroEquip.Update(items, ring1, currentRecruitData.Army.GetHero());

			mHallOfHerosPopup.UpdateHeroInfo(army.GetHero(), currentRecruitData , mTown ); // TODO: use recruitDatas[0].IsAvailable too indicate that the hero cannot be recruited because was defeated in the current turn
			mInventory.Update(army.GetHero().GetInventory().GetItems(), army.GetHero());
			mArmyRow.Update(army);
			mWarfareUnitRow.Update(army);
			mCurrentHeroID = unrealID;
			break;
		}
	}
}

function BtnSkillwheelClicked()
{
	local array<RecruitHeroData> recruitDatas;
	local RecruitHeroData currentRecruitData;

	recruitDatas = class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), mTown );
	
	foreach recruitDatas( currentRecruitData )
	{
		if( currentRecruitData.Army.GetHero().GetID() == mCurrentHeroID )
		{
			mOpenedSkillwheel = true;
			H7AdventureHud( GetHUD() ).GetSkillwheelCntl().UpdateFromHallOfHeroes(  currentRecruitData.Army.GetHero());
		}
	}
	H7AdventureHud(GetHUD()).BlockFlashBelow(H7AdventureHud( GetHUD() ).GetSkillwheelCntl());
	
}

function GetStatModSourceList(String statStr,int unrealID)
{
	local H7Unit unit;
	local EStat stat;
	local array<H7StatModSource> mods;
	local int i;
	local array<RecruitHeroData> recruitDatas;
	local RecruitHeroData currentRecruitData;

	;

	recruitDatas = class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), mTown );

	foreach recruitDatas( currentRecruitData )
	{
		if( currentRecruitData.Army.GetHero().GetID() == unrealID )
		{
			unit = currentRecruitData.Army.GetHero();
			break;
		}
	}

	for(i=0;i<=STAT_MAX;i++)
	{
		stat = EStat(i);
		if(String(stat) == statStr)
		{
			break;
		}
	}

	// special redirects
	if(statStr == "DAMAGE") stat = STAT_MIN_DAMAGE; 
	if(statStr == "STAT_MOVEMENT_TYPE") stat = STAT_MAX_MOVEMENT;

	if(stat == STAT_MAX)
	{
		;
		return;
	}

	;

	mods = unit.GetStatModSourceList(stat);

	mHeroInfo.SetStatModSourceList(mods);
}

function BtnHireClicked(EventData data)
{
	;
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().RecruitHero( mCurrentHeroID );
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetMiddleHUD().SetupQuickBar(mTown);
}

function KillPopUp()
{
	mOpenedSkillwheel = false;
	mHallOfHerosPopup.Closed();
	super.ClosePopup();
}

function ClosePopup()
{
	local RecruitHeroData data;

	if(!mOpenedSkillwheel) 
	{
		ForEach currentHeroPool(data)
		{
			data.Army.GetHero().DeleteImage();
		}

		mHallOfHerosPopup.Closed();
		super.ClosePopup();
	}
	
	mOpenedSkillwheel = false;
}

function Closed()
{
	ClosePopup();
}

function H7GFxUIContainer GetPopup()
{
	return mHallOfHerosPopup;
}

