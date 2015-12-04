# facebookcoverprofile
A little help creating a synced facebook cover and profile.

The code to the site http://facebookcoverprofile.meteor.com/

# Features

- Facebook login
- Library with views for best, newest and random
- Allow users to vote for other users coverprofiles
- Users can add their coverprofiles to the library

# Starting up

## Facebook

In order to get the facebooking login working you will
need to have this object in your settings

```json
{
	"facebook":
	{
		"appId": "your app id",
		"secret": "your app secret"
	}
}
```

# Deploying

`meteor deploy --settings <your_settings.json> your.site.com`



#TODO

- [ ] Load saved pictures for customization
- [ ] Add search by image name
- [ ] Holy shit... design - mothers weep at such grimy design!
