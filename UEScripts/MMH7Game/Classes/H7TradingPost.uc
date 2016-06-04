class H7TradingPost extends H7NeutralSite
	implements(H7ITooltipable)
	hidecategories(Defenses);

var(Developer) protected H7TradingTable mTradingTable<DisplayName="Trading Table">;
var(Developer) protected Texture2D      mFactionSymbol<DisplayName="Neutral faction icon">;

function H7TradingTable GetTradingTable()     {return mTradingTable;}
function String         GetFactionSepiaIconPath()  { return "img://" $ Pathname( mFactionSymbol );}

event InitAdventureObject()
{
	super.InitAdventureObject();
}

function OnVisit(out H7AdventureHero hero)
{
	local Vector2d newResFlash;

	if(hero.GetPlayer().GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
	{
		;

		// auto fullscreen
		newResFlash = class'H7PlayerController'.static.GetPlayerController().GetScreenResolution();
		newResFlash = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMarketPlaceCntl().UnrealPixels2FlashPixels(newResFlash);
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMarketPlaceCntl().GetPopup().RealignAdventureMap(newResFlash.x,newResFlash.y);
		
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMarketPlaceCntl().UpdateFromTradingPost(self);
	}

	super.OnVisit(hero);
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	
	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>"$Localize("H7Adventure","TT_TRADING_POST_DESC", "MMH7Game" )$"</font>";

	return data;
}

