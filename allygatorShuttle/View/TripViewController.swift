//
//  ViewController.swift
//  allygatorShuttle
//
//  Created by Giulio Gola on 02/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import UIKit
import MapKit
import Starscream
import SwiftyJSON

class TripViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextStopLabel: UILabel!
    @IBOutlet weak var pickUpAddressLabel: UILabel!
    @IBOutlet weak var dropOffAddressLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!    
    @IBOutlet weak var vehicleBearingImageView: UIImageView!
    
    private var socket: WebSocket!
    
    //MARK: - Ride global variables
    private var locationsLatitude = [Double]()
    private var locationsLongitude = [Double]()
    private var intermediateStopLocations = [Location]()
    private var intermediateStopLocationsJSON = [JSON]()
    private var currentVehicleLocation: Location?
    private var currentPassengerStatus = "Not available"
    private var dropoffLocationAddress: String?
    private var currentBearing: Double = 0  // Initial vehicle bearing image view (to the North)
    private var bearingShift: Double!
    private var mapHeadingCorrection: Double = 0
    private var previousHeadingCorrection: Double = 0
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        connectToSocket()
    }

    //MARK: - Start web socket connection
    func connectToSocket() {
        if let url = URL(string: Constants.socketURL) {
            socket = WebSocket(url: url)
            socket.delegate = self
            socket.connect()
        } else {
            print("Cannot connet to web socket")
        }
    }
}

//MARK: - MapView methods and delegates
extension TripViewController: MKMapViewDelegate {
 
    // Center map at the beginning
    private func centerMap() {
        // Finds most suitable region span to show in map
        let regionSpanInMeters = Calculations.calculateRegionSpan(lats: locationsLatitude, lngs: locationsLongitude)
        // Set map center
        let initialLocation = Calculations.findMapCenter(lats: locationsLatitude, lngs: locationsLongitude)
        let mapCenter = CLLocation(latitude: initialLocation.latitude, longitude: initialLocation.longitude)
        let coordinateRegion = MKCoordinateRegion(center: mapCenter.coordinate, latitudinalMeters: regionSpanInMeters, longitudinalMeters: regionSpanInMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Adds one marker
    private func addMarker(at location: Location) {
        mapView.addAnnotation(location)
    }
    
    // Adds many markers
    private func addMarkers(at locations: [Location]) {
        mapView.addAnnotations(locations)
    }
    
    // Removes one marker
    private func removeMarker(at location: Location) {
        mapView.removeAnnotation(location)
    }
    
    // Removes many markers
    private func removeMarkers(at locations: [Location]) {
        mapView.removeAnnotations(locations)
    }
    
    // Custom location view: attaches custom icon and Location infos to Location View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Handles user location annotation: not implemented at the moment
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        // Handles location view
        var locationView: LocationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "locationView") as? LocationView
        if locationView == nil {
            locationView = LocationView(annotation: annotation, reuseIdentifier: "locationView")
        }
        // Initialize location view with all the location data plus the image associated to the location
        let location = annotation as! Location
        locationView?.image = location.image
        locationView?.annotation = location
        // Tap to display callout with annotation title and subtitle
        locationView?.canShowCallout = true
        // Pass bearing value only if MKAnnotationView refers to the vehicle
        if location.type == "Vehicle" {
            if let bearing = bearingShift {
                // If shif has been calculated, add eventual correction due to map rotation
                locationView?.bearingShift = bearing - mapHeadingCorrection
                mapHeadingCorrection = 0
            } else {
                locationView?.bearingShift = bearingShift
            }
        }
        return locationView
    }
    
    // Gets correction angle to apply to vehicle bearing when user rotates the map
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newHeading = (mapView.camera.heading) * Double.pi / 180
        var newHeadingCorrection: Double = 0
        if newHeading <= Double.pi / 2 {
            newHeadingCorrection = newHeading
        } else {
            newHeadingCorrection = newHeading - (Double.pi * 2)
        }
        if previousHeadingCorrection != newHeadingCorrection {
            // Calculate new mapHeadingCorrection only if there was a rotation (not a zoom in/out)
            mapHeadingCorrection = newHeadingCorrection - previousHeadingCorrection
            previousHeadingCorrection = newHeadingCorrection
        }
    }
    
}

//MARK: - Update UI
extension TripViewController {
    
