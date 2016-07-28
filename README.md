# MemoryGame Summary
This is a simple memorization game where 9 images fetched from Flickr are shown briefly, 
and then the user is required to recall the position of the images one by one.

# Dependencies
The project was developed with Xcode 7.3 and coded in Swift 2.
The committed code includes dependencies imported via pods, so the project can be run simply by cloning the repository, and running the workspace with Xcode 7.3.

If there are any compile issues, they can be resolved by running `pod install` in the project home folder.
Note that, to run the project the `.xcodeworkspace` file has to be launched.

# Classes & their roles
The project has been built with a mind towards SOLID Principles of Objected-Oriented design.
Here is a brief list of classes and their responsibilities:

1. `ViewController` - the main View-Controller that controls the only screen in the app
2. `MTImageCell` - a collection-view-cell subclass to display images in a 3x3 grid.
3. `MTImageDownloader` - to download images and cache them using `SDWebImageDownloader`
4. `MTNetworkHelper` - to call the Flickr Feeds API and parse its response into image URLs
5. `MTMemoryGame` - the game controller class which manages the progress of the game, and notifies its delegate of relevant game events
6. `MTTimer` - a timer class to run a simple count-down timer using `NSTimer`
7. `MTUtility` - to generate random numbers

# Pods
Three Pods have been used:
1. `Alamofire` - a Swift networking library
2. `SDWebImage` - an image downloading caching library
3. `Freddy` - an elegant JSON parser in Swift
