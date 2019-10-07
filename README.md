# allygatorShuttle
Car pooling app - dood2door mobile challenge

Hello door2door people!

Here is my Allygator Shuttle app. I have implemented the basic and the optional features.
Regarding the second optional feature: I have added a custom compass at the bottom of the mapView to show the true heading of the vehicle in case the user rotates the map. In this case, the heading of the vehicle in the map is adjusted according to the map rotation.

In order to build it: just git clone it and run the xcworkspace from Xcode. All external pods I have used are included in the repo.

Design pattern: MVVM
Why? It works well in handling operational scenarios like the one in Ally: where data are pushed from the server, stored into models and then parsed and managed by the view model and made ready to be presented to the views.

Map: I have used the MapKit API
Why? Easier than for example Google Maps; no need to expose google API keys; faster to implement; less heavy.

UI: I kept it simple and informative. I have implemented the requested features (used custom annotationView to display the locations and a Trabi icon for the vehicle), plus I have added a dynamic label (nextStopLabel) on the top of the screen that shows up once the user is in the vehicle and displays the address of the next intermediate stop as well as the drop off address (when no more intermediate stops occur before the drop off).
When the passenger is in status “inVehicle”, the first intermediate stop has a slightly dark color (the same as the nextStopLabel background color),  
Why? I figured out that just by looking at the markers of the intermediate stops, the passenger does not really know which is the next stop, he/she just sees there are some intermediate stops, but does not know which one happens first and he/she might wanna get off earlier in case of sudden heavy traffic (you know, I’d rather walk 300 meters than spending 10 minutes in the car to drive 300 meters).

External libraries (pods from CocoaPods)
Starscream: quick and easy solution to read data from a web socket (found after some research)
SwiftyJSON: awesome JSON parsing library (I’ve used it before).

Testing: For the moment, I have tested with XC Unit Test the ViewModel structs throughly to make sure the logic behind the app is solid.
 
All icons are from theNounProject, free-licensed.
Colors are taken from palette number 158806 from colorhunt.co
Fonts: Arial Rounded, Arial
