//=============================================================================
// H7Deployment
//=============================================================================
// Data class to store deployment data created in Tactics phase.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Deployment extends Object
	dependsOn(H7EditorArmy, H7StructsAndEnumsNative)
	savegame;

const DEFAULT_MAP_HEIGHT = 10;

var protected savegame H7DeploymentData             mDeploymentData;
var protected savegame bool                         mIsCustomized;

function bool                               IsCustomized()                                                                  { return mIsCustomized; }
function                                    SetIsCustomized( bool b )                                                       { mIsCustomized = b; }
function H7DeploymentData                   GetDeploymentData()                                                             { return mDeploymentData; }
function                                    SetDeploymentData( H7DeploymentData data )                                      { mDeploymentData = data; }
function int                                GetOriginalMapHeight()                                                          { return mDeploymentData.OriginalMapHeight; }
function                                    SetOriginalMapHeight(int height)                                                { mDeploymentData.OriginalMapHeight = height; }
function bool                               GetForceAutodeployment()                                                        { return mDeploymentData.ForceAutodeployment; }
function                                    SetForceAutodeployment(bool forceAD)                                            { mDeploymentData.ForceAutodeployment=forceAD; }
function int                                GetNumberOfDeployedStacks()                                                     { return mDeploymentData.NumberOfDeployedStacks; }
function                                    SetNumberOfDeployedStacks(int num)                                              { mDeploymentData.NumberOfDeployedStacks=num; }
function int                                GetNumberOfStacksToDeploy()                                                     { return mDeploymentData.NumberOfStacksToDeploy; }
function                                    SetNumberOfStacksToDeploy(int num)                                              { mDeploymentData.NumberOfStacksToDeploy=num; }
function                                    IncNumberOfStacksToDeploy()                                                     { mDeploymentData.NumberOfStacksToDeploy++; }
function array<H7StackDeployment>           GetStackDeployments()                                                           { return  mDeploymentData.StackDeployments; }
function H7StackDeployment                  GetStackDeployment(int slotId)                                                  { if(slotId>=0 && slotId<mDeploymentData.StackDeployments.Length) return mDeploymentData.StackDeployments[slotId]; return mDeploymentData.StackDeployments[0]; }

function RemoveStackDeplyomentData( int slotID )
{
	local H7StackDeployment stackDeploymentData, emptySD;
	local int i;

	//Delete the old data and everything gets one place further
	stackDeploymentData = GetStackDeployment(slotId);
	mDeploymentData.StackDeployments.RemoveItem( stackDeploymentData );
	
	//Create a new empty SD at the end of the data
	emptySD.StackInfo.Creature=None;
	emptySD.StackInfo.Size=0;
	emptySD.StackInfo.CustomPositionX=0;
	emptySD.StackInfo.CustomPositionY=0;
	emptySD.SourceSlotId=-1;
	emptySD.Ordinal=-1;
	emptySD.DistanceSide=-1;
	emptySD.DistanceTop=-1;
	emptySD.SpacingBottom=-1;
	emptySD.SpacingTop=-1;
	mDeploymentData.StackDeployments.AddItem(emptySD);

	//Afterwards correct the SourceSlotId's for all StackDevelopmentData 
	for(i = slotID; i<mDeploymentData.StackDeployments.Length; i++)
	{
		if(mDeploymentData.StackDeployments[i].SourceSlotId != -1)
		{
			mDeploymentData.StackDeployments[i].SourceSlotId -= 1;
		}
	}
}

function int GetIdOfCreatureStack(H7CreatureStack creatureStack)
{
	local int i;

	for(i = 0; i < mDeploymentData.StackDeployments.Length; ++i)
	{
		if(mDeploymentData.StackDeployments[i].CreatureStackRef == creatureStack)
		{
			return i;
		}
	}

	return -1;
}

function SetStackGridPos(int slotId, IntPoint gp)
{
	local H7CombatMapGridController gridCntl;
	local int x;

	gridCntl = class'H7CombatMapGridController'.static.GetInstance();
	
	if(slotId>=0 && slotId<mDeploymentData.StackDeployments.Length)
	{
		if( gp.X > gridCntl.GetGridSizeX() / 2 )
		{
			x = gridCntl.GetGridSizeX();
			x -= class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE;
			x -= gp.X + class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
			gp.X = x;

			if( mDeploymentData.StackDeployments[slotId].StackInfo.Creature.GetBaseSize() == CELLSIZE_1x1 )
			{
				gp.X += 1;
			}
		}
		mDeploymentData.StackDeployments[slotId].Ordinal=0;
		mDeploymentData.StackDeployments[slotId].DistanceTop=gp.Y;
		mDeploymentData.StackDeployments[slotId].DistanceSide=gp.X;
		if( gp.X==-1 || gp.Y==-1 ) 
		{
			mDeploymentData.StackDeployments[slotId].Ordinal=-1;
			mDeploymentData.StackDeployments[slotId].SpacingTop=-1;
			mDeploymentData.StackDeployments[slotId].SpacingBottom=-1;
		}
	}
}

function SetStackSpacing(int slotId, int spacingTop, int spacingBottom )
{
	if(slotId>=0 && slotId<mDeploymentData.StackDeployments.Length)
	{
		mDeploymentData.StackDeployments[slotId].SpacingTop=spacingTop;
		mDeploymentData.StackDeployments[slotId].SpacingBottom=spacingBottom;
	}
}

function SetStackInfo( int idx, int sourceId, H7BaseCreatureStack baseStack, H7CreatureStack creatureStack )
{
	mDeploymentData.StackDeployments[idx].SourceSlotId = sourceId;
	mDeploymentData.StackDeployments[idx].CreatureStackRef = creatureStack;
	mDeploymentData.StackDeployments[idx].StackInfo.Creature = baseStack.GetStackType();
	mDeploymentData.StackDeployments[idx].StackInfo.Creature.SetDeploymentSlotID(sourceId);
	mDeploymentData.StackDeployments[idx].StackInfo.Size = baseStack.GetStackSize();
}

