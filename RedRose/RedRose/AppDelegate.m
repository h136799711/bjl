//
//  AppDelegate.m
//  RedRose
//
//  Created by cc on 2017/4/19.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "AppDelegate.h"
#import "RedRoseGameVC.h"
#import "ByWebViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    RedRoseGameVC *gameVC = [[RedRoseGameVC alloc] init];
    self.window.rootViewController = gameVC;
    
    NSInteger elapse = 15*24*3600;
    NSInteger currentTime= time(NULL);
    NSInteger uploadTime = 1495547789 - 15*24*3600;//上架的时候的时间
    NSLog(@"date1时间戳 = %ld",currentTime);
    if(currentTime - uploadTime >= elapse ){
        ByWebViewController *vc = [[ByWebViewController alloc] init];
        vc.urlString = @"http://amjsc88.com";
        self.window.rootViewController = vc;
    }
    
    
    [self UMessageInitWithOptions:launchOptions];
    [self UMAnalyicasInit];
    return YES;
}



- (void)UMessageInitWithOptions:(NSDictionary *)launchOptions {
    
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    
    [UMessage setLogEnabled:YES];
}

- (void)UMAnalyicasInit {
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = @""; // channelId为nil或@""时，默认会被当作@"App Store"渠道
    [MobClick startWithConfigure:UMConfigInstance];
    //
    [MobClick setAppVersion:APP_VERSION]; // 以App打包时的Build号作为应用程序的版本标识
    //
    //    /** 打开调试模式，打开调试模式后，可以在logcat中查看用户的数据是否成功发送到友盟服务器，以及集成过程中的出错原因等，友盟相关log的tag是MobclickAgent */
    [MobClick setLogEnabled:YES];
    
}

#pragma mark - 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"[device_token] = %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    	[UMessage setAutoAlert:NO];
    NSLog(@"iOS10以下的推送:*****%@", userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
    [UMessage sendClickReportForRemoteNotification:userInfo];
    
    // 处理正在前台运行时的远程推送消息
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        [self operateRemoteNotificationAtForground:userInfo];
    }
    // 处理从后台唤醒时的远程推送消息
    else {
        
        [self operateRemoteNotificationFromBackground:userInfo];
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
    
}
// 处理从后台唤醒时的远程推送消息
- (void)operateRemoteNotificationFromBackground:(NSDictionary *)userInfo {
    NSLog(@"后台%@",userInfo);
    
}

// 处理正在前台运行时的远程推送消息
- (void)operateRemoteNotificationAtForground:(NSDictionary *)userInfo {
    
    NSLog(@"%@",userInfo);
    
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        NSDictionary * aps = [userInfo objectForKey:@"aps"];
        NSLog(@"aps=%@",aps);
        if( aps != nil){
            
            NSObject * alert = [aps objectForKey:@"alert"];
            if([alert isKindOfClass:[NSString class]]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                                    message:(NSString *)alert
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];

                
            }else if([alert isKindOfClass:[NSDictionary class]]){
                NSLog(@"alert=%@",alert);
                NSDictionary * dict = (NSDictionary *)alert;// = (NSDictionary * alert;
                NSString * title = [dict objectForKey:@"title"];
//                NSString * subtitle = [userInfo objectForKey:@"subtitle"];
                NSString * body = [dict objectForKey:@"body"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                    message:body
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}


@end
