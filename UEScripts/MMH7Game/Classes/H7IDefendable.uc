//=============================================================================
// H7IDefendable
//=============================================================================
// Interface for sites that can host a garrison army.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IDefendable
	native;

event H7AdventureArmy GetGarrisonArmy( ) { }
function SetGarrisonArmy( H7AdventureArmy army ) { }
function H7AdventureArmy GetGuardingArmy( ) { }
function SetGuardingArmy( H7AdventureArmy army ) { }
function H7VisitableSite GetSite() {}
