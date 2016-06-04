//=============================================================================
// H7BackgroundImageProperties
//
// Image properties used by the H7GFxBackgroundImage and ultimatly by H7GFxBackgroundImageCntl. 
// Stored here to allow easy manipulation from within Unreal Editor.
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BackgroundImageProperties extends Object
	HideCategories(Object);

	var(Images) Texture2D DefeatBG_Wide;
	var(Images) Texture2D VictoryBG_Wide;
	var(Images) Texture2D DefeatBG_4x3;
	var(Images) Texture2D VictoryBG_4x3;
	var(Images) Texture2D MainMenuImage;
	var(Images) Texture2D FallbackScreenshot;
	var(Images) Texture2D SpecatortHUDImage;


	var(Timings) float fadeInDelayOnFleeSurrender<DisplayName=Fade in Delay when fleeing or surrendering>;
	var(Timings) float fadeInTimeOnFleeSurrender<DisplayName=Fade in Time when fleeing or surrendering>;
	
	var(Timings) float fadeInDelayOnWin<DisplayName=Fade in Delay when winning>;
	var(Timings) float fadeInDelayOnLose<DisplayName=Fade in Delay when losing (getting destroyed)>;
	var(Timings) float fadeInTimeOnWin<DisplayName=Fade in Time when winning>;
	var(Timings) float fadeInTimeOnLose<DisplayName=Fade in Time when losing (getting destroyed)>;



// Default properties block
