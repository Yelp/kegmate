
# KegPad

KegPad is the iPad interface in the KegMate project.

![KegPad Pouring](http://img.skitch.com/20100929-knpqqtri6qry79ci9judd27ph4.jpg)

## Admin

Tap the bottom left of the screen to pull up the admin interface. The default password is 'kegmate' and can be changed in Admin Settings.

## Importing

To import beers, kegs and users, see the JSON files in Resources/Fixtures/. These files are automatically read on startup and any data here is imported and updated. This is just temporary until the admin interface is built out.

## Deploying Builds

scp -r -4 build/Debug-iphoneos/KegPad.app root@kegmateaddress:/Applications/

## Debugging

    ssh -A root@kegmateaddress.local
    su mobile
    cd /Applications/KegPad.app/
    ./KegPad

Then tap the KegPad icon on the iPad, and it should show output to your terminal.

## Installing

- Download the KegPad app from https://github.com/Yelp/kegmate/downloads and extract it.
- Copy the app to the iPad's /Applications (replace with the iPad's real IP address): `scp -r -4 KegPad.app root@1.2.3.4:/Applications/`

## Permissions

Ensure all files in /var/mobile/Documents have their permissions set to the mobile user.
