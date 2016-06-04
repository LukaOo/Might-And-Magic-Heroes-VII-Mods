// Saves the user settings in the game ini file

class H7PopupKeybindings extends Object
	config(game)
	hideCategories(Object)
;

struct KeyCommand
{
	var String command; // ID string to identfy command and map it

	var KeyBind keyPrimary;
	var KeyBind keySecondary;
};

var() config array<KeyCommand> mPopupKeybindings;

function ChangeKeybind(string changeCommand,name key)
{
	local int i;

	for(i=0;i<mPopupKeybindings.Length;i++)
	{
		if(mPopupKeybindings[i].command == changeCommand && mPopupKeybindings[i].keyPrimary.Name == 'R')
		{
			mPopupKeybindings[i].keyPrimary.Name = key;
		}
	}

	SaveConfig();
}
