###
The highest we can drag the picture up
###
minY = 0

###
The lowest we can drag the picture
###
maxY = 0

image = null

###
Begin of drag in cover canvas
###
mousestart = (event)->
	previousY = event.offsetY

	# disable text selection after a double click
	event.preventDefault()
	false

###
Dragging the picture in the canvas
Only drags in Y axis for now
###
drag = (event)->
	# Triggered only if we are dragging an image
	return if not (event.buttons and image)

	# How far did we drag
	dy = event.offsetY - previousY
	previousY = event.offsetY

	translatedY += dy

	# Don't allow to drag the image out of sight
	if (translatedY < minY) or ( translatedY > maxY)
		translatedY -= dy
	update()

###
TODO
Allow users to save good pictures into the database and make them browseable
e.g http://cdn.superbwallpapers.com/wallpapers/games/dungeons-dragons-20207-1366x768.jpg
###
saveGoodPicture = ->

###
Setup the events
###
init = ->
	$("#urlForm").submit ->
		reset()
		update()
		false
	$("#urlForm>button")
	# .click reset
	# .click update

	$("#cover")
	.mousedown mousestart
	.mousemove drag

document.onready = init