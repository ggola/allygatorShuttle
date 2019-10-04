//
//  LocationManager.swift
//  allygatorShuttle
//
//  Created by Giulio Gola on 03/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import UIKit

struct LocationManager {
    
    static func getLocationType(from object: String) -> String {
        switch object {
        case "pickupLocation":
            return "Pick up"
        case "dropoffLocation":
            return "Drop off"
        case "vehicleLocation":
            return "Vehicle"
        default:
            return ""
        }
    }
    
    static func getLocationIcon(from object: String) -> UIImage? {
        switch object {
        case "pickupLocation":
            return UIImage(named: "pickUpLocation") ?? nil
        case "dropoffLocation":
            return UIImage(named: "dropOffLocation") ?? nil
        case "vehicleLocation":
            return UIImage(named: "vehicle") ?? nil
        default:
            return nil
        }
    }
    
    static func getIntermediateLocationType() -> String {
        return "Intermediate stop"
    }
    
    static func getIntermediateLocationIcon() -> UIImage? {
        return UIImage(named: "intermediateLocation")
    }
    
    static func getIntermediateLocationFirstIcon() -> UIImage? {
        return UIImage(named: "intermediateLocationFirst")
    }
    
    static func getVehicleUpdatesType() -> String {
        return "Vehicle"
    }
    
    static func getVehicleUpdatesIcon() -> UIImage? {
        return UIImage(named: "vehicle")
    }
    
}
