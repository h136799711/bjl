//
//  TabBarButton.h
//  梦香菜谱
//
//  Created by imac on 15/9/28.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByTabBarButton : UIButton

@property (nonatomic,strong) UIImageView *buttonImageView;          //未选中状态图片
@property (nonatomic,strong) UIImageView *selectedImageView;        //选中状态图片
@property (nonatomic,strong) UILabel *buttonLabel;                  //按钮图片下方文字
@property (nonatomic) BOOL isSelectedButton;                        //按钮当前是否是选中状态

//自定义按钮初始化方法
- (id)initWithFrame:(CGRect)frame
              Image:(UIImage *)image
      SelectedImage:(UIImage *)selectedImage
              Title:(NSString *)title;

- (void)relayoutviews;

@end
