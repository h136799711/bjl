//
//  Tool.h
//  card
//
//  Created by cc on 2017/4/17.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioUtils : NSObject

+ (void)play:(NSString *)name;

+ (void)closeEffectWithCompleteBlock:(void (^)(BOOL isAllow)) completeBlock;

+ (BOOL)allowPlayEffect;


@end
