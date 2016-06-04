class H7Message extends Object 
	dependson(H7MessageSystem)
	perobjectconfig
	hidecategories(Object);

var() localized String textTemplate;
var() H7MessageDestination destination;
var() H7MessageSettings settings;
var transient int ID;
var transient int creationTime;
var transient EMessageCreationContext creationContext;
var transient EPlayerNumber mPlayerNumber;
var transient String text;
var transient String mTooltip;
var transient bool mWaitingForOtherLocalPlayer;
var transient bool mWasAssigned;

var protected array<H7TooltipReplacementEntry>    mTooltipMapping;

function string GetTextTemplateLocalized() 
{
	return class'H7Loca'.static.LocalizeContent( self, "textTemplate", textTemplate );
}

function H7Message CreateMessageBasedOnMe()
{
	local H7Message message;

	message = new class'H7Message'(self);

	message.text = GetTextTemplateLocalized();

	;
	;

	return message;
}

function AddRepl(String placeholder,String value)
{
	local H7TooltipReplacementEntry entry;
	entry.placeholder = placeholder;
	entry.value = value;
	mTooltipMapping.AddItem(entry);
}

function array<H7TooltipReplacementEntry> GetMapping() {return mTooltipMapping;}

// checks if the given mapping can be merged with the message's mapping
function bool CanMergeMapping(array<H7TooltipReplacementEntry> mergeMapping)
{
	local H7TooltipReplacementEntry entryOld,entryNew;
	local int i;
	
	foreach mTooltipMapping(entryOld,i)
	{
		foreach mergeMapping(entryNew)
		{
			if(entryOld.placeholder == entryNew.placeholder)
			{
				if(int(entryOld.value) > 0 && int(entryNew.value) > 0) // is int && is int
				{
					// don't care if numbers are different
				}
				else if(entryOld.value != entryNew.value)
				{
					return false;
				}
			}
		}
	}
	return true;
}

// OPTIONAL can't merge ADDPERCENT,MULTIPLY and SET values, assumes it's ADD
function MergeMapping(array<H7TooltipReplacementEntry> mergeMapping)
{
	local H7TooltipReplacementEntry entryOld,entryNew;
	local int i;
	
	foreach mTooltipMapping(entryOld,i)
	{
		foreach mergeMapping(entryNew)
		{
			if(entryOld.placeholder == entryNew.placeholder)
			{
				if(int(entryOld.value) > 0 && int(entryNew.value) > 0) // is int && is int
				{
					//`log_dui("merging" @ entryOld.placeholder @ entryOld.value @ entryNew.value @ int(entryOld.value) @ int(entryNew.value));
					mTooltipMapping[i].value = String(int(entryOld.value) + int(entryNew.value));
					//`log_dui("->" @ mTooltipMapping[i].value);
				}
			}
		}
	}

	text = GetFormatedText();
}

function bool IsLocaKey(string unknown)
{
	return class'H7Loca'.static.IsLocaKey(unknown);
}

// colors, localized and replaces basetext
function String GetFormatedText()
{
	local String displayedText,valueColor,valueColoredHTML;
	local H7TooltipReplacementEntry entry;
	local Color nameColor;
	local String useText;

	if(text != "" && textTemplate == "") useText = text;
	else if(text == "" && textTemplate != "") useText = textTemplate;
	else 
	{
		;
		useText = text;
	}

	if(IsLocaKey(useText))
	{
		displayedText = class'H7Loca'.static.LocalizeSave(useText,"H7Message");
		if(class'H7Loca'.static.LocalizeFailed(displayedText))
		{
			displayedText = useText;
		}
	}
	else
	{
		displayedText = useText;
	}

	switch(destination)
	{
		case MD_LOG:
			displayedText = "<font size='#TINY#'>" $ displayedText $ "</font>";
			break;
		case MD_QA_LOG:
			displayedText = "<font size='#TINY#' color='#ff0000'>" $ displayedText $ "</font>";
			break;
	} 

	foreach mTooltipMapping(entry)
	{
		switch(entry.placeholder)
		{
			case "%n": // show names in the color of the player:
				if(settings.referenceObject != none)
				{
					if(H7CreatureStack(settings.referenceObject) != none)
					{
						nameColor = H7CreatureStack(settings.referenceObject).GetPlayer().GetColor();
					}
					else if(H7EditorHero(settings.referenceObject) != none)
					{
						nameColor = H7EditorHero(settings.referenceObject).GetPlayer().GetColor();
					}
					else
					{
						;
						nameColor = MakeColor(200,200,200);
					}
					valueColor = class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl().UnrealColorToHex(nameColor);
				}
				else
				{
					nameColor = MakeColor(200,200,200);
				}
				
			break;
			default:
				valueColor = "ffcc99";
				valueColor = class'H7TextColors'.static.GetInstance().UnrealColorToHex(class'H7TextColors'.static.GetInstance().mLogReplacementColor);
				break;
		}

		// apply color
		if(valueColor != "" && !settings.preventHTML)
		{
			valueColoredHTML = "<font color='#"$valueColor$"'>"$entry.value$"</font>";
		}
		else
		{
			valueColoredHTML = entry.value;
		}
		
		displayedText = Repl(displayedText,entry.placeholder,valueColoredHTML);

	}

	return displayedText;
}

function GUIWriteInto(out GFxObject data) // called manually, not part of ListeningSystem
{
	data.SetInt("ID",ID);
	data.SetString("Text",text);
	data.SetString("Icon","img://" $ PathName(settings.icon));
	
	// to prevent fade out, give it an action
	if(settings.fadeOutAfterXSeconds > 0)
	{
		data.SetBool("FadeOut",true);
		data.SetFloat("FadeOutAfterXSeconds",settings.fadeOutAfterXSeconds);
	}
	else
	{
		data.SetBool("FadeOut", settings.action == MA_NONE || settings.actionDuration > 0); // OPTIONAL prevent actionDuration > than default decay timer
		// fade out time will be: default setting
	}
	
	data.SetBool("DeleteWhenClicked",settings.deleteWhenClicked);
	data.SetBool("AllowDestroy",settings.allowDestroy);
	data.SetBool("HasRef",settings.referenceObject != none); // = glows when hovered
	
	if(mTooltip != "")
	{
		data.SetString("Tooltip",mTooltip);
	}
	// OPTIONAL rest
}

