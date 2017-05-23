//
//  TabBarView.m
//  JinShaMy
//
//  Created by cc on 2017/4/17.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "RedRoseTabBarView.h"

@implementation RedRoseTabBarView

+ (instancetype)loadTabBarView
{
    RedRoseTabBarView *view = [[UINib nibWithNibName:@"RedRoseTabBarView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil].lastObject;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view setUpClickEvents];
    return view;
}

- (void)setUpClickEvents
{
    [self.tab1Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tab2Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tab3Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tab4Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tab5Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)button
{
    NSInteger tag = button.tag;
    int index = (int)tag - 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnItemOfIndex:)]) {
        [self.delegate didTapOnItemOfIndex:index];
    }
}

- (void)buttonOfIndex:(int)index state:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        
    }
}

@end
