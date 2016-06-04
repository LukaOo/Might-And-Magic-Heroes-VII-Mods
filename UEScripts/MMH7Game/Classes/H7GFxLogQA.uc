class H7GFxLogQA extends H7GFxLog
	dependson(H7StructsAndEnumsNative);

function SetVisibleSave(bool val)
{
	if(val)
	{
		val = class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_WINDOW");
	}
	super.SetVisibleSave(val);
}
