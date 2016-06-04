/*=============================================================================
 * H7INeutralable
 * =============================================================================
 * 
 * Interface implemented by buildings to distinguish which ones are neutral
 * or not (belonging to a player).
 * 
 * Needed since not all buildings that are neutral in concept extend
 * H7NeutralSite
 * 
 * ===========================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/
interface H7INeutralable;

function bool IsNeutral();
