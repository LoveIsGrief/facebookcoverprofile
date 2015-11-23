maker = Template.maker

maker.onCreated ->
	@imageUrl = new ReactiveVar ""

maker.helpers {
	imageUrl: ->
		Template.instance().imageUrl
}

maker.events {
	"submit .urlForm": (event)->
		event.preventDefault()

		instance = Template.instance()
		newUrl = instance.$("input[name='url']").val()
		instance.imageUrl.set newUrl
}