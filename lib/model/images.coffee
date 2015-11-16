class @ImageModel

	###
	@param {string} title
	@param {string} url
	@param {string} userId
	@param {float} scaleFactor
	@param {object} pan
	@option pan {float} pan.x
	@option pan {float} pan.y
	###
	constructor: (
				@title
				@url
				@userId
				@scaleFactor
				@pan
			)->

		###
		IDs of the users that liked the image
		###
		@likesBy = []


@Images = new Meteor.Collection "images"