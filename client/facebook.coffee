###
TODO
Allow users to save good pictures into the database and make them browseable
e.g http://cdn.superbwallpapers.com/wallpapers/games/dungeons-dragons-20207-1366x768.jpg
###
saveToLibrary = ->
	url = $("#urlForm>input").val()
	return if not url
	imageModel = new ImageModel "test",
		url,
		Meteor.userId(),
		scale,
		{
			x: 0
			y: translatedY
		}
	Images.insert imageModel
