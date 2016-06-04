//=============================================================================
// H7TradingTable
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ArtifactRecyclingTable extends Object
		hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement);

var() protected array<H7ResourceQuantity> mRecycleValueHelmet<DisplayName=Recycle Value Head (Helmet)>;
var() protected array<H7ResourceQuantity> mRecycleValueCape<DisplayName=Recycle Value Shoulders (Cape)>;
var() protected array<H7ResourceQuantity> mRecycleValueChest<DisplayName=Recycle Value Torso (Chest)>;
var() protected array<H7ResourceQuantity> mRecycleValueWeapon<DisplayName=Recycle Value Main Hand (Weapon)>;
var() protected array<H7ResourceQuantity> mRecycleValueNecklace<DisplayName=Recycle Value Neck (Necklace)>;
var() protected array<H7ResourceQuantity> mRecycleValueGloves<DisplayName=Recycle Value Off-Hand (Gloves)>;
var() protected array<H7ResourceQuantity> mRecycleValueRing<DisplayName=Recycle Value Finger (Ring)>;
var() protected array<H7ResourceQuantity> mRecycleValueShoes<DisplayName=Recycle Value Feet (Shoes)>;

var() protected float mMulitplierMajor<DisplayName=Multiplier for major Artifacts>;
var() protected float mMulitplierRelic<DisplayName=Multiplier for relic Artifacts>;

function array<H7ResourceQuantity> GetRecycleValueByType(EItemType type)
{
	switch (type)
	{
		case ITYPE_HELMET: return mRecycleValueHelmet;
		case ITYPE_CAPE: return mRecycleValueCape;
		case ITYPE_CHEST_ARMOR: return mRecycleValueChest;
		case ITYPE_WEAPON: return mRecycleValueWeapon;
		case ITYPE_NECKLACE: return mRecycleValueNecklace;
		case ITYPE_GLOVES: return mRecycleValueGloves;
		case ITYPE_RING: return mRecycleValueRing;
		case ITYPE_SHOES: return mRecycleValueShoes;
	}
}

function float GetMultiplierByTier(ETier tier)
{
	switch (tier)
	{
		case ITIER_MINOR: return 1;
		case ITIER_MAJOR: return mMulitplierMajor;
		case ITIER_RELIC: return mMulitplierRelic;
	}
}

function float GetMulitplierMajor() {return mMulitplierMajor;}
function float GetMulitplierRelic() {return mMulitplierRelic;}
