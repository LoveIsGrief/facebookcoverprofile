Meteor.subscribe "images"
Meteor.subscribe "bestimages"

BestImages = new Mongo.Collection "bestimages"
library = Template.library

library.onCreated ->
	@tabs = [
			id: "best"
			text: "Best"
		,
			id: "random"
			text: "Random"
		,
			id: "newest"
			text: "Newest"
	]

	@activeTab = new ReactiveVar "best"

library.helpers {
		###
		Depends on the active tab
		###
		images: ->
			instance = Template.instance()
			switch instance.activeTab.get()
				when "best"
					BestImages.find {}
				when "newest"
					Images.find {}
				when "random"
					images = Images.find({})
					_.sample images.fetch(), 10

		tabs: ->
			instance = Template.instance()
			instance.tabs

		activeTab: (tabId)->
			Template.instance().activeTab.get() == tabId

		likes: (imageModel)->
			_.contains imageModel.likesBy, Meteor.userId()
	}

library.events
	###
	Simply set the active tab
	###
	"click .tab": (event)->
		instance = Template.instance()
		instance.activeTab.set @id
	"click .like": (event)->
		Meteor.call("like", @._id)