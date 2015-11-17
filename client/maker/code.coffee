maker = Template.maker

maker.onRendered ->
	@coverprofile = Blaze.render Template.coverprofile, @$(".cpContainer")[0]

maker.events {
	"submit .urlForm": (event)->
		event.preventDefault()

		instance = Template.instance()
		newUrl = instance.$("input[name='url']").val()
		Blaze.remove instance.coverprofile

		instance.coverprofile = Blaze.renderWithData Template.coverprofile, {
				url: newUrl
			},
			instance.$(".cpContainer")[0]
}