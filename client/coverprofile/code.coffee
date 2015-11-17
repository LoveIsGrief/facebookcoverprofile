coverprofile = Template.coverprofile

coverprofile.onCreated ->
	###
	@property {string} url
	@property {float} translatedByX
	@property {float} translatedByY
	###
	@data = @data || {}
	@imageUrl = @data["url"] || "images/default.png"
	###
	Current drag of the picture
	###
	@translatedBy =  {
		x: @data["translatedByX"] || 0
		y: @data["translatedByY"] || 0
	}

	# Properties that we want to be public
	coverprofile.helpers {
		imageUrl: =>
			@imageUrl
		translatedBy: =>
			@translatedBy
	}

	# Private vars
	###
	Where mouse previously was
	We need this to calculate how far the mouse moved when dragged
	###
	@_previousY = 0


	# Private functions

	###
	Reseting calculations
	###
	@_reset = ->
		minY = @translatedBy.y = @_previousY = 0

	###
	A refresh of the canvas to allow us to draw afresh
	###
	@_clearCanvas = (canvas)->
		return if not canvas
		canvas.getContext("2d").clearRect 0,0,
			canvas.width, canvas.height

	@_update = ->

		cover = @$(".cover")[0]
		profile = @$(".profile")[0]

		coverC = cover.getContext("2d")
		profileC = profile.getContext("2d")
		totalHeight = 176 + profile.height

		image = new Image()

		dBox = 160

		image.onload = =>
			ratio = image.width / image.height

			#TODO allow the user to define a scale
			scale = cover.width / image.width
			minY = totalHeight - (image.height * scale)

			# Draw a scaled version for the cover
			@_clearCanvas cover
			coverC.drawImage image,
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
			profileC.drawImage image,
				sx,sy, wx, wy
				0,0, profile.width, profile.height


		image.src = @imageUrl


coverprofile.onRendered ->
	@_update()