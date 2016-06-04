//=============================================================================
// H7MagicSchoolIcons.uc
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7MagicSchoolIcons extends Object
	hideCategories(Object);

var(Icons) protected Texture2D mMight<DisplayName=Might>;
var(Icons) protected Texture2D mAirMagic<DisplayName=Air Magic>;
var(Icons) protected Texture2D mDarkMagic<DisplayName=Dark Magic>;
var(Icons) protected Texture2D mEarthMagic<DisplayName=Earth Magic>;
var(Icons) protected Texture2D mFireMagic<DisplayName=Fire Magic>;
var(Icons) protected Texture2D mLightMagic<DisplayName=Light Magic>;
var(Icons) protected Texture2D mPrimeMagic<DisplayName=Prime Magic>;
var(Icons) protected Texture2D mWaterMagic<DisplayName=Water Magic>;
var(Icons) protected Texture2D mNoneSchool<DisplayName=No School>;

var(Icons) protected Texture2D mAdventureFilter<DisplayName=Adventure Filter>;
var(Icons) protected Texture2D mCombatFilter<DisplayName=Combat Filter>;
var(Icons) protected Texture2D mDamageFilter<DisplayName=Damage Filter>;
var(Icons) protected Texture2D mUtilityFilter<DisplayName=Utility Filter>;
var(Icons) protected Texture2D mNoFilter<DisplayName=No Filter>;

var(Backgrounds) protected Texture2D mMightBG<DisplayName=Might BG>;
var(Backgrounds) protected Texture2D mAirMagicBG<DisplayName=Air Magic BG>;
var(Backgrounds) protected Texture2D mDarkMagicBG<DisplayName=Dark Magic BG>;
var(Backgrounds) protected Texture2D mEarthMagicBG<DisplayName=Earth Magic BG>;
var(Backgrounds) protected Texture2D mFireMagicBG<DisplayName=Fire Magic BG>;
var(Backgrounds) protected Texture2D mLightMagicBG<DisplayName=Light Magic BG>;
var(Backgrounds) protected Texture2D mPrimeMagicBG<DisplayName=Prime Magic BG>;
var(Backgrounds) protected Texture2D mWaterMagicBG<DisplayName=Water Magic BG>;

var(TitleIcons) protected Texture2D mMightIcon<DisplayName=Might Icon>;
var(TitleIcons) protected Texture2D mAirMagicIcon<DisplayName=Air Magic Icon>;
var(TitleIcons) protected Texture2D mDarkMagicIcon<DisplayName=Dark Magic Icon>;
var(TitleIcons) protected Texture2D mEarthMagicIcon<DisplayName=Earth Magic Icon>;
var(TitleIcons) protected Texture2D mFireMagicIcon<DisplayName=Fire Magic Icon>;
var(TitleIcons) protected Texture2D mLightMagicIcon<DisplayName=Light Magic Icon>;
var(TitleIcons) protected Texture2D mPrimeMagicIcon<DisplayName=Prime Magic Icon>;
var(TitleIcons) protected Texture2D mWaterMagicIcon<DisplayName=Water Magic Icon>;

var (SpellbookFrames) protected Texture2D mMightFrameBase<DisplayName=Might frame base>;
var (SpellbookFrames) protected Texture2D mMightFrameUpgrade<DisplayName=Might frame upgrade>;
var (SpellbookFrames) protected Texture2D mAirFrameBase<DisplayName=Air frame base>;
var (SpellbookFrames) protected Texture2D mAirFrameUpgrade<DisplayName=Air frame upgrade>;
var (SpellbookFrames) protected Texture2D mDarkFrameBase<DisplayName=Dark frame base>;
var (SpellbookFrames) protected Texture2D mDarkFrameUpgrade<DisplayName=Dark frame upgrade>;
var (SpellbookFrames) protected Texture2D mEarthFrameBase<DisplayName=Earth frame base>;
var (SpellbookFrames) protected Texture2D mEarthFrameUpgrade<DisplayName=Earth frame upgrade>;
var (SpellbookFrames) protected Texture2D mFireFrameBase<DisplayName=Fire frame base>;
var (SpellbookFrames) protected Texture2D mFireFrameUpgrade<DisplayName=Fire frame upgrade>;
var (SpellbookFrames) protected Texture2D mLightFrameBase<DisplayName=Light frame base>;
var (SpellbookFrames) protected Texture2D mLightFrameUpgrade<DisplayName=Light frame upgrade>;
var (SpellbookFrames) protected Texture2D mPrimeFrameBase<DisplayName=Prime frame base>;
var (SpellbookFrames) protected Texture2D mPrimeFrameUpgrade<DisplayName=Prime frame upgrade>;
var (SpellbookFrames) protected Texture2D mWaterFrameBase<DisplayName=Water frame base>;
var (SpellbookFrames) protected Texture2D mWaterFrameUpgrade<DisplayName=Water frame upgrade>;

