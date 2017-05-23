//
//  Tool.m
//  card
//
//  Created by cc on 2017/4/17.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "AudioUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UserDefaults.h"

#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

static SystemSoundID shake_sound_male_id = 0;

@implementation AudioUtils

+ (void)play:(NSString *)name{
    
    if ([self allowPlayEffect]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
        if (path) {
            //注册声音到系统
            AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]),&shake_sound_male_id);
            AudioServicesPlaySystemSound(shake_sound_male_id);
            AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
        }
        
        AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
        
        //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    }
}

+ (void)closeEffectWithCompleteBlock:(void (^)(BOOL isAllow))completeBlock
{
    BOOL isAllow = [self allowPlayEffect];
    [UserDefaults setBool:isAllow forKey:KEY_CLOSE_EFFECT];
    [UserDefaults synchronize];
    
    if (completeBlock) {
        completeBlock(!isAllow);
    }
}

+ (BOOL)allowPlayEffect
{
    return ![UserDefaults boolForKey:KEY_CLOSE_EFFECT];
}


@end
