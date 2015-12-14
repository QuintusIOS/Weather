//
//  WeatherModel.swift
//  Weather-Swift
//
//  Created by Arturs Derkintis on 12/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    /**Temperature in current location*/
    var temp : Double?
    
    /**Temperature unit. C for Celsius, F for Fahrenheit*/
    var temperatureUnit : String?
    
    /**City near current location*/
    var city: String?
    
    /**Country of current location*/
    var country : String?
    
    var desc : String?
    
    /**Returns official/creepy Yahoo weather images*/
    func getImageURL() -> NSURL?{
        var imageURL : NSURL?
        if let desc = self.desc{
        do {
            let regex = try NSRegularExpression(pattern: "(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?", options: .CaseInsensitive)
            
            regex.enumerateMatchesInString(desc, options: [], range: NSMakeRange(0, (desc as NSString).length), usingBlock: { (result : NSTextCheckingResult?, flags, stop) -> Void in
                if let result = result{
                    imageURL = NSURL(string: (desc as NSString).substringWithRange(result.rangeAtIndex(2)) as String)
                }
            })
        
        }catch _{
            
        }
        }
        return imageURL
    }
    
    /**If everything fails here must be info about why it happened*/
    var error : NSError?
    

}
