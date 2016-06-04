/*=============================================================================
* H7Obelisk
* =============================================================================
* 
* =============================================================================
*  Copyright 2015 Limbic Entertainment All Rights Reserved.
*  
*  
*  
* =============================================================================*/

class H7Obelisk extends H7VisitableSite
	implements(H7ITooltipable, H7INeutralable)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var(Sound) protected AKEvent mVisitingSound <DisplayName = On Visit Sound>;

// H7INeutralable implementation
function bool IsNeutral() { return true; }

event InitAdventureObject()
{
	super.InitAdventureObject();

	class'H7AdventureController'.static.GetInstance().IncrementObeliskCount();
}

function OnVisit( out H7AdventureHero hero )
{
	local string fctMessage;
	local int numOfPiecesRevealed;
	
	if( !hero.GetAbilityManager().HasAbility( class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaSpellTemplate ) )
	{
		if(hero.GetAbilityManager().LearnAbility( class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaSpellTemplate ) != none)
		{
			// OPTIONAL and/or notification
			fctMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_ABILITY","H7FCT");
			fctMessage = Repl(fctMessage, "%owner", hero.GetName());
			fctMessage = Repl(fctMessage, "%ability", class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaSpellTemplate.GetName());
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, Location, hero.GetPlayer(), fctMessage ,,class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaSpellTemplate .GetIcon() );
		}
	}

	if( !HasVisited( hero.GetPlayer() ) )
	{
		numOfPiecesRevealed = GetPiecesRevealedForNextVisit( hero.GetPlayer() ); // this visit right now
		
		hero.GetPlayer().AddVisitedObelisk( self );

		if(mVisitingSound != none)
		{
			class'H7SoundManager'.static.PlayAkEventOnActor(self,mVisitingSound,true,true,self.Location);
		}
		
		if( numOfPiecesRevealed > 1 )
		{
			fctMessage = class'H7Loca'.static.LocalizeSave("FCT_OBELISK_VISIT_PLURAL","H7FCT");
			fctMessage = Repl( fctMessage, "%num", numOfPiecesRevealed );
		}
		else
		{
			fctMessage = class'H7Loca'.static.LocalizeSave("FCT_OBELISK_VISIT","H7FCT");
		}
		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), fctMessage, MakeColor(255,255,0,255));

		if( hero.GetPlayer().IsControlledByLocalPlayer() && !hero.GetPlayer().IsControlledByAI() )
		{
			class'H7AdventureController'.static.GetInstance().SendTrackingTreasureHunt();
			class'H7TreasureHuntCntl'.static.GetInstance().OpenPopup();
		}
	}
	else
	{
		//tell the player he already has the piece from here
		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT"), MakeColor(255,255,0,255));
	}

	super.OnVisit( hero ); // triggers scripts and events that are blocked if popup was opened
}

// total pieces revealed atm, or after next visit
static function int GetPiecesRevealed(H7Player dasPlayer,optional bool forecast)
{
	local int numOfVisitableObelisks;
	local int numOfVisitedObelisks;
	
	numOfVisitableObelisks = Min(8,class'H7AdventureController'.static.GetInstance().GetAmountOfObelisks());
	numOfVisitedObelisks = dasPlayer.GetNumOfVisitedObelisks();
	
	if( forecast) { ++numOfVisitedObelisks; }

	if(numOfVisitedObelisks > numOfVisitableObelisks) return 8;
	if(numOfVisitedObelisks == 0) return 0;
	return FFloor(float(numOfVisitedObelisks)/float(numOfVisitableObelisks)*8.0f);
}

// diff pieces you get with the next visit
static function int GetPiecesRevealedForNextVisit( H7Player dasPlayer)
{
	local int piecesNow,piecesFuture;
	
	piecesNow = GetPiecesRevealed(dasPlayer);
	piecesFuture = GetPiecesRevealed(dasPlayer,true);
	
	return piecesFuture-piecesNow;
}

function bool HasVisited( H7Player dasPlayer )
{
	local array<H7Obelisk> obelisks;

	obelisks = dasPlayer.GetVisitedObelisks();

	if( obelisks.Find( self ) == INDEX_NONE )
	{
		return false;
	}
	else
	{
		return true;
	}
}


function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local string visited;
	local int numVisitedObelisks,numVisitableObelisks;

	numVisitedObelisks = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetNumOfVisitedObelisks();
	numVisitableObelisks = class'H7AdventureController'.static.GetInstance().GetAmountOfObelisks();

	if( HasVisited( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() ) )
	{
		visited = GetVisitString(true);
	}
	else
	{
		visited = GetVisitString(false);
	}

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description =  "<font size='#TT_BODY#'>" $ Repl(Repl(class'H7Loca'.static.LocalizeSave("TT_VISITED_OBELISKS","H7GFxActorTooltip"),"%current",numVisitedObelisks),"%max",numVisitableObelisks) $ "</font>";
	data.Visited = visited;

	return data;
}
