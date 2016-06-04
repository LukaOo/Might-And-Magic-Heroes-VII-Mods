class H7SeqAct_SetPlayerInputEnabled extends SequenceAction;

var(PlayerInput) bool mIsPlayerInputEnabled<DisplayName=Is Unreal Input Enabled>;
var(PlayerInput) bool mIsGUIInputEnabled<DisplayName=Is Flash Input Enabled>;

event Activated()
{
	class'H7PlayerController'.static.GetPlayerController().SetInputAllowedFromKismet( mIsPlayerInputEnabled );
	if(mIsGUIInputEnabled)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().UnblockAllFlashMovies();
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().BlockAllFlashMovies();
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

