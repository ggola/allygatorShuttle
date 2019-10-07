//
//  DistanceCalculation.swift
//  allygatorShuttle
//
//  Created by Giulio Gola on 03/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import UIKit
import CoreLocation

struct Calculations {
    
    // This function converts decimal degrees to radians
    private func deg2rad(deg: Double) -> Double {
        return deg * Double.pi / 180
    }
    
    // This function converts radians to decimal degrees
    private func rad2deg(rad: Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    // Calculate distance between two points with lat and lng
    // https://www.movable-type.co.uk/scripts/latlong.html
    func calculateFor(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371000.0 // earth avg radius in metres
        let φ1 = deg2rad(deg: lat1)
        let φ2 = deg2rad(deg: lat2)
        let Δφ = deg2rad(deg: (lat2-lat1))
        let Δλ = deg2rad(deg: (lon2-lon1))
        let a = sin(Δφ/2) * sin(Δφ/2) + cos(φ1) * cos(φ2) * sin(Δλ/2) * sin(Δλ/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return R * c
    }
    
    // Find map center
    func findMapCenter(lats: [Double], lngs: [Double]) -> CLLocationCoordinate2D {
        let initialLatitude = lats.reduce(0, +) / Double(lats.count)
        let initialLongitude = lngs.reduce(0, +) / Double(lngs.count)
        return CLLocationCoordinate2D(latitude: initialLatitude, longitude: initialLongitude)
    }
    
    // Find region initial span
    func calculateRegionSpan(lats: [Double], lngs: [Double]) -> Double {
        let factor = 1.5
        
        let maxLat = lats.max()
        let maxLatIndex = lats.indices.filter{lats[$0] == maxLat!}[0]
        let pointMaxLat = CLLocationCoordinate2D(latitude: lats[maxLatIndex], longitude: lngs[maxLatIndex])
        
        let minLat = lats.min()
        let minLatIndex = lats.indices.filter{lats[$0] == minLat!}[0]
        let pointMinLat = CLLocationCoordinate2D(latitude: lats[minLatIndex], longitude: lngs[minLatIndex])
        
        let maxLng = lngs.max()
        let maxLngIndex = lngs.indices.filter{lngs[$0] == maxLng!}[0]
        let pointMaxLng = CLLocationCoordinate2D(latitude: lats[maxLngIndex], longitude: lngs[maxLngIndex])
        
        let minLng = lngs.min()
        let minLngIndex = lngs.indices.filter{lngs[$0] == minLng!}[0]
        let pointMinLng = CLLocationCoordinate2D(latitude: lats[minLngIndex], longitude: lngs[minLngIndex])
        
        let distLat = calculateFor(lat1: pointMaxLat.latitude, lon1: pointMaxLat.longitude, lat2: pointMinLat.latitude, lon2: pointMinLat.longitude)
        let distLng = calculateFor(lat1: pointMaxLng.latitude, lon1: pointMaxLng.longitude, lat2: pointMinLng.latitude, lon2: pointMinLng.longitude)
        
        return (distLat > distLng) ? distLat * factor : distLng * factor
    }
    
    // Return the bearing of an object moving from point1 to point2
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = deg2rad(deg: point1.coordinate.latitude)
        let lon1 = deg2rad(deg: point1.coordinate.longitude)
        
        let lat2 = deg2rad(deg: point2.coordinate.latitude)
        let lon2 = deg2rad(deg: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        return atan2(y, x)
    }
}



