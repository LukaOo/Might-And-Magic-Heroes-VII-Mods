//=============================================================================
// H7MainMenuInfo
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MainMenuInfo extends H7GameInfo;

static function H7MainMenuInfo GetInstance() { return H7MainMenuInfo( class'WorldInfo'.static.GetWorldInfo().Game ); }

event InitGame(string Options, out string ErrorMessage)
{
	Super.InitGame(Options, ErrorMessage);
}

event LocalPlayer GetLP()
{
	local Engine Eng;
	local int LocalPlayerOwnerIndex;	
	
	Eng = class'Engine'.static.GetEngine();
	LocalPlayerOwnerIndex = Eng.GamePlayers.Find(LocalPlayer(GetALocalPlayerController().Player)); 
    
	if(LocalPlayerOwnerIndex == INDEX_NONE)
	{
		LocalPlayerOwnerIndex = 0;
	}

	//If it is an INDEX_NONE, try the default player
	if (LocalPlayerOwnerIndex < 0)
	{
		LocalPlayerOwnerIndex = 0;
	}
	//If it is completely invalid return none
	else if  (LocalPlayerOwnerIndex >= Eng.GamePlayers.Length)
	{
		return none;
	}
	return  Eng.GamePlayers[LocalPlayerOwnerIndex];
}

/** Stubbed out so we don't spawn a player in the menus */
function RestartPlayer(Controller NewPlayer);

// Singleplayer
function StartSkirmish(string MapName)
{
	local string URL;
	
	;

	if(Len(MapName) > 0)
	{
		URL = MapName;
		// Transition to being the party host without notifying clients and traveling absolute
		class'H7ReplicationInfo'.static.GetInstance().StartMap(URL);
	}
}

