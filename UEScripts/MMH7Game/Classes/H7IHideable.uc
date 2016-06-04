/*=============================================================================
 * H7IHideable
 * 
 * Interface for objects than can be hidden or revealed by Kismet
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/
interface H7IHideable
	native;

native function bool IsHiddenX() {}

function Hide();
function Reveal();
