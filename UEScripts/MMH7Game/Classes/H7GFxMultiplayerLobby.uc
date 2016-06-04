//=============================================================================
// H7GFxMultiplayerLobby
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMultiplayerLobby extends H7GFxUIContainer;


function Update( )
{
	ActionscriptVoid("Update");
}

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
