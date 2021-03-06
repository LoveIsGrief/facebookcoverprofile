class @ImageModel

	@MatchPattern:
		title: String
		url: String
		scaleFactor: Number
		pan:
			x: Number
			y: Number
		likesBy: Match.Optional [String]
		numberOfLikes: Match.Optional Number
		userId: Match.Optional Match.Any

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
		@numberOfLikes = 0

		###
		Which user is saving the image
		###
		@userId = null


@Images = new Meteor.Collection "images"