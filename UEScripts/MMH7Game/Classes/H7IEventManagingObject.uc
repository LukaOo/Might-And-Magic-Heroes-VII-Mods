//=============================================================================
// H7IEventManagingObject
//=============================================================================
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IEventManagingObject
	dependson(H7StructsAndEnumsNative)
	native; // Not in Tussi header to avoid circular reference

native function H7EventManager      GetEventManager()                       {}
function String                     GetName()                               {}
native function int					GetID()							        {}
