/*=============================================================================
H7AreaOfControlBuffSite - The only one seems to be Lighthouse, lighthouse is hardcoded in the tooltip
* =============================================================================
*  Class for a adventure map object, the AoC Buffsite.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7AreaOfControlBuffSite extends H7AreaOfControlSiteVassal
	implements(H7ITooltipable)
	dependson(H7ITooltipable)
	placeable
	native;

/** Type of Buff which is provided to every players hero, when the Lighthouse is in the players AOC and under his control */
var(Buff) protected archetype H7BaseBuff mBuff<DisplayName=Increased Sea Movement Buff>;
var(Buff) protected int mPlunderingDelay<DisplayName=Delay after visit|ClampMin=0|ClampMax=50>;
var protected H7Flag mPlunderFlag;
var protected int mDelay;

var(Audio) protected AkEvent mOnCaptureSound<DisplayName = Capture sound>;
var(Audio) protected AkEvent mAlreadyVisitedSound<DisplayName = Already visited sound>;

function OnVisit(out H7AdventureHero hero)
{
	super.OnVisit(hero);

	if(mDelay <= 0 && hero.GetPlayer().GetPlayerNumber() == mSiteOwner)
	{
		ProvideBuffToAllPlayerHeroes(hero.GetPlayer());
	}
}

function AddPlunderFlag()
{
	local Vector flagLocation;

	// creating the flag
	mPlunderFlag = Spawn( class'H7Flag', GetFlag() ,,, Rotation );
	mPlunderFlag.SetScale( 5.0f );
	mPlunderFlag.SetBase( GetFlag() );
	flagLocation.Y -= 50;
	mPlunderFlag.InitLocation( flagLocation );
	
	mPlunderFlag.SetSymbol( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mSiteOwner).GetFaction().GetFactionSepiaIcon() );

	if( GetPlayer() != none )
	{
		mPlunderFlag.SetColor( GetPlayer().GetColor() );
	}
}

function RemovePlunderFlag()
{
	mPlunderFlag.Destroy();
	mPlunderFlag = none;
}

event InitAdventureObject()
{
	super.InitAdventureObject();

	class'H7AdventureController'.static.GetInstance().AddAoCBuffSite( self );
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local String explainStr;
	local H7Player player;
	local H7AdventureHero hero;

	player = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetPlayer();
	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();

	data.Title = GetName();
	// we have only the hardcoded lighthouse tooltip as description of this class :-/
	explainStr = Repl(class'H7Loca'.static.LocalizeSave("TT_NON_PERMANENT_BUFF_SITE","H7AdvMapObjectToolTip"),"%buff", "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ mBuff.GetName() $ "</font>");
	// explainStr = explainStr $ mBuff.GetTooltip(); // technically buff tooltips can no longer be used to explain the building!

	data.Description = 	"<font size='#TT_BODY#'> " $ explainStr $ "</font>";

	if(!CanBeVisitedByPlayer(player) && mSiteOwner == player.GetPlayerNumber() && mDelay > 1)
	{
		data.Visited = "<font size='22' color='#ff0000'>" $ Repl(class'H7Loca'.static.LocalizeSave("TT_NOT_AVAILABLE_DAYS","H7AdvMapObjectToolTip"),"%i",mDelay) $ "</font>";
	}
	else if(!CanBeVisitedByPlayer(player) && mSiteOwner == player.GetPlayerNumber() && mDelay == 1)
	{
		data.Visited = "<font size='22' color='#ff0000'>" $ Repl(class'H7Loca'.static.LocalizeSave("TT_NOT_AVAILABLE_DAY","H7AdvMapObjectToolTip"),"%i",mDelay) $ "</font>";
	}
	else if (!CanBeVisitedByPlayer(player))
	{
		data.Visited = "<font size='22' color='#ff0000'>" $(class'H7Loca'.static.LocalizeSave("TT_NOT_OWNER","H7AdvMapObjectToolTip")) $ "</font>";
	}
	else if(CanBeVisitedByPlayer(player) && hero.GetBuffManager().HasBuff(mBuff, hero, false) && mSiteOwner == player.GetPlayerNumber())
	{
		data.Visited = "<font size='22' color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_VISITED","H7General") $ "</font>";
	}
	else if(CanBeVisitedByPlayer(player) && !hero.GetBuffManager().HasBuff(mBuff, hero, false))
	{
		data.Visited = "<font size='22' color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_AVAILABLE","H7AdvMapObjectToolTip") $ "</font>";
	}

	return data;
}

function bool CanBeVisitedByPlayer(H7Player player)
{
	if(mDelay > 0) return false;

	if(GetLord() == none ) return true; //If its not connected to a aoc it can be visited by anybody

	if(GetLord().GetPlayerNumber() == PN_NEUTRAL_PLAYER)
	{ 
		return false; // Buff can only be applied when the AoC is under control of the player
	}    
	else if(GetLord().GetPlayer().IsPlayerHostile(player))
	{ 
		return false; // Buff can only applied to the player which is controlling the site
	} 

	return true;
}

function SetSiteOwner( EPlayerNumber newOwner, optional bool showPopup = true  )   
{
	local H7Player tmpPlayer;

	if(mSiteOwner == newOwner)
	{
		return; // Already owned
	}

	;

	// Remove the buff from all heroes of the last owner
	if( mSiteOwner != PN_NEUTRAL_PLAYER )
	{
		tmpPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner );
		RemoveBuffofAllPlayerHeroes (tmpPlayer);
	}
	
	// --------
	super.SetSiteOwner(newOwner,showPopup);
	// --------

	// Provide all heroes of the new owner with the buff
	tmpPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( newOwner );
	ProvideBuffToAllPlayerHeroes(tmpPlayer);
}

function ProvideBuffToAllPlayerHeroes (H7Player player)
{
	local H7AdventureHero hero;
	local Array<H7AdventureHero> playerHeroes;
	local H7Player tmpPlayer;

	tmpPlayer = player;
	playerHeroes = tmpPlayer.GetHeroes();

	foreach playerHeroes(hero)
	{
		hero.GetBuffManager().AddBuff(mBuff, self);
	}

	mDelay = mPlunderingDelay;
	AddPlunderFlag();
}

function RemoveBuffofAllPlayerHeroes (H7Player player)
{
	local H7AdventureHero hero;
	local Array<H7AdventureHero> playerHeroes;
	local H7Player tmpPlayer;

	tmpPlayer = player;
	playerHeroes = tmpPlayer.GetHeroes();

	foreach playerHeroes(hero)
	{
		hero.GetBuffManager().RemoveBuff(mBuff, self);
	}
}

function UpdatePlunderDelay()
{

	if( mDelay <= 0 ) { return; }
	
	mDelay--;
	;
	
	if( mDelay == 0 )
	{
		;
		RemovePlunderFlag();
	}
}
