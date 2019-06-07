import std.stdio;
import std.conv;

import gtk.MainWindow;
import gtk.Main;
import gtk.Box;
import gtk.Widget;
import cairo.Context;
import cairo.Surface;
import gtk.DrawingArea;
import gdk.Pixbuf;

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
		setSizeRequest(640, 360);
		
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
	GtkAllocation size; // the area assigned to the DrawingArea by its parent
	Pixbuf pixbuf; // an 8-bit/pixel image buffer
	string[] icoOptions, icoOptionValues;
	Surface surface;	
	
	this()
	{
		addOnDraw(&onDraw);
		
	} // this()
	
	bool onDraw(Scoped!Context context, Widget w)
	{
		context.setLineWidth(10);
		context.setLineCap(CairoLineCap.ROUND); // options are: BUTT, ROUND, SQUARE
		context.setLineJoin(CairoLineJoin.ROUND); // options are: MITER, ROUND, BEVEL
		context.moveTo(10, 10);
		context.lineTo(249, 249);
		context.lineTo(450, 15);
		context.lineTo(450, 249);
		context.stroke();
		
		return(true);
		
	} // onDraw()
	
} // class MyDrawingArea