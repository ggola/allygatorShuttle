//
//  StatusManager.swift
//  allygatorShuttle
//
//  Created by Giulio Gola on 03/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import UIKit

struct StatusManager {
    
    // Returns status label based on status retrieved from the server
    static func getLabel(for status: String) -> String {
        switch status {
        case "waitingForPickup":
            return "Waiting"
        case "inVehicle":
            return "In vehicle"
        case "droppedOff":
            return "Dropped off"
        default:
            return "Unknown"
        }
    }
    
    // Returns status icon based on status retrieved from the server
    static func getIcon(for status: String) -> UIImage? {
        switch status {
        case "waitingForPickup":
            return UIImage(named: "waiting") ?? nil
        case "inVehicle":
            return UIImage(named: "inTheVehicle") ?? nil
        case "droppedOff":
            return UIImage(named: "droppedOff") ?? nil
        default:
            return nil
        }
    }
    
}


