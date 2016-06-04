//=============================================================================
// H7BackgroundImage
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxBackgroundImage extends H7GFxUIContainer;

//var protected const H7BackgroundImageProperties ImageProperties;

private function LoadBackground(String backgroundPath, optional int fadeInTime, optional int fadeInDelay, optional string screenText)
{
	ActionScriptVoid("LoadBackground");
}

function LoadBackgroundTexture(Texture2d texture, optional int fadeInTime, optional int fadeInDelay, optional string screenText)
{
	LoadBackground("img://H7Backgrounds." $ texture.Name, fadeInTime, fadeInDelay, screenText);
}

