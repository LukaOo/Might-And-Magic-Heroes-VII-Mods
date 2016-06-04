//=============================================================================
// H7StatIcons.uc
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7StatIcons extends Object
	hideCategories(Object);

var(Icons) protected Texture2D mAttack<DisplayName=Attack>;
var(Icons) protected Texture2D mMagic<DisplayName=Magic>;
var(Icons) protected Texture2D mSpirit<DisplayName=Spirit>;
var(Icons) protected Texture2D mDefense<DisplayName=Defense>;
var(Icons) protected Texture2D mMoral<DisplayName=Moral>;
var(Icons) protected Texture2D mLuck<DisplayName=Luck>;
var(Icons) protected Texture2D mDestiny<DisplayName=Destiny>;
var(Icons) protected Texture2D mLeadership<DisplayName=Leadership>;
var(Icons) protected Texture2D mArcaneKnowledge<DisplayName=Arcane Knowledge>;
var(Icons) protected Texture2D mMovementPoints<DisplayName=Movement Points>;
var(Icons) protected Texture2D mInitiative<DisplayName=Initiative>;
var(Icons) protected Texture2D mRange<DisplayName=Range>;
var(Icons) protected Texture2D mMana<DisplayName=Mana>;
var(Icons) protected Texture2D mHealth<DisplayName=Health>;
var(Icons) protected Texture2D mExpRate<DisplayName=Exp Rate>;
var(Icons) protected Texture2D mExp<DisplayName=Exp>;

var(Icons) protected Texture2D mWalk<DisplayName=Walk>;
var(Icons) protected Texture2D mFly<DisplayName=Fly>;
var(Icons) protected Texture2D mTeleport<DisplayName=Teleport>;
var(Icons) protected Texture2D mGhostwalk<DisplayName=Ghostwalk>;
var(Icons) protected Texture2D mStatic<DisplayName=Static>;

static function H7StatIcons GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIcons; }
static function H7StatIcons GetInstanceForText() { return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIconsInText; }

function Texture2D GetStatIcon( EStat stat, optional H7Unit unit=none )
{
	switch( stat )
	{
		case STAT_ATTACK: return mAttack;
		case STAT_MAGIC: return mMagic;	
		case STAT_SPIRIT: return mSpirit;
		case STAT_DEFENSE: return mDefense;
		case STAT_LUCK_DESTINY: return (unit != none && unit.GetEntityType() == UNIT_HERO)? mDestiny : mLuck;
		case STAT_MORALE_LEADERSHIP: return (unit != none && unit.GetEntityType() == UNIT_HERO)? mLeadership : mMoral;		
		case STAT_FOREIGN_MORALE_PENALTY_MODIFIER: return mMoral;
		case STAT_MAX_MOVEMENT: 
		case STAT_CURRENT_MOVEMENT:
			return mMovementPoints;
		case STAT_RANGE: return mRange;
		case STAT_HEALTH: return mHealth;
		case STAT_INITIATIVE: return mInitiative;
		case STAT_MANA_COST:
		case STAT_MANA: return mMana;
		case STAT_CURRENT_MANA: return mMana;
		case STAT_MANA_REGEN: return mMana;
		case STAT_XP_RATE: return mExpRate;
		case STAT_CURRENT_XP: return mExp;
		case STAT_ARCANE_KNOWLEDGE: return mArcaneKnowledge;
		case STAT_MIN_DAMAGE:
		case STAT_MAX_DAMAGE:
			// not defined
			break;
	}

	;
	return none;
}

function Texture2D GetStatIconByStr(string stat)
{
	local int i;
	local EStat statEnum;
	if(Caps(stat) == Caps("stat_LEADERSHIP")) return mLeadership;
	if(Caps(stat) == Caps("stat_morale") || Caps(stat) == Caps("stat_moral")) return mMoral;
	if(Caps(stat) == Caps("STAT_LUCK")) return mLuck;
	if(Caps(stat) == Caps("STAT_DESTINY")) return mDestiny;
	if(Caps(stat) == Caps("STAT_ARCANE_KNOWLEDGE")) return mArcaneKnowledge; // why is this needed, should be handled by the loop
	if(Caps(stat) == Caps("STAT_XP")) return mExp;
	if(Caps(stat) == Caps("STAT_MIGHT")) return mAttack;
	if(Caps(stat) == Caps("STAT_movement")) return mMovementPoints;
	for(i=0;i<STAT_MAX;i++)
	{
		if(Caps(String(GetEnum(Enum'EStat',i))) == Caps(stat))
		{
			statEnum = EStat(i);
			return GetStatIcon(statEnum);
		}
	}
	return none;
}

function String GetStatIconPath(EStat stat, optional H7Unit unit = none)
{
	local Texture2D tex;
	tex = GetStatIcon(stat,unit);
	return "img://" $ PathName( tex );
}

function string GetStatIconPathHTML(EStat stat, optional H7Unit unit = none)
{
	local string path;
	path = GetStatIconPath(stat,unit);
	return "<img src='" $ path $ "' width='#TT_POINT#' height='#TT_POINT#'>";
}

function String GetMovementIconString(EMovementType type)
{
	switch(type)
	{
		case CMOVEMENT_WALK      : return "img://" $ Pathname( mWalk );
		case CMOVEMENT_FLY       : return "img://" $ Pathname( mFly );
		case CMOVEMENT_TELEPORT  : return "img://" $ Pathname( mTeleport );
		case CMOVEMENT_GHOSTWALK : return "img://" $ Pathname( mGhostwalk );
		case CMOVEMENT_STATIC    : return "img://" $ Pathname( mStatic );
	}
}

function String GetLuckIconString()         { return "img://" $ Pathname( mLuck ); }
function String GetDestinyIconString()      { return "img://" $ Pathname( mDestiny ); }
function String GetMoralIconString()        { return "img://" $ Pathname( mMoral ); }
function String GetLeadershipIconString()   { return "img://" $ Pathname( mLeadership ); }
