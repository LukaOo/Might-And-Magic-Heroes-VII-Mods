class H7GFxHeroHUD extends H7GFxUIContainer;

var protected GFxObject mData;
var array<H7AdventureHero> mHeroes;
var protected H7AdventureHero mPendingHero;

function SetHeroes(array<H7AdventureHero> heroes)
{
	if( class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInTownScreen() ) { return; }

	mHeroes = heroes;
	GetHud().SetTimer( 0.2f, false, nameof( SetHeroesDelayed ), self );
}

function SetHeroesDelayed()
{
	local GFxObject data;
	local GFxObject heroData;
	local H7AdventureHero hero;
	local int i;
	local array<H7BaseBuff> buffs;

	// remove old heroes listeners
	if( mData != none )
	{
		i = 0;
		while(mData.GetElementObject(i) != none)
		{
			class'H7ListeningManager'.static.GetInstance().RemoveListener(mData.GetElementObject(i));
			i++;
		}
	}
	
	data = CreateArray();
	i = 0;
	foreach mHeroes( hero )
	{
		heroData = CreateDataObject();
		
		hero.GUIWriteInto(heroData,LF_HERO_SLOT);
		hero.GUIAddListener(heroData);
		hero.GetBuffManager().GetActiveBuffs(buffs);
		heroData.SetObject( "Buffs", BuildBuffs(buffs));

		data.SetElementObject(i, heroData);
		i++;
	}

	;   
	if(mHeroes.Length == 0)
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().SetTownMode(true);
	}
	else if(!H7AdventureHud(GetHud()).GetTownHudCntl().IsInAnyScreen())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().SetTownMode(false);
	}

	mData = data;
	SetObject( "mData" , data);

	Update();
}

protected function Update()
{
	ActionscriptVoid("Update");
	
	//enable/disable heroButtons in commandPanel
	if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none)
		H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetAdventureHudCntl().GetCommandPanel().EnableHeroButtons(true);
	else
		H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetAdventureHudCntl().GetCommandPanel().EnableHeroButtons(false);
}

function SelectHeroByHero( H7AdventureHero hero ) 
{
	mPendingHero = hero;

	GetHud().SetTimer( 0.2f, false, nameof( SelectHeroByHeroDelayed ), self );
}

function SelectHeroByHeroDelayed() 
{
    if(mPendingHero == none)
	{
		SelectHero(-1,false);
	}
	else
	{
		SelectHero(mPendingHero.GetID(),mPendingHero.GetSkillPoints() > 0);
	}
}

private function SelectHero(int id, bool canSpendSkillPoints) // also automatically deselects all others
{
	;
	ActionscriptVoid("SelectHero");

	//enable/disable heroButtons in commandPanel
	if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none)
		H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetAdventureHudCntl().GetCommandPanel().EnableHeroButtons(true);
	else
		H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetAdventureHudCntl().GetCommandPanel().EnableHeroButtons(false);
}

// Returns the hero ID of the hero with HUD position index
function int HudPositionToHeroId(int index)
{
	if(index < 0 || index >= mHeroes.Length)
	{
		//`warn("Can't get hero ID for HUD slot no."@index);
		return -1;
	}

	return mHeroes[index].GetID();
}

function DisableMe()
{
	ActionScriptVoid("Disable");
}

function EnableMe()
{
	ActionScriptVoid("Enable");
}

protected function UpdateMovement( )
{
	ActionscriptVoid("UpdateMovement");
}

protected function GFxObject BuildBuffs(array<H7BaseBuff> buffs)
{
	local H7BaseBuff buff;
	local GFxObject list,tmp;
	local int i;
	
	i = 0;
	list = CreateArray();
	foreach buffs(buff)
	{
		if( buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() )
		{
			tmp = CreateObject("Object");
			tmp.SetBool( "BuffIsDisplayed", buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
			tmp.SetBool( "BuffIsDebuff", buff.IsDebuff() );
			tmp.SetString( "BuffName", buff.GetName() ); 
			tmp.SetString( "BuffTooltip", buff.GetTooltip() );
			tmp.SetString( "BuffIcon", buff.GetFlashIconPath() );
			tmp.SetInt( "BuffDuration", buff.GetDuration() );
			list.SetElementObject(i, tmp);
			i++;
		}
	}
	return list;
}
