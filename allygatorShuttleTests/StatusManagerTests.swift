//
//  StatusManagerTest.swift
//  allygatorShuttleTests
//
//  Created by Giulio Gola on 07/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import XCTest

@testable import allygatorShuttle

class StatusManagerTest: XCTestCase {

    var sut: StatusManager!
    
    override func setUp() {
        super.setUp()
        sut = StatusManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // Status label
    func testStatusManagerGetLabel() {
        var status: String!
        var statusLabel: String!
        
        // given
        status = "waitingForPickup"
        // when
        statusLabel = sut.getLabel(for: status)
        // then
        XCTAssertEqual(statusLabel, "Waiting", "Wrong status label")
        
        // given
        status = "inVehicle"
        // when
        statusLabel = sut.getLabel(for: status)
        // then
        XCTAssertEqual(statusLabel, "In vehicle", "Wrong status label")
        
        // given
        status = "droppedOff"
        // when
        statusLabel = sut.getLabel(for: status)
        // then
        XCTAssertEqual(statusLabel, "Dropped off", "Wrong status label")
        
        // given
        status = ""
        // when
        statusLabel = sut.getLabel(for: status)
        // then
        XCTAssertEqual(statusLabel, "Unknown", "Wrong status label")
    }
    
    // Status icon
    func testStatusManagerGetIcon() {
        var status: String!
        var statusIcon: UIImage?
        
        // given
        status = "waitingForPickup"
        // when
        statusIcon = sut.getIcon(for: status)
        // then
        XCTAssertEqual(statusIcon, UIImage(named: "waiting"), "Wrong status icon")
        
        // given
        status = "inVehicle"
        // when
        statusIcon = sut.getIcon(for: status)
        // then
        XCTAssertEqual(statusIcon, UIImage(named: "inTheVehicle"), "Wrong status icon")
        
        // given
        status = "droppedOff"
        // when
        statusIcon = sut.getIcon(for: status)
        // then
        XCTAssertEqual(statusIcon, UIImage(named: "droppedOff"), "Wrong status icon")
        
        // given
        status = ""
        // when
        statusIcon = sut.getIcon(for: status)
        // then
        XCTAssertEqual(statusIcon, nil, "Wrong status icon")
    }

}
