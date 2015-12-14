//
//  UIImage+GIF.swift
//  Weather-Swift
//
//  Created by Arturs Derkintis on 12/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {
    class func imageWithData(data: NSData, animate: Bool) -> UIImage? {
        if (!animate) {
            return UIImage(data: data)
        }
        let source: CGImageSourceRef = CGImageSourceCreateWithData(data, nil)!
        let count: Int = CGImageSourceGetCount(source)
        if (count < 2) {
            return UIImage(data: data)
        }
        
        // Compile key frames
        var frames: [(image: CGImageRef, delay: Float)] = []
        for (var i: Int = 0; i < count; ++i) {
            
            // Mimic WebKit approach to determine frame delay
            var delay: Float = 0.1 // WebKit default delay
            if let frameProperties: NSDictionary = CGImageSourceCopyPropertiesAtIndex(source, i, nil), GIFProperties = frameProperties["{GIF}"] as? [String: AnyObject] {
                if let unclampedDelayTime = GIFProperties["UnclampedDelayTime"] as? Float where unclampedDelayTime > 0.0 {
                    
                    // Prefer "unclamped" delay time
                    delay = unclampedDelayTime
                } else if let delayTime = GIFProperties["DelayTime"] as? Float where delayTime > 0.0 {
                    delay = delayTime
                }
            }
            let frame: (image: CGImageRef, delay: Float) = (CGImageSourceCreateImageAtIndex(source, i, nil)!, delay)
            frames.append(frame)
        }
        
        // Convert key frames to animated image
        var images: [UIImage] = []
        var duration: Float = 0.0
        for frame in frames {
            let image = UIImage(CGImage: frame.image)
            for (var i: Int = 0; i < Int(frame.delay * 100.0); i++) {
                
                // Add fill frames
                images.append(image)
            }
            duration += frame.delay
        }
        return UIImage.animatedImageWithImages(images, duration: NSTimeInterval(duration))
    }
}