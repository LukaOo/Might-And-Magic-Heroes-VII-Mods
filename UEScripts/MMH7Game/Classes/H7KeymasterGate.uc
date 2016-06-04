/*=============================================================================
* H7KeymasterGate
* =============================================================================
* 
* =============================================================================
*  Copyright 2014 Limbic Entertainment All Rights Reserved.
*  
*  
*  
* =============================================================================*/

class H7KeymasterGate extends H7VisitableSite
	implements(H7ITooltipable, H7INeutralable)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var(Key) protected EPlayerColor         mKeyColor;
var(Visuals) protected ParticleSystem   mUnlockedParticle;
var protected savegame bool             mUnlocked;
var(Audio)protected AkEvent             mOnVisitSound <DisplayName=On Unlock Sound>;


// H7INeutralable implementation
function bool IsNeutral() { return true; }

function OnVisit( out H7AdventureHero hero )
{
	super.OnVisit( hero );

	if( CanUnlock( hero.GetPlayer() ) || mUnlocked )
	{
		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_KEYMASTER_GATE_HAS_KEY","H7FCT"), MakeColor(255,255,0,255));
		if( !mUnlocked )
		{
			mFX.DeactivateSystem();

			mFX.SetTemplate( mUnlockedParticle );
			mFX.ActivateSystem( true );
			mUnlocked = true;

			if(hero.GetPlayer().IsControlledByLocalPlayer())
			{
				PlayAkEvent(mOnVisitSound,true);
			}
		}
	}
	else
	{
		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_KEYMASTER_GATE_NO_KEY","H7FCT"), MakeColor(255,255,0,255));
	}
}

function bool CanPass( H7Player dasPlayer ) 
{
	return mUnlocked;
}

function bool CanUnlock( H7Player dasPlayer ) 
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
	local string passable;

	if( CanPass( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() ) )
	{
		passable = "<font color='#00ff00' size='22'>"$class'H7Loca'.static.LocalizeSave("TT_KEYMASTER_PASSABLE","H7Adventure")$"</font>";
	}
	else if(CanUnlock( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() ) )
	{
		passable = "<font color='#00ff00' size='22'>"$class'H7Loca'.static.LocalizeSave("TT_KEYMASTER_VISITABLE","H7Adventure")$"</font>";
	}
	else
	{
		passable =  "<font color='#999999' size='22'>"$class'H7Loca'.static.LocalizeSave("TT_KEYMASTER_IMPASSABLE","H7Adventure")$"</font>";
	}

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_SEAL","H7AdvMapObjectToolTip") $ "</font>";
	data.Visited = passable;

	return data;
}

event PostSerialize()
{
	if( mUnlocked )
	{
		mFX.SetTemplate( mUnlockedParticle );
		mFX.ActivateSystem( true );
	}
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