function array<H7StackDeployment> GetDeploymentByOrdinals()
{
	local array<H7StackDeployment> SD;
	local int id, ord;

	ord=0;
	for(ord=0;ord<14;ord++)
	{
		for(id=0;id<14;id++) 
		{
			if( mDeploymentData.StackDeployments[id].Ordinal==ord )
			{
				SD.AddItem(mDeploymentData.StackDeployments[id]);
				continue;
			}
		}
	}
	return SD;
}

// 
function RecalcStackOrdinal()
{
	local int id,i0,i1,k,l;
	local array<int> sortedIdxList;
	local array<H7StackDeployment> SD;
	local bool openTop, openBottom;

	// build list with deployed creatures
	for(id=0;id<14;id++) 
	{
		if( mDeploymentData.StackDeployments[id].SourceSlotId!=-1 && mDeploymentData.StackDeployments[id].Ordinal!=-1 )
		{
			sortedIdxList.AddItem(id);
		}
	}

	// sort by scanline positions ...
	for(l=0;l<sortedIdxList.Length-1;l++) 
	{
		for(k=l+1;k<sortedIdxList.Length;k++)
		{
			i0=sortedIdxList[l];
			i1=sortedIdxList[k];
			if( mDeploymentData.StackDeployments[i1].DistanceTop  < mDeploymentData.StackDeployments[i0].DistanceTop ||
			   (mDeploymentData.StackDeployments[i1].DistanceTop == mDeploymentData.StackDeployments[i0].DistanceTop &&	mDeploymentData.StackDeployments[i1].DistanceSide < mDeploymentData.StackDeployments[i0].DistanceSide) )
			{
				// swap entries
				i0=sortedIdxList[k]; sortedIdxList[k]=sortedIdxList[l]; sortedIdxList[l]=i0;
			}
		}
	}

	// set oridnal values
	for(l=0;l<sortedIdxList.Length;l++) 
	{
		i0=sortedIdxList[l];
		mDeploymentData.StackDeployments[i0].Ordinal=l;
	}

	// recalc spacing values
	SD=GetDeploymentByOrdinals();
	for(id=0;id<SD.Length;id++)
	{
		openTop=(id==0) ? true : false;
		openBottom=(id==SD.Length-1) ? true : false;

		if(openTop==true)
		{
			SD[id].SpacingTop=SD[id].DistanceTop;
		}
		else
		{
			if(SD[id-1].StackInfo.Creature!=None)
			{
				SD[id].SpacingTop=SD[id].DistanceTop - (SD[id-1].DistanceTop + SD[id-1].StackInfo.Creature.GetYSize());
			}
			else
			{
				SD[id].SpacingTop=SD[id].DistanceTop - (SD[id-1].DistanceTop + 1);
			}
		}

		if(openBottom==true)
		{
			if(SD[id].StackInfo.Creature!=None)
			{
				SD[id].SpacingBottom=mDeploymentData.OriginalMapHeight-(SD[id].DistanceTop + SD[id].StackInfo.Creature.GetYSize());
			}
			else
			{
				SD[id].SpacingBottom=mDeploymentData.OriginalMapHeight-(SD[id].DistanceTop + 1);
			}
		}
		else
		{
			if(SD[id].StackInfo.Creature!=None)
			{
				SD[id].SpacingBottom=(SD[id].DistanceTop + SD[id].StackInfo.Creature.GetYSize()) - SD[id+1].DistanceTop;
			}
			else
			{
				SD[id].SpacingBottom=(SD[id].DistanceTop + 1) - SD[id+1].DistanceTop;
			}
		}
	}
	// update deployment
	for(l=0;l<sortedIdxList.Length;l++) 
	{
		i0=sortedIdxList[l];
		mDeploymentData.StackDeployments[i0].SpacingTop=SD[mDeploymentData.StackDeployments[i0].Ordinal].SpacingTop;
		mDeploymentData.StackDeployments[i0].SpacingBottom=SD[mDeploymentData.StackDeployments[i0].Ordinal].SpacingBottom;
	}

	DebugLogSelf();
}

function Reset()
{
	local H7StackDeployment sd;
	local int id;

	mDeploymentData.ForceAutodeployment = true;
	mDeploymentData.OriginalMapHeight = DEFAULT_MAP_HEIGHT;
	mDeploymentData.NumberOfDeployedStacks = 0;
	mDeploymentData.NumberOfStacksToDeploy = 0;
	mDeploymentData.StackDeployments.Remove(0, mDeploymentData.StackDeployments.Length);
	mIsCustomized = false;
	
	// preset maximum number of deployment slots
	// [0..6,7,8] 7 army stacks + 2 additional temp. battle stacks [9..13] 5 guard army stacks if available
	for(id=0;id<14;id++) 
	{
		sd.StackInfo.Creature=None;
		sd.StackInfo.Size=0;
		sd.StackInfo.CustomPositionX=0;
		sd.StackInfo.CustomPositionY=0;
		sd.SourceSlotId=-1;
		sd.Ordinal=-1;
		sd.DistanceSide=-1;
		sd.DistanceTop=-1;
		sd.SpacingBottom=-1;
		sd.SpacingTop=-1;
		mDeploymentData.StackDeployments.AddItem(sd);
	}
}

function DebugLogSelf()
{
	local H7StackDeployment deployment;

	;
 
	;

	;

	foreach mDeploymentData.StackDeployments(deployment)
	{
		if( deployment.SourceSlotId != -1 )
		{
			;
			;
			;
		}
	}
}
