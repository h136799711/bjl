//
//  NSString+Helper.m
//  itboye2015002
//
//  Created by boye_mac1 on 15/8/18.
//  Copyright (c) 2015年 Boye. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

#pragma mark - URL String Encode
- (NSString *)stringByEncodingURLFormat {
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (__bridge CFStringRef)self,
                                                              (__bridge CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}


#pragma mark - URL String Decode
- (NSString *)stringByDecodingURLFormat {
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}



@end
