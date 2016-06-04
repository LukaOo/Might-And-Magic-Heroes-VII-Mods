/*=============================================================================
 * H7SeqAct_ObjectiveAndGateStatus
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/
class H7SeqAct_ObjectiveAndGateStatus extends Object
	native
	savegame;

/** Is this gate currently open? */
var savegame bool IsOpen;

/** Mirrors the InputLinks array, hold data whether a specific input has fired. */
var savegame array<bool> LinkedOutputFiredStatus;

/** Cached array of linked input ops for this gate, so we can track that they have all fired. */
var transient native array<pointer>	LinkedOutputs{FSeqOpOutputLink};

