coverprofile = Template.coverprofile

coverprofile.onCreated ->
	###
	@property {string} url
	@property {float} translatedByX
	@property {float} translatedByY
	@property {float} scale
	@property {boolean} scalable
	@property {Set} registrar
	###
	@data = @data || {}

	@mouseMoveStarted = false

	# Private vars
	###
	Where mouse previously was
	We need this to calculate how far the mouse moved when dragged
	###
	@_previousY = 0
	@_previousX = 0

	###
	Active image element
	###
	@_image = null

	# Private functions

	###
	Reseting calculations
	###
	@_hasBeenReset = true
	@_reset = =>
		@translatedBy = {
			x: 0
			y: 0
		}
		@_previousX = @_previousY = @scale = 0
		@_hasBeenReset = true

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

			if @_hasBeenReset
				@scale = cover.width / image.width
				@_hasBeenReset = false

			# Draw a scaled version for the cover
			@_clearCanvas cover
			coverC.drawImage @_image,
				@translatedBy.x, @translatedBy.y
				image.width*@scale,
				image.height * @scale

			# Coordinates and dimensions of profile picture
			# We need to project from the scaled to the original
			s = 160
			sx = (20-@translatedBy.x)/@scale
			sy = (176-@translatedBy.y)/@scale
			wx = wy = s/@scale

			# Draw scaled version of the profile picture projection
			@_clearCanvas profile
			profileC.drawImage @_image,
				sx,sy, wx, wy
				0,0, profile.width, profile.height



		image.src = @imageUrl.get()

	# Public functions

	@setImageUrlFromData = (data)=>
		return if not data
		return if not url = data["url"]
		return if url == @imageUrl.get()
		# Don't reset if the url doesn't change
		@_reset()
		@imageUrl.set data["url"]

	# Register with parent if need be
	if registrar = @data["registrar"]
		registrar.add @

	@defaultImageUrl = "images/default.png"
	@imageUrl = new ReactiveVar @defaultImageUrl
	@setImageUrlFromData(@data)

	###
	What factor was used to scale the image
	###
	@scale = @data["scale"] || 0
	@scalable = false || @data["scalable"]

	###
	Current drag of the picture
	###
	@translatedBy =  {
		x: @data["translatedByX"] || 0
		y: @data["translatedByY"] || 0
	}

	@_hasBeenReset = @scale == 0


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
		instance._previousX = event.offsetX
		instance.mouseMoveStarted = true

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
		return if not
			(event.buttons and instance._image) or
			Template.currentData()["static"] or
			not instance.mouseMoveStarted


		# How far did we drag
		dy = event.offsetY - instance._previousY
		dx = event.offsetX - instance._previousX
		# Update last position
		instance._previousY = event.offsetY
		instance._previousX = event.offsetX
		# Move
		instance.translatedBy.y += dy
		instance.translatedBy.x += dx
		# Display
		instance._update()

	"mouseup .cover": (event)->
		instance = Template.instance()
		instance.mouseMoveStarted = false

	"wheel .cover": (event)->

		instance = Template.instance()
		return if not (instance._image and instance.scalable)

		event.preventDefault()

		wheelEvent = event.originalEvent
		direction = if wheelEvent.deltaY < 0 then 0.01 else -0.01
		instance.scale += direction
		instance._update()
}