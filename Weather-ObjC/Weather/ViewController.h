//
//  ViewController.h
//  Weather
//
//  Created by Arturs Derkintis on 12/9/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherAPI.h"
#import <MapKit/MapKit.h>
#import "UIImage+animatedGIF.h" 

@interface ViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) WeatherAPI *api;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;

@end

