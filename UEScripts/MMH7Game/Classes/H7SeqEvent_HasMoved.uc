/*============================================================================
* H7SeqEvent_HasMoved
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqEvent_HasMoved extends H7SeqEvent_HeroEvent
	native;

var(Properties) bool mEventMovementCheck<DisplayName="Check movement points">;
var(Properties) EOperationBool mEventMovementOperation<DisplayName="Movement Points are">;
var(Properties) int mEventMovementPoints<DisplayName="Movement Points are">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7HeroEventParam param;

	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		if(!mEventMovementCheck) return true;

		param = H7HeroEventParam(evtParam);
		if (param != none)
		{
			switch(mEventMovementOperation)
			{
				case OP_TYPE_BOOL_EQUAL:
					if(param.mEventMovementPoints == mEventMovementPoints) return true; break;
				case OP_TYPE_BOOL_NOTEQUAL:
					if(param.mEventMovementPoints != mEventMovementPoints) return true; break;
				case OP_TYPE_BOOL_LESSEQUAL:
					if(param.mEventMovementPoints <= mEventMovementPoints) return true; break;
				case OP_TYPE_BOOL_LESS:
					if(param.mEventMovementPoints < mEventMovementPoints) return true; break;
				case OP_TYPE_BOOL_MOREEQUAL:
					if(param.mEventMovementPoints >= mEventMovementPoints) return true; break;
				case OP_TYPE_BOOL_MORE: 
					if(param.mEventMovementPoints > mEventMovementPoints) return true; break;
			}
		}
	}
	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

