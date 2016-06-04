class H7GFxLogChat extends H7GFxLog
	dependson(H7StructsAndEnumsNative);

function ListenUpdate(H7IGUIListenable gameEntity)
{
	mData = CreateArray();

	;
	H7Log(gameEntity).GUIWriteInto(mData,LF_EVERYTHING,self);
	
	;
	SetObject("mData",mData);

	UpdateChat();
}

function UpdateChat()
{
	;
	ActionScriptVoid("UpdateChat");
}

function SwitchToChat()
{
	ActionScriptVoid("SwitchToChat");
}

function AddPlayerToChat(string playerName,int playerChatIndex)
{
	ActionScriptVoid("AddPlayerToChat");
}
