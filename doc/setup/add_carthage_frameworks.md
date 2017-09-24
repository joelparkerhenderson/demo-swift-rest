# Add Carthage frameworks

To see if you have Carthage installed, and if the Carthage version is current, run this command:

    $ carthage version
    0.25.0

If Carthage is not installed, or the version is lower than 0.25.0:

  * Use these [Carthage instructions](https://github.com/Carthage/Carthage)


## Create a Carthage Cartfile
 
Create an empty text file named `Cartfile` at the top level of the project. 
   
Edit the `Cartfile`.

  * You can add any framework you want. 

  * For example, you can add this text:

      github "user/example"

Update.

    $ carthage update
    *** Fetching Prelude
    *** Downloading Example.framework binary at "2.0"
    *** xcodebuild output can be found in /var/folders/…

See the results if you like.

  * There is a new file `Cartfile.resolved` that lists the framework and its exact version number.

  * There is a new directory `Carthage`. This contains the `Build` directory and the framework files.

    $ ls -1
    Cartfile
    Cartfile.resolved
    Carthage
    Demo Swift Carthage
    Demo Swift Carthage.xcodeproj
    Demo Swift CarthageTests
    Demo Swift CarthageUITests

    $ ls Carthage
    Build

    $ cat Cartfile.resolved
    github "user/Example" "2.0.0"


## Link the framework

Go to the Xcode project "General" area.

Scroll down the section "Linked Frameworks and Libraries", with the text that says "Add frameworks &amp; libraries here".

Tap the "+" icon.

  * A dialog opens that says "Choose frameworks and libraries to add".

  * Tap the button "Add Other..."

Choose the framework.

  * A file chooser opens.

  * Navigate up a folder, and you see the "Carthage" folder.

  * Open the folder "Carthage", then the folder "Build", then the folder "iOS".

  * Tap the file "Example.framework" (or whatever the name is) to highlight it.

  * Tap "Open"

The section "Linked Frameworks and Libraries" now shows "Example.framework".


## Create the Run Script

Go to the Xcode project "Build Phases" settings area.

  * Click the "+" icon, then choose "New Run Script Phase".

  * Click the triangle by the new "Run Script" list item.

  * The "Shell" field should say `/bin/sh`.

  * The larger text field should say `Type a script or drag a script file from your workspace to insert its path`.

  * Set the larger text field to say `/usr/local/bin/carthage copy-frameworks`

Add input files.

  * In the area "Add input files here", click "+".

  * Set the "Input Files" to `$(SRCROOT)/Carthage/Build/iOS/Example.framework`


## More

Need help with Carthage? See our repo [demo_swift_carthage](https://github.com/joelparkerhenderson/demo_swift_carthage).

