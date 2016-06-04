/*=============================================================================
* H7FortuneTeller
* 
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7FortuneTeller extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var protected savegame bool mIsHidden;

native function bool IsHiddenX();

function OnVisit(out H7AdventureHero hero)
{
	local H7Week week;
	local string popUpMessage;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	week = class'H7AdventureController'.static.GetInstance().GetCalendar().GetNextWeek();

	popUpMessage = "<br></br>";
	popUpMessage = popUpMessage $ "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("PU_FORTUNE_TELLER","H7PopUp") $ "</font>\n";
	popUpMessage = Repl( popUpMessage,"%week", week.GetName() );
	popUpMessage = Repl( popUpMessage,"%description", week.GetDescription() );

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().MessagePopup(self.GetName(), popUpMessage);

	super.OnVisit(hero);
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_FORTUNE_TELLER","H7AdvMapObjectToolTip") $ "</font>\n";

	return data;
}

function Hide()
{
	mIsHidden=true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden=false;
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

