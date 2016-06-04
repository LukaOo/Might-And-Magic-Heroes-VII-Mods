//=============================================================================
// H7ObjectListenable (alternative to H7IGUIListenable)
//
// Here goes what is common to all actors/unreal elements that can display something of themselves in the GUI
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ObjectListenable extends Object; // NOT USED ATM

var protected array<H7GFxListener> mListener;

function DataChanged()
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}