    // Updates UI based on event type
    private func updateUI(with data: JSON) {
        if let event = data["event"].string {
            switch event {
            case "bookingOpened":
                updateUIForBookingOpened(with: data)
            case "vehicleLocationUpdated":
                updateUIForVehicleLocationUpdated(with: data)
            case "statusUpdated":
                updateUIForStatusUpdated(with: data)
            case "intermediateStopLocationsChanged":
                updateUIForIntermediateStopLocationsChanged(with: data)
            case "bookingClosed":
                updateUIForBookingClosed()
            default:
                print("Event not found")
                setInitialUI()
            }
        } else {
            print("Error retrieving event data")
            setInitialUI()
        }
    }
    
    // Handles UI update for booking opened event
    private func updateUIForBookingOpened(with data: JSON) {
        setInitialUI()
        // Saves and shows pickup location
        if let pickupLocation = DataParser.parseLocation(from: data, for: "pickupLocation") {
            updatePickupLocation(with: pickupLocation)
        }
        // Saves and shows drop off location
        if let dropoffLocation = DataParser.parseLocation(from: data, for: "dropoffLocation") {
            updateDropoffLocation(with: dropoffLocation)
        }
        // Saves and shows initial vehicle location
        if let vehicleLocation = DataParser.parseLocation(from: data, for: "vehicleLocation") {
            updateInitialVehicleLocation(with: vehicleLocation)
        }
        // Sets passenger status
        if let status = data["data"]["status"].string {
            updateInitialPassengerStatus(with: status)
        }
        // Saves and shows intermediate Stop Locations
        if let intermediateLocations = data["data"]["intermediateStopLocations"].array {
            updateInitialIntermediateLocations(with: intermediateLocations)
        }

    }
    
    private func updatePickupLocation(with location: Location) {
        // Updates pick up label
        pickUpAddressLabel.text = location.address
        // Stores lat and lng
        locationsLatitude.append(location.latitude)
        locationsLongitude.append(location.longitude)
        // Adds marker to map
        addMarker(at: location)
    }
    
    private func updateDropoffLocation(with location: Location) {
        // Updates drop off label
        dropOffAddressLabel.text = location.address
        // Saves drop off address to be displayed in nextStopLabel
        dropoffLocationAddress = location.address
        // Stores lat and lng
        locationsLatitude.append(location.latitude)
        locationsLongitude.append(location.longitude)
        // Adds marker to map
        addMarker(at: location)
    }
    
    private func updateInitialVehicleLocation(with location: Location) {
        // Stores lat and lng
        locationsLatitude.append(location.latitude)
        locationsLongitude.append(location.longitude)
        // Saves current vehicle location
        currentVehicleLocation = location
        // Adds marker to map
        addMarker(at: location)
        // Centers map based on collected locationsLatitude and locationsLongitude
        centerMap()
    }
    
    private func updateInitialPassengerStatus(with status: String) {
        currentPassengerStatus = status
        statusLabel.text = StatusManager.getLabel(for: status)
        statusImageView.image = StatusManager.getIcon(for: status)
        // Set next stop label
        setNextStopLabel(for: currentPassengerStatus)
    }
    
    private func updateInitialIntermediateLocations(with locations: [JSON]) {
        intermediateStopLocationsJSON = locations
        constructIntermediateStopLocations()
        if intermediateStopLocations.count > 0 {
            // Show on map
            addMarkers(at: intermediateStopLocations)
        }
    }
    
    // Handles UI updates for vehicle location updated events
    private func updateUIForVehicleLocationUpdated(with data: JSON) {
        // Vehicle location
        if let updatedLocation = DataParser.parseVehicleLocation(from: data) {
            // Check if there is a current vehicle location
            if let currentLocation = currentVehicleLocation {
                // Remove current vehicle marker from map and update vehicle bearing
                removeMarker(at: currentLocation)
                updateVehicleBearing(withCurrentLocation: currentLocation, andUpdatedLocation: updatedLocation)
            }
            // Stores updated location as current location
            currentVehicleLocation = updatedLocation
            // Add new location in map
            addMarker(at: updatedLocation)
        }
    }
    
