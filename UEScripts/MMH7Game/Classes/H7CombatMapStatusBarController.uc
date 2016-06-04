//=============================================================================
// H7CombatMapManaBarController
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapStatusBarController extends Actor
	dependson(H7StructsAndEnumsNative);

var protected array<Bar> mActiveBars;

static function H7CombatMapStatusBarController GetInstance()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatBarController();
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetCombatBarController( self );
}

function CreateManaBar( H7Unit unit, int percent)
{
	local Bar newBar;
	
	newBar.unit = unit;
	newBar.flashID = class'H7OverlaySystemCntl'.static.GetInstance().GetStatusBarSystem().CreateManaBar(0 , 0,  percent, 160 ); 
	newBar.oldPercent = percent;
	newBar.type = BARTYPE_MANA;
	newBar.oldVisible = true; // flash creates it in visible-state
	mActiveBars.AddItem( newBar );
}

function CreateHealthBar( H7Unit unit, int percent)
{
	local Bar newBar;
	local int width; 

	width = unit.GetUnitBaseSize() == CELLSIZE_1x1 ? 100 : 160;
	newBar.unit = unit;
	newBar.flashID = class'H7OverlaySystemCntl'.static.GetInstance().GetStatusBarSystem().CreateHealthBar(0 , 0,  percent, width );   
	newBar.oldPercent = percent;
	newBar.oldVisible = false; // flash creates it in invisible-state
	mActiveBars.AddItem( newBar );
 }

// pixel returned are flash_pixel
// bar sizes are: 
// 1x1: 100 
// 2x2: 160
// manabar: 100
// 0,0 is the unit-origin
function IntPoint ScreenOffest( H7CreatureStack stack)
{
	local intPoint point; 

	if( stack.GetUnitBaseSize() == CELLSIZE_2x2) 
	{
		point.X = -80;
		point.Y = 20;
	}
	else
	{
		point.X = -50;
		point.Y = 20;
	}

	return point;
}

function Update( Canvas canvas )
{
	local Bar tmpBar;
	local H7CombatHero hero;
	local H7CreatureStack stack;
	local bool visible; 
	local Vector2D flashCoord;
	local int percent,i;
	local IntPoint sOffest,newPosition; 
	local bool sendUpdate;
	local H7OverlaySystemCntl overlay;
	local bool updateOne;
	local bool smartUpdate,statusBarSystemIsVisible;

	// TODO: Needs more testing
	//local H7Camera cam;

	//cam = class'H7Camera'.static.GetInstance();

	//if( cam.mLastRotatedAngle == 0 && 
	//	cam.mLastPannedDistance == 0 )
	//{
	//	return;
	//}

	overlay = class'H7OverlaySystemCntl'.static.GetInstance();
	smartUpdate = class'H7GUIGeneralProperties'.static.GetInstance().mSmartOverlayUpdate;
	statusBarSystemIsVisible = overlay.GetStatusBarSystem().IsCurrentlyVisibleHealtBars();

	foreach mActiveBars( tmpBar , i) 
	{
		sendUpdate = false;

		if( tmpBar.type == BARTYPE_MANA )
		{
			hero = H7CombatHero(tmpBar.unit);
			if( !hero.IsHero())
			{
				continue;
			}

			if(hero.HasDataChanged())
			{
				hero.ResetHasDataChanged();
				percent = ( float(hero.GetCurrentMana())  /  float(hero.GetMaxMana()) ) * 100;
			}
			else
			{
				percent = -1;
			}

			flashCoord = overlay.UnrealPixels2FlashPixels( UnitProject(canvas, tmpBar.unit) ); 
			
			if(!smartUpdate)
			{
				sendUpdate = true;
			}
			else if(tmpBar.oldVisible != true 
				|| tmpBar.oldPercent != percent && percent != -1
				|| tmpBar.oldX != int(flashCoord.X)
				|| tmpBar.oldY != int(flashCoord.Y))
			{
				sendUpdate = true;
			}
			
			if(sendUpdate)
			{
				if( !updateOne )
				{
					overlay.GetStatusBarSystem().StartMultiUpdate();
				}
				updateOne = true;

				mActiveBars[i].oldVisible = true;
				if(percent != -1) mActiveBars[i].oldPercent = percent;
				mActiveBars[i].oldX = int(flashCoord.X) - 80;
				mActiveBars[i].oldY = int(flashCoord.Y);
				
				overlay.GetStatusBarSystem().AddUpdate(tmpBar.flashID, mActiveBars[i].oldX , mActiveBars[i].oldY, mActiveBars[i].oldPercent, true  );  
				
			}
		}
		else if( tmpBar.type == BARTYPE_HEALTH ) 
		{
			stack = H7CreatureStack(tmpBar.unit);
			visible = ( stack.IsVisible() && !stack.IsDead() ) && statusBarSystemIsVisible;
			if(stack.HasDataChanged())
			{
				stack.ResetHasDataChanged();
				percent =  ( float( stack.GetTopCreatureHealth() ) / float( stack.GetBaseCreatureHealth() ) ) * 100;
			}
			else
			{
				percent = -1;
			}
			if(visible)
			{
				sOffest = ScreenOffest(stack);
				flashCoord = overlay.UnrealPixels2FlashPixels( UnitProject(canvas, tmpBar.unit) ); 
				newPosition.X = int(flashCoord.X + sOffest.X);
				newPosition.Y = int(flashCoord.Y + sOffest.Y);
			}
			else
			{
				// if it is not visible just leave it where it is, we don't care
				newPosition.X = tmpBar.oldX;
				newPosition.Y = tmpBar.oldY;
			}

			if(!smartUpdate)
			{
				sendUpdate = true;
			}
			else if(tmpBar.oldVisible != visible                        // update if it switched state
				|| 
				(visible && 
					(                                                   // update if is visible and changed data
					(tmpBar.oldPercent != percent && percent != -1)
					|| tmpBar.oldX != newPosition.X
					|| tmpBar.oldY != newPosition.Y
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
					overlay.GetStatusBarSystem().StartMultiUpdate();
				}
				updateOne = true;

				mActiveBars[i].oldVisible = visible;
				if(percent != -1) mActiveBars[i].oldPercent = percent;
				mActiveBars[i].oldX = newPosition.X;
				mActiveBars[i].oldY = newPosition.Y;

				overlay.GetStatusBarSystem().AddUpdate(tmpBar.flashID, mActiveBars[i].oldX , mActiveBars[i].oldY, mActiveBars[i].oldPercent, visible ); 
				
			}
		}
	}

	if( updateOne )
	{
		overlay.GetStatusBarSystem().MultiUpdate();
	}

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

function removeBar( H7Unit unit ) 
{
	local Bar tmpBar; 
	foreach mActiveBars( tmpBar )
	{
		if( tmpBar.unit.GetID() == unit.GetID() )
			mActiveBars.RemoveItem( tmpBar );
	}
}

function DeleteAllBars()
{
	mActiveBars.Length = 0;
	class'H7OverlaySystemCntl'.static.GetInstance().GetStatusBarSystem().Clear();
}

