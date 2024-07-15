extends Control

var rows = 8
var columns = 8
var cell_size


var legend_size = 100
var showGridAndNumbers = true
var reset = false

var palette = {
	0:Color("#ded4c8"),
	1:Color("#beaa9c"),
	2:Color("#94837a"),
	3:Color("#645c59"),
	4:Color("#181e28"),
	5:Color("#dbaf88"),
	6:Color("#b8926f"),
	7:Color("#987052"),
	8:Color("#624a30"),
	9:Color("#2f2114"),
	10:Color("#df8b79"),
	11:Color("#e26560"),
	12:Color("#b0454c"),
	13:Color("#5b3636"),
	14:Color("#e5be3e"),
	15:Color("#be8e03"),
	16:Color("#916803"),
	17:Color("#644507"),
	18:Color("#f18b49"),
	19:Color("#d46b2b"),
	20:Color("#ba5113"),
	21:Color("#7a3412"),
	22:Color("#eb8281"),
	23:Color("#d95b5b"),
	24:Color("#bf2f37"),
	25:Color("#64272c"),
	26:Color("#b58fb6"),
	27:Color("#7e638e"),
	28:Color("#594a66"),
	29:Color("#3c3145"),
	30:Color("#30bab3"),
	31:Color("#1390ac"),
	32:Color("#0b5472"),
	33:Color("#233552"),
	34:Color("#abcf5f"),
	35:Color("#789949"),
	36:Color("#39681d"),
	37:Color("#084739"),
}
	
var stateDictionary: Dictionary = {}
var window_size

func _ready():
	get_node("ServerNode")
	window_size = DisplayServer.window_get_size()
	cell_size =  window_size.y / rows

func _draw():
	if not cell_size:
		print('got here???')
		return

	for x in columns:
		for y in rows:
			var point = Vector2(x,y)
			if !reset && point in stateDictionary:
				var currentColorIndex = stateDictionary[point]
				
				print("Color Index: ", currentColorIndex, palette[currentColorIndex])
				draw_rect(translatePixelToRect(x, y, cell_size), palette[currentColorIndex])
			else:
				draw_rect(translatePixelToRect(x, y, cell_size), palette[0])
				
	reset = false
	addLegend()
	if showGridAndNumbers:
		addXNumbers()
		addYNumbers()
		addLines()


var default_font: Font = ThemeDB.fallback_font
var default_font_size = ThemeDB.fallback_font_size

func addLines():
	for x in columns:
		draw_line(Vector2(x * cell_size,0), Vector2(x* cell_size, (rows + 1)* cell_size), Color.DIM_GRAY)
		
	for y in rows:
		draw_line(Vector2(0,y * cell_size), Vector2((columns + 1) * cell_size, y * cell_size), Color.DIM_GRAY)

func addXNumbers():
	
	var x = columns
	for y in rows:
		draw_string(default_font, Vector2(x * cell_size, (y+1) * cell_size), str(y), HORIZONTAL_ALIGNMENT_FILL, -1,  75)


func addYNumbers():
	var y = rows + 1
	for x in columns:
		draw_string(default_font, Vector2(x * cell_size, y * cell_size), str(x), HORIZONTAL_ALIGNMENT_CENTER, -1,  75)

func addLegend():
	var indexNum = 0
	var numberOfColumns = ceil(palette.size() / float(rows + 2))

	for x in numberOfColumns:
		for y in columns + 2:
			if indexNum <= palette.size() -1: 
				var realX = x + columns + 2
				
				var pos = Vector2(realX * cell_size, y * legend_size)
				draw_rect(Rect2(pos.x, pos.y, legend_size, legend_size), palette[indexNum])
				draw_string(default_font, pos + Vector2(0, legend_size), str(indexNum), HORIZONTAL_ALIGNMENT_CENTER, -1,  75)
				
				indexNum += 1
	
func translatePixelToRect(x, y, rect_size):
	var xStart = x * rect_size
	var yStart = y * rect_size
	
	return Rect2(xStart, yStart, rect_size, rect_size)

func _on_server_node_pixel_change(x, y, colorIndex):
	if x >= 0 || x <= 15 && y >= 0 || y <= 15 &&  colorIndex >= 0 || x <= 39 :
		stateDictionary[Vector2(x,y)] = colorIndex
		queue_redraw()
	
func toggle_grid_pressed():
	showGridAndNumbers = !showGridAndNumbers
	queue_redraw()

func reset_canvas():
	reset = true
	queue_redraw()
