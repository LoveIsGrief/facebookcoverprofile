Meteor.subscribe "images"

Template.library.helpers {
		images: ->
			Images.find {}
	}