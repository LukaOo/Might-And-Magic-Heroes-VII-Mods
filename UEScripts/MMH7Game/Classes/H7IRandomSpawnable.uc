/*=============================================================================
 * H7IRandomSpawnable
 * ============================================================================
 * 
 * Interface for objects that spawn random sites.
 * =============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================
 */

interface H7IRandomSpawnable native;

event HatchRandomSpawnable();
function H7AreaOfControlSite GetSpawnedSite() {}
event DisposeShell() {}
function native SetRandomPlayerNumber( EPlayerNumber number );
function native SetFactionType( ERandomSiteFaction factionType );
function ERandomSiteFaction GetFactionType() {}
event H7Faction GetChosenFaction();
