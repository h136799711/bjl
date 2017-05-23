//
//  RedRoseTabBarView.h
//  JinShaMy
//
//  Created by cc on 2017/4/17.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedRoseTabBarDelegate <NSObject>

- (void)didTapOnItemOfIndex:(int)index;

@end

@interface RedRoseTabBarView : UIView

@property (weak, nonatomic) id<RedRoseTabBarDelegate> delegate;

+ (instancetype)loadTabBarView;

@property (weak, nonatomic) IBOutlet UIButton *tab1Btn;
@property (weak, nonatomic) IBOutlet UIButton *tab2Btn;
@property (weak, nonatomic) IBOutlet UIButton *tab3Btn;
@property (weak, nonatomic) IBOutlet UIButton *tab4Btn;
@property (weak, nonatomic) IBOutlet UIButton *tab5Btn;

- (void)buttonOfIndex:(int)index state:(UIControlState)state;

@end
