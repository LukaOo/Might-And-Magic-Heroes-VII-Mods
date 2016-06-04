/*=============================================================================
* H7AreaOfControlSiteLord
* =============================================================================
*  Class for adventure map objects that are owned by other sites in an Area of 
*  Control.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7AreaOfControlSiteVassal extends H7AreaOfControlSite
	hideCategories(Defenses)
	native
	placeable;

var protected savegame H7AreaOfControlSiteLord mLord;

function H7AreaOfControlSiteLord GetLord() { return mLord; }

function OnVisit(out H7AdventureHero hero)
{
	local Vector HeroMsgOffset;

	HeroMsgOffset = Vect(0,0,600);

	// been there, done that
	if( GetPlayer() == hero.GetPlayer() && self.IsA('H7BuffSite') )
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FTC_ALREADY_CAPTURED","H7FCT") , MakeColor(255,255,0,255));
	}

	super.OnVisit(hero);

	mHeroEventParam.mEventHeroTemplate = hero.GetAdventureArmy().GetHeroTemplateSource();
	mHeroEventParam.mEventPlayerNumber = hero.GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventSite = self;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_VisitDwellingMine', mHeroEventParam, hero.GetAdventureArmy());
}

function bool SpendPickupCostsOnVisit(H7AdventureHero visitingHero)
{
	if(visitingHero != none && mLord != none
		&& (mLord.GetPlayerNumber() == PN_NEUTRAL_PLAYER || mLord.GetPlayer() == visitingHero.GetAdventureArmy().GetPlayer())
		&& GetPlayer().IsPlayerHostile( visitingHero.GetAdventureArmy().GetPlayer()))
	{
		// dude wants to conquer this
		return true;
	}

	return false;
}

protected function HandleOwnership( H7AdventureHero visitingHero)
{
	local H7Player currentPlayer;
	local array<H7BaseAbility> governorAbilities;
	local H7BaseAbility ability;
	local H7EventContainerStruct container;

	super.HandleOwnership( visitingHero );

	currentPlayer = visitingHero.GetPlayer();

	// Capture the Vassal only if its Lord is neutral or owned by the capturing player and the Vassal is unguarded
	;
	if( (mLord == none || mLord.GetPlayerNumber() == PN_NEUTRAL_PLAYER || mLord.GetPlayer() == currentPlayer || mLord.GetPlayer().IsPlayerAllied( currentPlayer ) ))
	{
		;
		if( GetPlayerNumber() == PN_NEUTRAL_PLAYER && ( mLord != none && mLord.GetPlayer().IsPlayerAllied( currentPlayer ) || mLord == none ) )
		{
			// pay pickup costs for capturing vassal
			visitingHero.UseMovementPoints(visitingHero.GetModifiedStatByID(STAT_PICKUP_COST));
			if( mLord == none )
			{
				SetSiteOwner( currentPlayer.GetPlayerNumber() );
			}
			else
			{
				SetSiteOwner( mLord.GetPlayerNumber() );
			}

			// If hostile hero is an owner of control site lord -> Force Update buffs from lord
			if(H7Town(mLord) != none && H7Town(mLord).GetGovernor() != none)
			{
				container.Targetable = H7Town(mLord);

				governorAbilities = H7Town(mLord).GetGovernor().GetGovernorAbilities();
				foreach governorAbilities(ability)
				{
					ability.GetEventManager().Raise(ON_GOVERNOR_ASSIGN, false, container);
				}
			}
		}
		else if( GetPlayer().IsPlayerHostile( currentPlayer ) )
		{
			// pay pickup costs for capturing vassal
			visitingHero.UseMovementPoints(visitingHero.GetModifiedStatByID(STAT_PICKUP_COST));
			SetSiteOwner( currentPlayer.GetPlayerNumber() );

			// If hostile hero is an owner of control site lord -> Force Update buffs from lord
			if(mLord != none && mLord.GetPlayer().GetPlayerNumber() == currentPlayer.GetPlayerNumber() && H7Town(mLord) != none && H7Town(mLord).GetGovernor() != none)
			{
				container.Targetable = H7Town(mLord);

				governorAbilities = H7Town(mLord).GetGovernor().GetGovernorAbilities();
				foreach governorAbilities(ability)
				{
					ability.GetEventManager().Raise(ON_GOVERNOR_ASSIGN, false, container);
				}
			}
		}
	}
}


function RenderDebugInfo( Canvas myCanvas )
{
	local Color textColor, bgColor;
	local Font textFont;
	local Vector textLocation;
	local float textLength, textHeight;
	local string displayText, lordName;

	textColor.A = 255;

	bgColor.R = 255;
	bgColor.G = ( mLord == none ) ? 255 : 128;
	bgColor.B = ( mLord == none ) ? 255 : 0;
	bgColor.A = 255;

	textFont = Font'enginefonts.TinyFont';
	myCanvas.Font = textFont;
	myCanvas.DrawColor = textColor;

	lordName = ( mLord == none ) ? "Free" : mLord.GetName();

	displayText = " Name: " @ mName @ " | " @ "Ownership: " @ lordName @ " ";
	
	myCanvas.StrLen( displayText, textLength, textHeight );
	textLocation = myCanvas.Project( self.Location );
	textLocation.X -= textLength / 2;

	myCanvas.SetPos( textLocation.X, textLocation.Y );
	myCanvas.DrawColor = bgColor;
	myCanvas.DrawRect(textLength, textHeight);
	
	myCanvas.SetPos( textLocation.X, textLocation.Y );
	myCanvas.DrawColor = textColor;
	myCanvas.DrawText( displayText );
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