    // Update bearing based on current and updated locations
    private func updateVehicleBearing(withCurrentLocation currentLoc: Location, andUpdatedLocation updatedLoc: Location) {
        let currentVehiclePosition = CLLocation(latitude: currentLoc.latitude, longitude: currentLoc.longitude)
        let updatedVehiclePosition = CLLocation(latitude: updatedLoc.latitude, longitude: updatedLoc.longitude)
        let updatedBearing = Calculations.getBearingBetweenTwoPoints(point1: currentVehiclePosition, point2: updatedVehiclePosition)
        // Store bearing difference and update current bearing value
        bearingShift = updatedBearing - currentBearing
        currentBearing = updatedBearing
        // Rotate vehicle image in the bearing compass view
        vehicleBearingImageView.transform = vehicleBearingImageView.transform.rotated(by: CGFloat(bearingShift))
    }
    
    // Handles UI updates for status updated events
    private func updateUIForStatusUpdated(with data: JSON) {
        // Retrieve current passenger status
        if let status = data["data"].string {
            currentPassengerStatus = status
            statusLabel.text = StatusManager.getLabel(for: status)
            statusImageView.image = StatusManager.getIcon(for: status)
            updateMapAndLabel()
        }
    }
    
    // Handles UI updates for intermediate stop locations changed events
    private func updateUIForIntermediateStopLocationsChanged(with data: JSON) {
        // Store new intermediate locations
        intermediateStopLocationsJSON = data["data"].arrayValue
        updateMapAndLabel()
    }
    
    private func updateMapAndLabel() {
        // Remove current intermediate locations from map and store new ones
        // Set intermediate stops custom view colors for status changes and update next stop label
        removeMarkers(at: intermediateStopLocations)
        intermediateStopLocations.removeAll()
        constructIntermediateStopLocations()
        if intermediateStopLocations.count > 0 {
            // Show intermediate locations on map
            addMarkers(at: intermediateStopLocations)
        }
        // Set next stop label
        setNextStopLabel(for: currentPassengerStatus)
    }
    
    // Handles UI update for booking closed event
    private func updateUIForBookingClosed() {
        // Booking closed, say bye bye
        animateNextStopLabel(with: "👋 Bye bye!")
    }
    
    
    // Sets initial UI and handles when casting event data produces an error
    private func setInitialUI() {
        pickUpAddressLabel.text = "Not available"
        dropOffAddressLabel.text = "Not available"
        statusLabel.text = "Not available"
        statusImageView.image = nil
    }
    
    // Contructs the intermediate stop locations Location object array from the intermediate stop location JSON array
    private func constructIntermediateStopLocations() {
        var isFirst = true
        for locationJSON in intermediateStopLocationsJSON {
            if let location = DataParser.parseIntermediateLocation(from: locationJSON, isFirst: isFirst, passengerStatus: currentPassengerStatus) {
                intermediateStopLocations.append(location)
                isFirst = false
            }
        }
    }
    
    // Set content and style of nextStopLabel
    private func setNextStopLabel(for passengerStatus: String) {
        // Set next stop label only if passenger is in vehicle and there are intermediate stops
        if passengerStatus == "inVehicle" {
            if intermediateStopLocations.count > 0 {
                // Display next intermediate location address if not nil
                if let address = intermediateStopLocations[0].address {
                    animateNextStopLabel(with: "Next stop: \(address)")
                } else {
                    animateNextStopLabel(with: "Not available")
                }
            } else {
                // No intermediate stops: display drop off location address if not nil
                if let address = dropoffLocationAddress {
                    animateNextStopLabel(with: "Next stop: \(address)")
                } else {
                    animateNextStopLabel(with: "Not available")
                }
            }
        }
    }
    
    private func animateNextStopLabel(with text: String) {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.nextStopLabel.text = text
            self.nextStopLabel.alpha = 1.0
            if self.intermediateStopLocations.count == 0 {
                // Next stop is drop off: give drop off backgroud color
                self.nextStopLabel.backgroundColor = Constants.dropoffBackgroundColor
            } else {
                self.nextStopLabel.backgroundColor = Constants.originalBackgroundColor
            }
            if self.currentPassengerStatus == "droppedOff" {
                // Set backgroud color back to original
                self.nextStopLabel.backgroundColor = Constants.originalBackgroundColor
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


//MARK: - Web Socket Delegate methods
extension TripViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("Web socket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Web socket is disconnected: \(error?.localizedDescription ?? "Error disconnecting form web socket")")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Got some data")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let data = JSON(parseJSON: text)
        DispatchQueue.main.async {
            self.updateUI(with: data)
        }
    }
}

