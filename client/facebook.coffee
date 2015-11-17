
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
		false
	$("#urlForm>button")
	# .click reset
	# .click update

document.onready = init