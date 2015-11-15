document.onready = ->
	console.log "ready"
	cover = document.getElementById("cover")
	profile = document.getElementById("profile")

	coverC = cover.getContext("2d")
	profileC = profile.getContext("2d")

	image = new Image()

	dBox = 160

	image.onload = ->
		console.log "width: #{image.width}, height: #{image.height}"
		ratio = image.width / image.height

		scale = cover.width / image.width
		coverC.drawImage image,
			0,0
			cover.width,
			image.height * scale

		s = 160
		sx = 20/scale
		sy = 176/scale
		wx = wy = s/scale

		profileC.drawImage image,
			sx,sy, wx, wy
			0,0, profile.width, profile.height


	image.src = 'images/space.jpg'
