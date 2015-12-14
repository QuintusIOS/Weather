
//
//  WeatherModel.m
//  Weather
//
//  Created by Arturs Derkintis on 12/9/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

//Finds image url in description
-(NSURL*)getImageURL{
    NSError *error = NULL;
    __block NSString * image = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    [regex enumerateMatchesInString:self.desc
                            options:0
                              range:NSMakeRange(0, [self.desc length])
                         usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                             
                             image = [self.desc substringWithRange:[result rangeAtIndex:2]];
                            

                         }];
    return [NSURL URLWithString:image];
}

@end
