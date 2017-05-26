//
//  config.h
//  beibei_ios
//
//  Created by hebidu on 16/4/16.
//  Copyright © 2016年 hebidu. All rights reserved.
//


/** 常用宏 配置头文件  */
/** 朱凯 982942570@qq.com */


#ifndef CommonConfig_h
#define CommonConfig_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif


/** 用于打印数组，且数组中包含\n等转译符，比如覆写了model的描述方法中都有\n，那么打印多个model的数组时用该方法 */
#define ARRAR_LOG(array) NSLog(@"%@", [array componentsJoinedByString:@",*************\n"])

#pragma mark -- 系统参数 --
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//常用宏定义
#define  APP_SCHEME   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define  APP_NAME   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define  APP_SHORT_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define  APP_BUNDLE_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define  APP_VERSION [NSString stringWithFormat:@"%@.%@", APP_SHORT_VERSION,APP_BUNDLE_VERSION]
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


//接口地址定义

#define BOYE_CLIENT_ID @"by565fa4e56a9241"
#define BOYE_CLIENT_SECRET @"c37725a62af42ea0569d79b1942935be"

/** 接口地址 */
#define BOYE_API_URL          [NSString stringWithFormat:@"%@", BOYE_BASE_URL]
/** 文件上传地址 */
//#define BOYE_FILE_UPLOAD_URL  [NSString stringWithFormat:@"%@/file/upload", BOYE_BASE_URL]
/** 图片查看地址 */
#define BOYE_PICTURE_VIEW_URL(id) [NSString stringWithFormat:@"%@/picture/index?id=%@", BOYE_BASE_URL, id]
/** 头像地址（专门）*/
#define BOYE_AVATAR_URL(id)       [NSString stringWithFormat:@"%@/picture/avatar?id=%@", BOYE_BASE_URL, id]
/** Web Base URL */
#define BOYE_WEB_BASE_URL       [NSString stringWithFormat:@"http://api.ryzcgf.com/public/web.php/"]


// 图片获取
#define BOYE_IMAGE_URL_ORIGINAL(id) [NSString stringWithFormat:@"%@/picture/index?id=%@", BOYE_API_URL, id]
#define BOYE_IMAGE_URL(id, size) [NSString stringWithFormat:@"%@/picture/index?id=%@&size=%@", BOYE_API_URL, id, size]



//--------------------整体色调-------------------------
#define rgba(r,g,b,a)   [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]


// 虎头奔色值
#define ZJ_SEPLINE_COLOR [UIColor colorWithWhite:0.9 alpha:1]
#define TABLE_COLOR rgba(250, 245, 245, 1)
#define TEXT_COLOR [UIColor blackColor]

#define HTB_THEME_COLOR [UIColor colorWithRGBHex:0x009ff0]      // 主色调
#define HTB_BG_GRAY [UIColor colorWithRGBHex:0xf2f3f8]          // 背景-灰
#define HTB_BG_WHITE [UIColor colorWithRGBHex:0xffffff]         // 背景-白
#define HTB_TEXT_COLOR1 [UIColor colorWithRGBHex:0x1a1a1a]      // 字色-标题等接近黑色的文案
#define HTB_TEXT_COLOR2 [UIColor colorWithRGBHex:0x545454]      // 字色-二级标题等次级文案
#define HTB_TEXT_COLOR3 [UIColor colorWithRGBHex:0x8c8c8c]      // 字色-较浅灰色的文案
#define HTB_ORDER_COLOR [UIColor colorWithRGBHex:0x81d3bc]      // 绿色字体
#define HTB_LINE_COLOR rgba(235, 235, 237, 1)                   // 分割线颜色

#define DEFAULT_IMAGE [UIImage imageNamed:@"default1-1"]
#define DEFAULT_IMAGE_1_2 [UIImage imageNamed:@"default1-2"]

#define DEFAULT_HEAD [UIImage imageNamed:@"mine_defaultHead"]

//--------------------系统字体-------------------------
#pragma mark -- 系统字体 --
// 字体：细
#define FONT(F) [UIFont systemFontOfSize:F]
// 字体：粗
#define B_FONT(F) [UIFont boldSystemFontOfSize:F]


//--------------------屏幕宽高-------------------------
#pragma mark -- 屏幕宽高 --
// 屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


// 常用
#define BY_USER [ByCommonCache getUserInfo]
#define BY_CONFIG ByNetConfig
#define BY_APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define LineHeight    35

#endif /* CommonConfig_h */
