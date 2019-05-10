/*
 Diagram:
 
 MyMenuBar
 	FileMenuHeader
 		FileMenu
 			NewFileItem
 			OpenFileItem
 			CloseFileItem
 			QuitItem
 	EditMenuHeader
 		EditMenu
 			UndoItem
 			RedoItem
 			CutItem
 			CopyItem
 			PasteItem
 	
 */

import std.stdio;

import gtk.MainWindow;
import gtk.Box;
import gtk.Main;
import gtk.Menu;
import gtk.MenuBar;
import gtk.MenuItem;
import gtk.Widget;
import gdk.Event;
import gtk.AccelGroup;
import gdk.c.types;

// NOTE: use the '-i' compiler flag to include our own external modules
import singleton.SingletonAccelGroup;

void main(string[] args)
{
    Main.init(args);

    TestRigWindow testRig = new TestRigWindow();
    
    Main.run();
    
} // main()


class TestRigWindow : MainWindow
{
	string title = "Multiple Menus Example";
	SingletonAccelGroup singletonAccelGroup;

	this()
	{
		super(title);
		setDefaultSize(640, 480);
		addOnDestroy(&quitApp);

		singletonAccelGroup = singletonAccelGroup.get();
		addAccelGroup(singletonAccelGroup);

		AppBox appBox = new AppBox();
		add(appBox);
		
		showAll();
		
	} // this()
	
	
	void quitApp(Widget w)
	{
		// do other quit stuff here if necessary
		
		Main.quit();
		
	} // quitApp()
	
} // TestRigWindow


class AppBox : Box
{
	int padding = 10;
	MyMenuBar menuBar;
	
	this()
	{
		super(Orientation.VERTICAL, padding);
		
		menuBar = new MyMenuBar();
    	packStart(menuBar, false, false, 0);		
		
	} // this()
	
} // class AppBox


class MyMenuBar : MenuBar
{
	string fileHeaderLabel = "File";
	string editHeaderLabel = "Edit";
	
	FileMenuHeader fileHeader;
	EditMenuHeader editHeader;
	
	this()
	{
		super();
		
		fileHeader = new FileMenuHeader(fileHeaderLabel);
		append(fileHeader);
				
		editHeader = new EditMenuHeader(editHeaderLabel);
		append(editHeader);		
		
	} // this()
	
} // class MyMenuBar


class FileMenuHeader : MenuItem
{
	FileMenu fileMenuHeader;
	
	// arg: a Menu object
	this(string headerTitle)
	{
		super(headerTitle);
		
		fileMenuHeader = new FileMenu();
		setSubmenu(fileMenuHeader);
		
	} // this()
	
} // class MenuHeader


class EditMenuHeader : MenuItem
{
	EditMenu editMenuHeader;
	
	// arg: a Menu object
	this(string headerTitle)
	{
		super(headerTitle);
		
		editMenuHeader = new EditMenu();
		setSubmenu(editMenuHeader);
		
	} // this()
	
} // class MenuHeader


class FileMenu : Menu
{
	NewFileItem newFileItem;
	OpenFileItem openFileItem;
	SaveFileItem saveFileItem;
	SaveAsFileItem saveAsFileItem;
	CloseFileItem closeFileItem;
	QuitItem quitItem;
	
	// arg: an array of items
	this()
	{
		super();
		
		newFileItem = new NewFileItem();
		append(newFileItem);
		
		openFileItem = new OpenFileItem();
		append(openFileItem);
		
		saveFileItem = new SaveFileItem();
		append(saveFileItem);
		
		saveAsFileItem = new SaveAsFileItem();
		append(saveAsFileItem);
		
		closeFileItem = new CloseFileItem();
		append(closeFileItem);
		
		quitItem = new QuitItem();
		append(quitItem);
		
	} // this()
	
	
} // class FileMenu


class EditMenu : Menu
{
	UndoItem undoItem;
	RedoItem redoItem;
	CutItem cutItem;
	CopyItem copyItem;
	PasteItem pasteItem;
	NonStandardItem nonStandardItem;
	
	// arg: an array of items
	this()
	{
		super();
		
		undoItem = new UndoItem();
		append(undoItem);
		
		redoItem = new RedoItem();
		append(redoItem);
		
		cutItem = new CutItem();
		append(cutItem);
		
		copyItem = new CopyItem();
		append(copyItem);
		
		pasteItem = new PasteItem();
		append(pasteItem);
		
		nonStandardItem = new NonStandardItem();
		append(nonStandardItem);
		
	} // this()
	
} // class EditMenu


class QuitItem : MenuItem
{
	string itemLabel = "Quit";
	char accelKey = 'q';
	SingletonAccelGroup singletonAccelGroup;
   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();		
		super(&doSomething, itemLabel, "activate", true, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		//addOnActivate(&doSomething);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("Quitting... Bye.");
		
		Main.quit();
		
	} // quit()
	
} // class QuitItem


class NewFileItem : MenuItem
{
	string itemLabel = "New";
	char accelKey = 'n';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("New file created.");
		
	} // doSomethingNew()
	
} // class NewFileItem


class OpenFileItem : MenuItem
{
	string itemLabel = "Open";
   char accelKey = 'o';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("A file dialog will be shown now for chosing a file to open.");
		
	} // doSomething()
	
} // class OpenFileItem


class SaveFileItem : MenuItem
{
	string itemLabel = "Save";
	char accelKey = 's';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("A file dialog will be shown ONLY if the file hasn't yet been saved.");
		
	} // doSomething()
	
} // class SaveFileItem


class SaveAsFileItem : MenuItem
{
	string itemLabel = "Save as...";
	char accelKey = 's';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK | ModifierType.SHIFT_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("A file dialog will be shown so the file can be saved under a different name.");
		
	} // doSomething()
	
} // class SaveAsFileItem


class CloseFileItem : MenuItem
{
	string itemLabel = "Close";
	char accelKey = 'w';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("The file is closed.");
		
		// If this was the last open file, 
		// ask the user if the the application should also be closed.
		
	} // doSomething()
	
} // class CloseFileItem


class UndoItem : MenuItem
{
	string itemLabel = "Undo";
	char accelKey = 'z';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("Doing Undo.");
		
	} // doSomething()
	
} // class UndoItem


class RedoItem : MenuItem
{
	string itemLabel = "Redo";
	char accelKey = 'z';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK | ModifierType.SHIFT_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("Doing Redo.");
		
	} // doSomething()
	
} // class RedoItem


class CutItem : MenuItem
{
	string itemLabel = "Cut";
	char accelKey = 'x';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("Cutting...");
		
	} // doSomething()
	
} // class CutItem


class CopyItem : MenuItem
{
	string itemLabel = "Copy";
	char accelKey = 'c';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("Copying...");
		
	} // doSomething()
	
} // class CopyItem


class PasteItem : MenuItem
{
	string itemLabel = "Paste";
	char accelKey = 'p';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("Pasting...");
		
	} // doSomething()
	
} // class PasteItem


class NonStandardItem : MenuItem
{
	string itemLabel = "Non-standard command";
	char accelKey = 'j';
	SingletonAccelGroup singletonAccelGroup;
	   
	this()
	{
		singletonAccelGroup = singletonAccelGroup.get();
		super(&doSomething, itemLabel, "activate", false, singletonAccelGroup, accelKey, ModifierType.CONTROL_MASK | ModifierType.MOD1_MASK, AccelFlags.VISIBLE);
		
	} // this()
	
	
	void doSomething(MenuItem mi)
	{
		writeln("This is a non-standard item to show a Ctrl-Alt key combo.");
		
	} // doSomething()
	
} // class PasteItem
