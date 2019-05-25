// ComboBox with one column containing strings

import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Box;
import gtk.ComboBox;
import gtk.ListStore;
import gtk.TreeIter;
import gtk.TreeViewColumn;
import gtk.CellRendererText;
import gtk.CellRendererPixbuf;
import gdk.RGBA;
import pango.PgFontDescription;
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

} // class TestRigWindow


class AppBox : Box
{
	WeatherComboBox weatherComboBox;
	WeatherListStore weatherListStore;
	
	this()
	{
		super(Orientation.VERTICAL, 10);
		
		weatherListStore = new WeatherListStore();
		weatherComboBox = new WeatherComboBox(weatherListStore);
		packStart(weatherComboBox, false, false, 0);
		
	} // this()

} // class AppBox


class WeatherComboBox : ComboBox
{
	private:
	bool entryOn = false;
	WeatherListStore _weatherListStore;
	CellRendererText cellRendererText;
	CellRendererPixbuf cellRendererPixbuf;
	int visibleColumn = 0;
	int activeItem = 0;
	
	public:
	this(WeatherListStore weatherListStore)
	{
		super(entryOn);

		// set up and bring in the store
		_weatherListStore = weatherListStore;
		setModel(_weatherListStore);
		setActive(activeItem);
		
		// hook up signals
		addOnChanged(&doSomething);
		
		// set up the ComboBox's column to render text
		cellRendererText = new CellRendererText();
		packStart(cellRendererText, false);
		addAttribute(cellRendererText, "text", _weatherListStore.Column.TEXT);
		addAttribute(cellRendererText, "font-desc", _weatherListStore.Column.FONT);
		addAttribute(cellRendererText, "foreground-rgba", _weatherListStore.Column.FG_COLOR);
		addAttribute(cellRendererText, "foreground-set", _weatherListStore.Column.COLOR_ON);
		addAttribute(cellRendererText, "background-rgba", _weatherListStore.Column.BG_COLOR);
		addAttribute(cellRendererText, "background-set", _weatherListStore.Column.COLOR_ON);		

		cellRendererPixbuf = new CellRendererPixbuf();
		packStart(cellRendererPixbuf, false);
		addAttribute(cellRendererPixbuf, "pixbuf", _weatherListStore.Column.IMAGE);
		
	} // this()
	
	
	void doSomething(ComboBox cb)
	{
		string data;
		TreeIter treeIter;

		write("index of selection: ", getActive(), ", "); // returns the index of the selected item
		
		if(getActiveIter(treeIter) == true) // bool indicates if retrieval successed or not
		{
			data = getModel().getValueString(treeIter, 0); // get what's in the 1st (and only) column
			writeln("data: ", data);
		}

	} // doSomething()

} // class WeatherComboBox


class WeatherListStore : ListStore
{
	string[] textItems = ["Sunny", "Partly Cloudy", "Cloudy", "Rainy", "Thunderstorm", "Snowy"];
	string[] fontNames = ["Times New Roman", "Arial", "Trebuchet MS", "Verdana", "Comic Sans MS", "Courier New"];
	int[] fontSizes = [12, 13, 14, 15, 16, 17];

	float[][] fgColors = [[.027, .067, .855, 1.0], [.02, .043, .576, 1.0], [.012, .031, .404, 1.0], 
								 [.741, .757, .816, 1.0], [.894, 1.0, 0.0, 1.0], [0.0, .933, 1.0, 1.0]];
								 
	float[][] bgColors = [[.592, .957, 1.0, 1.0], [.522, .847, .882, 1.0], [.365, .596, .62, 1.0], 
								 [.259, .42, .435, 1.0], [.18, .29, .302, 1.0], [1.0, 1.0, 1.0, 1.0]];

	string[] images = ["_images/sun_50x.png", "_images/partly_cloudy_50x.png", "_images/cloudy_50x.png",
							 "_images/rainy_50x.png", "_images/thunder_50x.png", "_images/snowy_50x.png"];

	enum Column
	{
		TEXT = 0,
		FONT = 1,
		COLOR_ON = 2,
		FG_COLOR = 3,
		BG_COLOR = 4,
		IMAGE = 5
		
	} // enum Column
	
	TreeIter treeIter;
	
	this()
	{
		string textItem, fontName, imageName;
		float fgRed, bgRed, fgGreen, fgAlpha, bgGreen, fgBlue, bgBlue, bgAlpha;
		int fontSize;
		
		super([GType.STRING, PgFontDescription.getType(), GType.INT, RGBA.getType(), RGBA.getType(), Pixbuf.getType()]);
		
		for(int i; i < textItems.length; i++)
		{
			textItem = textItems[i];
			fontName = fontNames[i];
			fontSize = fontSizes[i];
			
			fgRed = fgColors[i][0];
			fgGreen = fgColors[i][1];
			fgBlue = fgColors[i][2];
			fgAlpha = fgColors[i][3];
			
			bgRed = bgColors[i][0];
			bgGreen = bgColors[i][1];
			bgBlue = bgColors[i][2];
			bgAlpha = bgColors[i][3];
			
			imageName = images[i];

			treeIter = createIter();
			setValue(treeIter, Column.TEXT, textItem);
			setValue(treeIter, Column.FONT, new PgFontDescription(fontName, fontSize));
			setValue(treeIter, Column.COLOR_ON, true);
			setValue(treeIter, Column.FG_COLOR, new RGBA(fgRed, fgGreen, fgBlue, fgAlpha));
			setValue(treeIter, Column.BG_COLOR, new RGBA(bgRed, bgGreen, bgBlue, bgAlpha));
			setValue(treeIter, Column.IMAGE, new Pixbuf(imageName));
		}

	} // this()

} // class WeatherListStore

