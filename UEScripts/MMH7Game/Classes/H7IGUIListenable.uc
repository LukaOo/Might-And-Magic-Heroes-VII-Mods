//=============================================================================
// H7IGUIListenable (alternative to H7ObjectListenable)
//
// Heros,Towns,Units,Armies... every game entity that can change and then wants to 
// cause an automatic update of the GUI representation of it, can implement this
// interface
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IGUIListenable;

// Game Object needs to know how to write its data into GFx format, 
// -- only needed if DataObjects listens, else GFxObject can read game object
function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	
}

/*
function bool HasDataChanged()
{
	`log_gui(self @ "HasDataChanged not implemented")
	return false;
}
*/

// The following 2 functions are usually the same for all children, copy and paste:

// WriteInto this GFxObject if DataChanged
function GUIAddListener(GFxObject data,optional H7ListenFocus focus) 
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}

// Game Object needs to know what to do when its data changes (usually they just call ListeningManager)
function DataChanged(optional String cause) 
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}
