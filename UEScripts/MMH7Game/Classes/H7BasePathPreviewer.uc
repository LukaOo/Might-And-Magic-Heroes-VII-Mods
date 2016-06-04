//=============================================================================
// H7BasePathPreviewer
//
//
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BasePathPreviewer extends Actor;

const DECAL_OFFSET = 200.0f;

var protected array<H7PathDot> mUnusedDots;
var protected array<H7PathDot> mUsedDots;

function HidePreview()
{
	local H7PathDot dot;

	foreach mUsedDots( dot )
	{
		dot.SetHidden( true );
		mUnusedDots.AddItem( dot );
	}

	mUsedDots.Length = 0;
}
