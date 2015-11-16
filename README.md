# facebookcoverprofile
A little help creating a synced facebook cover and profile.

The code to the site http://facebookcoverprofile.meteor.com/

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