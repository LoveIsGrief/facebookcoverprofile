Meteor.startup ->
	if "facebook" of Meteor.settings
		fb = Meteor.settings.facebook
		ServiceConfiguration.configurations.upsert {service: "facebook"} ,
			$set:
				appId: fb.appId
				loginStyle: "popup"
				secret: fb.secret