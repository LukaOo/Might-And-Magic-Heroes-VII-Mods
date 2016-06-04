//=============================================================================
// H7AiPatrolController
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiPatrolController extends Actor
	placeable
	dependson(H7StructsAndEnumsNative);

var(AI) protected array<AiWaypoint>   mPath<DisplayName=Path>;
var(AI) protected EPathControlType    mCtrlBeginType<DisplayName=Begin Control Type>;
var(AI) protected EPathControlType    mCtrlEndType<DisplayName=End Control Type>;
var(AI) protected int                 mSensorRange;
var(AI) protected bool                mStopAttackAlways;
var protected int                     mCurrentNode;
var protected int                     mNextNode;
var protected bool                    mInTransit;
var protected int                     mTurnCounter;


function AiWaypoint GetCurrentWaypoint()
{
	if(mCurrentNode<0) return mPath[0];
	if(mCurrentNode>=mPath.Length) return mPath[mPath.Length-1];
	return mPath[mCurrentNode];
}

function AiWaypoint GetNextWaypoint()
{
	if(mNextNode<0) return mPath[0];
	if(mNextNode>=mPath.Length) return mPath[mPath.Length-1];
	return mPath[mNextNode];
}

function EPathControlType   GetBeginType()                    { return mCtrlBeginType; }
function EPathControlType   GetEndType()                      { return mCtrlEndType; }
function bool               IsTransit()                       { return mInTransit; }
function                    SetTransit(bool t)                { mInTransit=t; }
function int                GetTurns()                        { return mTurnCounter; }
function                    SetTurns(int val)                 { mTurnCounter=val; }
function bool               DecTurns()                        { mTurnCounter--; if(mTurnCounter<=0) return true; return false; }
function int                GetSensorRange()                  { return mSensorRange; }
function bool               StopAttackAlways()                { return mStopAttackAlways; }

function AdvanceNode()
{
	if(mCurrentNode==-1)
	{
		mCurrentNode++;
		mNextNode++;
		return;
	}

	if(mCurrentNode<mNextNode)
	{
		mCurrentNode++;
		mNextNode++;
		if(mNextNode>=mPath.Length)
		{
			if(mCtrlEndType==PCT_CONSTANT)
			{
				mCurrentNode=mPath.Length-1;
				mNextNode=mCurrentNode;
			}
			else if(mCtrlEndType==PCT_REPEAT)
			{
				mCurrentNode=mPath.Length-1;
				mNextNode=0;
			}
			else if(mCtrlEndType==PCT_MIRROR)
			{
				mCurrentNode=mPath.Length-1;
				mNextNode=mPath.Length-2;
			}
		}
	}
	else if(mCurrentNode>mNextNode)
	{
		mCurrentNode--;
		mNextNode--;
		if(mCurrentNode<=0)
		{
			if(mCtrlBeginType==PCT_CONSTANT)
			{
				mCurrentNode=0;
				mNextNode=0;
			}
			else if(mCtrlBeginType==PCT_REPEAT)
			{
				mCurrentNode=0;
				mNextNode=mPath.Length-1;
			}
			else if(mCtrlBeginType==PCT_MIRROR)
			{
				mCurrentNode=0;
				mNextNode=1;
			}
		}
	}
}

