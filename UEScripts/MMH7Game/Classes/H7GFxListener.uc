//=============================================================================
// H7GFxListener
//
// Every GUI element inside flash can be linked up to this listener and
// then gets informed if the Game-Entity it is listening to, changes
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxListener extends GFxObject;

// if gameEntity calls gameEntity.DataChanged() the H7GFxListener will get called H7GFxListener.ListenUpdate()
function ListenTo(Object gameEntity)
{
	if(H7IGUIListenable(gameEntity) != none)
	{
		class'H7ListeningManager'.static.GetInstance().AddListener(gameEntity,self);
	}
	else
	{
		;
	}
}

// needs to be implemented by the child gui element
function ListenUpdate(H7IGUIListenable gameEntity)
{
	;
}
