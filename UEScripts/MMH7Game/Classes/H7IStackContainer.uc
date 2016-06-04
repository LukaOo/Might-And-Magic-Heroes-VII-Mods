/*=============================================================================
 * H7IStackContainer
 * 
 * Interface for objects that carry creature stacks
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/
interface H7IStackContainer
	native;

function int GetCreatureAmountTotal();
function int GetCreatureAmount( H7Creature creature );
