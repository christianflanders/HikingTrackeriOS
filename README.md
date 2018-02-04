# Peaks
Peaks is a hiking specific workout tracker for iOS, build using Swift 4.

# Images


# Getting Started:
You can run Peaks using a simulated device location, however, you will not receive any altitude information, so the tracking will not be accurate and some data will be missing. This seems to be an intentional decision inside Xcode. You can also run the test "testHikeUploadToFirebase" to use one of the included GPX files to create a fake workout and include it in the database. You can use your own GPX files, but I have only tested files from Runkeeper so any other format may not work as expected.



## Installing:
Run `pod-install `
to install necessary packages. Peaks uses Firebase as a cloud backend. You will have to create your own Firebase project at https://firebase.google.com to get a unique Firebase Service Key. If you want to run Peaks with each account having it's own unique storage, change your rules to the following :


     {
      "rules": {
        ".read": "auth != null",
    ".write": "auth != null"
      }
     }


For help, please visit this fantastic [Ray Wenderlich Tutorial](https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2)

# Versions:
**1.0**- Initial release on App Store- Current Version

# Planned Features:
* Import GPX file into app and display route on Mapbox
* ARKit trail marking
* Sharing trails with friends/Basic social integration
* Point of interest sharing along trail
* Siri integration
* Standalone watch support
* Watch app customization



# Contributors:
Christian Flanders: [Twitter](https://twitter.com/shredflanders92)



# License
Shared under the MIT license

# Acknowledgements:
* [Charts](https://github.com/danielgindi/Charts)
* [GPX Parser](https://github.com/vermont42/GpxLocationManager)
* [Solar](https://github.com/ceeK/Solar)
* [Mapbox](https://www.mapbox.com)
* [Firebase](https://firebase.google.com)
