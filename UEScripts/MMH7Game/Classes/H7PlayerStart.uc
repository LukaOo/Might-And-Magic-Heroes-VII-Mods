/*=============================================================================
 * H7PlayerStart
 * 
 * 1x1 tile object as placeholder for the starting hero of players.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7PlayerStart extends H7EditorMapObject
	hideCategories(Editor)
	implements(H7DynGridObjInterface, H7IOwnable)
	native
	placeable;

var(Properties) private EPlayerNumberWithoutNeutral mPlayer<DisplayName="Player">;

var private editoronly MaterialInstanceConstant mPlayerColorMaterials[10];

var protected bool mIsValid;

native function EPlayerNumber GetPlayerNumber();
native function SetPlayerNumber(EPlayerNumber playerNumber);

public function Hatch()
{
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell pointingCell;
	local array<H7EditorHero> allHeroes;
	local array<H7EditorHero> forbiddenHeroes;
	local array<H7EditorHero> factionHeroes;
	local H7EditorHero hero;
	local H7Faction faction;
	local H7TransitionData transition;

	transition = class'H7TransitionData'.static.GetInstance();

	hero = transition.GetPlayerStartHeroDuringGameTime(GetPlayerNumber());
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	forbiddenHeroes = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(GetPlayerNumber()).GetForbiddenHeroes();

	if(hero == none)
	{
		faction = transition.GetPlayerFactionDuringGameTime(GetPlayerNumber());
		class'H7GameData'.static.GetInstance().GetHeroes(allHeroes);
		foreach allHeroes(hero)
		{
			if(hero != none && hero.GetFaction() == faction && forbiddenHeroes.Find(hero) == -1)
			{
				factionHeroes.AddItem(hero);
			}
		}
		hero = factionHeroes[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(factionHeroes.Length)];
	}

	if(hero != none && gridManager != none)
	{
		pointingCell = gridManager.GetCellByWorldLocation( self.Location );

		if(pointingCell != none && !pointingCell.IsBlocked() && mIsValid)
		{
			H7AdventurePlayerController(class'H7PlayerController'.static.GetPlayerController()).SpawnArmy(pointingCell,
				int(GetPlayerNumber()), self.Rotation, hero, true);

		}
	}

	Destroy();
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

