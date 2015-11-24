class @ImageModel

	###
	@param {string} title
	@param {string} url
	@param {float} scaleFactor
	@param {object} pan
	@option pan {float} pan.x
	@option pan {float} pan.y
	###
	constructor: (
				@title
				@url
				@scaleFactor
				@pan
			)->

		###
		IDs of the users that liked the image
		###
		@likesBy = []
		###
		Which user is saving the image
		###
		@userId = null


@Images = new Meteor.Collection "images"