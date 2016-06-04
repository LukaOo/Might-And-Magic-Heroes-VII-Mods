//=============================================================================
// H7CreatureStackPlateController
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackPlateController extends Actor
	dependson(H7StructsAndEnumsNative);

var protected array<Plate> mActivePlates;
var protected bool mOldStatusBarVisible;

static function H7CreatureStackPlateController GetInstance()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCreaturePlateController();
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetCreaturePlateController( self );
}

function CreatePlate( H7CreatureStack stack )
{
	local Plate newPlate;
	local Color stackColor;

	stackColor = stack.GetStackColor();
	newPlate.stack = stack;
	newPlate.flashID = class'H7OverlaySystemCntl'.static.GetInstance().GetStackPlateSystem().CreatePlate(0, 0, stack.GetStackSize(), stackColor.R, stackColor.G, stackColor.B ); 
	newPlate.oldX = 0;
	newPlate.oldY = 0;
	newPlate.orientation = ScreenOffest(stack);
	newPlate.oldSize = stack.GetStackSize();
	newPlate.oldVisible = false;

	mActivePlates.AddItem( newPlate );
}

function Update( Canvas canvas )
{
	local Plate tmpPlate;
	local H7CreatureStack stack,activeStack;
	local bool visible; 
	//local IntPoint offset;
	local Vector2D flashCoord;
	local bool sendUpdate;
	local int i;
	local H7OverlaySystemCntl overlay;
	local bool unitIsActive;
	local bool updateOne;
	local bool statusBarSystemIsVisible;
	local bool smartUpdate,isSpectator;
	// TODO: Needs more testing
	//local H7Camera cam;

	//cam = class'H7Camera'.static.GetInstance();

	//if( cam.mLastRotatedAngle == 0 && 
	//	cam.mLastPannedDistance == 0 )
	//{
	//	return;
	//}

	overlay = class'H7OverlaySystemCntl'.static.GetInstance();
	statusBarSystemIsVisible = overlay.GetStatusBarSystem().IsCurrentlyVisibleHealtBars();
	smartUpdate = class'H7GUIGeneralProperties'.static.GetInstance().mSmartOverlayUpdate;
	isSpectator = class'H7CombatController'.static.GetInstance().IsLocalPlayerSpectator();
	activeStack = H7CreatureStack( class'H7CombatController'.static.GetInstance().GetActiveUnit());

	foreach mActivePlates( tmpPlate , i) 
	{
		sendUpdate = false;
		stack = tmpPlate.stack;
		visible = stack.IsVisible() && !stack.IsDead(); 
		if(isSpectator)
		{
			visible = false;
		}
		if(visible)
		{
			flashCoord = overlay.UnrealPixels2FlashPixels( UnitProject(canvas, stack ) ); 
		}
		else
		{
			flashCoord.X = tmpPlate.oldX;
			flashCoord.Y = tmpPlate.oldY;
		}
	    unitIsActive = false;

		if( tmpPlate.stack == activeStack)
			unitIsActive = true;
		
		//offset = ScreenOffest( stack );

		if(!smartUpdate)
		{
			sendUpdate = true;
		}
		else if(tmpPlate.oldVisible != visible                  // update if it switched state
			|| mOldStatusBarVisible != statusBarSystemIsVisible // plates need to refresh if status bar system switched on or off
			|| (visible && 
				(tmpPlate.oldSize != stack.GetStackSize()       // update if is visible and changed data
				|| tmpPlate.oldX != int(flashCoord.X)
				|| tmpPlate.oldY != int(flashCoord.Y)
				|| tmpPlate.oldIsActive != unitIsActive
				)
			)
		)
		{
			sendUpdate = true;
		}

		if(sendUpdate)
		{
			if( !updateOne )
			{
				overlay.GetStackPlateSystem().StartMultiUpdate();
			}
			updateOne = true;
			
			mActivePlates[i].oldSize = stack.GetStackSize();
			mActivePlates[i].oldVisible = visible;	

			mActivePlates[i].oldX = int(flashCoord.X);
			mActivePlates[i].oldY = int(flashCoord.Y);
			mActivePlates[i].oldIsActive = unitIsActive;

			overlay.GetStackPlateSystem().AddUpdate( tmpPlate.flashID, flashCoord.X, flashCoord.Y, stack.GetStackSize(), visible, tmpPlate.orientation, unitIsActive ); 
		}
		else
		{
			//`log_dui("no update");
		}
	}

	if( updateOne )
	{
		overlay.GetStackPlateSystem().MultiUpdate();
	}
	
	mOldStatusBarVisible = statusBarSystemIsVisible;
}

// pixel returned are flash_pixel
// bar sizes are: 
// 1x1: 100 
// 2x2: 160
// manabar: 100
// 0,0 is the unit-origin
function EStackPlateOrientation ScreenOffest( H7CreatureStack stack)
{
	switch ( stack.StackHeading() ) 
	{
		case O_WEST: // creatures ON the EAST side
			return PLATE_ORIENTATION_RIGHT;
			//break;
		case O_EAST: // creatures ON the WEST side
			return PLATE_ORIENTATION_LEFT;
	}
	return PLATE_ORIENTATION_RIGHT;
}

function Vector2D UnitProject( Canvas myCanvas, H7Unit unit ) 
{
	local Vector tmpVector;
	local Vector2D unrealXY;
	tmpVector = myCanvas.Project( unit.Location );
	
	unrealXY.X = tmpVector.X;
	unrealXY.Y = tmpVector.Y;

	return unrealXY;
}

function removePlate( H7Unit unit ) 
{
	local Plate tmpPlate; 
	foreach mActivePlates( tmpPlate )
	{
		if( tmpPlate.stack.GetID() == unit.GetID() )
		{
			class'H7OverlaySystemCntl'.static.GetInstance().GetStackPlateSystem().DeletePlate(tmpPlate.flashID);
			mActivePlates.RemoveItem( tmpPlate );
		}
	}

}

function DeleteAllStackPlates()
{
	mActivePlates.Length = 0;
	class'H7OverlaySystemCntl'.static.GetInstance().GetStackPlateSystem().Clear();
}

function Hide()
{
	local Plate tmpPlate; 
	foreach mActivePlates( tmpPlate )
	{
		;	
		
	}
}

