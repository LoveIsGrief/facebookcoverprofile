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
			# TODO do a real image model check
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
			imageModel.dateAdded = Date.now()
			Images.insert imageModel
		like: (id)->
			imageModel = Images.findOne id,
				fields:
					likesBy: 1
			return if not imageModel
			uid = Meteor.userId()

			# Toggle a like
			if (i = imageModel.likesBy.indexOf uid) > -1
				Images.update imageModel._id, {
					$pull:
						likesBy: uid
					$inc:
						numberOfLikes: -1
				}
			else
				Images.update imageModel._id, {
					$push:
						likesBy: uid
					$inc:
						numberOfLikes: 1
				}

	}

	# Images are sorted by newest first by default
	Meteor.publish "images", ->
		Images.find {},
			sort:
				dateAdded: -1

	# Image collection sorted in descending order
	# by number of likes
	bestImageCollection = "bestimages"
	Meteor.publish "bestimages", ->
		# Since we are accessing the Images collection
		# we need to create our own subscription
		# because for some reason simply giving it a name
		# won't actually use the name and will use the name
		# of the collection returning the cursor
		# makes sense, right?

		cursor = Images.find {},
			sort:
				numberOfLikes: -1
				dateAdded: -1

		handle = cursor.observeChanges
			added: (id, fields)=>
				@added bestImageCollection, id, fields
			removed: (id)=>
				@removed bestImageCollection, id
			changed: (id, fields)=>
				@changed bestImageCollection, id, fields

		@ready()

		@onStop ->
			handle.stop()
		return

