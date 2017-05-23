//
//  NSString+Helper.h
//  itboye2015002
//
//  Created by boye_mac1 on 15/8/18.
//  Copyright (c) 2015年 Boye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"

@interface NSString (Helper)

/** URL String Encode */
- (NSString *)stringByEncodingURLFormat;


/** URL String Decode */
- (NSString *)stringByDecodingURLFormat;




@end
