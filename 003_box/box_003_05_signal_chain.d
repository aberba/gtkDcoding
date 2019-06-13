// illustrates how to interrupt the flow of signals 

import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Box;
import gtk.Button;
import gtk.ToggleButton;
import gdk.Event;

void main(string[] args)
{
	testRigWindow testRigWindow;
	
	Main.init(args);

	testRigWindow = new testRigWindow();

	Main.run();
	
} // main()


class testRigWindow : MainWindow
{
	string title = "Test Rig";
	string greeting = "Hello GtkD World.";
	string ungreeting = "Bye, bye, GtkD World.";
	
	this()
	{
		super(title);
		addOnDestroy(delegate void(Widget w) { quitApp(); } );
		
		AddBox addBox = new AddBox();
		add(addBox);
		
		showAll();
		
	} // this() CONSTRUCTOR
	
	
	void sayHi()
	{
		writeln(greeting); // appears in the console, not the GUI
		
	} // sayHi()
	
	
	void quitApp()
	{
		writeln(ungreeting);
		
		Main.quit();
		
	} // quitApp()

} // class testRigWindow


class AddBox : Box
{
	this()
	{
		super(Orientation.VERTICAL, 5);
		
		WatchedButton myToggle = new WatchedButton();
		ObserverButton observerButton = new ObserverButton(myToggle);

		add(observerButton);
		add(myToggle);
		
	} // this()
	
} // class AddBox


class ObserverButton : Button
{
	string label = "Take Action";
	WatchedButton _watchedButton;
	
	this(WatchedButton watchedButton)
	{
		super(label);
		_watchedButton = watchedButton;
		
		// signal hook-ups
		addOnButtonRelease(&outputSomething);
		addOnButtonRelease(&takeAction);
		addOnButtonRelease(&clickReport);
		addOnButtonRelease(&endStatement);

	} // this()
	
	
	bool endStatement(Event event, Widget widget)
	{
		writeln("And that's the report from Walls-R-Us.\n");
		
		return(true);
		
	} // endStatement()
	
	
	bool clickReport(Event event, Widget widget)
	{
		writeln("Reporting a click.");
		
		return(false);
		
	} // clickReport()
	
	
	bool takeAction(Event event, Widget widget)
	{
		bool continueFlag = true;
		
		writeln("Action was taken.");
		
		if(_watchedButton.getMode() == true)
		{
			continueFlag = false;
			writeln("A value of 'false' keeps the signal chain going.");
		}
		else
		{
			continueFlag = true;
			writeln("A value of 'true' tells the chain its work is done.\n");
		}

		return(continueFlag);
		
	} // takeAction()
		
	
	bool outputSomething(Event event, Widget widget)
	{
		write("observedState = ", _watchedButton.getMode(), ": ");
		
		if(_watchedButton.getMode()) // if it's 'true'
		{
			writeln("Walls make good neighbours, eh.");
		}
		else
		{
			writeln("Berlin doesn't like walls.");
		}

		return(false);
		
	} // outputSomething()

} // class ObserverButton


class WatchedButton : ToggleButton
{
	string onText = "Toggle is on.\n";
	string offText = "Toggle is off.\n";
	string onLabel = "Toggle: ON";
	string offLabel = "Toggle: OFF";
	
	this()
	{
		super(onLabel);
		addOnClicked(&toggleMode);
		setMode(true);
		
		writeln(onText);
		
	} // this()
	
	
	void toggleMode(Button b)
	{
		if(getMode() == true)
		{
			setMode(false);
			writeln(offText);
			setLabel(offLabel);
		}
		else
		{
			setMode(true);
			writeln(onText);
			setLabel(onLabel);
		}
	
	} // toggleMode()
	
} // class WatchedButton
