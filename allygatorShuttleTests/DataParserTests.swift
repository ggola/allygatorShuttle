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

    func testBookingOpenedEventPickupLocationDataAreParsed() {
        // 1. given
        let objectLocation = "pickupLocation"
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "BookingOpenedEvent", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let dataJSON = try? JSON(data: data!)
        
        // 2. when
        //sut.
        
        // 3. then
        //XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
    }

}
