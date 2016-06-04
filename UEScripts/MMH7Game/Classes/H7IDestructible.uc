//=============================================================================
// H7IDestructible
//=============================================================================
// Interface for sites that can be destroyed by a manipulator.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IDestructible
	native;


function DestroyDestructibleObject()  {}
function RepairDestructibleObject()   {}

function bool                           IsDestroyed()				{}
function bool                           IsDestroying()				{}
function bool                           IsRepairing()				{}
function                                SetDestroying( bool v )     {}
function                                SetRepairing( bool v )      {}

function array<H7DestructibleObjectManipulator> GetManipulators()   {}

//function H7GameplayFracturedMeshActor   GetFracturedMeshActor()     {}
