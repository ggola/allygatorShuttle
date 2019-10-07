//
//  allygatorShuttleTests.swift
//  allygatorShuttleTests
//
//  Created by Giulio Gola on 01/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import allygatorShuttle

class DataParserTests: XCTestCase {
    
    var sut: DataParser!

    override func setUp() {
        super.setUp()
        sut = DataParser()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // Booking Opened Event
    func testBookingOpenedEventDataAreParsed() {
        // given
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "BookingOpenedEvent", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let dataJSON = try? JSON(data: data!)
        var objectType = ""
        var location: Location?
        
        // **** Pickup location data
        objectType = "pickupLocation"
        // when
        location = sut.parseLocationForBookingOpened(from: dataJSON!, for: objectType)
        // then
        XCTAssertEqual(location?.coordinate.latitude, 52.526629999999997, "Object latitude is wrong")
        XCTAssertEqual(location?.coordinate.longitude, 13.411632000000001, "Object longitude is wrong")
        XCTAssertEqual(location?.address, "Volksbühne Berlin", "Object address is wrong")
        XCTAssertEqual(location?.image, UIImage(named: "pickUpLocation"), "Wrong image for first intermediate location")
        
        // **** Dropoff location data
        objectType = "dropoffLocation"
        // when
        location = sut.parseLocationForBookingOpened(from: dataJSON!, for: objectType)
        // then
        XCTAssertEqual(location?.coordinate.latitude, 52.513762999999997, "Object latitude is wrong")
        XCTAssertEqual(location?.coordinate.longitude, 13.393208, "Object longitude is wrong")
        XCTAssertEqual(location?.address, "Gendarmenmarkt", "Object address is wrong")
        XCTAssertEqual(location?.image, UIImage(named: "dropOffLocation"), "Wrong image for first intermediate location")
        
        // **** Vehicle initial location data
        objectType = "vehicleLocation"
        // when
        location = sut.parseLocationForBookingOpened(from: dataJSON!, for: objectType)
        // then
        XCTAssertEqual(location?.coordinate.latitude, 52.519061000000001, "Object latitude is wrong")
        XCTAssertEqual(location?.coordinate.longitude, 13.426788999999999, "Object longitude is wrong")
        XCTAssertEqual(location?.address, nil, "Object address is not nil")
        XCTAssertEqual(location?.image, UIImage(named: "vehicle"), "Wrong image for first intermediate location")
        
        // **** Intermediate locations count
        // when
        let locationsJSON = sut.parseIntermediateLocationsForBookingOpened(from: dataJSON!)
        // then
        XCTAssertEqual(locationsJSON?.count, 2, "Wrong number of intermediate locations")
        
        // **** Intermediate locations data
        // Passenger waitingForPickup
        // when
        var intermediateLocation: JSON!
        intermediateLocation = locationsJSON![0]
        location = sut.parseIntermediateLocation(from: intermediateLocation, isFirst: true, passengerStatus: "waitingForPickup")
        // then
        XCTAssertEqual(location?.coordinate.latitude, 52.523727999999998, "Object latitude is wrong")
        XCTAssertEqual(location?.coordinate.longitude, 13.399355999999999, "Object longitude is wrong")
        XCTAssertEqual(location?.address, "The Sixties Diner", "Object address is wrong")
        XCTAssertEqual(location?.image, UIImage(named: "intermediateLocation"), "Wrong image for intermediate location")
        // Passenger inVehicle - not first itermediate location
        // when
        intermediateLocation = locationsJSON![0]
        location = sut.parseIntermediateLocation(from: intermediateLocation, isFirst: false, passengerStatus: "inVehicle")
        // then
        XCTAssertEqual(location?.coordinate.latitude, 52.523727999999998, "Object latitude is wrong")
        XCTAssertEqual(location?.coordinate.longitude, 13.399355999999999, "Object longitude is wrong")
        XCTAssertEqual(location?.address, "The Sixties Diner", "Object address is wrong")
        XCTAssertEqual(location?.image, UIImage(named: "intermediateLocation"), "Wrong image for intermediate location")
        // Passenger inVehicle - first itermediate location
        // when
        intermediateLocation = locationsJSON![0]
        location = sut.parseIntermediateLocation(from: intermediateLocation, isFirst: true, passengerStatus: "inVehicle")
        // then
        XCTAssertEqual(location?.coordinate.latitude, 52.523727999999998, "Object latitude is wrong")
        XCTAssertEqual(location?.coordinate.longitude, 13.399355999999999, "Object longitude is wrong")
        XCTAssertEqual(location?.address, "The Sixties Diner", "Object address is wrong")
        XCTAssertEqual(location?.image, UIImage(named: "intermediateLocationFirst"), "Wrong image for first intermediate location")
 
        // **** Passenger Status
        // when
        let status = sut.parsePassengerStatusForBookingOpened(from: dataJSON!)
        // then
        XCTAssertEqual(status, "waitingForPickup", "Wrong passenger status")
    }
    
    // Intermediate Stop Location Changed Event
    func testIntermediateStopLocationsChangeEventDataAreParsed() {
        // given
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "IntermediateStopLocationsChangeEvent", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let dataJSON = try? JSON(data: data!)
        
        // **** Intermediate locations count
        // when
        let locationsJSON = sut.parseIntermediateLocationsForLocationsChanged(from: dataJSON!)
        // then
        XCTAssertEqual(locationsJSON?.count, 2, "Wrong number of intermediate locations")
    }
    
    // Vehicle Location Updated
    func testVehicleLocationUpdatedEventDataAreParsed() {
        // given
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "VehicleLocationUpdateEvent", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let dataJSON = try? JSON(data: data!)
        
        // when
        let location = sut.parseVehicleLocation(from: dataJSON!)
        // then
        XCTAssertEqual(location?.coordinate.latitude, 52.520046627821515, "Object latitude is wrong")
        XCTAssertEqual(location?.coordinate.longitude, 13.423404693603516, "Object longitude is wrong")
        XCTAssertEqual(location?.address, nil, "Object address is not nil")
        XCTAssertEqual(location?.image, UIImage(named: "vehicle"), "Wrong image for first intermediate location")
    }
    
    // Passenger Status Updated
    func testStatusUpdateEventDataAreParsed() {
        // given
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "StatusUpdateEvent", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let dataJSON = try? JSON(data: data!)
        
        // when
        let status = sut.parsePassengerStatusUpdated(from: dataJSON!)
        // then
        XCTAssertEqual(status, "inVehicle", "Wrong passenger status")
    }
    

}
