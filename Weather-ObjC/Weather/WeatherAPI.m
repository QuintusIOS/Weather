//
//  WeatherAPI.m
//  WeatherTest
//
//  Created by Arturs Derkintis on 12/9/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

#import "WeatherAPI.h"
#import <AFNetworking/AFNetworking.h>
#import "WeatherModel.h"
@implementation WeatherAPI

-(void)generateModelForCoordinates:(CLLocationCoordinate2D)coordinate completion:(void (^)(WeatherModel *model))finishBlock{
    WeatherModel *model = [WeatherModel alloc];
    
    //Prepare request string
    NSString *string = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (SELECT woeid FROM geo.placefinder WHERE text=\"%f, %f\" and gflags=\"R\") and u=\"c\"&format=json", coordinate.latitude, coordinate.longitude];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *request = [string stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //This can look better, but I keep it simple
        NSString * temp = (NSString*)responseObject[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"];
        NSString * html = (NSString*)responseObject[@"query"][@"results"][@"channel"][@"item"][@"description"];
        NSString * tempUnit = (NSString*)responseObject[@"query"][@"results"][@"channel"][@"units"][@"temperature"];
        NSString * city = (NSString*)responseObject[@"query"][@"results"][@"channel"][@"location"][@"city"];
        NSString * country = (NSString*)responseObject[@"query"][@"results"][@"channel"][@"location"][@"country"];
        
        //update model
        model.temp = [temp doubleValue];
        model.desc = html;
        model.temperatureUnit = tempUnit;
        model.city = city;
        model.country = country;
        
        //Returns model
        finishBlock(model);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        //Put error in model
        model.error = error;
        
        //Returns model
        finishBlock(model);
    }];
    
    
}

@end
