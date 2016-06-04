/*=============================================================================
 * H7IRandomPropertyOwner
 * ============================================================================
 * 
 * Interface for objects that reference random objects in their properties
 * that need to get updated once the random objects hatch.
 * 
 * =============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================
 */

interface H7IRandomPropertyOwner native;

function UpdateRandomProperties(Object randomObject, Object hatchedObject);
