//
//  SightsTests.swift
//  SightsTests
//
//  Created by Lina Alkhodair on 12/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import XCTest

@testable import Sights
import CoreLocation

class SightsTests: XCTestCase {
    
    
    func testRandomHiddenLocation() {

        let challengeVC = ChallengeViewController()
        let actual = challengeVC.randomLocation(lat: 24.3453, lng: 43.7392)
        
        XCTAssertFalse(24.3453 == actual.latitude)
        XCTAssertFalse(43.7392 == actual.longitude)

    }

    func testPOIview() {
        
        let homeVC = HomeViewController()
        let actual = homeVC.setPOIView(ID: "aYLkWgVxQYKKr4ADl8MH")
        
        XCTAssertNotNil(actual)
        
    }
    
    func testMotion() {
        
        let expected = "stationary"
        let coreMotion = CoreMotionManager()
        
        coreMotion.startUpdates { (actual) in
            XCTAssertTrue(expected == actual)
        }
    }
    
    func testLBnotification() {
        
        let notification = LBNotification(lat: 24.754808, lng: 46.738183)
        let actual = notification.foursquareNotification(name: "sample")
        
        XCTAssertNotNil(actual)
        
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
