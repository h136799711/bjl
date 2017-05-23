//
//  UserDefaults.h
//  JustTest
//
//  Created by macuser on 2017/4/12.
//  Copyright © 2017年 just play. All rights reserved.
//

#define UserDefaults        [NSUserDefaults standardUserDefaults]

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define WEAKSELF            __weak typeof(self) weakSelf = self;

// 关闭背景音乐
#define KEY_CLOSE_BG_MUSIC   @"KEY_CLOSE_BG_MUSIC"

// 关闭音效
#define KEY_CLOSE_EFFECT     @"KEY_CLOSE_EFFECT"

#define UMessageAppKey      @""   
