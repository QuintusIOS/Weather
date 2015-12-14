//
//  ViewController.m
//  Weather
//
//  Created by Arturs Derkintis on 12/9/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
//º
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _api = [WeatherAPI alloc];
    
    //Initializes location services.
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    
}

//Manual way to request weather data
- (IBAction)getWeatherForCurrentLocation:(id)sender {
    
    CLLocationCoordinate2D coordinate = [[[_mapView userLocation] location] coordinate];
  
    [_api generateModelForCoordinates:coordinate completion:^(WeatherModel *model) {
        if (model.error) {
            //If api eats something bad, it'll throw error
            self.location.text = model.error.localizedDescription;
            return;
        }
        
        //Request image in background thread to not disturb stuf that happens on main thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *url = [model getImageURL];
            UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        });
        
        self.location.text = [NSString stringWithFormat:@"%@, %@", model.city, model.country];
        self.temp.text = [NSString stringWithFormat:@"%.1fº%@", model.temp, model.temperatureUnit];
        [self setBackgroundColor:model.temp withUnit:model.temperatureUnit];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
}

//Each time there's new location received request new weather.
//It's bad in long run, because Yahoo server might fail to deliever responce
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    [_api generateModelForCoordinates:userLocation.location.coordinate completion:^(WeatherModel *model) {
        if (model.error) {
            //If api eats something bad, it'll throw error
            self.location.text = model.error.localizedDescription;
            return;
        }
        
        //Request image in background thread to not disturb stuf that happens on main thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *url = [model getImageURL];
            UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        });
        
        self.location.text = [NSString stringWithFormat:@"%@, %@", model.city, model.country];
        self.temp.text = [NSString stringWithFormat:@"%.1fº%@", model.temp, model.temperatureUnit];
        
        [self setBackgroundColor:model.temp withUnit:model.temperatureUnit];
    }];

}

//If temperature is under 0 celsius - sets background in different shades of blue according to coldness level
//Else if temperature is above 0C - sets background in different shade of red according how hot it is
- (void)setBackgroundColor:(double)temp withUnit:(NSString*)unit{
    double celsius = 0.0;
    if ([unit isEqualToString:@"F"]){
        celsius = [self fahrenheitToCelsius:temp];
    }else if ([unit isEqualToString:@"C"]){
        celsius = temp;
    }
    if (celsius <= 0) {
        double low = 0.4 + ((fabs(celsius) / 60) * 0.6);
        self.view.backgroundColor = [UIColor colorWithHue:240.f/359.0f saturation: low brightness:1.0 alpha:1.0];
    }else if (celsius > 0) {
        double low = 0.4 + ((fabs(celsius) / 60) * 0.6);
        self.view.backgroundColor = [UIColor colorWithHue:0 saturation: low brightness:1.0 alpha:1.0];
    }
}

//Converts Fahrenheits to Celsius
- (double) fahrenheitToCelsius:(double)f{
    double i = 5.0f / 9.0f;
    double value = (f - 32) * i;
    return value;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
