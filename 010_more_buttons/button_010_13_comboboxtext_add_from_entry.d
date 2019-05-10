// Test Rig Foundation for Learning GtkD Coding

import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Box;
import gtk.Widget;
import gtk.ComboBoxText;
import gtk.Entry; // because we have an Entry in this ComboBoxText
import gtk.Bin; // needed for getChild() to retrieve the Entry and, from there, retrieve its text
import gtk.Button;

import gdk.Event; // needed for addOnKeyRelease() and addOnReleased()
import gdk.Keysyms; // needed for detecting which key was pressed
import gobject.ParamSpec;

void main(string[] args)
{
	Main.init(args);

	TestRigWindow myTestRig = new TestRigWindow("Test Rig");
	
	Main.run();
	
} // main()


class TestRigWindow : MainWindow
{
	AppBox appBox;
	
	this(string title)
	{
		super(title);
		addOnDestroy(&quitApp);
		
		appBox = new AppBox();
		add(appBox);
		
		showAll();

	} // this() CONSTRUCTOR
	
		
	void quitApp(Widget widget)
	{
		writeln("Bye.");
		Main.quit();
		
	} // quitApp()

} // class myAppWindow


class AppBox : Box
{
	DayComboBoxText dayComboBoxText;
	RetrieveEntryButton retrieveEntryButton;
	
	this()
	{
		super(Orientation.HORIZONTAL, 10);
		
		dayComboBoxText = new DayComboBoxText();
		packStart(dayComboBoxText, false, false, 0);
		
		retrieveEntryButton = new RetrieveEntryButton(dayComboBoxText);
		packEnd(retrieveEntryButton, false, false, 0);
		
		writeln("Type something into the Entry, then hit the Add button.");
		writeln("You can also hit Enter to echo the contents of the Entry to the terminal, but this action doesn't add the contents to the list.");
	} // this()

} // class AppBox


class DayComboBoxText : ComboBoxText
{
	string[] days = ["yesterday", "today", "tomorrow"];
	bool entryOn = true;
	Entry _entry;
	
	this()
	{
		super(entryOn);
		
		foreach(day; days)
		{
			appendText(day);
		}

		_entry = cast(Entry)getChild();
		_entry.addOnFocusOut(&onFocusOut);
//		addOnFocusOut(&onFocusOut); 			// doesn't fire
//		addOnKeyRelease(&onKeyRelease); 		// doesn't fire
		addOnChanged(&onChanged);
		addOnEventAfter(&onEventAfter);

	} // this()


	void onEventAfter(Event e, Widget w)
	{
		writeln("onEventAfter: ", getActiveText());
		
	} // onEventAfter()
	

	bool onFocusOut(Event e, Widget w)
	{
		bool stopHere = false;
		
		writeln("onFocusOut: ", getActiveText());
		
		return(stopHere);
	}


	bool onKeyRelease(Event event, Widget w)
	{
		bool stopHereFlag = true;
		
		if(event.type == EventType.KEY_RELEASE)
		{
			GdkEventKey* keyEvent = event.key;
			
			if(keyEvent.keyval == GdkKeysyms.GDK_Return)
			{
				writeln("onKeyRelease: ", getActiveText());			
			}
		}

		return(stopHereFlag);
		
	} // echoToTerminal()

	
	void onChanged(ComboBoxText cbt)
	{
		// how to filter out key presses and just react to selecting an item from the list
		
		
//		if(event.type == EventType.KEY_RELEASE)
//		{
//			GdkEventKey* keyEvent = event.key;
			
//			if(keyEvent.keyval == GdkKeysyms.GDK_Return)
//			{
				writeln("onChanged: ", getActiveText());			
//			}
//		}
		
	} // reportSelected()
	
} // class DayComboBoxText


class RetrieveEntryButton : Button
{
	private:
	ComboBoxText _comboBoxText;
	Entry _entry;
	string _entryText, buttonText = "Add";
	
	public:
	this(ComboBoxText comboBoxText)
	{
		super(buttonText);
		
		_comboBoxText = comboBoxText;

		addOnReleased(&doSomething);		
		
	} // this()
	
	
	void doSomething(Button b)
	{
		_entry = cast(Entry) _comboBoxText.getChild();
		_entryText = _entry.getText();
		_comboBoxText.appendText(_entryText);

	} // doSomething()
	
} // class DayEntry
