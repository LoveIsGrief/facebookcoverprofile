###
Current drag of the picture
###
translatedY = 0

###
Where mouse previously was
We need this to calculate how far the mouse moved when dragged
###
previousY = 0

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
A refresh of the canvas to allow us to draw afresh
###
clearCanvas = (canvas)->
	if typeof canvas == "string"
		canvas = document.getElementById canvas
		console.log canvas

	return if not canvas
	canvas.getContext("2d").clearRect 0,0,
		canvas.width, canvas.height


update = ->

	url = $("#urlForm>input").val() || "images/default.png"
	cover = document.getElementById("cover")
	profile = document.getElementById("profile")

	coverC = cover.getContext("2d")
	profileC = profile.getContext("2d")
	totalHeight = 176 + profile.height

	image = new Image()

	dBox = 160

	image.onload = ->
		ratio = image.width / image.height

		#TODO allow the user to define a scale
		scale = cover.width / image.width
		minY = totalHeight - (image.height * scale)

		# Draw a scaled version for the cover
		clearCanvas cover
		coverC.drawImage image,
			0, translatedY
			cover.width,
			image.height * scale

		# Coordinates and dimensions of profile picture
		# We need to project from the scaled to the original
		s = 160
		sx = 20/scale
		sy = (176-translatedY)/scale
		wx = wy = s/scale

		# Draw scaled version of the profile picture projection
		clearCanvas profile
		profileC.drawImage image,
			sx,sy, wx, wy
			0,0, profile.width, profile.height


	image.src = url

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
Reseting calculations
###
reset = ->
	minY = translatedY = previousY = 0

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
	.click reset
	.click update

	$("#cover")
	.mousedown mousestart
	.mousemove drag

	update()

document.onready = init