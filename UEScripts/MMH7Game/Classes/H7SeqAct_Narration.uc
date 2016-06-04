/*=============================================================================
 * Base class for narration actions
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *===========================================================================*/

class H7SeqAct_Narration extends SeqAct_Latent
	abstract
	native;

const CONTENT_KEY = "_Content";

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

