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
    
    let locationManager = LocationManager()
    
    // Parses data based for objectType: pickupLocation, dropoffLocation, vehicleLocation. (event: bookingOpened). Returns Location object.
    func parseLocationForBookingOpened(from data: JSON, for objectType: String) -> Location? {
        if let lat = data["data"][objectType]["lat"].double,
            let lng = data["data"][objectType]["lng"].double {
            // address can be nil
            let address = data["data"][objectType]["address"].string
            let type = locationManager.getLocationType(from: objectType)
            let icon = locationManager.getLocationIcon(from: objectType)
            return Location(latitude: lat, longitude: lng, address: address, type: type, image: icon, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        } else {
            return nil
        }
    }
    
    // Parses data for intermediate stop locations (event: bookingOpened). Returns JSON objects array
    func parseIntermediateLocationsForBookingOpened(from data: JSON) -> [JSON]? {
        if let intermediateLocations = data["data"]["intermediateStopLocations"].array {
            return intermediateLocations
        } else {
            return nil
        }
    }
    
    // Parses passenger status (event: bookingOpened). Returns status as string
    func parsePassengerStatusForBookingOpened(from data: JSON) -> String? {
        if let status = data["data"]["status"].string {
            return status
        } else {
            return nil
        }
    }
    
    // Parses data for intermediate stop locations (event: intermediateStopLocationsChanged). Returns JSON objects array
    func parseIntermediateLocationsForLocationsChanged(from data: JSON) -> [JSON]? {
        if let intermediateLocations = data["data"].array {
            return intermediateLocations
        } else {
            return nil
        }
    }
    
    // Parses data for intermediate stop locations changes from each element of intermediateLocations JSON object array. Returns Location object.
    func parseIntermediateLocation(from data: JSON, isFirst: Bool, passengerStatus: String) -> Location? {
        if let lat = data["lat"].double,
            let lng = data["lng"].double {
            // address can be nil
            let address = data["address"].string
            let type = locationManager.getIntermediateLocationType()
            var icon = locationManager.getIntermediateLocationIcon()
            if passengerStatus == "inVehicle" {
                // Highlight first intermediate location only when passenger is inVehicle
                icon = isFirst ? locationManager.getIntermediateLocationFirstIcon() : locationManager.getIntermediateLocationIcon()
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
            let type = locationManager.getVehicleUpdatesType()
            let icon = locationManager.getVehicleUpdatesIcon()
            return Location(latitude: lat, longitude: lng, address: address, type: type, image: icon, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        } else {
            return nil
        }
    }
    
    // Parses passenger status (event: statusUpdated). Returns status as string
    func parsePassengerStatusUpdated(from data: JSON) -> String? {
        if let status = data["data"].string {
            return status
        } else {
            return nil
        }
    }
}
