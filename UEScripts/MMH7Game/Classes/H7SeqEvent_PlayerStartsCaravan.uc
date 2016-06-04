/*============================================================================
* H7SeqEvent_PlayerStartsCaravan
*
* Triggers when player orders caravan.
* 
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/
class H7SeqEvent_PlayerStartsCaravan extends H7SeqEvent_PlayerEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

