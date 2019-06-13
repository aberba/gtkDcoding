// label with a colored background
// has to be done by dropping the Label into an EventBox

import std.stdio;

import gtk.Main;
import gtk.MainWindow;
import gtk.EventBox; // Labels can't have a background color, so we pack them in EventBoxes which can
import gtk.Label;
import gdk.RGBA; // needed for defining colors for the label backgrounds

// Note: StateFlags are found in gtk.c.types

void main(string[] args)
{
	Main.init(args);

	testRigWindow testRigWindow = new testRigWindow();

	Main.run();
	
} // main()


class testRigWindow : MainWindow
{
	string title = "A label with a colored background";
	
	this()
	{
		super(title);
		
		RedLabel redLabel = new RedLabel(); // extra spaces at start and end so it doesn't look crowded
		add(redLabel);

		showAll();
		
	} // this()
	
	
} // class testRigWindow


// wrap a widget in an EventBox
class RedLabel : EventBox                                                       // *** NEW ***
{
	string labelText = "  Label with Red Background  ";
	
	this()
	{
		super();
		Label label = new Label(labelText);
		RGBA redColor = new RGBA(1.0, 0.420, 0.557, 1.0); // 1.000	0.420	0.557
		overrideBackgroundColor(StateFlags.NORMAL, redColor);
		
		add(label);
		
	} // this()
	
} // class RedLabel
