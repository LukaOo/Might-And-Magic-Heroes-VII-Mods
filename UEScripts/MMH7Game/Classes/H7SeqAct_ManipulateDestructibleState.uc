//=============================================================================
// H7SeqAct_ManipulateDestructibleState
//
// Destroys / repairs a bridge 
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_ManipulateDestructibleState extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** The destructible object that should be repaired or destroyed */
var (Properties) H7GameplayFracturedMeshActor mManipulatedActor<DisplayName="Destructible object">;
var (Properties) H7IDestructible mManipulatedInterfaceActor<DisplayName="Destructible site">;

event Activated()
{
	local array<H7DestructibleObjectManipulator> manipulators;
	local H7DestructibleObjectManipulator manipulator;
	local vector emptyVect;
	emptyVect = Vect(0,0,0);
	if (mManipulatedActor != none)
	{
		if ( InputLinks[0].bHasImpulse )
		{
			mManipulatedActor.TakeDamage(100000,none,emptyVect,emptyVect,none);
			mManipulatedActor.SetDestroying( false );
			mManipulatedActor.SetRepairing( false );
		}
		else if ( InputLinks[1].bHasImpulse )
		{
			mManipulatedActor.TakeDamage(-100000,none,emptyVect,emptyVect,none);
			mManipulatedActor.SetDestroying( false );
			mManipulatedActor.SetRepairing( false );
		}
		else if (InputLinks.Length >= 3 && InputLinks[2].bHasImpulse )
		{
			manipulators = mManipulatedActor.GetManipulators();
			foreach manipulators( manipulator )
			{
				manipulator.AbortMyManipulation();
			}
		}
	}
	if( mManipulatedInterfaceActor != none )
	{
		if ( InputLinks[0].bHasImpulse )
		{
			mManipulatedInterfaceActor.DestroyDestructibleObject();
		}
		else if ( InputLinks[1].bHasImpulse )
		{
			mManipulatedInterfaceActor.RepairDestructibleObject();
		}
		else if (InputLinks.Length >= 3 && InputLinks[2].bHasImpulse )
		{
			manipulators = mManipulatedInterfaceActor.GetManipulators();
			foreach manipulators( manipulator )
			{
				manipulator.AbortMyManipulation();
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

