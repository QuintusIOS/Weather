//
//  WeatherAPI.h
//  WeatherTest
//
//  Created by Arturs Derkintis on 12/9/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "WeatherModel.h"
#import <MapKit/MapKit.h>

@interface WeatherAPI : NSObject

-(void)generateModelForCoordinates:(CLLocationCoordinate2D)coordinate completion:(void (^)(WeatherModel *model))finishBlock;

@end
