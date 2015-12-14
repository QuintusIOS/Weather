//
//  WeatherAPI.swift
//  Weather-Swift
//
//  Created by Arturs Derkintis on 12/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class WeatherAPI: NSObject {
    func generateModelForCoordinates(coordinates : CLLocationCoordinate2D, completion : (model : WeatherModel) -> Void){
        
        let string = "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (SELECT woeid FROM geo.placefinder WHERE text=\"\(coordinates.latitude), \(coordinates.longitude)\" and gflags=\"R\") and u=\"c\"&format=json"
        let request = string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        Alamofire.request(.GET, request!)
            .response { request, response, data, error in
                
                let model = WeatherModel()
                if let error = error{
                    model.error = error
                }
                if let data = data{
                    do{
                        let jsonRaw = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        let json = JSON(jsonRaw)
                    
                        //print("JSON: \(json)")
                        let city = json["query"]["results"]["channel"]["location"]["city"].string
                        let country = json["query"]["results"]["channel"]["location"]["country"].string
                        let desc = json["query"]["results"]["channel"]["item"]["description"].string
                        let temp = json["query"]["results"]["channel"]["item"]["condition"]["temp"].doubleValue
                        let tempUnit = json["query"]["results"]["channel"]["units"]["temperature"].string
                        model.temp = temp
                        model.city = city
                        model.country = country
                        model.temperatureUnit = tempUnit
                        model.desc = desc
                        
                    }catch let error as NSError{
                        model.error = error
                    }
                }
                print("finished")
                completion(model: model)
        }
    }
}
