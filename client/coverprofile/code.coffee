coverprofile = Template.coverprofile

coverprofile.onCreated ->
	###
	@property {string} url
	@property {float} translatedByX
	@property {float} translatedByY
	###
	@data = @data || {}

	@imageUrl = new ReactiveVar "images/default.png"
	###
	Current drag of the picture
	###
	@translatedBy =  {
		x: @data["translatedByX"] || 0
		y: @data["translatedByY"] || 0
	}

	@setImageUrlFromData = (data)=>
		return if not data
		@imageUrl.set data["url"] || "images/default.png"

	# Private vars
	###
	Where mouse previously was
	We need this to calculate how far the mouse moved when dragged
	###
	@_previousY = 0

	###
	The highest we can drag the picture up
	###
	@_minY = 0

	###
	The lowest we can drag the picture
	###
	@_maxY = 0

	###
	Active image element
	###
	@_image = null

	# Private functions

	###
	Reseting calculations
	###
	@_reset = =>
		minY = @translatedBy.y = @_previousY = 0

	###
	A refresh of the canvas to allow us to draw afresh
	###
	@_clearCanvas = (canvas)->
		return if not canvas
		canvas.getContext("2d").clearRect 0,0,
			canvas.width, canvas.height

	@_update = =>

		cover = @$(".cover")[0]
		profile = @$(".profile")[0]

		coverC = cover.getContext("2d")
		profileC = profile.getContext("2d")
		totalHeight = 176 + profile.height

		image = @_image = new Image()

		dBox = 160

		image.onload = =>
			ratio = image.width / image.height

			#TODO allow the user to define a scale
			scale = cover.width / image.width
			@_minY = totalHeight - (image.height * scale)

			# Draw a scaled version for the cover
			@_clearCanvas cover
			coverC.drawImage @_image,
				0, @translatedBy.y
				cover.width,
				image.height * scale

			# Coordinates and dimensions of profile picture
			# We need to project from the scaled to the original
			s = 160
			sx = 20/scale
			sy = (176-@translatedBy.y)/scale
			wx = wy = s/scale

			# Draw scaled version of the profile picture projection
			@_clearCanvas profile
			profileC.drawImage @_image,
				sx,sy, wx, wy
				0,0, profile.width, profile.height


		image.src = @imageUrl.get()


# Properties that we want to be public
coverprofile.helpers {
	imageUrl: =>
		instance = Template.instance()
		instance.imageUrl.get()
	translatedBy: =>
		instance = Template.instance()
		instance.translatedBy
}


coverprofile.onRendered ->
	@autorun =>
		@setImageUrlFromData Template.currentData()
		@_update()

coverprofile.events {
	###
	Begin of drag in cover canvas
	###
	"mousedown .cover": (event)->
		instance = Template.instance()
		instance._previousY = event.offsetY

		# disable text selection after a double click
		event.preventDefault()
		event.stopPropagation()

	###
	Dragging the picture in the canvas
	Only drags in Y axis for now
	###
	"mousemove .cover": (event)->
		instance = Template.instance()
		# Triggered only if we are dragging an image
		# TODO and if dragging is activated
		return if not (event.buttons and instance._image)

		# How far did we drag
		dy = event.offsetY - instance._previousY
		instance._previousY = event.offsetY

		translatedY = instance.translatedBy.y
		translatedY += dy

		# Don't allow to drag the image out of sight
		if (translatedY < instance._minY) or ( translatedY > instance._maxY)
			translatedY -= dy

		instance.translatedBy.y = translatedY
		instance._update()
}