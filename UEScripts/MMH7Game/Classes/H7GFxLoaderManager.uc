//=============================================================================
// H7GFxLoaderManager
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxLoaderManager extends H7GFxUIContainer
;

struct LoaderEntry
{
	var string filename; // without .swf .gfx
	var SwfMovie movie;
	var H7FlashMovieCntl controller;
	var delegate<OnLoadComplete> callbackFunction;
};

var protected array<LoaderEntry> mLoaderEntries;
var protected array<LoaderEntry> mLoaderQueue;
var protected H7FlashMovieCntl mCurrentlyLoading;

public delegate OnLoadComplete();

function H7FlashMovieCntl GetCurrentlyLoadingCntl() { return mCurrentlyLoading; }

function LoadMovie(H7FlashMovieCntl controller,delegate<OnLoadComplete> callbackFunction)
{
	local LoaderEntry entry;
	entry.filename = String(controller.MovieInfo);
	entry.movie = controller.MovieInfo;
	entry.callbackFunction = callbackFunction;
	entry.controller = controller;
		
	if(mCurrentlyLoading == none)
	{
		StartLoading(entry);
	}
	else
	{
		mLoaderQueue.AddItem(entry);
	}
}

private function StartLoading(LoaderEntry entry)
{
	mCurrentlyLoading = entry.controller;
	mLoaderEntries.AddItem(entry);

	;
	LoadSWF("../../" $ Repl(PathName(entry.movie),".","/") $ ".swf");
}
private function LoadSWF(string path)
{
	ActionScriptVoid("LoadSWF");
}

function LoadComplete(string filename) // arrives with .gfx
{
	local LoaderEntry entry;
	local delegate<OnLoadComplete> callback;
	;
	foreach mLoaderEntries(entry)
	{
		//`log_dui(entry.filename @ filename);
		//`log_dui(Caps(entry.filename));
		//`log_dui(mid(Caps(filename),0,len(filename)-4));
		if(Caps(entry.filename) == mid(Caps(filename),0,len(filename)-4) )
		{
			callback = entry.callbackFunction;
			callback();
		}
	}

	mCurrentlyLoading = none;
	if(mLoaderQueue.Length > 0)
	{
		entry = mLoaderQueue[0];
		mLoaderQueue.Remove(0,1);
		StartLoading(entry);
	}
}
