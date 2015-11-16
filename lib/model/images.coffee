class @ImageModel

	constructor: (
				@title
				@url
				@user
				@scale
				@pan
			)->

		###
		IDs of the users that liked the image
		###
		@likesBy = []


@Images = new Meteor.Collection "images"