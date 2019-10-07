//
//  LocationManagerTests.swift
//  allygatorShuttleTests
//
//  Created by Giulio Gola on 07/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import XCTest

@testable import allygatorShuttle

class LocationManagerTests: XCTestCase {

    var sut: LocationManager!
    
    override func setUp() {
        super.setUp()
        sut = LocationManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // Location type
    func testLocationManagerGetLocationType() {
        var object: String!
        var locationType: String!
        
        // given
        object = "pickupLocation"
        // when
        locationType = sut.getLocationType(from: object)
        // then
        XCTAssertEqual(locationType, "Pick up", "Wrong location type")
        
        // given
        object = "dropoffLocation"
        // when
        locationType = sut.getLocationType(from: object)
        // then
        XCTAssertEqual(locationType, "Drop off", "Wrong location type")
        
        // given
        object = "vehicleLocation"
        // when
        locationType = sut.getLocationType(from: object)
        // then
        XCTAssertEqual(locationType, "Vehicle", "Wrong location type")
        
        // given
        object = ""
        // when
        locationType = sut.getLocationType(from: object)
        // then
        XCTAssertEqual(locationType, "", "Wrong location type")
    }
    
    // Location icon
    func testLocationManagerGetLocationIcon() {
        var object: String!
        var locationIcon: UIImage?
        
        // given
        object = "pickupLocation"
        // when
        locationIcon = sut.getLocationIcon(from: object)
        // then
        XCTAssertEqual(locationIcon, UIImage(named: "pickUpLocation"), "Wrong location icon")
        
        // given
        object = "dropoffLocation"
        // when
        locationIcon = sut.getLocationIcon(from: object)
        // then
        XCTAssertEqual(locationIcon, UIImage(named: "dropOffLocation"), "Wrong location icon")
        
        // given
        object = "vehicleLocation"
        // when
        locationIcon = sut.getLocationIcon(from: object)
        // then
        XCTAssertEqual(locationIcon, UIImage(named: "vehicle"), "Wrong location icon")
        
        // given
        object = ""
        // when
        locationIcon = sut.getLocationIcon(from: object)
        // then
        XCTAssertEqual(locationIcon, nil, "Wrong location icon")
    }
    
    // Intermediate location type
    func testLocationManagerGetIntermediateLocationType() {
        // when
        let type = sut.getIntermediateLocationType()
        // then
        XCTAssertEqual(type, "Intermediate stop", "Wrong intermediate location type")
    }
    
    // Intermediate location icon
    func testLocationManagerGetIntermediateLocationIcon() {
        // when
        let icon = sut.getIntermediateLocationIcon()
        // then
        XCTAssertEqual(icon, UIImage(named: "intermediateLocation"), "Wrong intermediate location icon")
    }
    
    // Intermediate location first icon
    func testLocationManagerGetIntermediateLocationFirstIcon() {
        // when
        let icon = sut.getIntermediateLocationFirstIcon()
        // then
        XCTAssertEqual(icon, UIImage(named: "intermediateLocationFirst"), "Wrong intermediate location first icon")
    }

    // Vehicle update type
    func testLocationManagerGetVehicleUpdatesType() {
        // when
        let type = sut.getVehicleUpdatesType()
        // then
        XCTAssertEqual(type, "Vehicle", "Wrong vehicle type")
    }

    // Vehicle update icon
    func testLocationManagerGetVehicleUpdatesIcon() {
        // when
        let icon = sut.getVehicleUpdatesIcon()
        // then
        XCTAssertEqual(icon, UIImage(named: "vehicle"), "Wrong vehicle update icon")
    }

}
