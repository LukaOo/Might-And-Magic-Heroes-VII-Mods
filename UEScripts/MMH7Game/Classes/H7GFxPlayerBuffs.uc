//=============================================================================
// H7GFxPlayerBuffs
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxPlayerBuffs extends H7GFxUIContainer;

var GFxObject mData;

function SetPlayer(H7Player player)
{	
	if(player!=None)
	{
		ListenTo(player);
		Update(player);
	}
}

function Update(H7Player player)
{
	local array<H7BaseBuff> buffs;
	local H7BaseBuff buff;
	local int i;

	mData = CreateArray();

	player.GetBuffManager().GetActiveBuffs(buffs);
	foreach buffs(buff,i)
	{
		mData.SetElementObject(i,CreateBuffObject(buff));
	}

	SetObject("mData",mData);
	ActionScriptVoid("Update");
}

function GFxObject CreateBuffObject(H7BaseBuff buff)
{
	local GFxObject ob;
	ob = CreateObject("Object");
	ob.SetBool( "BuffIsDisplayed", buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
	ob.SetBool( "BuffIsDebuff", buff.IsDebuff() );
	ob.SetString( "BuffName", buff.GetName() ); 
	ob.SetString( "BuffTooltip", buff.GetTooltip() );
	ob.SetString( "BuffIcon", buff.GetFlashIconPath() );
	ob.SetInt( "BuffDuration", buff.GetCurrentDuration() );

	// for tooltip:
	ob.SetString( "AbilityName", buff.GetName() );
	ob.SetString( "AbilityDesc", buff.GetTooltip() );

	return ob;
}

// needs to be implemented by the child gui element
function ListenUpdate(H7IGUIListenable ob)
{
	local H7Player player;
	player = H7Player(ob);
	Update(player);
}
