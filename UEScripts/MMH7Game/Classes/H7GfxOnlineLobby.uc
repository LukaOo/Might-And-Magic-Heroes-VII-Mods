//=============================================================================
// H7GfxOnlineLobby
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GfxOnlineLobby extends H7GFxUIContainer;

function DisableWindow()
{
	Update();
	SetVisibleSave( false );
}

function EnableWindow( ) 
{
	Update();
	SetVisibleSave( true );
}

function Update( )
{
	ActionscriptVoid("Update");
}
