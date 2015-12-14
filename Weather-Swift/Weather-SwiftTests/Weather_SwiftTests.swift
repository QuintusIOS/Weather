//
//  Weather_SwiftTests.swift
//  Weather-SwiftTests
//
//  Created by Arturs Derkintis on 12/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import XCTest
import MapKit
@testable import Weather_Swift

class Weather_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherApi(){
        //London, UK
        let coordinates = CLLocationCoordinate2DMake(51.5099, -0.1337)
        let expectation = self.expectationWithDescription("Should wait for responce")
        let api = WeatherAPI()
        api.generateModelForCoordinates(coordinates) { (model) -> Void in
            if let error = model.error{
                print(error.localizedDescription)
                expectation.fulfill()
                return
            }
            print(model.city)
            XCTAssertNotNil(model.temp)
            XCTAssertNotNil(model.city)
            XCTAssertNotNil(model.country)
            XCTAssertNotNil(model.getImageURL())
            XCTAssertNotNil(model.temperatureUnit)
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(100, handler: nil)
    }
    
}
