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

#TODO

- [x] Allow users to save good pictures
into the database and make them browseable e.g
[DnD](http://cdn.superbwallpapers.com/wallpapers/games/dungeons-dragons-20207-1366x768.jpg)
- [ ] Make saving images secure
- [ ] Load saved pictures for customization
- [ ] Allow users to vote for other users pics
- [x] Add tabs for best, newest and random
- [ ] Add search by image name
- [ ] Holy shit... design - mothers weep at such grimy design!