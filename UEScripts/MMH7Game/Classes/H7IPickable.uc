//=============================================================================
// H7IPickable
//=============================================================================
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IPickable
	native
	dependson(H7StructsAndEnumsNative);

function PickUp( H7AdventureHero lootingHero, optional ELootType lootType = LOOT_TYPE_MAX, optional bool doMultiplayerSynchro = false )  {}
function bool IsLooted() {}
