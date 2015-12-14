//
//  ViewController.swift
//  Weather-Swift
//
//  Created by Arturs Derkintis on 12/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var api = WeatherAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.requestAlwaysAuthorization()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Manual way to request weather data
    @IBAction func getWeatherForCurrentLocation(sender: AnyObject) {
        if let currentCoordinates = mapView.userLocation.location?.coordinate{
            api.generateModelForCoordinates(currentCoordinates, completion: { (model : WeatherModel) -> Void in
                if let error = model.error{
                    self.location.text = error.localizedDescription
                    return
                }
                if let temp = model.temp, let unit = model.temperatureUnit, let city = model.city, let country = model.country{
                    self.temp.text = "\(temp), º\(unit)"
                    self.location.text = "\(city), \(country)"
                    self.setBackgroundColor(temp, withUnit: unit)
                    //Request image in background thread to not disturb the stuf that happens on main thread
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        if let url = model.getImageURL(){
                            if let data = NSData(contentsOfURL: url){
                                let image = UIImage.imageWithData(data, animate: true)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.imageView.image = image
                                })
                            }
                        }
                    })
                }
            })
        }
    }
    
    //Each time there's new location received request new weather.
    //It's bad in long run, because Yahoo server might fail to deliever responce
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let currentCoordinates = userLocation.location?.coordinate{
            api.generateModelForCoordinates(currentCoordinates, completion: { (model : WeatherModel) -> Void in
                if let error = model.error{
                    self.location.text = error.localizedDescription
                    return
                }
                if let temp = model.temp, let unit = model.temperatureUnit, let city = model.city, let country = model.country{
                    self.temp.text = "\(temp)º\(unit)"
                    self.location.text = "\(city), \(country)"
                    self.setBackgroundColor(temp, withUnit: unit)
                    //Request image in background thread to not disturb the stuf that happens on main thread
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        if let url = model.getImageURL(){
                            if let data = NSData(contentsOfURL: url){
                                let image = UIImage.imageWithData(data, animate: true)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.imageView.image = image
                                })
                            }
                        }
                    })
                }
            })
        }
    }
    
    //If temperature is under 0 celsius - sets background in different shades of blue according to coldness level
    //Else if temperature is above 0C - sets background in different shade of red according how hot it is
    func setBackgroundColor(temp : Double, withUnit unit : String){
        var celsius = 0.0
        if unit == "F"{
            celsius = fahrenheitToCelsius(temp)
        }else if unit == "C"{
            celsius = temp
        }
        if celsius <= 0{
            let low : Double = 0.4 + ((fabs(celsius) / 60) * 0.6)
            view.backgroundColor = UIColor(hue: 240/359, saturation: CGFloat(low), brightness: 1.0, alpha: 1.0)
        }else if celsius > 0{
            let low : Double = 0.4 + ((fabs(celsius) / 60) * 0.6)
            view.backgroundColor = UIColor(hue: 0, saturation: CGFloat(low), brightness: 1.0, alpha: 1.0)
        }
    }
    
    
    //Converts Fahrenheits to Celsius
    func fahrenheitToCelsius(f : Double) -> Double{
        let i = 5.0 / 9.0
        let value = (f - 32) * i
        return value
    }
    
}

