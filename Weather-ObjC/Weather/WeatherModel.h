//
//  WeatherModel.h
//  Weather
//
//  Created by Arturs Derkintis on 12/9/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherModel : NSObject

/**Temperature in current location*/
@property (nonatomic) double temp;

/**Temperature unit. C for Celsius, F for Fahrenheit*/
@property (nonatomic) NSString *temperatureUnit;

/**City near current location*/
@property (nonatomic) NSString *city;

/**Country of current location*/
@property (nonatomic) NSString *country;

@property (nonatomic) NSString *desc;

/**Returns official/creepy Yahoo weather images*/
-(NSURL*)getImageURL;

/**If everything fails here must be info about why it happened*/
@property (nonatomic) NSError  *error;

@end
