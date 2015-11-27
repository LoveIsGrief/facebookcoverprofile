Meteor.subscribe "images"

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
					Images.find {}

		tabs: ->
			instance = Template.instance()
			instance.tabs

		activeTab: (tabId)->
			Template.instance().activeTab.get() == tabId

	}

library.events
	###
	Simply set the active tab
	###
	"click .tab": (event)->
		instance = Template.instance()
		instance.activeTab.set @id
		console.log instance.activeTab.get()