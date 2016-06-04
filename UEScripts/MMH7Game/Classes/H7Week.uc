//=============================================================================
// H7Week
//
// class to represent current week
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7Week extends H7EffectContainer
	native(Tussi)
	savegame;


var()   protected localized string          mDescription<DisplayName=Description>;

var     private     savegame int             mDelay;

function            int             GetDelay()              { return mDelay;  }
function                            SetDelay( int delay )   { mDelay = delay; }
function                            Reduce()                { mDelay--;}

function            string          GetDescription()        
{ 
	//return class'H7Loca'.static.LocalizeContent(self, "mDescription", mDescription);
	return GetTooltip(false,GetArchetypeDescription());
}

function string GetArchetypeDescription()
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		return class'H7Loca'.static.LocalizeContent( self, "mDescription", mDescription );
	}
	else
	{
		return H7Week( ObjectArchetype ).GetArchetypeDescription();
	}
}

function OnInit(H7ICaster caster)
{
	if(IsArchetype()) 
	{
		return;
	}

	SetCaster(caster);

	InstanciateEffectsFromStructData(true);
}

