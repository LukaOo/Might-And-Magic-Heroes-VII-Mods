//=============================================================================
// H7ITooltipable
//=============================================================================
// 
// Interface implemented by Game Entities (army,town,resource,buffsite) that
// want to display a tooltip on the adventuremap
// 
// OPTIONAL: adapt system for combatmap
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7ITooltipable
	dependson(H7StructsAndEnumsNative);


function H7TooltipData GetTooltipData(optional bool extendedVersion) {}
