/*=============================================================================
 * H7SeqAct_MoveToBuilding
 * 
 * Move action that targets a visitable site.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_MoveToBuilding extends H7SeqAct_MoveTo
	implements(H7IRandomPropertyOwner)
	native
	savegame;

/** The building to move to */
var(Properties) protected savegame H7VisitableSite mMoveTarget<DisplayName=Move Target Building>;

function H7AdventureMapCell GetTargetCell()
{
	return mMoveTarget.GetEntranceCell();
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7VisitableSite'))
	{
		if(mMoveTarget == randomObject)
		{
			mMoveTarget = H7VisitableSite(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

