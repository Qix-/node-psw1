# Aukey PS-W1 Scanner Interface
This is a *pure javascript* implementation of a very basic scan library
over WiFi for the Aukey PS-W1.

## Requirements
You must have `imagemagick` and `graphicsmagick` installed

> On OSX, this is as easy as `brew install imagemagick graphicsmagick`.

### Scanner Setup
As of now, the library only reads scans in one by one; a scan daemon, if you
will.

The scanner itself must be in WiFi mode connected to your network. To do this,
you have to download the
[DirectScan for iOS](https://itunes.apple.com/ca/app/directscan/id875764405?mt=8)
off of iTunes or
[DirectScan for Android](https://play.google.com/store/apps/details?id=com.directscan)
off of Google Play. If you simply cannot use a phone to do a **one time
configuration**, then use Google's
[Arc Welder](https://developer.chrome.com/apps/getstarted_arc)
and obtain the APK by using
[this site](http://apps.evozi.com/apk-downloader/?id=com.directscan).

Once you have acquired the appropriate DirectScan app, you must put the scanner
in WiFi mode and wait for the icon to turn blue (indicating it's ready).
This may take up to 2 minutes.

Connect to it directly (the SSID should be along the lines of `DIRECTSCAN`, etc)
using the password in your manual (the default is `12345678`).

Once connected, open up the DirectScan app and let it discover the scanner.
Select it from the list, and then go to settings.

Once in settings, make sure to adjust your scan settings how you'd like (i.e.
scan DPI and color/BW) and then go into wireless settings. **Leave the access
point settings alone** and only change the **repeater** settings to reflect
your local network settings. Keep in mind the app does not allow you to
input manual SSID settings; your SSID will have to be (at least temporarily)
publicly broadcasted.

Make sure to hit *OK* and disconnect from the scanner. Let the scanner reconnect
to your network.

> If the scanner connects, but is only showing up in the peer table with a MAC
> and no assigned address, you probably typed the password wrong. If you are
> sure you didn't, you may need to reserve an IP in the DHCP settings of your
> router. This thing's WiFi capabilities are quite... lackluster.

Once the device has connected, you'll need to get its IP address. This is
what you pass to the constructor of the `PSW1` class as the first argument.

# Usage
See *test.js*. It can't get any more simple than that.

## Format
The format returned in the `scan` event is a buffer containing a JPEG image.
Since the scanner actually does size detection, it should already be the correct
size. This library doesn't care what is done with the image; it simply serves
it to you.


# License
MIT license. You're probably familiar with it.
