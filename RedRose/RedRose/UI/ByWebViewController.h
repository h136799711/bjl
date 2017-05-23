//
//  ByWebViewController.h
//  hutouben_ios
//
//  Created by mc on 2017/5/18.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong)   UIWebView   *webView;
@property (nonatomic, strong)   UIColor     *color;
@property (nonatomic, copy)     NSString    *urlString;

@end
