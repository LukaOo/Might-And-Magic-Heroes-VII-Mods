/*=============================================================================
 * H7VisitingShell
 * 
 * TODO: Serialization
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
===========================================================================*/
class H7VisitingShell extends H7VisitableSite implements(H7ITooltipable, H7IHideable)
	native
	placeable
	dependson(H7IPickable,H7ITooltipable, H7StructsAndEnumsNative)
	savegame;
	
var protected savegame bool mIsHidden;

// Appearance on the adventure map.
var(Properties) protected editoronly archetype StaticMesh mAppearance<DisplayName="Appearance">;
// State at the start of the map.
var(Properties) protected savegame bool mIsActive<DisplayName="Active">;
// Description text for active state tooltip.
var(Properties) protected localized string mDescription<DisplayName="Active Description">;
// Description text for inactive state tooltip.
var(Properties) protected localized string mDescriptionInactive<DisplayName="Inactive Description">;
// Progressing quest condition to include in the tooltip
var(Developer) protected H7IProgressable mProgressable<DisplayName="Progressing Quest Condition">;

var protected transient string mDescriptionInst;
var protected transient string mDescriptionInactiveInst;

native function bool IsHiddenX();
native function OnTerrainChange(LandscapeLayerInfoObject newLayer, LandscapeProxy newLandscape);

function bool IsActive() { return mIsActive; }
function SetActive(bool val) { mIsActive = val; }

function string	GetDescription()
{
	if(Len(mDescriptionInst) == 0)
	{
		mDescriptionInst = class'H7Loca'.static.LocalizeMapObject(self, "mDescription", mDescription);
	}
	return mDescriptionInst;
}

function string	GetDescriptionInactive()
{
	if(Len(mDescriptionInactiveInst) == 0)
	{
		mDescriptionInactiveInst = class'H7Loca'.static.LocalizeMapObject(self, "mDescriptionInactive", mDescriptionInactive);
	}
	return mDescriptionInactiveInst;
}


function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	if(mHideMeshAndFX)
	{
		SetVisibility(!mIsHidden);
	}
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	if(mHideMeshAndFX)
	{
		SetVisibility(!mIsHidden);
	}
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event InitAdventureObject()
{
	super.InitAdventureObject();
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() )
	{
		return;
	}

	super.OnVisit( hero );

	class'H7ScriptingController'.static.GetInstance().UpdateSiteVisit(self, hero.GetPlayer().GetPlayerNumber());

	mHeroEventParam.mEventHeroTemplate = hero.GetAdventureArmy().GetHeroTemplateSource();
	mHeroEventParam.mEventPlayerNumber = hero.GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventSite = self;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_VisitShell', mHeroEventParam, hero.GetAdventureArmy());
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	if(mIsActive && mDescription != "")
	{
		data.Description = "<font size='#TT_BODY#'>" $ GetDescription() $ "</font>";
	}
	else if(!mIsActive && mDescriptionInactive != "")
	{
		data.Description = "<font size='#TT_BODY#'>" $ GetDescriptionInactive() $ "</font>";
	}

	if(mProgressable != none)
	{
		progresses = mProgressable.GetCurrentProgresses();
		if(progresses.Length > 0)
		{
			data.Description= data.Description $ "<font size='#TT_BODY#'>";
			foreach progresses(progress)
			{
				data.Description = data.Description $ "\n" $ progress.ProgressText;
			}
			data.Description = data.Description $ "</font>";
		}
	}

	return data;
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

