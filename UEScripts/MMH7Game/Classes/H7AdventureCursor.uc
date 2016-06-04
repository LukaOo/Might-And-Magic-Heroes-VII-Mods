//=============================================================================
// H7AdventureCursor
//
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureCursor extends Object
					dependson( H7PlayerController );

var protected bool mDrag;

function SetCursor( ECursorType cursorType )
{
	class'H7PlayerController'.static.GetPlayerController().SetCursor( cursorType );
}

function UpdateAdventureCursorWithItem(optional H7HeroItem item)
{
	// set cursor icon for drag&drop
	if(item != none)
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursorTexture(none, item.GetIcon());
		
		if(!mDrag)
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DRAG");
			mDrag = true;
		}
	}
	else if (mDrag)
	{
		class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
		mDrag = false;
	}
}

function UpdateAdventureCursorWithSpell(optional H7BaseAbility spell)
{
	// set cursor icon for drag&drop
	if(spell != none)
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursorTexture(none, spell.GetIcon() , 40 , 0 , 40 , 40);
		
		if(!mDrag)
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("SELECT_SPELL");
			mDrag = true;
		}
	}
	else if (mDrag)
	{
		class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
		mDrag = false;
	}
}

function UpdateAdventureCursorWithStack(optional H7BaseCreatureStack stack)
{
	;
	if(stack !=none)
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursorTexture(none, stack.GetStackType().GetIcon());
		if(!mDrag)
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DRAG");
			mDrag = true;
		}
	}
	else if (mDrag)
	{
		class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
		mDrag = false;
	}
}

function UpdateAdventureCursorWithWarfareUnit(optional H7EditorWarUnit unit)
{
	if(unit !=none)
	{
		class'H7PlayerController'.static.GetPlayerController().SetCursorTexture(none, unit.GetIcon());
		
		if(!mDrag)
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DRAG");
			mDrag = true;
		}
	}
	else if (mDrag)
	{
		class'H7PlayerController'.static.GetPlayerController().UnLoadCursorObject();
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
		mDrag = false;
	}
}
