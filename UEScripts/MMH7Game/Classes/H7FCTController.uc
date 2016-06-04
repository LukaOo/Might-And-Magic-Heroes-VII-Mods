//=============================================================================
// H7FCTController
//
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FCTController extends Actor
	dependson(H7StructsAndEnumsNative)
	native;

var protected array<H7FCTElement> mActiveFCTs;
var protected H7FCTMappingProperties mFCTType2IconMapping;
var protected bool mIsHighlighting;

function SetHighlighting( bool isHighlighting ) 
{ 
	mIsHighlighting = isHighlighting;
}

function bool HasActiveHighlights()
{
	local H7FCTElement fct;

	foreach mActiveFCTs( fct )
	{
		if( fct.GetType() == FCT_HIGHLIGHT ) return true;
	}
	return false;
}

static function H7FCTController GetInstance()
{
	if(class'H7ReplicationInfo'.static.GetInstance() == none) return none;
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetFCTController();
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetFCTController( self );
}

function H7FCTElement StartFCT(EFCTType type, Vector startPosition, H7Player initiator, optional String text = "", optional Color textColor = MakeColor(255,255,255,255) , optional Texture2d icon) //, optional Vector2D pixelOffset = vect2d(0,0))
{
	if( class'H7AdventureController'.static.GetInstance() != none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() &&
		H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).GetCombatPlayerType() == COMBATPT_SPECTATOR )
	{
		return none; // no floats for you
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() || initiator != none && initiator == class'H7AdventureController'.static.GetInstance().GetLocalPlayer() )
	{
		return StartFCTReal(type,startPosition,text,textColor,icon); // pixelOffset);
	}

	return none;
}

private function H7FCTElement StartFCTReal(EFCTType type, Vector startPosition, optional String text = "", optional Color textColor = MakeColor(255,255,255,255) , optional Texture2d icon) // optional Vector2D pixelOffset = vect2d(0,0))
{
	local H7FCTElement newFCT;
	local int flashID;
	local String flashIconPath;
	local Vector2D pixelOffset;

	if(icon == none)
	{
		flashIconPath = mFCTType2IconMapping.GetFlashIconPath( type );
	}
	else
	{
		flashIconPath = "img://" $ Pathname( icon );
	}

	// OPTIONAL new system that avoids overlaps in a smart way
	// just move it to the bottom for now
	if( mActiveFCTs.Length > 0 && GetLastConflictingFloatOffset(startPosition) > -1)
	{
		pixelOffset.Y += GetLastConflictingFloatOffset(startPosition) + 50;
	}

	;

	// auto colors
	if(textColor == MakeColor(255,255,255,255))
	{
		switch(type)
		{
			case FCT_ERROR:textColor = MakeColor(255,0,0,0);break;
		}
	}
	
	flashID = class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().GetFloatingSystem().CreateFloatingCombatText(type, flashIconPath , text, -100,-100, textColor.R, textColor.G, textColor.B);

	newFCT = new class'H7FCTElement';
	newFCT.Init(startPosition,text,textColor,flashID,flashIconPath,pixelOffset,type);
	mActiveFCTs.addItem(newFCT);

	return newFCT;
}

function float GetLastConflictingFloatOffset(Vector newPos)
{
	local H7FCTElement element;
	local H7FCTElement conflictElement;
	local float lastOffset;

	lastOffset = -1;

	foreach mActiveFCTs(element)
	{
		if(IsConflicting(element.GetWorldPosition(),newPos))
		{
			conflictElement = element;
			if(conflictElement.GetPixelOffset().Y > lastOffset) lastOffset = conflictElement.GetPixelOffset().Y;
		}
	}

	return lastOffset;
}

function bool IsConflicting(Vector a,Vector b)
{
	if(Round(a.X) == Round(b.X) && Round(a.Y) == Round(b.Y)) return true;
	else return false;
}

// - called every frame
event Tick(float deltaTime)
{
	local H7FCTElement fct;
	local int i;
	
	super.Tick(deltaTime); // why? - because it's just common courtesy to call you super that way

	foreach mActiveFCTs(fct,i)
	{
		if( fct.GetType() == FCT_HIGHLIGHT && !mIsHighlighting )
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().GetFloatingSystem().KillFloat(fct.GetFlashID());
			mActiveFCTs.remove(i,1);
		}
		else
		{
			fct.Age(deltaTime);
			if( fct.isDead() )
			{
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().GetFloatingSystem().KillFloat(fct.GetFlashID());
				mActiveFCTs.remove(i,1);
			}
		}
	}
}

// - called every frame // OPTIONAL unify Render and Tick
function Render(Canvas myCanvas)
{
	local H7FCTElement fct;
	
	foreach mActiveFCTs(fct)
	{
		fct.Render(myCanvas);
	}
}

