//
//  DataParser.swift
//  allygatorShuttle
//
//  Created by Giulio Gola on 03/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

struct DataParser {
    
    // Parses data based for objectLocation (event: bookingOpened). Returns Location object.
    func parseLocation(from data: JSON, for objectLocation: String) -> Location? {
        if let lat = data["data"][objectLocation]["lat"].double,
            let lng = data["data"][objectLocation]["lng"].double {
            // address can be nil
            let address = data["data"][objectLocation]["address"].string
            let type = LocationManager.getLocationType(from: objectLocation)
            let icon = LocationManager.getLocationIcon(from: objectLocation)
            return Location(latitude: lat, longitude: lng, address: address, type: type, image: icon, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        } else {
            return nil
        }
    }
    
    // Parses data for intermediate stop locations for booking opened event -> returns JSON objects array
    func parseIntermediateLocationsForBookingOpened(from data: JSON) -> [JSON]? {
        if let intermediateLocations = data["data"]["intermediateStopLocations"].array {
            return intermediateLocations
        } else {
            return nil
        }
    }
    
    // Parses data for intermediate stop locations for intermediate stop locations changed event -> returns JSON objects array
    func parseIntermediateLocationsForLocationsChanged(from data: JSON) -> [JSON]? {
        if let intermediateLocations = data["data"].array {
            return intermediateLocations
        } else {
            return nil
        }
    }
    
    // Parses data for intermediate stop locations changes (event: intermediateStopLocationsChanged). Returns Location object.
    func parseIntermediateLocation(from data: JSON, isFirst: Bool, passengerStatus: String) -> Location? {
        if let lat = data["lat"].double,
            let lng = data["lng"].double {
            // address can be nil
            let address = data["address"].string
            let type = LocationManager.getIntermediateLocationType()
            var icon = LocationManager.getIntermediateLocationIcon()
            if passengerStatus == "inVehicle" {
                // Highlight first intermediate location only when passenger is inVehicle
                icon = isFirst ? LocationManager.getIntermediateLocationFirstIcon() : LocationManager.getIntermediateLocationIcon()
            }
            return Location(latitude: lat, longitude: lng, address: address, type: type, image: icon, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        } else {
            return nil
        }
    }
    
    // Parses data for vehicle locations updates (event: vehicleLocationUpdated). Returns Location object.
    func parseVehicleLocation(from data: JSON) -> Location? {
        if let lat = data["data"]["lat"].double,
            let lng = data["data"]["lng"].double {
            // address can be nil
            let address = data["data"]["address"].string
            let type = LocationManager.getVehicleUpdatesType()
            let icon = LocationManager.getVehicleUpdatesIcon()
            return Location(latitude: lat, longitude: lng, address: address, type: type, image: icon, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        } else {
            return nil
        }
    }
    
    // Parses passenger status for booking opened event
    func parsePassengerStatusBookingOpened(from data: JSON) -> String? {
        if let status = data["data"]["status"].string {
            return status
        } else {
            return nil
        }
    }
    
    // Parses passenger status for status updated event
    func parsePassengerStatusUpdated(from data: JSON) -> String? {
        if let status = data["data"].string {
            return status
        } else {
            return nil
        }
    }
}
