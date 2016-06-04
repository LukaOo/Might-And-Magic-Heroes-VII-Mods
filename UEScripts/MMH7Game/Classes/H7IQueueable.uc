//=============================================================================
// H7IQueueable
//=============================================================================
// 
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IQueueable
	dependson(H7StructsAndEnumsNative);

function PutPopupIntoQueue(H7PopupParameters params,EPlayerNumber recipient, optional EMessageCreationContext creationContext = MCC_UNKNOWN) {}

function OpenPopupFromQueue(H7PopupParameters params) {}
