maker = Template.maker

maker.onCreated ->
	@imageUrl = new ReactiveVar ""
	@children = new Set()

	###
	Save what user sees in the make to the db
	###
	@saveToLibrary = ->
		return if not @children.size

		# let's assume we won't be registering any more children
		coverprofile = @children.values().next().value

		return if coverprofile.imageUrl == coverprofile.defaultImageUrl

		title = prompt """Title for the image?
		Any funny business and it gets a bad random name.
		You have been warned ;)
		"""
		imageModel = new ImageModel title || "image #{Date.now()}",
			coverprofile.imageUrl.get(),
			coverprofile.scale,
			{
				x: coverprofile.translatedBy.x
				y: coverprofile.translatedBy.y
			}
		Meteor.call "saveToLibrary", imageModel, (error,result)->
			if error
				alert error.reason

maker.helpers {
	imageUrl: ->
		Template.instance().imageUrl
	children: ->
		Template.instance().children
}

maker.events {
	"submit .urlForm": (event)->
		event.preventDefault()

		instance = Template.instance()
		newUrl = instance.$("input[name='url']").val()
		instance.imageUrl.set newUrl

	"click .save": (event)->
		instance = Template.instance()
		instance.saveToLibrary()
}