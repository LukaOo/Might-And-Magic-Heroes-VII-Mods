/*=============================================================================
* H7ResourceDepot
* =============================================================================
*  Class for adventure map objects that serve as resource depots.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7ResourceDepot extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	dependson(H7ITooltipable)
	hidecategories(Defenses)
	placeable
	native
	savegame;

var(Developer) protected archetype H7BaseAbility mAbility<DisplayName=Ability to trigger>;

var         protected savegame bool     mIsHidden;

native function bool IsHiddenX();

event InitAdventureObject()
{
	super.InitAdventureObject();

	if(!class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame())
	{
		if( mAbility != none )
		{
			GetAbilityManager().LearnAbility( mAbility );
		}
	}
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	if( !CanBeVisited() )
	{
		AlreadyVisited(hero);
		
		if(mOnVisitSound!=None)
		{
			class'H7SoundController'.static.PlayGlobalAkEvent(mOnVisitSound,true);
		}

		return;
	}
	// this gives the buff
	super.OnVisit( hero );
}

function AlreadyVisited(H7AdventureHero hero)
{
	local Vector HeroMsgOffset;

	HeroMsgOffset = Vect(0,0,600);
	class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT") , MakeColor(255,255,0,255));
}

function bool CanBeVisited()
{
	local array<H7BaseBuff> currentBuffsActive;
	self.GetBuffManager().GetActiveBuffs( currentBuffsActive );
	if( currentBuffsActive.Length == 0 )
	{
		return true;
	}
	return false;
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local string visited;

	if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none )
	{
		if( !CanBeVisited() )
			visited = GetVisitString(true);
		else
			visited = GetVisitString(false);
	}
	
	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>";
	data.Description = data.Description $ mAbility.GetTooltip() $ "</font>";
	data.Visited = visited;

	return data;
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
	super.PostSerialize();

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
