Meteor.startup ->
	if "facebook" of Meteor.settings
		fb = Meteor.settings.facebook
		ServiceConfiguration.configurations.upsert {service: "facebook"} ,
			$set:
				appId: fb.appId
				loginStyle: "popup"
				secret: fb.secret

	Meteor.methods {
		saveToLibrary: (imageModel)->
			userId = Meteor.userId()
			if not userId
				throw new Meteor.Error "logged-out",
					"The user must be logged in save to the library"
			if not imageModel
				throw new Meteor.Error "bad parameter",
					"No image model given"

			existing = Images.find {
				url: imageModel.url
				userId: userId
			}

			if existing.fetch().length
				throw new Meteor.Error "image exists",
					"User has already saved this image"

			imageModel.userId = userId
			Images.insert imageModel


	}