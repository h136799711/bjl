//
//  ByWebViewController.m
//  hutouben_ios
//
//  Created by mc on 2017/5/18.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "ByWebViewController.h"

// view
#import "ByTabBarButton.h"

@interface ByWebViewController ()<UIScrollViewDelegate>
{
    UILabel *_loadLabel;                        // 网页加载提示文字
    
    UILabel *_notesLable;                       //提供者
}

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;    // 网页加载菊花转动
@property (nonatomic, strong) UIImageView *tabBarView;                   // 自定义tabBar
@property (nonatomic, strong) ByTabBarButton *selectedButton;            // 选中按钮
@property (nonatomic, strong) UIScrollView *bgScroller;
@end

@implementation ByWebViewController

#pragma mark -- getter

-(BOOL)prefersStatusBarHidden

{
    
    return YES;// 返回YES表示隐藏，返回NO表示显示
    
}
-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _indicatorView;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown;
}

#pragma mark --

-(void) viewDidAppear:(BOOL)animated{

    [_webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabBar];
    [self createWebView];
    [self initNotify];
    
}
#pragma mark -- notification

- (void) initNotify{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)deviceOrientationDidChange
{
    NSLog(@"deviceOrientationDidChange:%ld", (long)[UIDevice currentDevice].orientation);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [self portraitViews];
        NSLog(@"UIDeviceOrientationPortrait");
        
        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        NSLog(@"UIDeviceOrientationLandscapeLeft");
        [self landscapeViews];
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        NSLog(@"UIDeviceOrientationLandscapeRight");
        [self landscapeViews];
    }else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        NSLog(@"UIDeviceOrientationPortraitUpsideDown");
        [self portraitViews];
    }
    
    NSLog(@"SCREEN_WIDTH= %f,SCREEN_HEIGHT = %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    
    
    
}

