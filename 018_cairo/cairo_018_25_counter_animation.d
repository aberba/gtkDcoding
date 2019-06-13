// Cairo: Draw an arc

import std.stdio;
import std.conv;
import std.math;

import gtk.MainWindow;
import gtk.Main;
import gtk.Box;
import gtk.Widget;
import cairo.Context;
import gtk.DrawingArea;
import glib.Timeout;

void main(string[] args)
{
	Main.init(args);

	testRigWindow testRigWindow = new testRigWindow();
	
	Main.run();
	
} // main()


class testRigWindow : MainWindow
{
	string title = "Cairo: Draw an Arc";
	int width = 640, height = 360; 
	AppBox appBox;
	
	this()
	{
		super(title);
		setSizeRequest(width, height);
		
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

} // class testRigWindow


class AppBox : Box
{
	MyDrawingArea myDrawingArea;
	
	this()
	{
		super(Orientation.VERTICAL, 10);
		
		myDrawingArea = new MyDrawingArea();
		
		packStart(myDrawingArea, true, true, 0); // LEFT justify
		
	} // this()

} // class AppBox


class MyDrawingArea : DrawingArea
{
	Timeout _timeout;
	int number = 1;
	int fps = 1000 / 24; // 24 frames per second
	cairo_text_extents_t extents;
	
	this()
	{
		addOnDraw(&onDraw);
		
	} // this()
	
	bool onDraw(Scoped!Context context, Widget w)
	{
		if(_timeout is null)
		{
			_timeout = new Timeout(fps, &onFrameElapsed, false);
		}
		
		context.selectFontFace("Comic Sans MS", CairoFontSlant.NORMAL, CairoFontWeight.NORMAL);
		context.setFontSize(35);
		context.setSourceRgb(0.0, 0.0, 1.0);
		context.moveTo(580, 340); // bottom right corner
		
		if(number > 24) // number range: 1 - 24
		{
			number = 1;
		}

		context.showText(number.to!string());
		number++;

		return(true);
		
	} // onDraw()


	bool onFrameElapsed()
	{
		GtkAllocation area;
		getAllocation(area);
		
		queueDrawArea(area.x, area.y, area.width, area.height);
		
		return(true);
		
	} // onFrameElapsed()
	
} // class MyDrawingArea
