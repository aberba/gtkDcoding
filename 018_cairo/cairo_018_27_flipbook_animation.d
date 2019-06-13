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
import cairo.Surface;
import gdk.Pixbuf;
import gdk.Cairo;
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
	int width = 992, height = 720; 
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
	int currentFrame = 0;
	float arcLength = PI / 12;
	int fps = 1000 / 6; // 6 frames per second
	Timeout _timeout;
	Pixbuf[] pixbufs;
	int numberOfFrames = 75;
	
	this()
	{
		for(int i = 0; i < numberOfFrames; i++)
		{
			if(i < 10)
			{
				pixbufs ~= new Pixbuf("./images/sequence/one00" ~ i.to!string() ~ ".tif");
			}
			else
			{
				pixbufs ~= new Pixbuf("./images/sequence/one0" ~ i.to!string() ~ ".tif");
			}

		} // for()
		
		addOnDraw(&onDraw);
		
	} // this()
	
	bool onDraw(Scoped!Context context, Widget w)
	{
		if(_timeout is null)
		{
			_timeout = new Timeout(fps, &onFrameElapsed, false);
			
		}
		
		context.setSourcePixbuf(pixbufs[currentFrame], 0, 0);
		context.paint();
		
		currentFrame += 1;
		
		if(currentFrame >= numberOfFrames)
		{
			currentFrame = 0;
		}
		
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
