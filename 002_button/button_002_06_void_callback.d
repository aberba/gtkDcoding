// Example of:
//  a plain button
//  coded in the OOP paradigm
//  command line args are passed to a void callback

import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;
import gdk.Event;

void main(string[] args)
{
	Main.init(args);
	TestRigWindow myTestRig = new TestRigWindow("Test Rig OOP", args);
	
	// give control over to the gtkD .
	Main.run();
	
} // main()


class TestRigWindow : MainWindow
{
	this(string title, string[] args)
	{
		super(title);
		addOnDestroy(&quitApp);                                     // *** NEW ***
		
		MyButton button = new MyButton("Click this", args);
		add(button);
	
		// Show the window and its contents...
		showAll();

	} // this()
	
	
	void quitApp(Widget w)                                         // *** NEW ***
	{
		writeln("Bye.");
		Main.quit();
		
	} // quitApp()

} // class TestRigWindow

 
class MyButton : Button
{
	this(string label, string[] args)
	{
		super(label);
		// Either of the two following lines will do the job at hand. The first
		// line shows the actual syntax while the second shows the same thing, but
		// using type inference.
		//addOnClicked(delegate void(Button b) { buttonAction(args); });          // *** NEW ***
		addOnClicked(delegate void(_) { buttonAction(args); });                   // *** NEW ***
		
	} // this()
	
	
	void buttonAction(string[] args)                                             // *** NEW ***
	{
		writeln("The command line arguments are:");

		foreach(arg; args)
		{
			if(arg != args[0])
			{
				writeln("\t", arg);
			}
		}
		
	} // buttonAction()
	
} // class MyButton