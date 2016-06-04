//=============================================================================
// looks DEPRECATED
// 
// H7StartScreenController
//
// controls the UI_QuickStart.swf
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7StartScreenController extends H7FlashMovieCntl;

/** Reference to the label used to display the message on the UI */
var GFxObject MessageLabel;

/** Reference to the text field used to enter the player's name */
var GFxObject PlayerText;

/** Reference to the text field used to enter the player's title */
var GFxObject TitleText;

/** Reference to the text field used to enter the player's clan */
var GFxObject ClanText;

/** Reference to the button used to save the profile info - must add a widget binding since we expect a GFxCLIKWidget */
var GFxCLIKWidget SaveButton;

/** Reference to the button used to close the UI - must add a widget binding since we expect a GFxCLIKWidget */
var GFxCLIKWidget ExitButton;

// Called when the UI is opened to start the movie
function bool Start(optional bool StartPaused = false) 
{
	// Start playing the movie
    Super.Start();

	// Initialize all objects in the movie
    AdvanceDebug(0);

	Super.Initialize();
    return true;
}

// Callback automatically called for each object in the movie with enableInitCallback enabled
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    // Determine which widget is being initialized and handle it accordingly
    switch(Widgetname)
    {
        case 'messageLabel':
        	// Save reference to the label that displays the message to the player
            MessageLabel = Widget;
            break;
        case 'playerText':
        	// Save reference to the text field for the player's name
            PlayerText = Widget;
            break;
        case 'titleText':
        	// Save reference to the text field for the player's title
            TitleText = Widget;
            break;
        case 'clanText':
        	// Save reference to the text field for the player's clan
            ClanText = Widget;
            break;
        case 'saveButton':
        	// Save reference to the button that saves the profile info
		// the Widget is cast to a GFxCLIKWidget to allow for event listeners - see WidgetBindings
            SaveButton = GFxCLIKWidget(Widget);
            // Add a delegate for when this button is clicked
            SaveButton.AddEventListener('CLIK_click', SavePlayerData);
            break;
        case 'exitButton':
        	// Save reference to the button that closes the UI
		// the Widget is cast to a GFxCLIKWidget to allow for event listeners - see WidgetBindings
            ExitButton = GFxCLIKWidget(Widget);
            // Add a delegate for when this button is clicked
            ExitButton.AddEventListener('CLIK_click', CloseMovie);
            break;
        default:
        	// Pass on if not a widget we are looking for
            return Super.WidgetInitialized(Widgetname, WidgetPath, Widget);
    }
    
    return false;
}

// Delegate added to change the message using the data entered
//In a real game situation, the data would be saved somewhere
function SavePlayerData(EventData data)
{
    // Only on left mouse button
    if(data.mouseIndex == 0)
    {
    	// Set the text property of the message label using the profile info entered
        MessageLabel.SetString("text", "Welcome,"@PlayerText.GetString("text")@"("$TitleText.GetString("text")@"in"@ClanText.GetString("text")$")");
    }
}
 
// Delegate added to close the movie
function CloseMovie(EventData data)
{
    // Only on left mouse button
    if(data.mouseIndex == 0)
    {
    	// Close the UI
        Close();
    }
}

