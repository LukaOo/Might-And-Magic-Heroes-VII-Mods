/*=============================================================================
* H7Keymaster
* =============================================================================
* 
* =============================================================================
*  Copyright 2014 Limbic Entertainment All Rights Reserved.
*  
*  
*  
* =============================================================================*/

class H7Keymaster extends H7VisitableSite
	implements(H7ITooltipable, H7INeutralable)
	dependson(H7ITooltipable)
	placeable
	native;

var(Key) protected EPlayerColor mKeyColor;
var(Sound) protected AKEvent mVisitingSound <DisplayName = On Visit Sound>;

// H7INeutralable implementation
function bool IsNeutral() { return true; }

function OnVisit( out H7AdventureHero hero )
{
	super.OnVisit( hero );

	if( !HasVisited( hero.GetPlayer() ) )
	{
		hero.GetPlayer().AddVisitedKeymaster( mKeyColor );
		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("TT_VISITED","H7General"), MakeColor(255,255,0,255));
		
		if(mVisitingSound != none)
		{
			class'H7SoundManager'.static.PlayAkEventOnActor(self,mVisitingSound,true,true,self.Location);
		}
	}
	else
	{
		//tell the player he already has the key from here
		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT"), MakeColor(255,255,0,255));
	}
}

function bool HasVisited( H7Player dasPlayer )
{
	local array<EPlayerColor> colors;

	colors = dasPlayer.GetVisitedKeymasters();

	if( colors.Find( mKeyColor ) == INDEX_NONE )
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
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_ALTAR","H7AdvMapObjectToolTip") $ "</font>";
	data.Visited = visited;

	return data;
}