// real school icon
function Texture2D GetSchoolIcon( EAbilitySchool school )
{
	switch( school )
	{
		case MIGHT : return mMight;
		case AIR_MAGIC : return mAirMagic;
		case DARK_MAGIC : return mDarkMagic;
		case EARTH_MAGIC : return mEarthMagic;
		case FIRE_MAGIC : return mFireMagic;
		case LIGHT_MAGIC : return mLightMagic;
		case PRIME_MAGIC : return mPrimeMagic;
		case WATER_MAGIC : return mWaterMagic;
		case ABILITY_SCHOOL_NONE : return mNoneSchool;
		default: ;
	}

	return none;
}

function Texture2D GetSpellFrame(EAbilitySchool school, bool upgradedVersion)
{
	if(!upgradedVersion)
	{
		switch( school )
		{
			case MIGHT : return mMightFrameBase;
			case AIR_MAGIC : return mAirFrameBase;
			case DARK_MAGIC : return mDarkFrameBase;
			case EARTH_MAGIC : return mEarthFrameBase;
			case FIRE_MAGIC : return mFireFrameBase;
			case LIGHT_MAGIC : return mLightFrameBase;
			case PRIME_MAGIC : return mPrimeFrameBase;
			case WATER_MAGIC : return mWaterFrameBase;
			case ABILITY_SCHOOL_NONE : return mNoneSchool;
			default: ;
		}
	}
	else
	{
		switch( school )
		{
			case MIGHT : return mMightFrameUpgrade;
			case AIR_MAGIC : return mAirFrameUpgrade;
			case DARK_MAGIC : return mDarkFrameUpgrade;
			case EARTH_MAGIC : return mEarthFrameUpgrade;
			case FIRE_MAGIC : return mFireFrameUpgrade;
			case LIGHT_MAGIC : return mLightFrameUpgrade;
			case PRIME_MAGIC : return mPrimeFrameUpgrade;
			case WATER_MAGIC : return mWaterFrameUpgrade;
			case ABILITY_SCHOOL_NONE : return mNoneSchool;
			default: ;
		}
	}
	return none;
}

// real school icon
function Texture2D GetSchoolIconByStr(string school)
{
	if(Caps(school) == Caps("school_might_damage")) return mMight;
	if(Caps(school) == Caps("school_air")) return mAirMagic;
	if(Caps(school) == Caps("school_dark")) return mDarkMagic;
	if(Caps(school) == Caps("school_earth")) return mEarthMagic;
	if(Caps(school) == Caps("school_fire")) return mFireMagic;
	if(Caps(school) == Caps("school_light")) return mLightMagic;
	if(Caps(school) == Caps("school_prime")) return mPrimeMagic;
	if(Caps(school) == Caps("school_water")) return mWaterMagic;
	return none;
}

// some bg?
function Texture2D GetSchoolBG( EAbilitySchool school )
{
	switch( school )
	{
		case MIGHT : return mMightBG;
		case AIR_MAGIC : return mAirMagicBG;
		case DARK_MAGIC : return mDarkMagicBG;
		case EARTH_MAGIC : return mEarthMagicBG;
		case FIRE_MAGIC : return mFireMagicBG;
		case LIGHT_MAGIC : return mLightMagicBG;
		case PRIME_MAGIC : return mPrimeMagicBG;
		case WATER_MAGIC : return mWaterMagicBG;
		default: ;
	}

	return none;
}

// Spell Book ornamental title background
function Texture2D GetSchoolTitleIcon(EAbilitySchool school)
{
	switch( school )
	{
		case MIGHT : return mMightIcon;
		case AIR_MAGIC : return mAirMagicIcon;
		case DARK_MAGIC : return mDarkMagicIcon;
		case EARTH_MAGIC : return mEarthMagicIcon;
		case FIRE_MAGIC : return mFireMagicIcon;
		case LIGHT_MAGIC : return mLightMagicIcon;
		case PRIME_MAGIC : return mPrimeMagicIcon;
		case WATER_MAGIC : return mWaterMagicIcon;
		default: ;
	}

	return none;	
}

function String GetSchoolIconPath(EAbilitySchool school)
{
	local Texture2D tex;
	tex = GetSchoolIcon(school);
	return "img://" $ PathName( tex );
}

function Texture2D GetFilterIcon(string filter)
{
	switch (filter)
	{
		case "adventure": return mAdventureFilter;
		case "combat"   : return mCombatFilter;
		case "damage"   : return mDamageFilter;
		case "utility"  : return mUtilityFilter;
		case "nofilter" : return mNoFilter;
	}

	return none;
}