// 横屏
-(void) landscapeViews{
    _tabBarView.hidden = YES;
    [self.view setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    // 竖屏
    _bgScroller.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_webView setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

// 竖屏
-(void) portraitViews{
    _tabBarView.hidden = NO;
    [_tabBarView setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    [self.view setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    // 竖屏
    _bgScroller.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
    _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    [_webView setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    //    ByTabBarButton
    CGFloat width = SCREEN_WIDTH / 5;
    NSLog(@"底部菜单宽度%f",width);
    int j =0 ;
    for (int i=0;i< _tabBarView.subviews.count; i++) {
        ByTabBarButton * btn  = (ByTabBarButton *) _tabBarView.subviews[i];
        if(btn != nil && [btn isKindOfClass:[ByTabBarButton class]]){
            
            [btn setBounds:CGRectMake(0, 0, 64, 49)];
            [btn setFrame:CGRectMake((j) * width - width/3, 0, width, 49)];
            j++;
        }
    }
}

#pragma mark -- 创建视图
- (void)viewWillLayoutSubviews{
    NSLog(@"调整布局");
    
    [super viewWillLayoutSubviews];
//    [_tabBarView setBounds:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//    [_tabBarView setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//    [self.view setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    // 竖屏
//    _bgScroller.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//    _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//    [_webView setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    
//    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
//        [self.view setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        // 竖屏
//        _bgScroller.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        [_webView setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//
//        
//    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
//        // 横屏
//        [self.view setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        self.view.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
//        _bgScroller.frame = CGRectMake(0, 0,SCREEN_WIDTH ,  SCREEN_HEIGHT - 49);
//        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        [_webView setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
//        [_tabBarView setBounds:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//        [_tabBarView setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//
//        
//    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
//        // 横屏
//        [self.view setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        self.view.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
//        _bgScroller.frame = CGRectMake(0, 0,SCREEN_WIDTH ,  SCREEN_HEIGHT - 49);
//        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        [_webView setBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
//        [_tabBarView setBounds:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//        [_tabBarView setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//
//        
//    }else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
//        // 竖屏
//        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        _bgScroller.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        [_tabBarView setBounds:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//        [_tabBarView setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//        
//        NSLog(@"UIDeviceOrientationPortraitUpsideDown");
//    }
}
// 创建webview
- (void)createWebView{
    self.view.autoresizesSubviews = YES;
    // 添加一个scroller
    _bgScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _bgScroller.delegate = self;
    _bgScroller.maximumZoomScale = 1;
    _bgScroller.minimumZoomScale = 1;
    [self.view addSubview:_bgScroller];
    
    // 创建网页webView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.delegate = self;
    [_bgScroller addSubview:_webView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    backgroundView.backgroundColor = rgba(46, 49, 50, 1);
    [_bgScroller insertSubview:backgroundView atIndex:0];
    
    _notesLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
    _notesLable.text = @"";
    _notesLable.textAlignment = NSTextAlignmentCenter;
    _notesLable.textColor = [UIColor grayColor];
    _notesLable.backgroundColor = [UIColor clearColor];
    _notesLable.font = FONT(12);
    _notesLable.hidden = YES;
    [backgroundView addSubview:_notesLable];
    [_webView insertSubview:backgroundView atIndex:0];
    
    
    // 发送请求，获取该网页内容
    _urlString = [[NSString stringWithFormat:@"%@",_urlString] stringByEncodingURLFormat];
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];

}

// 创建自定义的TabBar
- (void)createTabBar {
    
    // 未选中状态图片
    NSArray *imageNames = @[
                            @"home",
                            @"back",
                            @"forward",
                            @"refresh",
                            @"quit"
                            ];
    // 选中状态图片
    NSArray *selectedImageNames = @[
                                    @"home_selected",
                                    @"back_selected",
                                    @"forward_selected",
                                    @"refresh_selected",
                                    @"quit_selected"
                                    ];
    // 标签栏标题
    NSArray *titles = @[
                        @"首页",
                        @"后退",
                        @"前进",
                        @"刷新",
                        @"退出"
                        ];
    
    // 创建整个TabBar
    _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    _tabBarView.userInteractionEnabled = YES;
    _tabBarView.contentMode = UIViewContentModeScaleToFill;
    // 添加分隔线
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    separateLine.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [_tabBarView addSubview:separateLine];
    [self.view addSubview:_tabBarView];
    
    // 创建tabBar按钮
    CGFloat buttonWidth = SCREEN_WIDTH / titles.count;
    for (int i = 0; i < titles.count; i++) {
        // 未选中图片
        UIImage *buttonImage = [UIImage imageNamed:imageNames[i]];
        // 选中图片
        UIImage *selectedImage = [UIImage imageNamed:selectedImageNames[i]];
        ByTabBarButton *button = [[ByTabBarButton alloc] initWithFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, 49) Image:buttonImage SelectedImage:selectedImage Title:titles[i]];
        button.tag = i + 10;
        if (i == 0) {
            // 刚开始设置第一个按钮为选中按钮
            button.isSelectedButton = YES;
            self.selectedButton = button;
        }
        [button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarView addSubview:button];
    }
}

#pragma mark -- 按钮点击事件
- (void)_buttonAction:(ByTabBarButton *)button{
    // 首页
    if (button.tag == 10) {
        NSLog(@"首页");
//        [_webView stopLoading];
        // 发送请求，获取该网页内容
        _urlString = [[NSString stringWithFormat:@"%@",_urlString] stringByEncodingURLFormat];
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_webView loadRequest:request];

    }
    // 后退
    else if (button.tag == 11){
       NSLog(@"后退");
        [_webView goBack];
    }
    // 前进
    else if (button.tag == 12){
       NSLog(@"前进");
        [_webView goForward];
    }
    //刷新
    else if (button.tag == 13){
       NSLog(@"刷新");
        [_webView reload];
    }
    // 退出
    else{
        NSLog(@"退出");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否退出应用？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            exit(0);
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    // 上一次选中的按钮状态改为no
    self.selectedButton.isSelectedButton = NO;
    // 当前被点击的按钮状态改为yes
    button.isSelectedButton = YES;
    // 记录当前选中按钮
    self.selectedButton = button;
    
    
    
}
#pragma mark - UIVebView代理方法
// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    // 加载网页时，菊花转动
    _indicatorView.color = [UIColor lightGrayColor];
    CGPoint point = CGPointMake(CGRectGetWidth(_webView.frame) / 2, CGRectGetHeight(_webView.frame) / 2);
    _indicatorView.center = point;
    [_webView addSubview:_indicatorView];
    _indicatorView.hidesWhenStopped = YES;
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
    // 10秒后还未加载完就隐藏菊花
    [self performSelector:@selector(delayAction) withObject:nil afterDelay:5];
}

- (void)delayAction {
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
}

// 加载结束
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 加载提示移除
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != _bgScroller) {
        CGFloat yOffset = scrollView.contentOffset.y;
        //向上偏移量变正  向下偏移量变负
        if (yOffset < 0) {
            _notesLable.hidden = NO;
        }else{
            _notesLable.hidden = YES;
        }

    }
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    for (UIView *subView in scrollView.subviews) {
//        NSLog(@"%@",subView.class);
//        if ([subView isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) {
//            subView.userInteractionEnabled = YES;
//            return subView;
//        }
//    
//    }
//    return nil;
    if (scrollView == _bgScroller) {
        return _webView;
    }
    return nil;
   
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    NSLog(@"%@%f",view,scale);
}

#pragma mark --允许横屏
-(BOOL)shouldAutorotate{
    return YES;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
