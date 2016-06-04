/*============================================================================
* H7SeqEvent_DestructibleObjectUsed
* 
* Base class for interactions for destructible object interactions.
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_DestructibleObjectUsed extends H7SeqEvent
	implements(H7ITriggerable, H7IRandomPropertyOwner)
	abstract
	native
	savegame;

/** The object used to destroy/repair the destructible object */
var(Properties) protected H7DestructibleObjectManipulator mDestructibleObjectManipulator<DisplayName="Destructible object manipulator">;
/** The fort that is destroyed/rebuilt */
var(Properties) protected savegame H7Fort mFort<DisplayName="Fort">;

var protected Actor mRequiredInstigator;

event RegisterEvent()
{
	Super.RegisterEvent();

	if( mFort != none )
	{
		mRequiredInstigator = mFort;
	}
	else
	{
		mRequiredInstigator = mDestructibleObjectManipulator;
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7Fort'))
	{
		if(mFort == randomObject)
		{
			mFort = H7Fort(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

