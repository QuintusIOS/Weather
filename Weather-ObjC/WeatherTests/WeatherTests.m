//
//  WeatherTests.m
//  WeatherTests
//
//  Created by Arturs Derkintis on 12/9/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherAPI.h"
#import <MapKit/MapKit.h>

@interface WeatherTests : XCTestCase

@end

@implementation WeatherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWeatherApi {
    
    //London, UK
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(51.5099, -0.1337);
    WeatherAPI *api = [WeatherAPI alloc];
    XCTestExpectation *exp = [self expectationWithDescription:@"Should return model or error"];
    [api generateModelForCoordinates:coor completion:^(WeatherModel *model) {
        if (!model.error) {
            NSLog(@"%@", model.city);
            XCTAssertNotNil(model.country);
            XCTAssertNotNil(model.city);
            NSString *string = [NSString stringWithFormat:@"%f", model.temp];
            NSString *empty = [NSString stringWithFormat:@""];
            XCTAssertNotEqual(string, empty);
            XCTAssertNotNil([model getImageURL]);
            XCTAssertNotNil(model.temperatureUnit);
            [exp fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
}



@end
