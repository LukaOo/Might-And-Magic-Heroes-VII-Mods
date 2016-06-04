/*=============================================================================
* H7SignPostBuoy
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7SignPostBuoy extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame
	perobjectconfig;

/** The headline of the sign. */
var(Properties) protected localized string mHeadline<DisplayName="Enter headline">;
/** The message of the sign. */
var(Properties) protected localized string mMessage<DisplayName="Enter message text">;
var protected savegame bool mIsHidden;

var protected transient string mHeadlineInst;
var protected transient string mMessageInst;

native function bool IsHiddenX();

function string GetHeadline()
{
	if(mGlobalName == none || Len(mHeadline) > 0)
	{
		if(Len(mHeadlineInst) == 0)
		{
			mHeadlineInst = class'H7Loca'.static.LocalizeMapObject(self, "mHeadline", mHeadline);
		}
		return mHeadlineInst;
	}
	else
	{
		return mGlobalName.GetName();
	}
}

function string GetMessage()
{
	if(Len(mMessageInst) == 0 && Len(mMessage) > 0)
	{
		mMessageInst = class'H7Loca'.static.LocalizeMapObject(self, "mMessage", mMessage);
	}
	return mMessageInst;
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	if( hero.GetPlayer().IsControlledByLocalPlayer() )
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().MessagePopup(GetHeadline(),GetMessage());
	}

	super.OnVisit(hero);
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetHeadline();
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

