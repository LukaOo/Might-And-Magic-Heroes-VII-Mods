//=============================================================================
// H7TestCaseThreadTaskActor
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7TestCaseThreadTaskActor extends StaticMeshActor
	placeable
	dependson(H7ListingMap, H7ListingCombatMap, H7ListingCampaign, H7ListingSavegame)
	implements(H7ContentScannerListener)
	native;

var private native transient H7ListingMap mListingMap;
var private native transient H7ListingCombatMap mListingCombatMap;
var private native transient H7ListingCampaign mListingCampaign;
var private native transient H7ContentScanner mContentScanner;

var private native transient H7ListingSavegame mListingSavegame;

var() StaticMeshActor ActorWithStreamLoadMat;
var private transient H7Texture2DStreamLoad StreamLoadTex;


native event KismetActivate();


event OnScanned_AdventureMap(const out H7ContentScannerAdventureMapData AdvData) { ; }
event OnScanned_CombatMap(const out H7ContentScannerCombatMapData CombatData) { ; }
event OnScanned_Campaign(const out H7ContentScannerCampaignData CampaignData) { ; }


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

