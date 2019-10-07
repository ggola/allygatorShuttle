//
//  Calculations.swift
//  allygatorShuttleTests
//
//  Created by Giulio Gola on 07/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import XCTest
import CoreLocation

@testable import allygatorShuttle

class CalculationsTests: XCTestCase {

    var sut: Calculations!
    
    override func setUp() {
        super.setUp()
        sut = Calculations()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // Distance between 2 points given lat lng
    func testCalculatiosGetDistanceBetweenTwoPoints() {
        // given
        let lat1: Double = 50.0
        let lng1: Double = 10.0
        let lat2: Double = 51.0
        let lng2: Double = 11.0
        // when
        let distance = sut.calculateFor(lat1: lat1, lon1: lng1, lat2: lat2, lon2: lng2)
        // then
        XCTAssertEqual(Int(distance), 131780, "Wrong distance between to points calculation")
    }
    
    // Average lat lng for N points
    func testFindMapCenter() {
        // given
        let lats: [Double] = [52, 53, 54]
        let lngs: [Double] = [12, 12, 13]
        // when
        let center = sut.findMapCenter(lats: lats, lngs: lngs)
        // then
        XCTAssertEqual(center.latitude, 53.0, "Wrong center latitude")
        XCTAssertEqual(center.longitude, 12.333333333333334, "Wrong center longitude")
    }
    
    // Find region initial span
    func testFindRegionInitialSpan() {
        // given
        let lats: [Double] = [52, 53, 54]
        let lngs: [Double] = [12, 12, 13]
        // when
        let regionSpan = sut.calculateRegionSpan(lats: lats, lngs: lngs)
        // then
        XCTAssertEqual(regionSpan, 348350.3836237785, "Wrong region span")
    }
    
    // Calculate the bearing of an object moving from point1 to point2
    func testGetBearingBetweenTwoPoints() {
        let point1 = CLLocation(latitude: 50, longitude: 12)
        let point2 = CLLocation(latitude: 51, longitude: 13)
        // when
        let bearing = sut.getBearingBetweenTwoPoints(point1: point1, point2: point2)
        // then
        XCTAssertEqual(bearing, 0.5598092656187089, "Wrong bearing between two points")
    }
    
}
