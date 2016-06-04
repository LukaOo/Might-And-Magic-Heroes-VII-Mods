//=============================================================================
// H7OverlaySystemCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7OverlaySystemCntl extends H7FlashMovieCntl;

var protected H7GFxFloatingSystem         mFloatingSystem; // short messages that fade away after x seconds
var protected H7GFxStatusBarSystem        mStatusBarSystem; // permanent attached bars (health,mana,progress)
var protected H7GFxStackPlateSystem       mStackPlateSystem; // permanent attached stack numbers

var protected array<Bar> mActiveBars;

static function H7OverlaySystemCntl GetInstance()
{
	if(class'H7PlayerController'.static.GetPlayerController().GetHud() == none) { ScriptTrace(); }
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl(); }

function    H7GFxFloatingSystem       GetFloatingSystem()        {  	return mFloatingSystem; }
function    H7GFxStatusBarSystem      GetStatusBarSystem()       {   return mStatusBarSystem; }
function    H7GFxStackPlateSystem     GetStackPlateSystem()      {   return mStackPlateSystem; }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mFloatingSystem = H7GFxFloatingSystem(mRootMC.GetObject("aFloatingSystem", class'H7GFxFloatingSystem'));
	mStatusBarSystem = H7GFxStatusBarSystem(mRootMC.GetObject("aStatusBarSystem", class'H7GFxStatusBarSystem'));
	mStackPlateSystem = H7GFxStackPlateSystem(mRootMC.GetObject("aStackPlateSystem", class'H7GFxStackPlateSystem'));

	mStatusBarSystem.SetSystemVisible(false);

	Super.Initialize();
	return true;
}


function CreateProgressBar( H7Unit unit, int percent)
{
	local Bar newBar;
	
	newBar.unit = unit;
	newBar.flashID = mStatusBarSystem.CreateProgressBar(0 , 0,  percent, 100 ); 
	newBar.type = BARTYPE_PROGRESS;
	newBar.oldVisible = true; // flash creates it in visible-state
	mActiveBars.AddItem( newBar );
}

function Update(Canvas canvas)
{
	local Bar tmpBar;
	local H7AdventureHero hero;
	local Vector2D flashCoord;
	local int percent,i;
	local bool sendUpdate;
	local H7DestructibleObjectManipulator manipulator;

	for(i=mActiveBars.Length-1;i>=0;i--)
	{
		tmpBar = mActiveBars[i];
		sendUpdate = false;

		if( tmpBar.type == BARTYPE_PROGRESS )
		{
			hero = H7AdventureHero(tmpBar.unit);
			manipulator = class'H7DestructibleObjectManipulator'.static.GetObjectByArmy(hero.GetAdventureArmy());
			if(manipulator == none) // emergency hack fix for another issue
			{
				;
				RemoveBar(tmpBar.unit);
				continue;
			}
			percent = class'H7DestructibleObjectManipulator'.static.GetObjectByArmy(hero.GetAdventureArmy()).GetProgressPercent();
			
			flashCoord = class'H7AdventureHudCntl'.static.GetInstance().UnrealPixels2FlashPixels( UnitProject(canvas, tmpBar.unit) ); 
			
			if(!class'H7GUIGeneralProperties'.static.GetInstance().mSmartOverlayUpdate)
			{
				sendUpdate = true;
			}
			else if(tmpBar.oldVisible != true 
				|| tmpBar.oldPercent != percent
				|| tmpBar.oldX != flashCoord.X
				|| tmpBar.oldY != flashCoord.Y)
			{
				sendUpdate = true;
			}
			
			if(sendUpdate)
			{
				mStatusBarSystem.UpdateBar(tmpBar.flashID, flashCoord.X, flashCoord.Y, percent, true  );  
				mActiveBars[i].oldVisible = true;
				mActiveBars[i].oldPercent = percent;
				mActiveBars[i].oldX = flashCoord.X;
				mActiveBars[i].oldY = flashCoord.Y;
			}
		}
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

function RemoveBar( H7Unit unit ) 
{
	local Bar tmpBar; 
	foreach mActiveBars( tmpBar )
	{
		if( tmpBar.unit.GetID() == unit.GetID() )
		{
			mStatusBarSystem.RemoveBar(tmpBar.flashID);
			mActiveBars.RemoveItem( tmpBar );
		}
	}

}

