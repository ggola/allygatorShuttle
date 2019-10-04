//
//  Location.swift
//  allygatorShuttle
//
//  Created by Giulio Gola on 02/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject, MKAnnotation {
    
    var latitude: Double
    var longitude: Double
    var address: String?
    var type: String
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
    
    init(latitude: Double, longitude: Double, address: String?, type: String, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.type = type
        self.image = image
        self.coordinate = coordinate
        
        super.init()
    }
    
    var title: String? {
        return type
    }
    
    var subtitle: String? {
        return address
    }
    
}
